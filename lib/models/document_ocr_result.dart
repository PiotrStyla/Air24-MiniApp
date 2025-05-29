import 'dart:convert';

/// Model class for storing OCR results from scanned documents
class DocumentOcrResult {
  final String documentId;
  final String imagePath;
  final DateTime scanDate;
  final Map<String, String> extractedFields;
  final String rawText;
  final DocumentType documentType;

  DocumentOcrResult({
    required this.documentId,
    required this.imagePath,
    required this.scanDate,
    required this.extractedFields,
    required this.rawText,
    required this.documentType,
  });

  /// Create a new instance with updated fields
  DocumentOcrResult copyWith({
    String? documentId,
    String? imagePath,
    DateTime? scanDate,
    Map<String, String>? extractedFields,
    String? rawText,
    DocumentType? documentType,
  }) {
    return DocumentOcrResult(
      documentId: documentId ?? this.documentId,
      imagePath: imagePath ?? this.imagePath,
      scanDate: scanDate ?? this.scanDate,
      extractedFields: extractedFields ?? this.extractedFields,
      rawText: rawText ?? this.rawText,
      documentType: documentType ?? this.documentType,
    );
  }

  /// Convert to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'imagePath': imagePath,
      'scanDate': scanDate.toIso8601String(),
      'extractedFields': extractedFields,
      'rawText': rawText,
      'documentType': documentType.toString(),
    };
  }

  /// Create from a map (e.g., from Firestore)
  factory DocumentOcrResult.fromMap(Map<String, dynamic> map) {
    return DocumentOcrResult(
      documentId: map['documentId'] ?? '',
      imagePath: map['imagePath'] ?? '',
      scanDate: map['scanDate'] != null 
          ? DateTime.parse(map['scanDate']) 
          : DateTime.now(),
      extractedFields: Map<String, String>.from(map['extractedFields'] ?? {}),
      rawText: map['rawText'] ?? '',
      documentType: _parseDocumentType(map['documentType'] ?? ''),
    );
  }

  /// Convert to JSON
  String toJson() => json.encode(toMap());

  /// Create from JSON
  factory DocumentOcrResult.fromJson(String source) => 
      DocumentOcrResult.fromMap(json.decode(source));

  /// Parse document type from string
  static DocumentType _parseDocumentType(String value) {
    switch (value) {
      case 'DocumentType.boardingPass':
        return DocumentType.boardingPass;
      case 'DocumentType.flightTicket':
        return DocumentType.flightTicket;
      case 'DocumentType.luggageTag':
        return DocumentType.luggageTag;
      case 'DocumentType.idCard':
        return DocumentType.idCard;
      case 'DocumentType.passport':
        return DocumentType.passport;
      case 'DocumentType.receipt':
        return DocumentType.receipt;
      default:
        return DocumentType.unknown;
    }
  }
}

/// Types of documents that can be scanned
enum DocumentType {
  boardingPass,
  flightTicket,
  luggageTag,
  idCard,
  passport,
  receipt,
  unknown,
}

/// Extension methods for DocumentType
extension DocumentTypeExtension on DocumentType {
  String get displayName {
    switch (this) {
      case DocumentType.boardingPass:
        return 'Boarding Pass';
      case DocumentType.flightTicket:
        return 'Flight Ticket';
      case DocumentType.luggageTag:
        return 'Luggage Tag';
      case DocumentType.idCard:
        return 'ID Card';
      case DocumentType.passport:
        return 'Passport';
      case DocumentType.receipt:
        return 'Receipt';
      case DocumentType.unknown:
        return 'Unknown Document';
    }
  }
  
  /// Get field names to extract based on document type
  List<String> get fieldsToExtract {
    switch (this) {
      case DocumentType.boardingPass:
        return [
          'passenger_name',
          'flight_number',
          'departure_airport',
          'arrival_airport',
          'departure_date',
          'departure_time',
          'seat_number',
          'boarding_gate',
        ];
      case DocumentType.flightTicket:
        return [
          'passenger_name',
          'flight_number',
          'departure_airport',
          'arrival_airport',
          'departure_date',
          'departure_time',
          'ticket_number',
          'booking_reference',
          'fare_amount',
        ];
      case DocumentType.luggageTag:
        return [
          'passenger_name',
          'flight_number',
          'luggage_tag_number',
          'departure_airport',
          'arrival_airport',
        ];
      case DocumentType.idCard:
        return [
          'full_name',
          'document_number',
          'date_of_birth',
          'expiry_date',
        ];
      case DocumentType.passport:
        return [
          'full_name',
          'passport_number',
          'nationality',
          'date_of_birth',
          'expiry_date',
        ];
      case DocumentType.receipt:
        return [
          'merchant_name',
          'date',
          'total_amount',
          'currency',
          'payment_method',
        ];
      case DocumentType.unknown:
        return [];
    }
  }
}
