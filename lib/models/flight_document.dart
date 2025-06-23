import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Enum for the type of flight document.
enum FlightDocumentType {
  boardingPass,
  ticket,
  bookingConfirmation,
  eTicket,
  luggageTag,
  delayConfirmation,
  hotelReceipt,
  mealReceipt,
  transportReceipt,
  other,
}

/// Represents a single document related to a flight.
class FlightDocument {
  final String id;
  final String userId;
  final String flightNumber;
  final DateTime flightDate;
  final FlightDocumentType documentType;
  final String documentName;
  final String storageUrl;
  final DateTime uploadDate;
  final String? description;
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
    required this.uploadDate,
    this.description,
    this.thumbnailUrl,
    this.metadata,
  });

  /// Creates a FlightDocument from a Firestore document snapshot.
  factory FlightDocument.fromFirestore(Map<String, dynamic> data, String documentId) {
    return FlightDocument(
      id: documentId,
      userId: data['userId'] as String,
      flightNumber: data['flightNumber'] as String,
      flightDate: (data['flightDate'] as Timestamp).toDate(),
      documentType: FlightDocumentType.values.byName(data['documentType'] as String),
      documentName: data['documentName'] as String,
      storageUrl: data['storageUrl'] as String,
      uploadDate: (data['uploadDate'] as Timestamp).toDate(),
      description: data['description'] as String?,
      thumbnailUrl: data['thumbnailUrl'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Converts a FlightDocument instance to a map for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'flightNumber': flightNumber,
      'flightDate': Timestamp.fromDate(flightDate),
      'documentType': documentType.name,
      'documentName': documentName,
      'storageUrl': storageUrl,
      'uploadDate': Timestamp.fromDate(uploadDate),
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'metadata': metadata,
    };
  }

  /// Creates a FlightDocument from a JSON map.
  factory FlightDocument.fromJson(Map<String, dynamic> json) {
    return FlightDocument.fromFirestore(json, json['id'] as String);
  }

  /// Converts a FlightDocument instance to a JSON map.
  Map<String, dynamic> toJson() {
    final data = toFirestore();
    data['id'] = id; // Add id to the json representation
    return data;
  }
}
