import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import '../models/document_ocr_result.dart';

/// Service for scanning documents and extracting text using OCR
class DocumentOcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final List<DocumentOcrResult> _scannedDocuments = [];
  final Uuid _uuid = const Uuid();

  /// Scan an image file and extract text using OCR
  Future<DocumentOcrResult> scanDocument({
    required File imageFile,
    required DocumentType documentType,
  }) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

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

  void _extractBoardingPassFields(List<String> lines, Map<String, String> fields) {
    final flightRegex = RegExp(r'\b([A-Z]{2}|[A-Z]\d|\d[A-Z])\s*(\d{1,4})\b');
    final airportCodeRegex = RegExp(r'\b([A-Z]{3})\b');
    final dateRegex = RegExp(r'\b(\d{1,2}(?:JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\d{2,4})\b', caseSensitive: false);
    final timeRegex = RegExp(r'\b(\d{2}:\d{2})\b');
    final gateRegex = RegExp(r'(?:GATE|Gate)\s*([A-Z0-9]{1,3})|\b([A-Z]\d{1,2})\b');
    final seatRegex = RegExp(r'(?:SEAT|Seat)\s*([A-Z0-9]{2,3})|\b(\d{1,2}[A-F])\b');
    final nameRegex = RegExp(r'MR?S?\/([A-Z\s/]+)');
    String text = lines.join(' ');
    final flightMatch = flightRegex.firstMatch(text);
    if (flightMatch != null) {
      final airline = flightMatch.group(1);
      final number = flightMatch.group(2);
      if (airline != null && number != null) {
        fields['flight_number'] = '$airline$number';
      }
    }
    final airportMatches = airportCodeRegex.allMatches(text).toList();
    if (airportMatches.length >= 2) {
      fields['departure_airport'] = airportMatches[0].group(0) ?? '';
      fields['arrival_airport'] = airportMatches[1].group(0) ?? '';
    }
    final dateMatch = dateRegex.firstMatch(text);
    if (dateMatch != null) {
      fields['departure_date'] = dateMatch.group(0) ?? '';
    }
    final timeMatch = timeRegex.firstMatch(text);
    if (timeMatch != null) {
      fields['departure_time'] = timeMatch.group(0) ?? '';
    }
    final gateMatch = gateRegex.firstMatch(text);
    if (gateMatch != null) {
      fields['boarding_gate'] = gateMatch.group(1) ?? gateMatch.group(2) ?? '';
    }
    final seatMatch = seatRegex.firstMatch(text);
    if (seatMatch != null) {
      fields['seat_number'] = seatMatch.group(1) ?? seatMatch.group(2) ?? '';
    }
    final nameMatch = nameRegex.firstMatch(text);
    if (nameMatch != null) {
      fields['passenger_name'] = nameMatch.group(1)?.trim() ?? '';
    }
  }
  
  void _extractFlightTicketFields(List<String> lines, Map<String, String> fields) {
    _extractBoardingPassFields(lines, fields);
    final ticketNumberRegex = RegExp(r'(?:TICKET NO|Ticket No|ticket number)[:\s]\s*(\d{10,13})|\b(\d{13})\b');
    final bookingRefRegex = RegExp(r'(?:BOOKING REF|PNR|Booking Ref)[:\s]\s*([A-Z0-9]{6})|\b([A-Z0-9]{6})\b');
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
    final nameRegex = RegExp(r'(?:Name|SURNAME|GIVEN NAMES)[:\s]\s*([A-Z\s]+)');
    final documentNumberRegex = RegExp(r'(?:Document No|PASSPORT NO|ID NUMBER)[:\s]\s*([A-Z0-9<]{5,10})');
    final dobRegex = RegExp(r'(?:Date of Birth|DOB|BIRTH DATE)[:\s]\s*(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})');
    final expiryRegex = RegExp(r'(?:Date of Expiry|EXPIRY DATE)[:\s]\s*(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})');
    final nationalityRegex = RegExp(r'(?:Nationality|NATIONALITY)[:\s]\s*([A-Z]+)');
    String text = lines.join(' ');
    final nameMatch = nameRegex.firstMatch(text);
    if (nameMatch != null) {
      fields['full_name'] = nameMatch.group(1)?.trim() ?? '';
    }
    final docNumberMatch = documentNumberRegex.firstMatch(text);
    if (docNumberMatch != null) {
      fields[type == DocumentType.passport ? 'passport_number' : 'document_number'] = 
          docNumberMatch.group(1) ?? '';
    }
    final dobMatch = dobRegex.firstMatch(text);
    if (dobMatch != null) {
      fields['date_of_birth'] = dobMatch.group(1) ?? '';
    }
    final expiryMatch = expiryRegex.firstMatch(text);
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
    _textRecognizer.close();
  }
}
