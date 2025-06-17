import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';


// App imports
import 'package:f35_flight_compensation/main.dart' as app;
import 'package:f35_flight_compensation/screens/main_navigation.dart';
import 'package:f35_flight_compensation/screens/profile_screen.dart';
import 'package:f35_flight_compensation/screens/accessibility_settings_screen.dart';
import 'package:f35_flight_compensation/screens/claim_submission_screen.dart';
import 'package:f35_flight_compensation/services/aviation_stack_service.dart';
import 'package:f35_flight_compensation/services/document_ocr_service.dart';
import 'package:f35_flight_compensation/services/document_storage_service.dart';
import 'package:f35_flight_compensation/services/claim_submission_service.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/models/flight_document.dart';
import 'package:f35_flight_compensation/models/document_ocr_result.dart'; // Added

// Mock classes for services
class MockAviationStackService extends AviationStackService {
  MockAviationStackService({super.pythonBackendUrl = 'http://localhost:8000'})
      : super(baseUrl: 'https://mock-api.example.com');
  
  @override
  Future<List<Map<String, dynamic>>> getRecentArrivals({
    required String airportIcao,
    int minutesBeforeNow = 360,
  }) async {
    // Return mock flight data
    return [
      {
        'flightNumber': 'BA123',
        'airline': 'British Airways',
        'departureAirport': 'London Heathrow',
        'arrivalAirport': 'Berlin Brandenburg',
        'departureTime': '2025-05-30T10:00:00Z',
        'arrivalTime': '2025-05-30T12:30:00Z',
        'status': 'delayed',
        'delayMinutes': 190, // Over 3 hours delay for compensation eligibility
      }
    ];
  }
  
  @override
  Future<List<Map<String, dynamic>>> getEUCompensationEligibleFlights({
    int hours = 72,
    bool relaxEligibilityForDebugging = false,
  }) async {
    // Return mock eligible flights
    return [
      {
        'flightNumber': 'LH456',
        'airline': 'Lufthansa',
        'departureAirport': 'Munich',
        'arrivalAirport': 'Madrid',
        'departureTime': '2025-05-29T08:00:00Z',
        'arrivalTime': '2025-05-29T10:45:00Z',
        'status': 'delayed',
        'delayMinutes': 195,
        'isEligibleForCompensation': true,
        'potentialCompensationAmount': 400,
        'currency': 'EUR',
      }
    ];
  }
  
  @override
  Future<Map<String, dynamic>> checkCompensationEligibility({
    required String flightNumber,
    String? date,
  }) async {
    // Mock eligibility check
    return {
      'isEligible': true,
      'flightNumber': flightNumber,
      'airline': 'Test Airline',
      'departureAirport': 'Test Departure',
      'arrivalAirport': 'Test Arrival',
      'departureDate': date ?? '2025-05-28',
      'arrivalDate': date ?? '2025-05-28',
      'delayMinutes': 220,
      'reason': 'Delayed more than 3 hours',
      'estimatedCompensation': 400,
      'currency': 'EUR',
    };
  }
}

class MockDocumentOcrService implements DocumentOcrService {
  @override
  Future<DocumentOcrResult> scanDocument({
    required File imageFile,
    required DocumentType documentType,
    String userId = '',
  }) async {
    // Return a mock DocumentOcrResult
    return DocumentOcrResult(
      documentId: 'mock_doc_id_${DateTime.now().millisecondsSinceEpoch}',
      imagePath: imageFile.path,
      scanDate: DateTime.now(),
      extractedFields: {'mockField': 'mockValue'},
      rawText: 'Mock raw text',
      documentType: documentType,
    );
  }

  @override
  Future<List<DocumentOcrResult>> getOcrResultsForUser(String userId) async {
    return [];
  }

  @override
  Future<DocumentOcrResult?> getOcrResultById(String userId, String documentId) async {
    return null;
  }

  Stream<DocumentOcrResult?> getOcrResultStream(String userId, String documentId) {
    // Create a mock DocumentOcrResult for the stream
    final mockResult = DocumentOcrResult(
      documentId: documentId,
      imagePath: '/mock/path',
      scanDate: DateTime.now(),
      extractedFields: {'streamField': 'streamValue'},
      rawText: 'Mock stream text',
      documentType: DocumentType.unknown, // Default or make configurable
    );
    return Stream.value(mockResult);
  }

  @override
  Future<void> deleteOcrResult(String userId, String documentId) async {
    return;
  }

  Future<void> updateOcrResult(String userId, String documentId, Map<String, dynamic> data) async {
    return;
  }

  // Add dispose method to satisfy the interface, even if it does nothing in the mock.
  // The actual service uses TextRecognizer which has a close() method.
  @override
  void dispose() {
    // In a real scenario, if _textRecognizer were part of this mock, you'd call _textRecognizer.close() here.
  }
}

class MockDocumentStorageService implements DocumentStorageService {
  final List<FlightDocument> _documents = [];
  
  @override
  Future<List<FlightDocument>> getAllUserDocuments() async {
    return _documents;
  }
  
  // This mock method differs from DocumentStorageService.uploadFile
  Future<void> uploadDocument(File file, String documentType) async {
    final newDocument = FlightDocument(
      id: 'test-doc-${DateTime.now().millisecondsSinceEpoch}',
      userId: 'test-user',
      flightNumber: 'LH1234',
      flightDate: DateTime.now(),
      documentType: FlightDocumentType.boardingPass,
      documentName: 'Test Boarding Pass',
      storageUrl: 'https://example.com/test.pdf',
      uploadDate: DateTime.now(),
    );
    
    _documents.add(newDocument);
  }
  
  @override
  Future<bool> deleteDocument(FlightDocument document) async {
    final lengthBefore = _documents.length;
    _documents.removeWhere((doc) => doc.id == document.id);
    return lengthBefore > _documents.length;
  }
  
  @override
  Future<File?> pickImage(source) async => null;
  
  // This method is not in DocumentStorageService
  Future<String?> uploadImage(File file, {String? customPath}) async => 'https://example.com/test.jpg';
  
  @override
  Future<String?> createThumbnail(File file) async => 'https://example.com/test-thumb.jpg';
  
  @override
  Future<String?> uploadFile(File file, String flightNumber, FlightDocumentType type) async {
    final newDocument = FlightDocument(
      id: 'test-doc-file-${DateTime.now().millisecondsSinceEpoch}',
      userId: 'test-user',
      flightNumber: flightNumber,
      flightDate: DateTime.now(),
      documentType: type,
      documentName: 'Uploaded ${type.name}',
      storageUrl: 'https://example.com/uploaded_${file.path.split('/').last}',
      uploadDate: DateTime.now(),
    );
    _documents.add(newDocument);
    return newDocument.storageUrl;
  }

  @override
  Future<File?> pickDocument() async {
    return null;
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
    final newDoc = FlightDocument(
        id: 'doc_save_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'mock_user_id', // The actual service gets this internally
        flightNumber: flightNumber,
        flightDate: flightDate,
        documentType: documentType,
        documentName: documentName,
        storageUrl: storageUrl,
        description: description,
        thumbnailUrl: thumbnailUrl,
        metadata: metadata,
        uploadDate: DateTime.now());
    _documents.add(newDoc);
    return newDoc;
  }

  @override
  Future<List<FlightDocument>> getFlightDocuments(String flightNumber) async {
    return _documents.where((doc) => doc.flightNumber == flightNumber).toList();
  }

  @override
  Stream<List<FlightDocument>> streamFlightDocuments(String flightNumber) {
    // Return a stream that emits the current list of matching documents
    // For a more sophisticated mock, you might use a StreamController
    return Stream.value(_documents.where((doc) => doc.flightNumber == flightNumber).toList());
  }
}

class MockClaimSubmissionService extends ClaimSubmissionService {
  final List<Map<String, dynamic>> _claims = [];
  
  @override
  Future<String> submitClaim(Map<String, dynamic> claimData) async {
    final claimId = 'claim-${DateTime.now().millisecondsSinceEpoch}';
    final claim = {
      'id': claimId,
      ...claimData,
      'userId': 'test-user',
      'submissionDate': DateTime.now().toIso8601String(),
      'status': 'pending',
    };
    
    _claims.add(claim);
    return claimId;
  }
  
  @override
  Future<List<Map<String, dynamic>>> getUserClaims() async {
    return _claims;
  }
  
  @override
  Future<Map<String, dynamic>> getClaimById(String claimId) async {
    final claim = _claims.firstWhere(
      (claim) => claim['id'] == claimId,
      orElse: () => throw Exception('Claim not found'),
    );
    return claim;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Flight Compensation App - Claim Submission Flow', () {
    testWidgets('Complete claim submission with accessibility features',
        (WidgetTester tester) async {
      // Setup mock services
      final mockAviationService = MockAviationStackService();
      final mockDocumentOcrService = MockDocumentOcrService();
      final mockDocumentStorageService = MockDocumentStorageService();
      final mockClaimSubmissionService = MockClaimSubmissionService();
      
      // Register services for dependency injection
      // Using the existing ServiceInitializer's test mode functionality
      ServiceInitializer.overrideForTesting({
        AviationStackService: mockAviationService,
        DocumentOcrService: mockDocumentOcrService,
        DocumentStorageService: mockDocumentStorageService,
        ClaimSubmissionService: mockClaimSubmissionService,
      });
      
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Verify main navigation loaded
      expect(find.byType(MainNavigation), findsOneWidget);
      
      // Step 1: Navigate to Profile and enable accessibility features
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      
      expect(find.byType(ProfileScreen), findsOneWidget);
      
      // Tap on Accessibility button
      await tester.tap(find.text('Accessibility'));
      await tester.pumpAndSettle();
      
      expect(find.byType(AccessibilitySettingsScreen), findsOneWidget);
      
      // Enable high contrast mode
      await tester.tap(find.text('High Contrast Mode'));
      await tester.pumpAndSettle();
      
      // Enable large text mode
      await tester.tap(find.text('Large Text Mode'));
      await tester.pumpAndSettle();
      
      // Enable screen reader emphasis
      await tester.tap(find.text('Screen Reader Emphasis'));
      await tester.pumpAndSettle();
      
      // Go back to profile
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Step 2: Navigate to Claim Submission
      await tester.tap(find.text('New Compensation Claim'));
      await tester.pumpAndSettle();
      
      expect(find.byType(ClaimSubmissionScreen), findsOneWidget);
      
      // Step 3: Enter flight details
      await tester.enterText(find.byKey(const Key('flightNumberField')), 'LH1234');
      await tester.pumpAndSettle();
      
      // Select date (tap date picker and confirm)
      await tester.tap(find.byKey(const Key('departureDateField')));
      await tester.pumpAndSettle();
      
      // Select a date in the date picker
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      
      // Continue to next step
      await tester.tap(find.text('Check Eligibility'));
      await tester.pumpAndSettle();
      
      // Step 4: Review eligibility and continue
      expect(find.text('Your Flight is Eligible!'), findsOneWidget);
      
      await tester.tap(find.text('Continue to Claim Form'));
      await tester.pumpAndSettle();
      
      // Step 5: Fill in passenger details
      await tester.enterText(find.byKey(const Key('nameField')), 'John Smith');
      await tester.enterText(find.byKey(const Key('emailField')), 'john@example.com');
      await tester.enterText(find.byKey(const Key('phoneField')), '+1234567890');
      
      // Continue to document upload
      await tester.tap(find.text('Continue to Documents'));
      await tester.pumpAndSettle();
      
      // Step 6: Upload document (simulated)
      await tester.tap(find.text('Upload Boarding Pass'));
      await tester.pumpAndSettle();
      
      // Since we can't actually pick a file in tests, we'll simulate the upload success
      expect(find.text('Document Uploaded'), findsOneWidget);
      
      // Step 7: Complete submission
      await tester.tap(find.text('Submit Claim'));
      await tester.pumpAndSettle();
      
      // Verify success screen
      expect(find.text('Claim Submitted Successfully'), findsOneWidget);
      
      // Reset services for future tests
      ServiceInitializer.resetForTesting();
    });
  });
}
