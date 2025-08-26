import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:image_picker/image_picker.dart'; // Added for ImageSource

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
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import '../mock/unified_mock_auth_service.dart';
import 'package:f35_flight_compensation/services/mock_user.dart' as mu;

import 'package:f35_flight_compensation/models/flight_document.dart';
import 'package:f35_flight_compensation/models/document_ocr_result.dart'; // Added for DocumentOcrResult and DocumentType

/// This class provides the ability to override services during testing
class TestServiceInitializer {
  static bool testMode = false;
  static Map<Type, dynamic> testOverrides = {};

  /// Register services with specific overrides for testing
  static void registerServices() {
    // Implementation would go here
  }
}

// Mock classes for services
class MockAviationStackService extends AviationStackService {
  MockAviationStackService({super.baseUrl = 'https://test-api.example.com', super.pythonBackendUrl = 'https://test-python-backend.example.com'});
  
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

// Mock class for DocumentOcrService
class MockDocumentOcrService implements DocumentOcrService {
  final Map<String, List<DocumentOcrResult>> _resultsByUserId = {}; // Store results per user, made final

  @override
  Future<DocumentOcrResult> scanDocument({
    required File imageFile,
    required DocumentType documentType,
    String userId = 'mock-user-id', // Default mock user ID
  }) async {
    final result = DocumentOcrResult(
      documentId: 'ocr-doc-${DateTime.now().millisecondsSinceEpoch}',
      imagePath: imageFile.path,
      scanDate: DateTime.now(),
      extractedFields: {'field1': 'value1', 'type': documentType.toString()},
      rawText: 'Mock raw text from ${imageFile.path}',
      documentType: documentType,
      // userId: userId, // DocumentOcrResult does not have userId field
    );
    _resultsByUserId.putIfAbsent(userId, () => []).add(result);
    return result;
  }

  @override
  Future<List<DocumentOcrResult>> getOcrResultsForUser(String userId) async {
    return List.from(_resultsByUserId[userId] ?? []);
  }

  @override // Added back based on analyzer feedback
  Future<DocumentOcrResult?> getOcrResultById(String userId, String documentId) async {
    final userResults = _resultsByUserId[userId];
    if (userResults == null) return null;
    try {
      return userResults.firstWhere((res) => res.documentId == documentId);
    } catch (e) {
      return null; // Not found
    }
  }

  @override
  Stream<DocumentOcrResult?> getOcrResultStream(String userId, String documentId) {
    final userResults = _resultsByUserId[userId];
    DocumentOcrResult? currentResult;
    if (userResults != null) {
      try {
        currentResult = userResults.firstWhere((res) => res.documentId == documentId);
      } catch (e) {
        currentResult = null; // Not found
      }
    }
    return Stream.value(currentResult);
  }

  @override
  Future<void> deleteOcrResult(String userId, String documentId) async {
    _resultsByUserId[userId]?.removeWhere((result) => result.documentId == documentId);
  }

  @override // Added back based on analyzer feedback
  Future<void> updateOcrResult(String userId, String documentId, Map<String, dynamic> data) async {
    final userResults = _resultsByUserId[userId];
    if (userResults == null) return;
    final index = userResults.indexWhere((result) => result.documentId == documentId);
    if (index != -1) {
      // This is a simplified update. A real mock might merge fields or reconstruct the object.
      // For example, if 'data' contains new 'extractedFields':
      // final currentResult = userResults[index];
      // final updatedFields = Map<String, String>.from(currentResult.extractedFields)..addAll(Map<String, String>.from(data['extractedFields'] as Map));
      // userResults[index] = currentResult.copyWith(extractedFields: updatedFields); // Assuming a copyWith method
      // print('MockDocumentOcrService: updateOcrResult called for $documentId. Data: $data'); // Removed print
    }
  }

  @override
  void dispose() {
    _resultsByUserId.clear();
    // print('MockDocumentOcrService disposed.'); // Removed print
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    // print('MockDocumentOcrService: Called unmocked method ${invocation.memberName}'); // Removed print
    return super.noSuchMethod(invocation);
  }
}

// Mock class for DocumentStorageService
class MockDocumentStorageService implements DocumentStorageService {
  final List<FlightDocument> _documents = [];
  String _currentUserId = 'mock-user-id'; // Mock current user

  // Helper to simulate user context, actual service uses FirebaseAuth.instance.currentUser.uid
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  @override
  Future<List<FlightDocument>> getAllUserDocuments() async {
    return List.from(_documents.where((doc) => doc.userId == _currentUserId));
  }

  @override
  Future<FlightDocument?> saveDocument({
    required String flightNumber,
    required DateTime flightDate,
    required FlightDocumentType documentType,
    required String documentName,
    required String storageUrl, // This would typically come from a separate upload step
    String? description,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final newDocument = FlightDocument(
      id: metadata?['id'] as String? ?? 'mock-doc-${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUserId, // Use the mock current user ID
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
    _documents.add(newDocument);
    return newDocument;
  }

  @override
  Future<bool> deleteDocument(FlightDocument document) async {
    if (document.userId != _currentUserId) return false; // Basic security check
    final lengthBefore = _documents.length;
    _documents.removeWhere((doc) => doc.id == document.id && doc.userId == _currentUserId);
    return lengthBefore > _documents.length;
  }

  @override
  Stream<List<FlightDocument>> streamFlightDocuments(String flightNumber) {
    return Stream.value(_documents.where((doc) => doc.flightNumber == flightNumber && doc.userId == _currentUserId).toList());
  }
  
  // Methods from DocumentStorageService that might be needed by tests, but are not the primary focus of current fixes.
  // They are not part of a strict 'interface' if we only consider what ClaimSubmissionFlow tests use directly via the mock.
  // However, if other tests use this mock and need these, they should be implemented or properly mocked.

  @override // Added @override
  Future<File?> pickImage(ImageSource source) async {
    // print('MockDocumentStorageService: pickImage called. Returning null.'); // Removed print
    return null; // Mock behavior
  }

  @override // Added @override
  Future<String?> uploadFile(File file, String flightNumber, FlightDocumentType type) async {
    // print('MockDocumentStorageService: uploadFile called. Returning mock URL.'); // Removed print
    // Simulate an upload and return a mock URL
    final String fileName = file.path.split(Platform.pathSeparator).last;
    return 'mock/storage/users/$_currentUserId/flight_documents/$flightNumber/$fileName';
  }

  @override // Added @override
  Future<String?> createThumbnail(File file) async {
    // print('MockDocumentStorageService: createThumbnail called. Returning null.'); // Removed print
    return null; // Mock behavior
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    // print('MockDocumentStorageService: Called unmocked method ${invocation.memberName}'); // Removed print
    return super.noSuchMethod(invocation);
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
    setUp(() {
      ServiceInitializer.setTestMode(true);
    });

    tearDown(() {
      ServiceInitializer.resetForTesting();
    });

    testWidgets('Complete claim submission with accessibility features',
        (WidgetTester tester) async {
      // Setup mock services
      final mockAviationService = MockAviationStackService();
      final mockDocumentOcrService = MockDocumentOcrService();
      final mockDocumentStorageService = MockDocumentStorageService();
      final mockClaimSubmissionService = MockClaimSubmissionService();
      // Seed a logged-in user so AuthGate navigates to MainNavigation
      final authMock = UnifiedMockAuthService(
        initialUser: mu.MockUser(
          uid: 'test-user',
          displayName: 'Test User',
          email: 'test.user@example.com',
          photoURL: null,
          isAnonymous: false,
          emailVerified: true,
        ),
      );
      // Align storage mock to the same user context
      mockDocumentStorageService.setCurrentUserId('test-user');
      
      // Register services for dependency injection
      TestServiceInitializer.testOverrides = {
        FirebaseAuthService: authMock,
        AviationStackService: mockAviationService,
        DocumentOcrService: mockDocumentOcrService,
        DocumentStorageService: mockDocumentStorageService,
        ClaimSubmissionService: mockClaimSubmissionService,
      };
      
      // Inject our test services
      ServiceInitializer.overrideForTesting(TestServiceInitializer.testOverrides.cast<Type, Object>());
      
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
      TestServiceInitializer.testMode = false;
      TestServiceInitializer.testOverrides = {};
    });
  });
}
