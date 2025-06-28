import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/flight_document.dart';
import '../services/document_storage_service.dart';
import '../services/localization_service.dart';

/// ViewModel for flight document management following MVVM pattern
class DocumentViewModel extends ChangeNotifier {
  final DocumentStorageService _documentService;
  final LocalizationService _localizationService;
  
  List<FlightDocument> _documents = [];
  XFile? _selectedFile;
  bool _isUploading = false;
  bool _isLoadingInitialData = false;
  String? _errorMessage;
  FlightDocumentType _selectedDocumentType = FlightDocumentType.boardingPass;
  String _documentName = '';
  String _description = '';
  String _flightNumber = '';
  DateTime _flightDate = DateTime.now();
  Stream<List<FlightDocument>> _documentsStream = Stream.value([]);
  
  // Getters
  Stream<List<FlightDocument>> get documentsStream => _documentsStream;
  List<FlightDocument> get documents => _documents;
  bool get isLoadingInitialData => _isLoadingInitialData;
  XFile? get selectedFile => _selectedFile;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;
  FlightDocumentType get selectedDocumentType => _selectedDocumentType;
  String get documentName => _documentName;
  String get description => _description;
  bool get hasSelectedFile => _selectedFile != null;
  String get flightNumber => _flightNumber;
  DateTime get flightDate => _flightDate;
  
  // Constructor
  DocumentViewModel(this._documentService, this._localizationService);
  
  // Document type options for dropdown
  List<Map<String, dynamic>> get documentTypeOptions {
    return FlightDocumentType.values.map((type) {
      String displayName = type.toString().split('.').last;
      // Convert from camelCase to Title Case with spaces
      displayName = displayName.replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => ' ${match.group(0)}',
      ).trim();
      displayName = displayName[0].toUpperCase() + displayName.substring(1);
      
      return {
        'value': type,
        'label': displayName,
      };
    }).toList();
  }
  
  // Setters with validation
  void setFlightNumber(String value) {
    _flightNumber = value.trim();
    _errorMessage = null;
    notifyListeners();
  }
  
  void setFlightDate(DateTime value) {
    _flightDate = value;
    _errorMessage = null;
    notifyListeners();
  }
  
  void setDocumentType(FlightDocumentType type) {
    _selectedDocumentType = type;
    _errorMessage = null;
    notifyListeners();
  }
  
  void setDocumentName(String value) {
    _documentName = value.trim();
    _errorMessage = null;
    notifyListeners();
  }
  
  void setDescription(String value) {
    _description = value.trim();
    _errorMessage = null;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  void clearSelectedFile() {
    _selectedFile = null;
    notifyListeners();
  }
  
  // Document actions
  Future<bool> pickImage(ImageSource source) async {
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final file = await _documentService.pickImage(source);
      _selectedFile = file;
      _isUploading = false;
      
      // Auto-generate a document name based on type if empty
      if (_documentName.isEmpty && file != null) {
        final now = DateTime.now();
        _documentName = '${_selectedDocumentType.toString().split('.').last}_${now.millisecondsSinceEpoch}';
      }
      
      notifyListeners();
      return file != null;
    } catch (e) {
      _errorMessage = 'Failed to pick image: $e';
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> pickDocument() async {
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final file = await _documentService.pickImage(ImageSource.gallery);
      _selectedFile = file;
      _isUploading = false;
      
      // Auto-generate a document name based on type if empty
      if (_documentName.isEmpty && file != null) {
        final now = DateTime.now();
        _documentName = '${_selectedDocumentType.toString().split('.').last}_${now.millisecondsSinceEpoch}';
      }
      
      notifyListeners();
      return file != null;
    } catch (e) {
      _errorMessage = 'Failed to pick document: $e';
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Orchestrates the picking and uploading of a single document.
  /// Returns the new FlightDocument on success, null on failure.
  Future<FlightDocument?> pickAndUploadDocument({
    required String flightNumber,
    required DateTime flightDate,
    required FlightDocumentType documentType,
    String? documentName,
  }) async {
    // Use localized string for claim attachment name if none provided
    documentName = documentName ?? _localizationService.getString('claimAttachment', fallback: 'Claim Attachment');
    _errorMessage = null;
    notifyListeners();

    try {
      final XFile? pickedFile = await _documentService.pickImage(ImageSource.gallery);
      if (pickedFile == null) {
        print('[DocumentViewModel] File picking cancelled by user.');
        return null;
      }

      _selectedFile = pickedFile;
      setFlightNumber(flightNumber);
      setFlightDate(flightDate);
      setDocumentType(documentType);
      setDocumentName(documentName);

      print('[DocumentViewModel] File picked: ${_selectedFile?.name}, initiating upload.');
      return await uploadSelectedFile();
    } catch (e) {
      _errorMessage = 'Failed to pick and upload document: $e';
      print('[DocumentViewModel] Error in pickAndUploadDocument: $_errorMessage');
      notifyListeners();
      return null;
    }
  }

  Future<FlightDocument?> uploadSelectedFile() async {
    if (_selectedFile == null) {
      _errorMessage = 'No file was selected.';
      notifyListeners();
      return null;
    }
    if (_flightNumber.isEmpty) {
      _errorMessage = 'Flight number is required';
      notifyListeners();
      return null;
    }
    if (_documentName.isEmpty) {
      _errorMessage = 'Document name is required';
      notifyListeners();
      return null;
    }

    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('[DocumentViewModel] Attempting to upload file: ${_selectedFile?.name}');
      final storageUrl = await _documentService.uploadFile(
        _selectedFile!,
        _flightNumber,
        _selectedDocumentType,
      );

      if (storageUrl == null) {
        throw Exception('Failed to upload file');
      }

      final newDocument = await _documentService.saveDocument(
        flightNumber: _flightNumber,
        flightDate: _flightDate,
        documentType: _selectedDocumentType,
        documentName: _documentName,
        storageUrl: storageUrl,
        description: _description.isNotEmpty ? _description : null,
      );

      if (newDocument == null) {
        throw Exception('Failed to save document metadata');
      }

      print('[DocumentViewModel] Document uploaded and saved successfully.');
      _documents.add(newDocument);
      _selectedFile = null;
      _documentName = '';
      _description = '';

      return newDocument;
    } on FirebaseException catch (e) {
      print('[DocumentViewModel] Caught FirebaseException: ${e.code} - ${e.message}');
      _errorMessage = 'Failed to save document metadata.';
      notifyListeners();
      return null;
    } catch (e) {
      print('[DocumentViewModel] Caught generic Exception: $e');
      _errorMessage = 'An unexpected error occurred: $e';
      notifyListeners();
      return null;
    } finally {
      _isUploading = false;
      notifyListeners();
      print('[DocumentViewModel] Exiting uploadSelectedFile method, isUploading is now false.');
    }
  }
  
  Future<void> loadDocumentsForFlight(String flightNumber) async {
    if (flightNumber.isEmpty) return;
    
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _documents = await _documentService.getFlightDocuments(flightNumber);
      _documentsStream = Stream.value(_documents);
      _isUploading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      _errorMessage = 'Failed to load documents: ${e.message}';
      _isUploading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _errorMessage = 'An unexpected error occurred while loading documents.';
      print('Load documents for flight error: $e\n$stackTrace');
      _isUploading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadAllUserDocuments() async {
    _isLoadingInitialData = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _documents = await _documentService.getAllUserDocuments();
      _documentsStream = Stream.value(_documents);
    } on FirebaseException catch (e) {
      _errorMessage = 'Failed to load documents: ${e.message}';
    } catch (e, stackTrace) {
      _errorMessage = 'An unexpected error occurred while loading documents.';
      print('Load all user documents error: $e\n$stackTrace');
    } finally {
      _isLoadingInitialData = false;
      notifyListeners();
    }
  }
  
  Future<bool> deleteDocument(FlightDocument document) async {
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final success = await _documentService.deleteDocument(document);
      
      if (success) {
        _documents.removeWhere((d) => d.id == document.id);
      } else {
        throw Exception('Failed to delete document');
      }
      
      _isUploading = false;
      notifyListeners();
      return success;
    } on FirebaseException catch (e) {
      _errorMessage = 'Failed to delete document: ${e.message}';
      _isUploading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _errorMessage = 'An unexpected error occurred during deletion.';
      print('Delete document error: $e\n$stackTrace');
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Clean up resources
  void dispose() {
    _selectedFile = null;
    super.dispose();
  }
}
