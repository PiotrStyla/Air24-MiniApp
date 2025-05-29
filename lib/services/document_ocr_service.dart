import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../models/document_ocr_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Service for scanning documents and extracting text using OCR
class DocumentOcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  
  /// Scan an image file and extract text using OCR
  Future<DocumentOcrResult> scanDocument({
    required File imageFile,
    required DocumentType documentType,
    String userId = '',
  }) async {
    try {
      // Generate a unique document ID
      final documentId = _uuid.v4();
      
      // Process the image with MLKit
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final rawText = recognizedText.text;
      
      debugPrint('OCR Raw Text: $rawText');
      
      // Extract fields based on document type
      final extractedFields = _extractFields(rawText, documentType);
      
      // Save the processed image
      final savedImagePath = await _saveProcessedImage(imageFile, documentId);
      
      // Create OCR result
      final ocrResult = DocumentOcrResult(
        documentId: documentId,
        imagePath: savedImagePath,
        scanDate: DateTime.now(),
        extractedFields: extractedFields,
        rawText: rawText,
        documentType: documentType,
      );
      
      // Store the OCR result if userId is provided
      if (userId.isNotEmpty) {
        await _storeOcrResult(ocrResult, userId);
      }
      
      return ocrResult;
    } catch (e) {
      debugPrint('Error scanning document: $e');
      rethrow;
    }
  }
  
  /// Extract specific fields from the OCR text based on document type
  Map<String, String> _extractFields(String text, DocumentType documentType) {
    final Map<String, String> fields = {};
    final lines = text.split('\n');
    final fieldsToExtract = documentType.fieldsToExtract;
    
    // Extract each field using pattern matching and NLP techniques
    switch (documentType) {
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
        _extractIdDocumentFields(lines, fields, documentType);
        break;
      case DocumentType.receipt:
        _extractReceiptFields(lines, fields);
        break;
      case DocumentType.unknown:
        // No specific extraction for unknown documents
        break;
    }
    
    return fields;
  }
  
  /// Extract boarding pass specific fields
  void _extractBoardingPassFields(List<String> lines, Map<String, String> fields) {
    // Flight number pattern: usually 2 letters followed by 3-4 digits (e.g., LH1234)
    final flightNumberRegex = RegExp(r'([A-Z]{2})\s*(\d{3,4})');
    
    // Airport code pattern: 3 uppercase letters
    final airportCodeRegex = RegExp(r'\b([A-Z]{3})\b');
    
    // Date pattern (various formats)
    final dateRegex = RegExp(r'\d{1,2}\s*(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|[0-9]{1,2})[A-Za-z]*\s*\d{2,4}|\d{1,2}[./-]\d{1,2}[./-]\d{2,4}');
    
    // Time pattern (e.g., 14:25, 2:30 PM)
    final timeRegex = RegExp(r'\b\d{1,2}[:h]\d{2}\s*(?:AM|PM)?\b');
    
    // Gate pattern (usually "GATE" followed by a letter/number)
    final gateRegex = RegExp(r'GATE\s*([A-Z0-9]{1,3})|(?:GATE|Gate|gate)[:\s]\s*([A-Z0-9]{1,3})');
    
    // Seat pattern (usually "SEAT" followed by a seat code like 12A)
    final seatRegex = RegExp(r'(?:SEAT|Seat|seat)[:\s]\s*([A-Z0-9]{1,3})|\b([0-9]{1,2}[A-Z])\b');
    
    // Name pattern (look for "NAME:" or common name patterns)
    final nameRegex = RegExp(r'(?:PASSENGER|Name|NAME)[:\s]\s*([A-Z\s]+)');
    
    // Search through each line for matches
    String text = lines.join(' ');
    
    // Extract flight number
    final flightMatch = flightNumberRegex.firstMatch(text);
    if (flightMatch != null) {
      final airline = flightMatch.group(1);
      final number = flightMatch.group(2);
      if (airline != null && number != null) {
        fields['flight_number'] = '$airline$number';
      }
    }
    
    // Extract airport codes (first two matches are likely origin and destination)
    final airportMatches = airportCodeRegex.allMatches(text).toList();
    if (airportMatches.length >= 2) {
      fields['departure_airport'] = airportMatches[0].group(0) ?? '';
      fields['arrival_airport'] = airportMatches[1].group(0) ?? '';
    }
    
    // Extract date
    final dateMatch = dateRegex.firstMatch(text);
    if (dateMatch != null) {
      fields['departure_date'] = dateMatch.group(0) ?? '';
    }
    
    // Extract time
    final timeMatch = timeRegex.firstMatch(text);
    if (timeMatch != null) {
      fields['departure_time'] = timeMatch.group(0) ?? '';
    }
    
    // Extract gate
    final gateMatch = gateRegex.firstMatch(text);
    if (gateMatch != null) {
      fields['boarding_gate'] = gateMatch.group(1) ?? gateMatch.group(2) ?? '';
    }
    
    // Extract seat
    final seatMatch = seatRegex.firstMatch(text);
    if (seatMatch != null) {
      fields['seat_number'] = seatMatch.group(1) ?? seatMatch.group(2) ?? '';
    }
    
    // Extract passenger name
    final nameMatch = nameRegex.firstMatch(text);
    if (nameMatch != null) {
      fields['passenger_name'] = nameMatch.group(1)?.trim() ?? '';
    }
  }
  
  /// Extract flight ticket specific fields
  void _extractFlightTicketFields(List<String> lines, Map<String, String> fields) {
    // Similar to boarding pass but with additional fields
    _extractBoardingPassFields(lines, fields); // Extract common fields
    
    // Ticket number pattern (usually 13 digits)
    final ticketNumberRegex = RegExp(r'(?:TICKET NO|Ticket No|ticket number)[:\s]\s*(\d{10,13})|\b(\d{13})\b');
    
    // Booking reference pattern (usually 6 alphanumeric characters)
    final bookingRefRegex = RegExp(r'(?:BOOKING REF|PNR|Booking Ref)[:\s]\s*([A-Z0-9]{6})|\b([A-Z0-9]{6})\b');
    
    // Fare amount pattern
    final fareRegex = RegExp(r'(?:FARE|Total|Amount)[:\s]\s*(?:[A-Z]{3})?\s*(\d+[.,]\d{2})');
    
    String text = lines.join(' ');
    
    // Extract ticket number
    final ticketMatch = ticketNumberRegex.firstMatch(text);
    if (ticketMatch != null) {
      fields['ticket_number'] = ticketMatch.group(1) ?? ticketMatch.group(2) ?? '';
    }
    
    // Extract booking reference
    final bookingMatch = bookingRefRegex.firstMatch(text);
    if (bookingMatch != null) {
      fields['booking_reference'] = bookingMatch.group(1) ?? bookingMatch.group(2) ?? '';
    }
    
    // Extract fare amount
    final fareMatch = fareRegex.firstMatch(text);
    if (fareMatch != null) {
      fields['fare_amount'] = fareMatch.group(1) ?? '';
    }
  }
  
  /// Extract luggage tag specific fields
  void _extractLuggageTagFields(List<String> lines, Map<String, String> fields) {
    // Flight number and airport patterns (reuse from boarding pass)
    _extractBoardingPassFields(lines, fields); // Extract common fields
    
    // Luggage tag number pattern (usually 10 digits)
    final tagNumberRegex = RegExp(r'\b(\d{10})\b');
    
    String text = lines.join(' ');
    
    // Extract luggage tag number
    final tagMatch = tagNumberRegex.firstMatch(text);
    if (tagMatch != null) {
      fields['luggage_tag_number'] = tagMatch.group(1) ?? '';
    }
  }
  
  /// Extract ID document fields (passport or ID card)
  void _extractIdDocumentFields(List<String> lines, Map<String, String> fields, DocumentType type) {
    // Name pattern
    final nameRegex = RegExp(r'(?:Name|SURNAME|GIVEN NAMES)[:\s]\s*([A-Z\s]+)');
    
    // Document number pattern
    final documentNumberRegex = RegExp(r'(?:Document No|PASSPORT NO|ID NUMBER)[:\s]\s*([A-Z0-9<]{5,10})');
    
    // Date patterns
    final dobRegex = RegExp(r'(?:Date of Birth|DOB|BIRTH DATE)[:\s]\s*(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})');
    final expiryRegex = RegExp(r'(?:Date of Expiry|EXPIRY DATE)[:\s]\s*(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})');
    
    // Nationality pattern (for passport)
    final nationalityRegex = RegExp(r'(?:Nationality|NATIONALITY)[:\s]\s*([A-Z]+)');
    
    String text = lines.join(' ');
    
    // Extract name
    final nameMatch = nameRegex.firstMatch(text);
    if (nameMatch != null) {
      fields['full_name'] = nameMatch.group(1)?.trim() ?? '';
    }
    
    // Extract document number
    final docNumberMatch = documentNumberRegex.firstMatch(text);
    if (docNumberMatch != null) {
      fields[type == DocumentType.passport ? 'passport_number' : 'document_number'] = 
          docNumberMatch.group(1) ?? '';
    }
    
    // Extract date of birth
    final dobMatch = dobRegex.firstMatch(text);
    if (dobMatch != null) {
      fields['date_of_birth'] = dobMatch.group(1) ?? '';
    }
    
    // Extract expiry date
    final expiryMatch = expiryRegex.firstMatch(text);
    if (expiryMatch != null) {
      fields['expiry_date'] = expiryMatch.group(1) ?? '';
    }
    
    // Extract nationality (for passport only)
    if (type == DocumentType.passport) {
      final nationalityMatch = nationalityRegex.firstMatch(text);
      if (nationalityMatch != null) {
        fields['nationality'] = nationalityMatch.group(1) ?? '';
      }
    }
  }
  
  /// Extract receipt specific fields
  void _extractReceiptFields(List<String> lines, Map<String, String> fields) {
    // Merchant name is usually at the top of the receipt
    if (lines.isNotEmpty) {
      fields['merchant_name'] = lines[0].trim();
    }
    
    // Date pattern
    final dateRegex = RegExp(r'\d{1,2}[./-]\d{1,2}[./-]\d{2,4}');
    
    // Total amount pattern
    final totalRegex = RegExp(r'(?:TOTAL|Total|total)[:\s]\s*(?:[A-Z]{3})?\s*(\d+[.,]\d{2})');
    
    // Currency pattern
    final currencyRegex = RegExp(r'\b(EUR|USD|GBP|PLN|CHF|JPY)\b');
    
    // Payment method pattern
    final paymentMethodRegex = RegExp(r'(?:VISA|MASTERCARD|AMEX|CASH|CREDIT CARD|DEBIT CARD)');
    
    String text = lines.join(' ');
    
    // Extract date
    final dateMatch = dateRegex.firstMatch(text);
    if (dateMatch != null) {
      fields['date'] = dateMatch.group(0) ?? '';
    }
    
    // Extract total amount
    final totalMatch = totalRegex.firstMatch(text);
    if (totalMatch != null) {
      fields['total_amount'] = totalMatch.group(1) ?? '';
    }
    
    // Extract currency
    final currencyMatch = currencyRegex.firstMatch(text);
    if (currencyMatch != null) {
      fields['currency'] = currencyMatch.group(1) ?? '';
    }
    
    // Extract payment method
    final paymentMethodMatch = paymentMethodRegex.firstMatch(text);
    if (paymentMethodMatch != null) {
      fields['payment_method'] = paymentMethodMatch.group(0) ?? '';
    }
  }
  
  /// Save the processed image to local storage
  Future<String> _saveProcessedImage(File imageFile, String documentId) async {
    try {
      // Get app document directory
      final appDir = await getApplicationDocumentsDirectory();
      final saveDir = Directory('${appDir.path}/scanned_documents');
      
      // Create directory if it doesn't exist
      if (!await saveDir.exists()) {
        await saveDir.create(recursive: true);
      }
      
      // Generate a unique filename
      final fileExtension = path.extension(imageFile.path);
      final fileName = 'document_$documentId$fileExtension';
      final savePath = '${saveDir.path}/$fileName';
      
      // Copy the file to the save location
      await imageFile.copy(savePath);
      
      return savePath;
    } catch (e) {
      debugPrint('Error saving processed image: $e');
      // If saving fails, return the original path
      return imageFile.path;
    }
  }
  
  /// Store OCR result in Firestore and upload image to Firebase Storage
  Future<void> _storeOcrResult(DocumentOcrResult result, String userId) async {
    try {
      // Upload image to Firebase Storage
      final File imageFile = File(result.imagePath);
      final storageRef = _storage.ref().child('documents/$userId/${result.documentId}');
      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();
      
      // Store OCR result in Firestore
      final resultMap = result.toMap();
      resultMap['imageUrl'] = imageUrl; // Add the storage URL
      
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('document_ocr_results')
          .doc(result.documentId)
          .set(resultMap);
      
      debugPrint('OCR result stored successfully: ${result.documentId}');
    } catch (e) {
      debugPrint('Error storing OCR result: $e');
      // Don't rethrow - we still want to return the OCR result even if storage fails
    }
  }
  
  /// Get OCR results for a user
  Future<List<DocumentOcrResult>> getOcrResultsForUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('document_ocr_results')
          .orderBy('scanDate', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => DocumentOcrResult.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting OCR results: $e');
      return [];
    }
  }
  
  /// Get OCR result by document ID
  Future<DocumentOcrResult?> getOcrResultById(String userId, String documentId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('document_ocr_results')
          .doc(documentId)
          .get();
      
      if (doc.exists) {
        return DocumentOcrResult.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting OCR result: $e');
      return null;
    }
  }
  
  /// Delete OCR result
  Future<void> deleteOcrResult(String userId, String documentId) async {
    try {
      // Delete from Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('document_ocr_results')
          .doc(documentId)
          .delete();
      
      // Delete from Storage
      await _storage.ref().child('documents/$userId/$documentId').delete();
      
      debugPrint('OCR result deleted successfully: $documentId');
    } catch (e) {
      debugPrint('Error deleting OCR result: $e');
      rethrow;
    }
  }
  
  /// Close the text recognizer when no longer needed
  void dispose() {
    _textRecognizer.close();
  }
}
