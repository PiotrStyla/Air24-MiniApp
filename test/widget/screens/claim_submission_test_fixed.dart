import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:f35_flight_compensation/screens/claim_submission_screen.dart';
import 'package:f35_flight_compensation/services/aviation_stack_service.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/viewmodels/claim_submission_viewmodel.dart';

// Manual mock classes
class MockAviationStackService extends AviationStackService {
  MockAviationStackService() : super(baseUrl: 'https://test-api.example.com');
  
  // Track method calls for verification
  final List<Map<String, dynamic>> methodCalls = [];
  
  // Override methods to provide mock implementations
  @override
  Future<Map<String, dynamic>> checkCompensationEligibility({
    required String flightNumber,
    String? date,
  }) async {
    methodCalls.add({
      'method': 'checkCompensationEligibility',
      'flightNumber': flightNumber,
      'date': date,
    });
    
    if (_shouldReturnEligible) {
      return {
        'isEligible': true,
        'flightNumber': flightNumber,
        'airline': 'Lufthansa',
        'departureAirport': 'Munich',
        'arrivalAirport': 'Madrid',
        'departureDate': date ?? '2025-05-28',
        'arrivalDate': date ?? '2025-05-28',
        'delayMinutes': 220,
        'reason': 'Delayed more than 3 hours',
        'estimatedCompensation': 400,
        'currency': 'EUR',
      };
    } else {
      return {
        'isEligible': false,
        'flightNumber': flightNumber,
        'airline': 'Lufthansa',
        'departureAirport': 'Munich',
        'arrivalAirport': 'Madrid',
        'departureDate': date ?? '2025-05-28',
        'arrivalDate': date ?? '2025-05-28',
        'delayMinutes': 45,
        'reason': 'Delay less than 3 hours',
        'estimatedCompensation': 0,
        'currency': 'EUR',
      };
    }
  }
  
  // Flag to control eligibility response
  bool _shouldReturnEligible = true;
  
  void setEligibilityResponse(bool isEligible) {
    _shouldReturnEligible = isEligible;
  }
  
  // Verification helper
  bool wasMethodCalled(String methodName, {Map<String, dynamic>? withParams}) {
    for (final call in methodCalls) {
      if (call['method'] != methodName) continue;
      
      if (withParams != null) {
        bool allParamsMatch = true;
        for (final entry in withParams.entries) {
          if (call[entry.key] != entry.value) {
            allParamsMatch = false;
            break;
          }
        }
        if (allParamsMatch) return true;
      } else {
        return true;
      }
    }
    return false;
  }
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
  
  void setHighContrastMode(bool value) {
    _highContrastMode = value;
    notifyListeners();
  }
  
  void setLargeTextMode(bool value) {
    _largeTextMode = value;
    notifyListeners();
  }
  
  void setScreenReaderEmphasis(bool value) {
    _screenReaderEmphasis = value;
    notifyListeners();
  }
  
  @override
  String semanticLabel(String defaultText, String accessibleText) {
    return _screenReaderEmphasis ? accessibleText : defaultText;
  }
}

void main() {
  late MockAviationStackService mockAviationService;
  late MockAccessibilityService mockAccessibilityService;
  late ClaimSubmissionViewModel viewModel;

  setUp(() {
    mockAviationService = MockAviationStackService();
    mockAccessibilityService = MockAccessibilityService();
    viewModel = ClaimSubmissionViewModel(
      aviationService: mockAviationService,
    );
  });

  // Helper function to build widget under test with necessary providers
  Widget createClaimSubmissionWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AviationStackService>.value(value: mockAviationService),
        ChangeNotifierProvider<AccessibilityService>.value(value: mockAccessibilityService),
        ChangeNotifierProvider<ClaimSubmissionViewModel>.value(value: viewModel),
      ],
      child: const MaterialApp(
        home: ClaimSubmissionScreen(),
      ),
    );
  }

  group('ClaimSubmissionScreen', () {
    testWidgets('shows flight number field and date picker',
        (WidgetTester tester) async {
      await tester.pumpWidget(createClaimSubmissionWidget());
      await tester.pumpAndSettle();

      // Check that the flight number field is displayed
      expect(find.byKey(const Key('flightNumberField')), findsOneWidget);
      
      // Check that the date picker field is displayed
      expect(find.byKey(const Key('departureDateField')), findsOneWidget);
      
      // Check that the continue button is displayed
      expect(find.text('Check Eligibility'), findsOneWidget);
    });

    testWidgets('validates flight number before continuing',
        (WidgetTester tester) async {
      await tester.pumpWidget(createClaimSubmissionWidget());
      await tester.pumpAndSettle();

      // Try to continue without entering flight number
      await tester.tap(find.text('Check Eligibility'));
      await tester.pumpAndSettle();
      
      // Should show validation error
      expect(find.text('Please enter a flight number'), findsOneWidget);
      
      // Enter a valid flight number
      await tester.enterText(find.byKey(const Key('flightNumberField')), 'LH1234');
      await tester.pumpAndSettle();
      
      // Try to continue again
      await tester.tap(find.text('Check Eligibility'));
      await tester.pumpAndSettle();
      
      // Should no longer show validation error
      expect(find.text('Please enter a flight number'), findsNothing);
    });

    testWidgets('checks eligibility and shows results',
        (WidgetTester tester) async {
      mockAviationService.setEligibilityResponse(true);
      
      await tester.pumpWidget(createClaimSubmissionWidget());
      await tester.pumpAndSettle();

      // Enter flight details
      await tester.enterText(find.byKey(const Key('flightNumberField')), 'LH1234');
      await tester.pumpAndSettle();
      
      // Tap date field and select a date
      await tester.tap(find.byKey(const Key('departureDateField')));
      await tester.pumpAndSettle();
      
      // Tap OK on date picker
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      
      // Tap check eligibility
      await tester.tap(find.text('Check Eligibility'));
      await tester.pumpAndSettle();
      
      // Verify mock was called with correct parameters
      expect(
        mockAviationService.wasMethodCalled(
          'checkCompensationEligibility',
          withParams: {'flightNumber': 'LH1234'},
        ),
        true,
      );
      
      // Verify eligibility result is displayed
      expect(find.text('Your Flight is Eligible!'), findsOneWidget);
      expect(find.text('Estimated Compensation: €400'), findsOneWidget);
      expect(find.text('Continue to Claim Form'), findsOneWidget);
    });

    testWidgets('handles ineligible flights correctly',
        (WidgetTester tester) async {
      // Set mock to return ineligible response
      mockAviationService.setEligibilityResponse(false);
      
      await tester.pumpWidget(createClaimSubmissionWidget());
      await tester.pumpAndSettle();

      // Enter flight details
      await tester.enterText(find.byKey(const Key('flightNumberField')), 'LH1234');
      await tester.pumpAndSettle();
      
      // Tap date field and select a date
      await tester.tap(find.byKey(const Key('departureDateField')));
      await tester.pumpAndSettle();
      
      // Tap OK on date picker
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      
      // Tap check eligibility
      await tester.tap(find.text('Check Eligibility'));
      await tester.pumpAndSettle();
      
      // Verify ineligibility result is displayed
      expect(find.text('Flight Not Eligible'), findsOneWidget);
      expect(find.text('Reason: Delay less than 3 hours'), findsOneWidget);
      expect(find.text('Check Another Flight'), findsOneWidget);
    });

    testWidgets('applies accessibility settings correctly',
        (WidgetTester tester) async {
      // Enable accessibility features
      mockAccessibilityService.setHighContrastMode(true);
      mockAccessibilityService.setLargeTextMode(true);
      mockAccessibilityService.setScreenReaderEmphasis(true);

      await tester.pumpWidget(createClaimSubmissionWidget());
      await tester.pumpAndSettle();
      
      // Verify the screen still functions with accessibility features enabled
      await tester.enterText(find.byKey(const Key('flightNumberField')), 'LH1234');
      await tester.pumpAndSettle();
      
      await tester.tap(find.byKey(const Key('departureDateField')));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Check Eligibility'));
      await tester.pumpAndSettle();
      
      // The screen should still function with accessibility features enabled
      expect(find.text('Your Flight is Eligible!'), findsOneWidget);
    });
  });
}
