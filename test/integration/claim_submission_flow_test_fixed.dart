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

// Mock classes for services
class MockAviationStackService extends AviationStackService {
  MockAviationStackService() : super(baseUrl: 'https://test-api.example.com');
  
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
  Future<List<Map<String, dynamic>>> getEUCompensationEligibleFlights({int hoursBeforeNow = 72}) async {
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
  Future<Map<String, dynamic>> checkCompensationEligibility({required String flightNumber}) async {
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

class MockDocumentOcrService extends DocumentOcrService {
  @override
  Future<Map<String, dynamic>> extractTextFromImage(File imageFile) async {
    // Return mock OCR data
    return {
      'boardingPass': {
        'flightNumber': 'BA123',
        'passengerName': 'John Smith',
        'departureAirport': 'LHR',
        'arrivalAirport': 'BER',
        'date': '2025-05-30',
      },
    };
  }
}

class MockDocumentStorageService extends DocumentStorageService {
  final List<Map<String, dynamic>> _documents = [];
  
  @override
  Future<List<Map<String, dynamic>>> getUserDocuments() async {
    return _documents;
  }
  
  @override
  Future<void> uploadDocument(File file, String documentType) async {
    _documents.add({
      'id': 'doc_${_documents.length + 1}',
      'name': 'Test $documentType',
      'type': documentType,
      'uploadDate': DateTime.now().toIso8601String(),
      'url': 'https://example.com/test-$documentType.pdf',
    });
  }
}

class MockClaimSubmissionService extends ClaimSubmissionService {
  @override
  Future<Map<String, dynamic>> submitClaim(Map<String, dynamic> claimData) async {
    // Return mock submission result
    return {
      'success': true,
      'claimId': 'CLM12345',
      'estimatedProcessingDays': 14,
      'message': 'Your claim has been successfully submitted.',
    };
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
    ServiceInitializer.testMode = true;
    ServiceInitializer.testOverrides = {
      'aviationStackService': mockAviationStackService,
      'documentOcrService': mockDocumentOcrService,
      'documentStorageService': mockDocumentStorageService,
      'claimSubmissionService': mockClaimSubmissionService,
    };
  });
  
  // Reset test mode after each test
  tearDown(() {
    ServiceInitializer.testMode = false;
    ServiceInitializer.testOverrides = {};
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
    final textScaleFactor = tester.binding.window.textScaleFactor;
    expect(textScaleFactor, greaterThan(1.0));
    
    // Return to home screen
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();

    // Verify we're back on the home screen
    expect(find.text('Flight Compensation'), findsOneWidget);
  });
}
