import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/flight_document.dart';

/// Abstract interface for a service that manages flight document storage.
abstract class DocumentStorageService {
  Future<File?> pickImage(ImageSource source);

  Future<String?> uploadFile(File file, String flightNumber, FlightDocumentType type);

  Future<FlightDocument?> saveDocument({
    required String flightNumber,
    required DateTime flightDate,
    required FlightDocumentType documentType,
    required String documentName,
    required String storageUrl,
    String? description,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
  });

  Future<List<FlightDocument>> getFlightDocuments(String flightNumber);

  Future<List<FlightDocument>> getAllUserDocuments();

  Future<bool> deleteDocument(FlightDocument document);
}

