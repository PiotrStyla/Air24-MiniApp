import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/flight_document.dart';
import 'document_storage_service.dart';

/// Platform-agnostic wrapper for Firebase operations
/// For web platform, we handle errors differently to avoid type errors
Future<T> safeFirebaseOperation<T>(Future<T> Function() operation, T fallbackValue, {String? operationName}) async {
  if (kIsWeb) {
    // Web platform requires special handling to avoid JavaScript interop errors
    try {
      return await operation();
    } catch (e) {
      // On web, just use toString() and avoid any property access on the exception
      debugPrint('${operationName ?? 'Firebase operation'} error on web: ${e.toString()}');
      return fallbackValue;
    }
  } else {
    // Native platforms can safely handle FirebaseException
    try {
      return await operation();
    } catch (e, stackTrace) {
      final errorMsg = e is FirebaseException ? e.message ?? 'Unknown Firebase error' : e.toString();
      debugPrint('${operationName ?? 'Firebase operation'} error: $errorMsg');
      debugPrint('Stack trace: $stackTrace');
      return fallbackValue;
    }
  }
}

/// Service for managing flight document storage and retrieval using Firebase.
class FirebaseDocumentStorageService implements DocumentStorageService {
  final FirebaseAuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  FirebaseDocumentStorageService(this._authService);

  String? get _currentUserId => _authService.currentUser?.uid;

  @override
  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      debugPrint('📝 Document: Image picked: ${pickedFile?.path ?? "null"}');
      return pickedFile;
    } catch (e, stackTrace) {
      debugPrint('❌ Document: Error picking image: $e');
      debugPrint('❌ Document: Stack trace: $stackTrace');
      return null;
    }
  }

  @override
  Future<String?> uploadFile(XFile file, String flightNumber, FlightDocumentType type) async {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint('❌ Document: Cannot upload file - no user ID');
      return null;
    }

    try {
      debugPrint('📤 Document: Uploading file: ${file.name}');

      // Create a unique ID for the file
      final String fileId = _uuid.v4();
      final String fileExtension = file.path.split('.').last;
      final String storagePath = 'documents/$userId/$flightNumber/${type.toString().split('.').last}_$fileId.$fileExtension';

      // Get file as bytes
      final Uint8List fileBytes = await file.readAsBytes();

      // Upload to Firebase Storage
      final Reference ref = _storage.ref().child(storagePath);
      
      debugPrint('📤 Document: Starting upload to Firebase Storage: $storagePath');
      final TaskSnapshot uploadTask = await ref.putData(
        fileBytes,
        SettableMetadata(contentType: 'image/$fileExtension'),
      );

      // Get download URL
      final String downloadUrl = await uploadTask.ref.getDownloadURL();
      debugPrint('✅ Document: File uploaded successfully. URL: $downloadUrl');
      return downloadUrl;
    } catch (e, stackTrace) {
      debugPrint('❌ Document: Error uploading file: $e');
      debugPrint('❌ Document: Stack trace: $stackTrace');

      // Only use mock URL if Firebase is explicitly marked unavailable in debug
      if (kDebugMode && FirebaseAuthService.isFirebaseUnavailable) {
        final mockUrl = 'https://mock-storage.example.com/documents/${_uuid.v4()}';
        debugPrint('ℹ️ Document: Using mock URL for testing due to Firebase unavailable flag: $mockUrl');
        return mockUrl;
      }
      debugPrint('⚠️ Document: Not using mock URL; returning null to surface error.');
      return null;
    }
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
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint('❌ Document: Cannot save document - no user ID');
      return null;
    }

    try {
      debugPrint('💾 Document: Saving metadata to Firestore for document: $documentName');
      final String docId = _uuid.v4();

      // Create safe Firestore document with explicit types
      Map<String, dynamic> docData = {
        'id': docId,
        'userId': userId,
        'flightNumber': flightNumber,
        'flightDate': Timestamp.fromDate(flightDate),
        'documentType': documentType.toString().split('.').last,
        'documentName': documentName,
        'storageUrl': storageUrl,
        'uploadDate': Timestamp.fromDate(DateTime.now()),
      };

      // Add optional fields only if they're not null
      if (description != null && description.isNotEmpty) {
        docData['description'] = description;
      }

      if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
        docData['thumbnailUrl'] = thumbnailUrl;
      }

      if (metadata != null && metadata.isNotEmpty) {
        // Ensure all metadata values are safe for Firestore
        Map<String, dynamic> safeMetadata = {};
        metadata.forEach((key, value) {
          // Only include primitive types safe for Firestore
          if (value is String || value is num || value is bool || 
              value is Map<String, dynamic> || value is List) {
            safeMetadata[key] = value;
          } else if (value != null) {
            safeMetadata[key] = value.toString();
          }
        });
        docData['metadata'] = safeMetadata;
      }

      // Save to Firestore
      await _firestore.collection('documents').doc(docId).set(docData);
      debugPrint('✅ Document: Metadata saved successfully to Firestore. ID: $docId');

      // Return the created FlightDocument
      return FlightDocument(
        id: docId,
        userId: userId,
        flightNumber: flightNumber,
        flightDate: flightDate,
        documentType: documentType,
        documentName: documentName,
        storageUrl: storageUrl,
        uploadDate: DateTime.now(),
        description: description,
        thumbnailUrl: thumbnailUrl,
        metadata: metadata,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Document: Error saving document metadata: $e');
      debugPrint('❌ Document: Stack trace: $stackTrace');

      // Only create a mock document if Firebase is explicitly marked unavailable in debug
      if (kDebugMode && FirebaseAuthService.isFirebaseUnavailable) {
        final mockId = _uuid.v4();
        debugPrint('ℹ️ Document: Creating mock document for testing due to Firebase unavailable flag: $mockId');
        return FlightDocument(
          id: mockId,
          userId: userId,
          flightNumber: flightNumber,
          flightDate: flightDate,
          documentType: documentType,
          documentName: documentName,
          storageUrl: storageUrl,
          uploadDate: DateTime.now(),
          description: description,
          thumbnailUrl: thumbnailUrl,
          metadata: metadata,
        );
      }
      debugPrint('⚠️ Document: Not creating mock document; returning null to surface error.');
      return null;
    }
  }

  @override
  Future<List<FlightDocument>> getFlightDocuments(String flightNumber) async {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint('❌ Document: Cannot get flight documents - no user ID');
      return [];
    }

    try {
      debugPrint('🔍 Document: Fetching documents for flight: $flightNumber');
      
      final QuerySnapshot snapshot = await _firestore.collection('documents')
          .where('userId', isEqualTo: userId)
          .where('flightNumber', isEqualTo: flightNumber)
          .get();
      
      List<FlightDocument> documents = _parseDocumentSnapshots(snapshot);
      debugPrint('✅ Document: Found ${documents.length} documents for flight $flightNumber');
      return documents;
    } catch (e) {
      debugPrint('❌ Document: Error fetching flight documents: $e');
      
      // In development mode, return mock documents only if Firebase is explicitly unavailable
      if (kDebugMode && FirebaseAuthService.isFirebaseUnavailable) {
        return [_createMockDocument(flightNumber)];
      }
      return [];
    }
  }

  @override
  Future<List<FlightDocument>> getAllUserDocuments() async {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint('❌ Document: Cannot get user documents - no user ID');
      return [];
    }

    try {
      debugPrint('🔍 Document: Fetching all documents for user: $userId');
      
      final QuerySnapshot snapshot = await _firestore.collection('documents')
          .where('userId', isEqualTo: userId)
          .get();
      
      List<FlightDocument> documents = _parseDocumentSnapshots(snapshot);
      debugPrint('✅ Document: Found ${documents.length} documents for user');
      return documents;
    } catch (e) {
      debugPrint('❌ Document: Error fetching user documents: $e');
      
      // In development mode, return mock documents only if Firebase is explicitly unavailable
      if (kDebugMode && FirebaseAuthService.isFirebaseUnavailable) {
        return [_createMockDocument('AB123'), _createMockDocument('CD456')];
      }
      return [];
    }
  }

  @override
  Future<bool> deleteDocument(FlightDocument document) async {
    try {
      debugPrint('🗑️ Document: Deleting document: ${document.id}');
      
      // Delete from Firestore first
      await _firestore.collection('documents').doc(document.id).delete();
      
      // Then try to delete from storage if we have a URL
      if (document.storageUrl.isNotEmpty) {
        try {
          // Extract storage path from URL
          // This assumes URLs are in the format: https://storage.googleapis.com/[bucket]/[path]
          // or firebase storage URLs that contain /o/ in the path
          final uri = Uri.parse(document.storageUrl);
          String? storagePath;
          
          if (document.storageUrl.contains('firebase') && uri.path.contains('/o/')) {
            // Firebase Storage URL format
            storagePath = Uri.decodeComponent(uri.path.split('/o/')[1].split('?').first);
          } else {
            // Standard Google Cloud Storage URL format
            storagePath = uri.path.replaceFirst('/', '');
          }
          
          if (storagePath != null && storagePath.isNotEmpty) {
            await _storage.ref().child(storagePath).delete();
            debugPrint('✅ Document: File deleted from storage: $storagePath');
          }
        } catch (storageError) {
          // Log error but don't fail the overall operation
          debugPrint('⚠️ Document: Failed to delete storage file: $storageError');
        }
      }
      
      debugPrint('✅ Document: Document deleted successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Document: Error deleting document: $e');
      
      // In development mode, pretend deletion succeeded only if Firebase is explicitly unavailable
      if (kDebugMode && FirebaseAuthService.isFirebaseUnavailable) {
        return true;
      }
      return false;
    }
  }

  // Helper method to parse Firestore documents into FlightDocument objects
  List<FlightDocument> _parseDocumentSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      
      // Handle Firestore Timestamp conversion to DateTime
      DateTime flightDate = DateTime.now();
      if (data['flightDate'] is Timestamp) {
        flightDate = (data['flightDate'] as Timestamp).toDate();
      }
      
      DateTime uploadDate = DateTime.now();
      if (data['uploadDate'] is Timestamp) {
        uploadDate = (data['uploadDate'] as Timestamp).toDate();
      }
      
      // Parse document type
      FlightDocumentType documentType = FlightDocumentType.ticket;
      if (data['documentType'] is String) {
        final typeStr = data['documentType'] as String;
        documentType = _parseDocumentType(typeStr);
      }
      
      return FlightDocument(
        id: data['id'] ?? doc.id,
        userId: data['userId'] ?? _currentUserId ?? '',
        flightNumber: data['flightNumber'] ?? '',
        flightDate: flightDate,
        documentType: documentType,
        documentName: data['documentName'] ?? '',
        storageUrl: data['storageUrl'] ?? '',
        uploadDate: uploadDate,
        description: data['description'],
        thumbnailUrl: data['thumbnailUrl'],
        metadata: data['metadata'] as Map<String, dynamic>?,
      );
    }).toList();
  }

  // Helper to parse document type strings from Firestore
  FlightDocumentType _parseDocumentType(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'ticket':
        return FlightDocumentType.ticket;
      case 'boardingpass':
      case 'boarding_pass':
        return FlightDocumentType.boardingPass;
      case 'bookingconfirmation':
      case 'booking_confirmation':
        return FlightDocumentType.bookingConfirmation;
      case 'eticket':
      case 'e_ticket':
        return FlightDocumentType.eTicket;
      case 'luggagetag':
      case 'luggage_tag':
        return FlightDocumentType.luggageTag;
      case 'delayconfirmation':
      case 'delay_confirmation':
        return FlightDocumentType.delayConfirmation;
      case 'hotelreceipt':
      case 'hotel_receipt':
        return FlightDocumentType.hotelReceipt;
      case 'mealreceipt':
      case 'meal_receipt':
        return FlightDocumentType.mealReceipt;
      case 'transportreceipt':
      case 'transport_receipt':
        return FlightDocumentType.transportReceipt;
      case 'receipt': // legacy generic type
      case 'identification': // legacy generic type
      case 'other':
        return FlightDocumentType.other;
      default:
        return FlightDocumentType.other;
    }
  }

  // Helper to create mock documents for development/testing
  FlightDocument _createMockDocument(String flightNumber) {
    final String mockId = _uuid.v4();
    return FlightDocument(
      id: mockId,
      userId: _currentUserId ?? 'mock-user',
      flightNumber: flightNumber,
      flightDate: DateTime.now(),
      documentType: FlightDocumentType.ticket,
      documentName: 'Mock Ticket',
      storageUrl: 'https://mock-storage.example.com/documents/$mockId',
      uploadDate: DateTime.now(),
      description: 'Mock document for testing',
      thumbnailUrl: null,
      metadata: {'mock': true},
    );
  }
}
