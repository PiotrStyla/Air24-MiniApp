import 'package:cloud_firestore/cloud_firestore.dart';

/// Types of flight documents that can be stored
enum FlightDocumentType {
  boardingPass,
  ticket,
  luggageTag,
  delayConfirmation,
  hotelReceipt,
  mealReceipt,
  transportReceipt,
  other
}

/// Model representing a flight-related document
class FlightDocument {
  final String id;
  final String userId;
  final String flightNumber;
  final DateTime flightDate;
  final FlightDocumentType documentType;
  final String documentName;
  final String storageUrl;
  final String? description;
  final DateTime uploadDate;
  final String? thumbnailUrl;
  final Map<String, dynamic>? metadata;

  FlightDocument({
    required this.id,
    required this.userId,
    required this.flightNumber,
    required this.flightDate,
    required this.documentType,
    required this.documentName,
    required this.storageUrl,
    this.description,
    required this.uploadDate,
    this.thumbnailUrl,
    this.metadata,
  });

  /// Create a FlightDocument from a map (e.g. Firestore data)
  factory FlightDocument.fromMap(Map<String, dynamic> map, String docId) {
    return FlightDocument(
      id: docId,
      userId: map['userId'] ?? '',
      flightNumber: map['flightNumber'] ?? '',
      flightDate: (map['flightDate'] as Timestamp).toDate(),
      documentType: FlightDocumentType.values.firstWhere(
        (e) => e.toString() == 'FlightDocumentType.${map['documentType']}',
        orElse: () => FlightDocumentType.other,
      ),
      documentName: map['documentName'] ?? '',
      storageUrl: map['storageUrl'] ?? '',
      description: map['description'],
      uploadDate: (map['uploadDate'] as Timestamp).toDate(),
      thumbnailUrl: map['thumbnailUrl'],
      metadata: map['metadata'],
    );
  }

  /// Convert FlightDocument to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'flightNumber': flightNumber,
      'flightDate': Timestamp.fromDate(flightDate),
      'documentType': documentType.toString().split('.').last,
      'documentName': documentName,
      'storageUrl': storageUrl,
      'description': description,
      'uploadDate': Timestamp.fromDate(uploadDate),
      'thumbnailUrl': thumbnailUrl,
      'metadata': metadata,
    };
  }

  /// Create a copy of this FlightDocument with specified fields updated
  FlightDocument copyWith({
    String? id,
    String? userId,
    String? flightNumber,
    DateTime? flightDate,
    FlightDocumentType? documentType,
    String? documentName,
    String? storageUrl,
    String? description,
    DateTime? uploadDate,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
  }) {
    return FlightDocument(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      flightNumber: flightNumber ?? this.flightNumber,
      flightDate: flightDate ?? this.flightDate,
      documentType: documentType ?? this.documentType,
      documentName: documentName ?? this.documentName,
      storageUrl: storageUrl ?? this.storageUrl,
      description: description ?? this.description,
      uploadDate: uploadDate ?? this.uploadDate,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}
