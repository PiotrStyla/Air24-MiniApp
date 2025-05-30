import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:f35_flight_compensation/screens/document_management_screen.dart';
import 'package:f35_flight_compensation/services/document_storage_service.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/models/flight_document.dart';

// Creating an abstract class that extends ChangeNotifier and implements DocumentStorageService interface
abstract class MockableDocumentStorageService extends ChangeNotifier implements DocumentStorageService {}

// Mock classes
class MockDocumentStorageService extends MockableDocumentStorageService {
  final List<FlightDocument> _documents = [];
  bool _throwOnOperation = false;
  Completer<List<FlightDocument>>? _documentsCompleter;
  
  @override
  Future<List<FlightDocument>> getUserDocuments() async {
    if (_documentsCompleter != null) {
      return _documentsCompleter!.future;
    }
    
    if (_throwOnOperation) throw Exception('Mock error');
    return [..._documents];
  }
  
  void setDocumentsCompleter(Completer<List<FlightDocument>> completer) {
    _documentsCompleter = completer;
  }
  
  @override
  Future<void> uploadDocument(File file, String documentType) async {
    if (_throwOnOperation) throw Exception('Mock error');
    final newDocument = FlightDocument(
      id: 'doc_${_documents.length + 1}',
      userId: 'mock_user_id',
      flightNumber: 'TEST123',
      flightDate: DateTime.now(),
      documentType: _stringToDocumentType(documentType),
      documentName: 'Test $documentType',
      storageUrl: 'https://example.com/test-$documentType.pdf',
      uploadDate: DateTime.now(),
      thumbnailUrl: 'https://example.com/test-$documentType-thumb.jpg',
    );
    
    _documents.add(newDocument);
    notifyListeners();
  }
  
  @override
  Future<bool> deleteDocument(FlightDocument document) async {
    if (_throwOnOperation) throw Exception('Mock error');
    // Fix: removeWhere returns void, so we need to check the length before and after
    final lengthBefore = _documents.length;
    _documents.removeWhere((doc) => doc.id == document.id);
    final success = lengthBefore > _documents.length;
    notifyListeners();
    return success;
  }
  
  void addMockDocument(String name, String documentType) {
    final newDocument = FlightDocument(
      id: 'doc_${_documents.length + 1}',
      userId: 'mock_user_id',
      flightNumber: 'TEST123',
      flightDate: DateTime.now(),
      documentType: _stringToDocumentType(documentType),
      documentName: name,
      storageUrl: 'https://example.com/${name.toLowerCase().replaceAll(' ', '_')}.pdf',
      uploadDate: DateTime.now(),
      thumbnailUrl: 'https://example.com/${name.toLowerCase().replaceAll(' ', '_')}-thumb.jpg',
    );
    
    _documents.add(newDocument);
    notifyListeners();
  }
  
  void setThrowOnOperation(bool shouldThrow) {
    _throwOnOperation = shouldThrow;
    notifyListeners();
  }
  
  FlightDocumentType _stringToDocumentType(String type) {
    switch (type.toLowerCase()) {
      case 'boarding_pass':
        return FlightDocumentType.boardingPass;
      case 'ticket':
        return FlightDocumentType.ticket;
      case 'luggage_tag':
        return FlightDocumentType.luggageTag;
      case 'delay_confirmation':
        return FlightDocumentType.delayConfirmation;
      default:
        return FlightDocumentType.other;
    }
  }
  
  // Implement remaining methods with simple mock implementations
  @override
  Future<File?> pickImage(source) async => null;
  
  @override
  Future<String?> uploadImage(File file, {String? customPath}) async => null;
  
  @override
  Future<String?> generateThumbnail(File file) async => null;
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAccessibilityService extends AccessibilityService {
  bool _highContrastMode = false;
  bool _largeTextMode = false;
  bool _screenReaderEmphasis = false;
  
  @override
  bool get highContrastMode => _highContrastMode;
  
  @override
  bool get largeTextMode => _largeTextMode;
  
  @override
  bool get screenReaderEmphasis => _screenReaderEmphasis;
  
  @override
  Future<void> toggleHighContrastMode() async {
    _highContrastMode = !_highContrastMode;
    notifyListeners();
  }
  
  @override
  Future<void> toggleLargeTextMode() async {
    _largeTextMode = !_largeTextMode;
    notifyListeners();
  }
  
  @override
  Future<void> toggleScreenReaderEmphasis() async {
    _screenReaderEmphasis = !_screenReaderEmphasis;
    notifyListeners();
  }
  
  @override
  String semanticLabel(String defaultText, String accessibleText) {
    return _screenReaderEmphasis ? accessibleText : defaultText;
  }
}

void main() {
  late MockDocumentStorageService mockDocumentStorageService;
  late MockAccessibilityService mockAccessibilityService;
  
  setUp(() {
    mockDocumentStorageService = MockDocumentStorageService();
    mockAccessibilityService = MockAccessibilityService();
  });
  
  // Helper function to build the widget under test
  Widget createDocumentManagementScreen() {
    return MultiProvider(
      providers: [
        // Fix: Use MockableDocumentStorageService type for the provider
        ChangeNotifierProvider<MockableDocumentStorageService>.value(value: mockDocumentStorageService),
        ChangeNotifierProvider<AccessibilityService>.value(value: mockAccessibilityService),
      ],
      child: const MaterialApp(
        home: DocumentManagementScreen(),
      ),
    );
  }
  
  group('DocumentManagementScreen', () {
    testWidgets('displays empty state when no documents are available', 
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(createDocumentManagementScreen());
      await tester.pumpAndSettle();

      // Verify empty state is displayed
      expect(find.text('No Documents Found'), findsOneWidget);
      expect(find.text('Upload documents to manage them in one place'), findsOneWidget);
    });

    testWidgets('displays document list when documents are available', 
        (WidgetTester tester) async {
      // Add mock documents
      mockDocumentStorageService.addMockDocument('Boarding Pass', 'boarding_pass');
      mockDocumentStorageService.addMockDocument('Flight Ticket', 'ticket');

      // Build the widget
      await tester.pumpWidget(createDocumentManagementScreen());
      await tester.pumpAndSettle();

      // Verify document list is displayed
      expect(find.text('Boarding Pass'), findsOneWidget);
      expect(find.text('Flight Ticket'), findsOneWidget);
    });
    
    testWidgets('shows loading indicator when documents are being fetched', 
        (WidgetTester tester) async {
      // We'll use a Completer to control when the future completes
      final documentsCompleter = Completer<List<FlightDocument>>();
      
      // Override the getUserDocuments method to return our controlled future
      mockDocumentStorageService.setDocumentsCompleter(documentsCompleter);
      
      // Build the widget
      await tester.pumpWidget(createDocumentManagementScreen());
      
      // Verify loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Complete the future
      documentsCompleter.complete([]);
      await tester.pumpAndSettle();
      
      // Verify empty state is now displayed
      expect(find.text('No Documents Found'), findsOneWidget);
    });

    testWidgets('shows error message when document fetch fails', 
        (WidgetTester tester) async {
      // Set the service to throw an error
      mockDocumentStorageService.setThrowOnOperation(true);
      
      // Build the widget
      await tester.pumpWidget(createDocumentManagementScreen());
      await tester.pumpAndSettle();
      
      // Verify error message is displayed
      expect(find.text('Error Loading Documents'), findsOneWidget);
    });
    
    testWidgets('accessibility features are applied correctly', 
        (WidgetTester tester) async {
      // Enable high contrast mode
      mockAccessibilityService._highContrastMode = true;
      mockAccessibilityService.notifyListeners();
      
      // Add a document
      mockDocumentStorageService.addMockDocument('Test Document', 'test');
      
      // Build the widget
      await tester.pumpWidget(createDocumentManagementScreen());
      await tester.pumpAndSettle();
      
      // Verify document is still displayed
      expect(find.text('Test Document'), findsOneWidget);
      
      // Now enable large text mode
      mockAccessibilityService._largeTextMode = true;
      mockAccessibilityService.notifyListeners();
      await tester.pumpAndSettle();
      
      // Verify text is still visible
      expect(find.text('Test Document'), findsOneWidget);
    });
    
    testWidgets('delete document functionality works', 
        (WidgetTester tester) async {
      // Add a document
      mockDocumentStorageService.addMockDocument('Delete Test', 'test');
      
      // Build the widget
      await tester.pumpWidget(createDocumentManagementScreen());
      await tester.pumpAndSettle();
      
      // Verify document is initially displayed
      expect(find.text('Delete Test'), findsOneWidget);
      
      // Find and tap the delete button
      final deleteIcon = find.byIcon(Icons.delete);
      expect(deleteIcon, findsOneWidget);
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();
      
      // Confirm deletion in the dialog
      final confirmButton = find.text('Delete');
      expect(confirmButton, findsOneWidget);
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      
      // Verify document is no longer displayed
      expect(find.text('Delete Test'), findsNothing);
    });
  });
}
