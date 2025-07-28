import 'dart:io';

import 'package:f35_flight_compensation/models/flight_document.dart';
import '../services/auth_service_firebase.dart' hide debugPrint;
import 'package:f35_flight_compensation/services/document_storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LocalDocumentStorageService implements DocumentStorageService {
  final FirebaseAuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  LocalDocumentStorageService(this._authService);

  String? get _currentUserId => _authService.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _documentsCollection =>
      _firestore.collection('documents');

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
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

  @override
  Future<String?> uploadFile(XFile file, String flightNumber, FlightDocumentType type) async {
    if (_currentUserId == null) throw Exception('User not authenticated');

    try {
      final path = await _localPath;
      final fileName = '${_uuid.v4()}_${file.name}';
      final localFile = File('$path/$fileName');

      await localFile.writeAsBytes(await file.readAsBytes());

      debugPrint('File saved locally at: ${localFile.path}');
      return localFile.path;
    } catch (e, stackTrace) {
      debugPrint('Error saving file locally: $e\n$stackTrace');
      return null;
    }
  }

  @override
  Future<FlightDocument?> saveDocument({
    required String flightNumber,
    required DateTime flightDate,
    required FlightDocumentType documentType,
    required String documentName,
    required String storageUrl, // This will now be a local file path
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
      storageUrl: storageUrl, // Storing local path
      uploadDate: DateTime.now(),
      description: description,
      thumbnailUrl: thumbnailUrl,
      metadata: metadata,
    );

    try {
      await _documentsCollection.doc(document.id).set(document.toFirestore());
      return document;
    } catch (e) {
      debugPrint('Error saving document metadata to Firestore: $e');
      // If metadata fails, delete the local file to avoid orphans
      try {
        final localFile = File(storageUrl);
        if (await localFile.exists()) {
          await localFile.delete();
        }
      } catch (deleteError) {
        debugPrint('Failed to clean up local file after Firestore error: $deleteError');
      }
      return null;
    }
  }

  @override
  Future<List<FlightDocument>> getFlightDocuments(String flightNumber) async {
    if (_currentUserId == null) return [];
    try {
      final querySnapshot = await _documentsCollection
          .where('userId', isEqualTo: _currentUserId)
          .where('flightNumber', isEqualTo: flightNumber)
          .get();
      return querySnapshot.docs.map((doc) => FlightDocument.fromFirestore(doc.data(), doc.id)).toList();
    } catch (e) {
      debugPrint('Error getting flight documents: $e');
      return [];
    }
  }

  @override
  Future<List<FlightDocument>> getAllUserDocuments() async {
    if (_currentUserId == null) return [];
    try {
      final querySnapshot = await _documentsCollection
          .where('userId', isEqualTo: _currentUserId)
          .get();
      final documents = querySnapshot.docs.map((doc) => FlightDocument.fromFirestore(doc.data(), doc.id)).toList();
      documents.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
      return documents;
    } catch (e) {
      debugPrint('Error getting all user documents: $e');
      return [];
    }
  }

  @override
  Future<bool> deleteDocument(FlightDocument document) async {
    if (document.userId != _currentUserId) {
      throw Exception('Document does not belong to current user');
    }
    try {
      // Delete from Firestore
      await _documentsCollection.doc(document.id).delete();
      // Delete from local storage
      final localFile = File(document.storageUrl);
      if (await localFile.exists()) {
        await localFile.delete();
      }
      return true;
    } catch (e) {
      debugPrint('Error deleting document: $e');
      return false;
    }
  }
}
