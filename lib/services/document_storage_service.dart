import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../models/flight_document.dart';

/// Service for managing flight document storage and retrieval
class DocumentStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  
  // Document collection reference
  CollectionReference get _documentsCollection => 
      _firestore.collection('flight_documents');
  
  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;
  
  /// Pick an image from gallery or camera
  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70, // Reduced quality for better performance
      );
      
      if (pickedFile == null) return null;
      
      return File(pickedFile.path);
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }
  
  /// Pick any document file (PDF, etc.)
  Future<File?> pickDocument() async {
    try {
      // Note: For PDF selection, you may need a plugin like file_picker
      // This is a simplified version using image_picker
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      
      if (pickedFile == null) return null;
      
      return File(pickedFile.path);
    } catch (e) {
      debugPrint('Error picking document: $e');
      return null;
    }
  }
  
  /// Upload a document file to Firebase Storage
  Future<String?> uploadFile(File file, String flightNumber, FlightDocumentType type) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      // Create a unique filename
      final String fileExtension = path.extension(file.path);
      final String fileName = '${const Uuid().v4()}$fileExtension';
      final String filePath = 'users/$_currentUserId/flight_documents/$flightNumber/$fileName';
      
      // Upload file to Firebase Storage
      final Reference storageRef = _storage.ref().child(filePath);
      final UploadTask uploadTask = storageRef.putFile(file);
      
      // Wait for upload to complete and get download URL
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return null;
    }
  }
  
  /// Create a thumbnail for image documents (optional)
  Future<String?> createThumbnail(File file) async {
    // Implementation would typically use a package like image to resize
    // For now, we'll just return the original URL
    return null; // Return null for now, implement thumbnail generation if needed
  }
  
  /// Save document metadata to Firestore
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
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final String docId = const Uuid().v4();
      final FlightDocument document = FlightDocument(
        id: docId,
        userId: _currentUserId!,
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
      
      // Save to Firestore
      await _documentsCollection.doc(docId).set(document.toMap());
      
      return document;
    } catch (e) {
      debugPrint('Error saving document metadata: $e');
      return null;
    }
  }
  
  /// Get all documents for a specific flight
  Future<List<FlightDocument>> getFlightDocuments(String flightNumber) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final QuerySnapshot snapshot = await _documentsCollection
          .where('userId', isEqualTo: _currentUserId)
          .where('flightNumber', isEqualTo: flightNumber)
          .orderBy('uploadDate', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return FlightDocument.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching flight documents: $e');
      return [];
    }
  }
  
  /// Get all documents for the current user
  Future<List<FlightDocument>> getAllUserDocuments() async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final QuerySnapshot snapshot = await _documentsCollection
          .where('userId', isEqualTo: _currentUserId)
          .orderBy('uploadDate', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return FlightDocument.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching user documents: $e');
      return [];
    }
  }
  
  /// Delete a document and its file from storage
  Future<bool> deleteDocument(FlightDocument document) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      // Verify this document belongs to the current user
      if (document.userId != _currentUserId) {
        throw Exception('Document does not belong to current user');
      }
      
      // Delete from Firestore
      await _documentsCollection.doc(document.id).delete();
      
      // Delete from Storage
      final Reference storageRef = _storage.refFromURL(document.storageUrl);
      await storageRef.delete();
      
      // Delete thumbnail if exists
      if (document.thumbnailUrl != null) {
        final Reference thumbnailRef = _storage.refFromURL(document.thumbnailUrl!);
        await thumbnailRef.delete();
      }
      
      return true;
    } catch (e) {
      debugPrint('Error deleting document: $e');
      return false;
    }
  }
  
  /// Stream of documents for a specific flight
  Stream<List<FlightDocument>> streamFlightDocuments(String flightNumber) {
    if (_currentUserId == null) {
      // Return empty stream if not authenticated
      return Stream.value([]);
    }
    
    return _documentsCollection
        .where('userId', isEqualTo: _currentUserId)
        .where('flightNumber', isEqualTo: flightNumber)
        .orderBy('uploadDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return FlightDocument.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }
}
