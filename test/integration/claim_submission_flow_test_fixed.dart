import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// App imports
import 'package:f35_flight_compensation/main.dart' as app;
import 'package:f35_flight_compensation/services/aviation_stack_service.dart';
import 'package:f35_flight_compensation/services/document_ocr_service.dart';
import 'package:f35_flight_compensation/services/document_storage_service.dart';
import 'package:f35_flight_compensation/services/claim_submission_service.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:f35_flight_compensation/models/document_ocr_result.dart';
import 'package:f35_flight_compensation/models/flight_document.dart';
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import '../mock/unified_mock_auth_service.dart';
import 'package:f35_flight_compensation/services/mock_user.dart' as mu;

// Mock classes for services
class MockAviationStackService extends AviationStackService {
  MockAviationStackService() : super(baseUrl: 'https://test-api.example.com', pythonBackendUrl: 'mock_python_url');
  
  @override
  Future<List<Map<String, dynamic>>> getRecentArrivals({required String airportIcao, int minutesBeforeNow = 360}) async {
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
  Future<List<Map<String, dynamic>>> getEUCompensationEligibleFlights({int hours = 72, bool relaxEligibilityForDebugging = false}) async {
    // Return mock eligible flights
    return [
      {
        'flightNumber': 'LH456',
        'airline': 'Lufthansa',
        'departureAirport': 'Munich',
        'arrivalAirport': 'Madrid',
        'departureTime': '2025-05-29T08:00:00Z',
        'arrivalTime': '2025-05-29T10:30:00Z',
        'status': 'delayed',
        'delayMinutes': 185,
        'isEligibleForCompensation': true,
        'potentialCompensationAmount': 400,
        'currency': 'EUR',
        'distance': 1500,
        'isDelayedOver3Hours': true,
      }
    ];
  }
  
  @override
  Future<Map<String, dynamic>> checkCompensationEligibility({String? date, required String flightNumber}) async {
    // Return mock eligibility data
    return {
      'isEligible': true,
      'flightNumber': flightNumber,
      'airline': flightNumber.startsWith('BA') ? 'British Airways' : 'Lufthansa',
      'departureAirport': 'Berlin',
      'arrivalAirport': 'London',
      'departureDate': '2025-05-28',
      'arrivalDate': '2025-05-28',
      'delayMinutes': 195,
      'reason': 'Flight delayed more than 3 hours',
      'estimatedCompensation': 400,
      'currency': 'EUR',
    };
  }
}

class MockDocumentOcrService implements DocumentOcrService {
  final Map<String, Map<String, DocumentOcrResult>> _resultsByUserId = {};
  String _currentUserId = 'test_user_fixed';

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  @override
  Future<DocumentOcrResult> scanDocument({
    required File imageFile,
    required DocumentType documentType,
    String userId = '',
  }) async {
    final effectiveUserId = userId.isEmpty ? _currentUserId : userId;
    final docId = 'ocr_fixed_${DateTime.now().millisecondsSinceEpoch}';
    final result = DocumentOcrResult(
      documentId: docId,
      imagePath: imageFile.path,
      scanDate: DateTime.now(),
      extractedFields: {'mockField': 'mockValueFixed', 'flightNumber': 'BA123'},
      rawText: 'Mock OCR raw text from fixed test',
      documentType: documentType,
    );
    _resultsByUserId.putIfAbsent(effectiveUserId, () => {})[docId] = result;
    return result;
  }

  @override
  Future<List<DocumentOcrResult>> getOcrResultsForUser(String userId) async {
    return _resultsByUserId[userId]?.values.toList() ?? [];
  }

  @override
  Future<DocumentOcrResult?> getOcrResultById(String userId, String documentId) async {
    return _resultsByUserId[userId]?[documentId];
  }

  Future<void> updateOcrResult(String userId, String documentId, Map<String, dynamic> data) async {
    final result = _resultsByUserId[userId]?[documentId];
    if (result != null) {
      final updatedResult = result.copyWith(
        extractedFields: {...result.extractedFields, ...data},
      );
      _resultsByUserId[userId]![documentId] = updatedResult;
    }
  }

  @override
  Future<void> deleteOcrResult(String userId, String documentId) async {
    _resultsByUserId[userId]?.remove(documentId);
  }

  @override
  void dispose() {
    _resultsByUserId.clear();
    // In a real scenario with a TextRecognizer, you might call _textRecognizer.close();
  }
}

class MockDocumentStorageService implements DocumentStorageService {
  final Map<String, List<FlightDocument>> _documentsByUserId = {};
  String _currentUserId = 'test_user_fixed';

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  @override
  Future<FlightDocument?> saveDocument({
    String? description,
    required String documentName,
    required FlightDocumentType documentType,
    required DateTime flightDate,
    required String flightNumber,
    Map<String, dynamic>? metadata,
    required String storageUrl,
    String? thumbnailUrl,
  }) async {
    final docId = 'doc_fixed_${DateTime.now().millisecondsSinceEpoch}';
    final document = FlightDocument(
      id: docId,
      userId: _currentUserId,
      documentName: documentName,
      documentType: documentType,
      flightDate: flightDate,
      flightNumber: flightNumber,
      uploadDate: DateTime.now(),
      storageUrl: storageUrl,
      thumbnailUrl: thumbnailUrl ?? 'https://example.com/thumb-$docId.jpg',
      description: description ?? '',
      metadata: metadata ?? {},
    );
    _documentsByUserId.putIfAbsent(_currentUserId, () => []).add(document);
    return document;
  }

  @override
  Future<List<FlightDocument>> getAllUserDocuments() async {
    return _documentsByUserId[_currentUserId] ?? [];
  }

  @override
  Future<bool> deleteDocument(FlightDocument document) async {
    final userDocs = _documentsByUserId[document.userId];
    if (userDocs != null) {
      final initialLength = userDocs.length;
      userDocs.removeWhere((d) => d.id == document.id);
      return userDocs.length < initialLength;
    }
    return false;
  }

  @override
  Future<List<FlightDocument>> getFlightDocuments(String flightNumber) async {
    final userDocs = _documentsByUserId[_currentUserId] ?? [];
    return userDocs.where((doc) => doc.flightNumber == flightNumber).toList();
  }

  @override
  Stream<List<FlightDocument>> streamFlightDocuments(String flightNumber) {
    final userDocs = _documentsByUserId[_currentUserId] ?? [];
    final filteredDocs = userDocs.where((doc) => doc.flightNumber == flightNumber).toList();
    return Stream.value(filteredDocs);
  }

  @override
  Future<File?> pickDocument() async {
    final tempDir = await Directory.systemTemp.createTemp('test_doc_fixed');
    final dummyFile = File('${tempDir.path}/dummy_document_fixed.pdf');
    await dummyFile.writeAsString('dummy document content fixed');
    return dummyFile;
  }

  @override
  Future<File?> pickImage(ImageSource source) async {
    final tempDir = await Directory.systemTemp.createTemp('test_img_fixed');
    final dummyFile = File('${tempDir.path}/dummy_image_fixed.jpg');
    await dummyFile.writeAsString('dummy image content fixed');
    return dummyFile;
  }

  @override
  Future<String?> uploadFile(File file, String flightNumber, FlightDocumentType documentType) async {
    // The 'path' parameter from the old mock seems to correspond to 'flightNumber'
    return 'https://mockstorage.example.com/fixed/$flightNumber/${file.path.split('/').last}';
  }
  
  @override
  Future<String?> createThumbnail(File imageFile) async {
    // Simplified mock, actual implementation might involve image processing
    return 'https://mockstorage.example.com/fixed/thumbnails/${imageFile.path.split('/').last}.jpg';
  }
}

class MockClaimSubmissionService extends ClaimSubmissionService {
  @override
  Future<String> submitClaim(Map<String, dynamic> claimData) async {
    // Return mock submission result (claim ID)
    return 'CLM12345_fixed';
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  // Create mock services
  final mockAviationStackService = MockAviationStackService();
  final mockDocumentOcrService = MockDocumentOcrService();
  final mockDocumentStorageService = MockDocumentStorageService();
  final mockClaimSubmissionService = MockClaimSubmissionService();
  final accessibilityService = AccessibilityService();
  
  // Register a special version of ServiceInitializer that uses our mock services
  setUp(() {
    ServiceInitializer.setTestMode(true);
    // Seed a logged-in user for AuthGate to route to MainNavigation
    final authMock = UnifiedMockAuthService(
      initialUser: mu.MockUser(
        uid: 'test_user_fixed',
        displayName: 'Test User',
        email: 'test.user@example.com',
        photoURL: null,
        isAnonymous: false,
        emailVerified: true,
      ),
    );
    // Align dependent mocks' user context
    mockDocumentOcrService.setCurrentUserId('test_user_fixed');
    mockDocumentStorageService.setCurrentUserId('test_user_fixed');

    ServiceInitializer.overrideForTesting({
      FirebaseAuthService: authMock,
      AviationStackService: mockAviationStackService,
      DocumentOcrService: mockDocumentOcrService,
      DocumentStorageService: mockDocumentStorageService,
      ClaimSubmissionService: mockClaimSubmissionService,
      AccessibilityService: accessibilityService,
    });
  });
  
  // Reset test mode after each test
  tearDown(() {
    ServiceInitializer.resetForTesting();
  });
  
  testWidgets('Complete claim submission flow with accessibility features',
      (WidgetTester tester) async {
    // Launch the app
    app.main();
    await tester.pumpAndSettle();

    // First, navigate to the Accessibility Settings through the Profile Screen
    // Find and tap on the Profile tab
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Verify we're on the Profile screen
    expect(find.text('Profile'), findsOneWidget);

    // Find and tap on the Accessibility button
    await tester.tap(find.text('Accessibility'));
    await tester.pumpAndSettle();

    // Verify we're on the Accessibility Settings screen
    expect(find.text('Accessibility Settings'), findsOneWidget);

    // Enable high contrast mode
    await tester.tap(find.text('High Contrast Mode'));
    await tester.pumpAndSettle();

    // Enable large text mode
    await tester.tap(find.text('Large Text Mode'));
    await tester.pumpAndSettle();

    // Navigate back to the main navigation
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    
    // Go to the Home tab
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();

    // Start a new claim by tapping on 'New Claim' button
    await tester.tap(find.text('New Claim'));
    await tester.pumpAndSettle();

    // Verify we're on the claim submission screen
    expect(find.text('Flight Compensation Claim'), findsOneWidget);

    // Step 1: Fill in flight information
    // Find the flight number input field and enter BA123
    await tester.enterText(find.byType(TextField).first, 'BA123');
    await tester.pumpAndSettle();

    // Tap the 'Check Eligibility' button
    await tester.tap(find.text('Check Eligibility'));
    await tester.pumpAndSettle();

    // Verify eligibility results are displayed
    expect(find.text('Eligible for Compensation'), findsOneWidget);
    expect(find.text('\u20ac400'), findsOneWidget);

    // Tap 'Continue' to proceed to next step
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 2: Passenger Information
    // Fill in the passenger information
    await tester.enterText(find.byKey(const Key('firstNameField')), 'John');
    await tester.enterText(find.byKey(const Key('lastNameField')), 'Smith');
    await tester.enterText(find.byKey(const Key('emailField')), 'john.smith@example.com');
    await tester.enterText(find.byKey(const Key('phoneField')), '+441234567890');
    await tester.pumpAndSettle();

    // Tap Continue to proceed to next step
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 3: Document Upload
    // Tap on 'Upload Boarding Pass' button
    await tester.tap(find.text('Upload Boarding Pass'));
    await tester.pumpAndSettle();

    // In the integration test we use a mock to simulate document upload
    // The mock should automatically add a document when the uploadDocument method is called
    // We can simulate the upload complete callback
    // Verification will happen when we check the document list

    // Tap Continue to proceed to next step
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 4: Review and Submit
    // Verify the review screen shows the correct information
    expect(find.text('Flight: BA123'), findsOneWidget);
    expect(find.text('British Airways'), findsOneWidget);
    expect(find.text('John Smith'), findsOneWidget);
    
    // Check the T&C checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    // Submit the claim
    await tester.tap(find.text('Submit Claim'));
    await tester.pumpAndSettle();

    // Verify success screen is shown
    expect(find.text('Claim Submitted Successfully'), findsOneWidget);
    expect(find.text('CLM12345'), findsOneWidget);
    
    // Verify the accessibility features are still applied
    // This is best done by checking certain widget properties or theme data
    // For example, check that text scales are bigger than the default
    final textScaleFactor = tester.platformDispatcher.textScaleFactor;
    expect(textScaleFactor, greaterThan(1.0));
    
    // Return to home screen
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();

    // Verify we're back on the home screen
    expect(find.text('Flight Compensation'), findsOneWidget);
  });
}
