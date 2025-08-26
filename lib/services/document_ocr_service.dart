import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import '../models/document_ocr_result.dart';

/// Service for scanning documents and extracting text using OCR
class DocumentOcrService {
  // Lazily initialized to avoid plugin initialization in pure Dart tests
  TextRecognizer? _textRecognizer;
  final List<DocumentOcrResult> _scannedDocuments = [];
  final Uuid _uuid = const Uuid();

  /// Scan an image file and extract text using OCR
  Future<DocumentOcrResult> scanDocument({
    required File imageFile,
    required DocumentType documentType,
  }) async {
    final inputImage = InputImage.fromFile(imageFile);
    // Initialize recognizer on demand
    _textRecognizer ??= TextRecognizer();
    final RecognizedText recognizedText = await _textRecognizer!.processImage(inputImage);

    final lines = recognizedText.text.split('\n');
    final Map<String, String> extractedFields = {};

    // Call the appropriate extraction method based on document type
    _extractFields(lines, extractedFields, documentType);

    final documentId = _uuid.v4();
    final savedImagePath = await _saveProcessedImage(imageFile, documentId);

    final newDocument = DocumentOcrResult(
      documentId: documentId,
      imagePath: savedImagePath,
      scanDate: DateTime.now(),
      extractedFields: extractedFields,
      rawText: recognizedText.text,
      documentType: documentType,
    );

    _scannedDocuments.add(newDocument);
    return newDocument;
  }

  /// Get all OCR results for the current user
  Future<List<DocumentOcrResult>> getOcrResultsForUser(String userId) async {
    // Note: In-memory implementation doesn't filter by userId as there's no multi-user concept.
    // Kept for API consistency.
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_scannedDocuments);
  }

  /// Get a single OCR result by its ID
  Future<DocumentOcrResult?> getOcrResultById(String userId, String documentId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _scannedDocuments.firstWhere((doc) => doc.documentId == documentId);
    } catch (e) {
      return null;
    }
  }

  /// Delete an OCR result
  Future<void> deleteOcrResult(String userId, String documentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _scannedDocuments.removeWhere((doc) => doc.documentId == documentId);
  }

  /// Main dispatcher for field extraction
  void _extractFields(List<String> lines, Map<String, String> fields, DocumentType type) {
    switch (type) {
      case DocumentType.boardingPass:
        _extractBoardingPassFields(lines, fields);
        break;
      case DocumentType.flightTicket:
        _extractFlightTicketFields(lines, fields);
        break;
      case DocumentType.luggageTag:
        _extractLuggageTagFields(lines, fields);
        break;
      case DocumentType.idCard:
      case DocumentType.passport:
        _extractIdDocumentFields(lines, fields, type);
        break;
      case DocumentType.receipt:
        _extractReceiptFields(lines, fields);
        break;
      case DocumentType.unknown:
        break;
    }
  }

  /// Exposes the extraction logic for testing with raw text inputs without invoking OCR.
  ///
  /// This keeps unit tests aligned with the service implementation and avoids
  /// duplicating regex patterns in tests.
  @visibleForTesting
  Map<String, String> extractFieldsForTesting(String rawText, DocumentType type) {
    final lines = rawText.split('\n');
    final Map<String, String> extracted = {};
    _extractFields(lines, extracted, type);
    return extracted;
  }

  void _extractBoardingPassFields(List<String> lines, Map<String, String> fields) {
    // Prefer labeled flight numbers and From/To patterns; avoid month tokens like JUN in dates
    final labeledFlightRegex = RegExp(
      r'(?:FLIGHT(?:\s*NO)?|FLT)[:\s\-]*([A-Z]{2})\s*(\d{3,4})',
      caseSensitive: false,
    );
    final flightRegex = RegExp(r'\b([A-Z]{2})\s*(\d{3,4})\b');
    final monthTokenRegex =
        RegExp(r'JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC', caseSensitive: false);
    // Prefer codes in parentheses e.g., From: Munich (MUC) To: Madrid (MAD)
    final fromToParenRegex = RegExp(
      r'From:?\s+[^\n]*?\(([A-Z]{3})\)[^\n]*?(?:To|TO|->)[:]??\s+[^\n]*?\(([A-Z]{3})\)',
      caseSensitive: false,
    );
    // Fallback to labeled codes without parentheses: From: MUC To: MAD (requires uppercase codes)
    final fromToCodesRegex = RegExp(
      r'From:?\s+([A-Z]{3})\b[^\n]*?(?:To|TO|->)[:]??\s+([A-Z]{3})\b',
    );
    final airportCodeRegex = RegExp(r'\b([A-Z]{3})\b');
    // Support both 01JUN2025 and 01 Jun 2025 formats
    final dateRegex = RegExp(
      r'\b(\d{1,2}\s*(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s*\d{2,4})\b',
      caseSensitive: false,
    );
    final timeRegex = RegExp(r'\b(\d{2}:\d{2})\b');
    final gateRegex = RegExp(r'(?:GATE|Gate)\s*([A-Z0-9]{1,3})|\b([A-Z]\d{1,2})\b');
    final seatRegex = RegExp(r'(?:SEAT|Seat)\s*([A-Z0-9]{2,3})|\b(\d{1,2}[A-F])\b');
    final passengerLabelRegex = RegExp(
      r'(?:Passenger|Name)[:\s]*([A-Z]+)[\/,]\s*([A-Z]+)',
      caseSensitive: false,
    );
    final nameRegex = RegExp(r'MR?S?\/([A-Z\s/]+)');
    String text = lines.join(' ');

    // Flight number: check labeled first, then generic but skip lines with month tokens or dates
    for (final rawLine in lines) {
      final line = rawLine.replaceAll('\r', '');
      if (!fields.containsKey('flight_number')) {
        final labeled = labeledFlightRegex.firstMatch(line);
        if (labeled != null) {
          final airline = labeled.group(1);
          final number = labeled.group(2);
          if (airline != null && number != null) {
            fields['flight_number'] = '$airline$number';
            continue;
          }
        }
        // Avoid matching inside dates like 01JUN2025
        if (!monthTokenRegex.hasMatch(line) && !line.toLowerCase().contains('date')) {
          final m = flightRegex.firstMatch(line);
          if (m != null) {
            final airline = m.group(1);
            final number = m.group(2);
            if (airline != null && number != null) {
              fields['flight_number'] = '$airline$number';
            }
          }
        }
      }
    }

    // Airports: prefer explicit From/To pattern
    final fromToParenMatch = fromToParenRegex.firstMatch(text);
    if (fromToParenMatch != null) {
      fields['departure_airport'] = fromToParenMatch.group(1) ?? '';
      fields['arrival_airport'] = fromToParenMatch.group(2) ?? '';
    } else {
      final fromToCodesMatch = fromToCodesRegex.firstMatch(text);
      if (fromToCodesMatch != null) {
        final dep = fromToCodesMatch.group(1) ?? '';
        final arr = fromToCodesMatch.group(2) ?? '';
        if (dep == dep.toUpperCase() && arr == arr.toUpperCase()) {
          fields['departure_airport'] = dep;
          fields['arrival_airport'] = arr;
        }
      }
      if (!fields.containsKey('departure_airport') || !fields.containsKey('arrival_airport')) {
        final airportMatches = airportCodeRegex.allMatches(text).toList();
        if (airportMatches.length >= 2) {
          fields['departure_airport'] = airportMatches[0].group(0) ?? '';
          fields['arrival_airport'] = airportMatches[1].group(0) ?? '';
        }
      }
    }

    // Date and time
    final dateMatch = dateRegex.firstMatch(text);
    if (dateMatch != null) {
      fields['departure_date'] = dateMatch.group(0) ?? '';
    }
    final timeMatch = timeRegex.firstMatch(text);
    if (timeMatch != null) {
      fields['departure_time'] = timeMatch.group(0) ?? '';
    }

    // Gate and seat
    final gateMatch = gateRegex.firstMatch(text);
    if (gateMatch != null) {
      fields['boarding_gate'] = gateMatch.group(1) ?? gateMatch.group(2) ?? '';
    }
    final seatMatch = seatRegex.firstMatch(text);
    if (seatMatch != null) {
      fields['seat_number'] = seatMatch.group(1) ?? seatMatch.group(2) ?? '';
    }

    // Passenger name (prefer labeled), fallback to MR/MS format
    for (final rawLine in lines) {
      if (fields.containsKey('passenger_name')) break;
      final line = rawLine.replaceAll('\r', '');
      final p = passengerLabelRegex.firstMatch(line);
      if (p != null) {
        final last = p.group(1) ?? '';
        final first = p.group(2) ?? '';
        final combined = [last, first].where((e) => e.isNotEmpty).join(' ');
        if (combined.isNotEmpty) {
          fields['passenger_name'] = combined;
          break;
        }
      }
      final nameMatch = nameRegex.firstMatch(line);
      if (nameMatch != null) {
        fields['passenger_name'] = nameMatch.group(1)?.trim() ?? '';
        break;
      }
    }
  }
  
  void _extractFlightTicketFields(List<String> lines, Map<String, String> fields) {
    _extractBoardingPassFields(lines, fields);
    final ticketNumberRegex = RegExp(r'(?:TICKET NO|Ticket No|ticket number)[:\s]\s*(\d{10,13})|\b(\d{13})\b');
    final bookingRefRegex = RegExp(r'(?:BOOKING\s*REF|PNR|Booking\s*Ref)[:\s]\s*([A-Z0-9]{6})', caseSensitive: false);
    final fareRegex = RegExp(r'(?:FARE|Total|Amount)[:\s]\s*(?:[A-Z]{3})?\s*(\d+[.,]\d{2})');
    String text = lines.join(' ');
    final ticketMatch = ticketNumberRegex.firstMatch(text);
    if (ticketMatch != null) {
      fields['ticket_number'] = ticketMatch.group(1) ?? ticketMatch.group(2) ?? '';
    }
    final bookingMatch = bookingRefRegex.firstMatch(text);
    if (bookingMatch != null) {
      fields['booking_reference'] = bookingMatch.group(1) ?? bookingMatch.group(2) ?? '';
    }
    final fareMatch = fareRegex.firstMatch(text);
    if (fareMatch != null) {
      fields['fare_amount'] = fareMatch.group(1) ?? '';
    }
  }
  
  void _extractLuggageTagFields(List<String> lines, Map<String, String> fields) {
    _extractBoardingPassFields(lines, fields);
    final tagNumberRegex = RegExp(r'\b(\d{10})\b');
    String text = lines.join(' ');
    final tagMatch = tagNumberRegex.firstMatch(text);
    if (tagMatch != null) {
      fields['luggage_tag_number'] = tagMatch.group(1) ?? '';
    }
  }
  
  void _extractIdDocumentFields(List<String> lines, Map<String, String> fields, DocumentType type) {
    // Prefer explicit SURNAME and GIVEN NAMES labels when present to build full_name
    final surnameRegex = RegExp(r'(?:SURNAME|Surname)[:\s]\s*([A-Z\s]+)');
    final givenNamesRegex = RegExp(r'(?:GIVEN NAMES|Given Names)[:\s]\s*([A-Z\s]+)');
    final nameFallbackRegex = RegExp(r'(?:Name)[:\s]\s*([A-Z\s]+)');
    final documentNumberRegex = RegExp(r'(?:Document No|PASSPORT NO|ID NUMBER)[:\s]\s*([A-Z0-9<]{5,10})');
    final dobRegex = RegExp(r'(?:Date of Birth|DOB|BIRTH DATE)[:\s]\s*(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})');
    // Support textual months like "15 JAN 1985"
    final dobTextualRegex = RegExp(r'(?:Date of Birth|DOB|BIRTH DATE)[:\s]\s*(\d{1,2}\s+[A-Z]{3}\s+\d{4})', caseSensitive: false);
    final expiryRegex = RegExp(r'(?:Date of Expiry|EXPIRY DATE)[:\s]\s*(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})');
    final expiryTextualRegex = RegExp(r'(?:Date of Expiry|EXPIRY DATE)[:\s]\s*(\d{1,2}\s+[A-Z]{3}\s+\d{4})', caseSensitive: false);
    final nationalityRegex = RegExp(r'(?:Nationality|NATIONALITY)[:\s]\s*([A-Z]+)');
    String text = lines.join(' ');

    String? surname;
    String? given;
    for (final rawLine in lines) {
      final line = rawLine.replaceAll('\r', '');
      if (surname == null || surname.isEmpty) {
        final s = surnameRegex.firstMatch(line);
        if (s != null) {
          surname = s.group(1)?.trim();
        }
      }
      if (given == null || given.isEmpty) {
        final g = givenNamesRegex.firstMatch(line);
        if (g != null) {
          given = g.group(1)?.trim();
        }
      }
    }
    if ((surname?.isNotEmpty == true) || (given?.isNotEmpty == true)) {
      final combined = [surname, given]
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .join(' ');
      if (combined.isNotEmpty) {
        fields['full_name'] = combined;
      }
    } else {
      final nameFallback = nameFallbackRegex.firstMatch(text);
      if (nameFallback != null) {
        fields['full_name'] = nameFallback.group(1)?.trim() ?? '';
      }
    }
    final docNumberMatch = documentNumberRegex.firstMatch(text);
    if (docNumberMatch != null) {
      fields[type == DocumentType.passport ? 'passport_number' : 'document_number'] = 
          docNumberMatch.group(1) ?? '';
    }
    final dobMatch = dobRegex.firstMatch(text) ?? dobTextualRegex.firstMatch(text);
    if (dobMatch != null) {
      fields['date_of_birth'] = dobMatch.group(1) ?? '';
    }
    final expiryMatch = expiryRegex.firstMatch(text) ?? expiryTextualRegex.firstMatch(text);
    if (expiryMatch != null) {
      fields['expiry_date'] = expiryMatch.group(1) ?? '';
    }
    if (type == DocumentType.passport) {
      final nationalityMatch = nationalityRegex.firstMatch(text);
      if (nationalityMatch != null) {
        fields['nationality'] = nationalityMatch.group(1) ?? '';
      }
    }
  }
  
  void _extractReceiptFields(List<String> lines, Map<String, String> fields) {
    if (lines.isNotEmpty) {
      fields['merchant_name'] = lines[0].trim();
    }
    final dateRegex = RegExp(r'\d{1,2}[./-]\d{1,2}[./-]\d{2,4}');
    final totalRegex = RegExp(r'(?:TOTAL|Total|total)[:\s]\s*(?:[A-Z]{3})?\s*(\d+[.,]\d{2})');
    final currencyRegex = RegExp(r'\b(EUR|USD|GBP|PLN|CHF|JPY)\b');
    final paymentMethodRegex = RegExp(r'(?:VISA|MASTERCARD|AMEX|CASH|CREDIT CARD|DEBIT CARD)');
    String text = lines.join(' ');
    final dateMatch = dateRegex.firstMatch(text);
    if (dateMatch != null) {
      fields['date'] = dateMatch.group(0) ?? '';
    }
    final totalMatch = totalRegex.firstMatch(text);
    if (totalMatch != null) {
      fields['total_amount'] = totalMatch.group(1) ?? '';
    }
    final currencyMatch = currencyRegex.firstMatch(text);
    if (currencyMatch != null) {
      fields['currency'] = currencyMatch.group(1) ?? '';
    }
    final paymentMethodMatch = paymentMethodRegex.firstMatch(text);
    if (paymentMethodMatch != null) {
      fields['payment_method'] = paymentMethodMatch.group(0) ?? '';
    }
  }
  
  Future<String> _saveProcessedImage(File imageFile, String documentId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final saveDir = Directory('${appDir.path}/scanned_documents');
      if (!await saveDir.exists()) {
        await saveDir.create(recursive: true);
      }
      final fileExtension = path.extension(imageFile.path);
      final fileName = 'document_$documentId$fileExtension';
      final savePath = '${saveDir.path}/$fileName';
      await imageFile.copy(savePath);
      return savePath;
    } catch (e) {
      debugPrint('Error saving processed image: $e');
      return imageFile.path;
    }
  }
  
  void dispose() {
    _textRecognizer?.close();
  }
}
