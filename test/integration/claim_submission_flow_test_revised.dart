import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

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
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/models/flight_document.dart';

/// This class provides the ability to override services during testing
class TestServiceInitializer {
  static bool _testMode = false;
  static Map<Type, dynamic> _testOverrides = {};

  static bool get testMode => _testMode;
  static set testMode(bool value) => _testMode = value;

  static Map<Type, dynamic> get testOverrides => _testOverrides;
  static set testOverrides(Map<Type, dynamic> value) => _testOverrides = value;

  /// Register services with specific overrides for testing
  static void registerServices() {
    // Implementation would go here
  }
}

// Mock classes for services
class MockAviationStackService extends AviationStackService {
  MockAviationStackService() : super(baseUrl: 'https://test-api.example.com');
  
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

class MockDocumentOcrService extends ChangeNotifier implements DocumentOcrService {
  @override
  Future<Map<String, String>> extractTextFromImage(File imageFile) async {
    // Return mock OCR results
    return {
      'flightNumber': 'LH1234',
      'airline': 'Lufthansa',
      'passengerName': 'John Smith',
      'departureAirport': 'MUC',
      'arrivalAirport': 'MAD',
      'departureDate': '2025-05-28',
    };
  }
}

class MockDocumentStorageService extends ChangeNotifier implements DocumentStorageService {
  final List<FlightDocument> _documents = [];
  
  @override
  Future<List<FlightDocument>> getUserDocuments() async {
    return _documents;
  }
  
  @override
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
    notifyListeners();
  }
  
  @override
  Future<bool> deleteDocument(FlightDocument document) async {
    final lengthBefore = _documents.length;
    _documents.removeWhere((doc) => doc.id == document.id);
    final success = lengthBefore > _documents.length;
    notifyListeners();
    return success;
  }
  
  @override
  Future<File?> pickImage(source) async => null;
  
  @override
  Future<String?> uploadImage(File file, {String? customPath}) async => 'https://example.com/test.jpg';
  
  @override
  Future<String?> generateThumbnail(File file) async => 'https://example.com/test-thumb.jpg';
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
      TestServiceInitializer.testMode = true;
      TestServiceInitializer.testOverrides = {
        AviationStackService: mockAviationService,
        DocumentOcrService: mockDocumentOcrService,
        DocumentStorageService: mockDocumentStorageService,
        ClaimSubmissionService: mockClaimSubmissionService,
      };
      
      // Inject our test services
      ServiceInitializer.registerMockServices(TestServiceInitializer.testOverrides);
      
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
