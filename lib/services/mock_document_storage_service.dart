import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/flight_document.dart';
import 'document_storage_service.dart';

/// Mock service for managing flight document storage and retrieval using in-memory storage.
class MockDocumentStorageService implements DocumentStorageService {
  final List<FlightDocument> _documents = [];
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  String? get _currentUserId => 'mock_user_id'; // Mock user ID

  MockDocumentStorageService() {
    // Seed with some mock data
    _documents.addAll([
      FlightDocument(
        id: _uuid.v4(),
        userId: _currentUserId!,
        flightNumber: 'BA2490',
        flightDate: DateTime.now().subtract(const Duration(days: 10)),
        documentType: FlightDocumentType.boardingPass,
        documentName: 'boarding_pass.jpg',
        storageUrl: 'https://example.com/mock/boarding_pass.jpg',
        uploadDate: DateTime.now().subtract(const Duration(days: 10)),
      ),
      FlightDocument(
        id: _uuid.v4(),
        userId: _currentUserId!,
        flightNumber: 'VS100',
        flightDate: DateTime.now().subtract(const Duration(days: 20)),
        documentType: FlightDocumentType.bookingConfirmation,
        documentName: 'booking_confirmation.pdf',
        storageUrl: 'https://example.com/mock/booking_confirmation.pdf',
        uploadDate: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ]);
  }

  @override
  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      return pickedFile;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  @override
  Future<String?> uploadFile(XFile file, String flightNumber, FlightDocumentType type) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate upload
    return 'https://example.com/mock/${_uuid.v4()}.jpg';
  }

  @override
  Future<FlightDocument?> saveDocument({
    required String flightNumber,
    required DateTime flightDate,
    required FlightDocumentType documentType,
    required String documentName,
    required String storageUrl,
    String? description,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
  }) async {
    // Always succeed in mock mode
    print('[MockDocumentStorageService] Saving document for flight: $flightNumber');
    
    try {
      final document = FlightDocument(
        id: _uuid.v4(),
        userId: _currentUserId ?? 'mock_user_id',
        flightNumber: flightNumber,
        flightDate: flightDate,
        documentType: documentType,
        documentName: documentName,
        storageUrl: storageUrl,
        description: description,
        uploadDate: DateTime.now(),
        thumbnailUrl: thumbnailUrl,
        metadata: metadata,
      );
      
      _documents.add(document);
      print('[MockDocumentStorageService] Document successfully saved with ID: ${document.id}');
      return document;
    } catch (e) {
      print('[MockDocumentStorageService] Error in saveDocument: $e');
      // In mock mode, we'll create and return a document even if there was an error
      final fallbackDocument = FlightDocument(
        id: _uuid.v4(),
        userId: 'mock_user_id',
        flightNumber: flightNumber,
        flightDate: flightDate,
        documentType: documentType,
        documentName: documentName,
        storageUrl: 'mock://document/${_uuid.v4()}',
        uploadDate: DateTime.now(),
      );
      _documents.add(fallbackDocument);
      return fallbackDocument;
    }
  }

  @override
  Future<List<FlightDocument>> getFlightDocuments(String flightNumber) async {
    return _documents
        .where((doc) => doc.userId == _currentUserId && doc.flightNumber == flightNumber)
        .toList();
  }

  @override
  Future<List<FlightDocument>> getAllUserDocuments() async {
    return _documents.where((doc) => doc.userId == _currentUserId).toList();
  }

  @override
  Future<bool> deleteDocument(FlightDocument document) async {
    if (document.userId != _currentUserId) {
      throw Exception('Document does not belong to current user');
    }
    _documents.removeWhere((doc) => doc.id == document.id);
    return true;
  }
}
