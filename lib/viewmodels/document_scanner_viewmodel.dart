import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:crop_image/crop_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/document_ocr_result.dart';
import '../services/document_ocr_service.dart';

/// ViewModel for document scanning and OCR processing
class DocumentScannerViewModel extends ChangeNotifier {
  final DocumentOcrService _ocrService;
  final FirebaseAuth _auth;
  
  DocumentScannerViewModel({
    required DocumentOcrService ocrService,
    required FirebaseAuth auth,
  }) : _ocrService = ocrService,
       _auth = auth;
  
  // State variables
  bool _isScanning = false;
  bool _isCropping = false;
  bool _isProcessing = false;
  File? _selectedImage;
  File? _croppedImage;
  DocumentOcrResult? _ocrResult;
  String _errorMessage = '';
  List<DocumentOcrResult> _savedDocuments = [];
  DocumentType _selectedDocumentType = DocumentType.unknown;
  
  // Getters
  bool get isScanning => _isScanning;
  bool get isCropping => _isCropping;
  bool get isProcessing => _isProcessing;
  File? get selectedImage => _selectedImage;
  File? get croppedImage => _croppedImage;
  DocumentOcrResult? get ocrResult => _ocrResult;
  String get errorMessage => _errorMessage;
  List<DocumentOcrResult> get savedDocuments => _savedDocuments;
  DocumentType get selectedDocumentType => _selectedDocumentType;
  
  /// Select document type
  void setDocumentType(DocumentType type) {
    _selectedDocumentType = type;
    notifyListeners();
  }
  
  /// Take a photo using the device camera
  Future<void> takePhoto() async {
    try {
      _isScanning = true;
      _errorMessage = '';
      notifyListeners();
      
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 90,
        maxWidth: 1600,
      );
      
      if (photo != null) {
        _selectedImage = File(photo.path);
        _isCropping = true;
      }
    } catch (e) {
      _errorMessage = 'Error taking photo: ${e.toString()}';
      debugPrint(_errorMessage);
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }
  
  /// Pick an image from the gallery
  Future<void> pickImage() async {
    try {
      _isScanning = true;
      _errorMessage = '';
      notifyListeners();
      
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 1600,
      );
      
      if (image != null) {
        _selectedImage = File(image.path);
        _isCropping = true;
      }
    } catch (e) {
      _errorMessage = 'Error picking image: ${e.toString()}';
      debugPrint(_errorMessage);
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }
  
  /// Save the cropped image
  void saveCroppedImage(File image) {
    _croppedImage = image;
    _isCropping = false;
    notifyListeners();
  }
  
  /// Cancel cropping
  void cancelCropping() {
    _selectedImage = null;
    _isCropping = false;
    notifyListeners();
  }
  
  /// Cancel processing and reset state
  void cancelProcessing() {
    _selectedImage = null;
    _croppedImage = null;
    _ocrResult = null;
    notifyListeners();
  }
  
  /// Process the selected image with OCR
  Future<void> processDocument() async {
    if (_croppedImage == null || _selectedDocumentType == DocumentType.unknown) {
      _errorMessage = 'Please select an image and document type';
      notifyListeners();
      return;
    }
    
    try {
      _isProcessing = true;
      _errorMessage = '';
      notifyListeners();
      
      // Get current user ID if logged in
      String userId = '';
      if (_auth.currentUser != null) {
        userId = _auth.currentUser!.uid;
      }
      
      // Process the document with OCR
      _ocrResult = await _ocrService.scanDocument(
        imageFile: _croppedImage!,
        documentType: _selectedDocumentType,
        userId: userId,
      );
      
      // Reload saved documents if user is logged in
      if (userId.isNotEmpty) {
        await loadSavedDocuments();
      }
    } catch (e) {
      _errorMessage = 'Error processing document: ${e.toString()}';
      debugPrint(_errorMessage);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
  
  /// Load saved documents for current user
  Future<void> loadSavedDocuments() async {
    if (_auth.currentUser == null) {
      _savedDocuments = [];
      notifyListeners();
      return;
    }
    
    try {
      _savedDocuments = await _ocrService.getOcrResultsForUser(_auth.currentUser!.uid);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading saved documents: ${e.toString()}';
      debugPrint(_errorMessage);
    }
  }
  
  /// Delete a saved document
  Future<void> deleteDocument(String documentId) async {
    if (_auth.currentUser == null) return;
    
    try {
      await _ocrService.deleteOcrResult(_auth.currentUser!.uid, documentId);
      await loadSavedDocuments(); // Reload the list
    } catch (e) {
      _errorMessage = 'Error deleting document: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }
  
  /// Get document by ID
  Future<DocumentOcrResult?> getDocumentById(String documentId) async {
    if (_auth.currentUser == null) return null;
    
    try {
      return await _ocrService.getOcrResultById(_auth.currentUser!.uid, documentId);
    } catch (e) {
      _errorMessage = 'Error getting document: ${e.toString()}';
      debugPrint(_errorMessage);
      notifyListeners();
      return null;
    }
  }
  
  /// Reset errors
  void resetError() {
    _errorMessage = '';
    notifyListeners();
  }
}
