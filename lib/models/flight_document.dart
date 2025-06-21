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
    // Handle timestamp conversion differently based on platform
    DateTime _parseTimestamp(dynamic timestamp) {
      if (timestamp == null) return DateTime.now();
      
      try {
        if (kIsWeb) {
          // On web, we need to handle timestamps with extra caution due to JS interop
          // Check if it's a Firebase Timestamp or a raw JS object
          if (timestamp is Timestamp) {
            return timestamp.toDate();
          } else if (timestamp is Map) {
            // Some web implementations might return a JSON-like object
            // with seconds and nanoseconds
            final seconds = timestamp['seconds'] as int?;
            final nanoseconds = timestamp['nanoseconds'] as int?;
            
            if (seconds != null) {
              final ms = seconds * 1000 + (nanoseconds ?? 0) ~/ 1000000;
              return DateTime.fromMillisecondsSinceEpoch(ms);
            }
          }
          // Fallback for web
          return DateTime.now();
        } else {
          // On native platforms, we can safely use the standard conversion
          return (timestamp as Timestamp).toDate();
        }
      } catch (e) {
        debugPrint('Error parsing timestamp: $e');
        return DateTime.now(); // Fallback
      }
    }

    return FlightDocument(
      id: documentId,
      userId: data['userId'] as String,
      flightNumber: data['flightNumber'] as String,
      flightDate: _parseTimestamp(data['flightDate']),
      documentType: FlightDocumentType.values.byName(data['documentType'] as String),
      documentName: data['documentName'] as String,
      storageUrl: data['storageUrl'] as String,
      uploadDate: _parseTimestamp(data['uploadDate']),
      description: data['description'] as String?,
      thumbnailUrl: data['thumbnailUrl'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Converts a FlightDocument instance to a map for Firestore.
  Map<String, dynamic> toFirestore() {
    // Create a safe timestamp for Firestore that works on both web and native platforms
    dynamic _safeTimestamp(DateTime dateTime) {
      try {
        return Timestamp.fromDate(dateTime);
      } catch (e) {
        // If creating a Timestamp fails (particularly on web), create a map that mimics Firestore timestamp structure
        debugPrint('Error creating Timestamp: $e');
        final milliseconds = dateTime.millisecondsSinceEpoch;
        return {
          'seconds': milliseconds ~/ 1000,
          'nanoseconds': (milliseconds % 1000) * 1000000
        };
      }
    }
    
    return {
      'userId': userId,
      'flightNumber': flightNumber,
      'flightDate': _safeTimestamp(flightDate),
      'documentType': documentType.name,
      'documentName': documentName,
      'storageUrl': storageUrl,
      'uploadDate': _safeTimestamp(uploadDate),
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
