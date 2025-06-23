import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:f35_flight_compensation/services/auth_service.dart';
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
  final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  FirebaseDocumentStorageService(this._authService);

  String? get _currentUserId => _authService.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _documentsCollection =>
      _firestore.collection('documents');

  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      return pickedFile;
    } catch (e, stackTrace) {
      debugPrint('Error picking image: $e\n$stackTrace');
      return null;
    }
  }

  Future<String?> uploadFile(XFile file, String flightNumber, FlightDocumentType type) async {
    print('[FirebaseDocumentStorageService] Starting upload for file: ${file.name}, flight: $flightNumber');
    if (_currentUserId == null) {
      print('[FirebaseDocumentStorageService] Error: User not authenticated.');
      throw Exception('User not authenticated');
    }

    try {
      final fileName = '${_uuid.v4()}_${file.name}';
      final ref = _storage.ref().child('user_documents').child(_currentUserId!).child(fileName);
      print('[FirebaseDocumentStorageService] Uploading to path: ${ref.fullPath}');

      final UploadTask uploadTask;
      if (kIsWeb) {
        print('[FirebaseDocumentStorageService] Using putData for web with MIME type: ${file.mimeType}');
        final metadata = SettableMetadata(contentType: file.mimeType);
        uploadTask = ref.putData(await file.readAsBytes(), metadata);
      } else {
        print('[FirebaseDocumentStorageService] Using putFile for native');
        uploadTask = ref.putFile(File(file.path));
      }

      final TaskSnapshot snapshot = await uploadTask;
      print('[FirebaseDocumentStorageService] Upload complete, getting URL...');
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('[FirebaseDocumentStorageService] Got download URL: $downloadUrl');

      return downloadUrl;
    } catch (e, stackTrace) {
      print('[FirebaseDocumentStorageService] An exception occurred in uploadFile: $e');
      print(stackTrace);
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
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final document = FlightDocument(
      id: _uuid.v4(),
      userId: _currentUserId!,
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

    return safeFirebaseOperation<FlightDocument?>(
      () async {
        await _documentsCollection.doc(document.id).set(document.toFirestore());
        return document;
      },
      null,
      operationName: 'Save document'
    );
  }

  Future<List<FlightDocument>> getFlightDocuments(String flightNumber) async {
    if (_currentUserId == null) return [];
    return safeFirebaseOperation<List<FlightDocument>>(
      () async {
        final querySnapshot = await _documentsCollection
            .where('userId', isEqualTo: _currentUserId)
            .where('flightNumber', isEqualTo: flightNumber)
            .get();
        return querySnapshot.docs.map((doc) => FlightDocument.fromFirestore(doc.data(), doc.id)).toList();
      },
      [],
      operationName: 'Get flight documents'
    );
  }

  Future<List<FlightDocument>> getAllUserDocuments() async {
    if (_currentUserId == null) return [];
    return safeFirebaseOperation<List<FlightDocument>>(
      () async {
        final querySnapshot = await _documentsCollection
            .where('userId', isEqualTo: _currentUserId)
            .get();
        final documents = querySnapshot.docs.map((doc) => FlightDocument.fromFirestore(doc.data(), doc.id)).toList();
        // Sort on the client to avoid needing a composite index in Firestore.
        documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
        return documents;
      },
      [],
      operationName: 'Get all user documents'
    );
  }

  Future<bool> deleteDocument(FlightDocument document) async {
    if (document.userId != _currentUserId) {
      throw Exception('Document does not belong to current user');
    }
    return safeFirebaseOperation<bool>(
      () async {
        // Delete from Firestore
        await _documentsCollection.doc(document.id).delete();
        // Delete from Storage
        await _storage.refFromURL(document.storageUrl).delete();
        return true;
      },
      false,
      operationName: 'Delete document'
    );
  }
}
