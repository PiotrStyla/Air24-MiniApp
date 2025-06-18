import 'dart:async';
import 'dart:io';

import 'dart:async';
import 'dart:io';

import 'package:f35_flight_compensation/l10n/l10n.dart';
import 'package:f35_flight_compensation/models/claim.dart';
import 'package:f35_flight_compensation/models/document_ocr_result.dart';
import 'package:f35_flight_compensation/services/airline_procedure_service.dart';
import 'package:f35_flight_compensation/services/claim_validation_service.dart';
import 'package:f35_flight_compensation/services/document_ocr_service.dart';
import 'package:f35_flight_compensation/services/firestore_service.dart';
import 'package:f35_flight_compensation/services/opensky_api_service.dart';
import 'package:f35_flight_compensation/utils/error_handler.dart';
import 'package:f35_flight_compensation/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:f35_flight_compensation/screens/claim_submission_screen.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/services/auth_service.dart';
import 'package:f35_flight_compensation/services/localization_service.dart';
import 'package:f35_flight_compensation/viewmodels/document_scanner_viewmodel.dart';

import '../mock/mock_firebase.dart';

// --- Mock Services ---

class MockAuthService extends AuthService with ChangeNotifier {
  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

  void simulateLogin(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void simulateLogout() {
    _currentUser = null;
    notifyListeners();
  }

  @override
  Future<void> signOut() async {
    simulateLogout();
  }
}

class MockAccessibilityService extends AccessibilityService {
  // ... implementation from previous tests ...
}

class MockLocalizationService extends LocalizationService {
  @override
  Locale get currentLocale => const Locale('en');
  @override
  Future<void> changeLanguage(Locale newLocale, {bool forceReload = false}) async {}
}

class MockManualLocalizationService extends ManualLocalizationService {
    @override
  Future<void> ensureLanguageLoaded(String languageCode) async {}

  @override
  Future<void> forceReload(String languageCode) async {}
}

class MockNotificationService implements NotificationService {
  @override
  void show(String message, {NotificationType type = NotificationType.info}) {}
}

class MockErrorHandler implements ErrorHandler {
  @override
  void handleError(dynamic error, StackTrace? stackTrace, {String? context}) {}
}

class MockDocumentOcrService implements DocumentOcrService {
  @override
  Future<DocumentOcrResult> scanDocument({required File imageFile, required DocumentType documentType, required String userId}) async {
    return DocumentOcrResult(id: 'ocr-123', userId: userId, type: documentType, data: {'field': 'value'});
  }

  @override
  Future<List<DocumentOcrResult>> getOcrResultsForUser(String userId) async => [];

  @override
  Future<void> deleteOcrResult(String userId, String documentId) async {}

  @override
  Future<DocumentOcrResult?> getOcrResultById(String userId, String documentId) async => null;
}

class MockDocumentScannerViewModel extends DocumentScannerViewModel {
    MockDocumentScannerViewModel({required DocumentOcrService ocrService, required AuthService authService})
        : super(ocrService: ocrService, authService: authService);
}

class MockFirestoreService implements FirestoreService {
  @override
  Future<List<Claim>> getClaimsForUser(String userId) async => [];
  // Add other methods as needed for tests
}

// NOTE: The following mock classes are for static services. We cannot inject these mocks.
// The tests will call the real static methods. This is a limitation of the current app architecture.
class MockClaimValidationService {
  static Future<ClaimValidationResult> validateClaim(Claim claim, List<Claim> existingClaims, {bool verifyWithOpenSky = true}) async {
    if (claim.flightNumber.isEmpty) {
      return ClaimValidationResult(isValid: false, errors: ['Please enter a flight number']);
    }
    return ClaimValidationResult(isValid: true);
  }
}

class MockOpenSkyApiService {
  static Future<List<Map<String, dynamic>>> findFlightsByFlightNumber({required String flightNumber, required DateTime flightDate, required String username, required String password}) async => [];
}

class MockAirlineProcedureService {
    static Future<AirlineClaimProcedure?> getProcedureByIata(String iata) async => null;
}

void main() {
  // Mocks
  late MockAuthService mockAuthService;
  late MockAccessibilityService mockAccessibilityService;
  late MockLocalizationService mockLocalizationService;
  late MockManualLocalizationService mockManualLocalizationService;
  late MockNotificationService mockNotificationService;
  late MockErrorHandler mockErrorHandler;
  late MockDocumentOcrService mockDocumentOcrService;
  late MockDocumentScannerViewModel mockDocumentScannerViewModel;
  late MockFirestoreService mockFirestoreService;

  setupFirebaseAuthMocks();

  setUpAll(() async {
    await ServiceInitializer.initialize(testing: true);

    mockAuthService = MockAuthService();
    mockAccessibilityService = MockAccessibilityService();
    mockLocalizationService = MockLocalizationService();
    mockManualLocalizationService = MockManualLocalizationService();
    mockNotificationService = MockNotificationService();
    mockErrorHandler = MockErrorHandler();
    mockDocumentOcrService = MockDocumentOcrService();
    mockDocumentScannerViewModel = MockDocumentScannerViewModel(
        ocrService: mockDocumentOcrService, authService: mockAuthService);
    mockFirestoreService = MockFirestoreService();

    await ServiceInitializer.overrideForTesting({
      AuthService: mockAuthService,
      AccessibilityService: mockAccessibilityService,
      LocalizationService: mockLocalizationService,
      ManualLocalizationService: mockManualLocalizationService,
      NotificationService: mockNotificationService,
      ErrorHandler: mockErrorHandler,
      DocumentScannerViewModel: mockDocumentScannerViewModel,
      FirestoreService: mockFirestoreService,
    });
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      home: child,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
    );
  }

  group('ClaimSubmissionScreen', () {
    setUp(() {
      // Reset mocks before each test
      mockAuthService.simulateLogout();
    });

    testWidgets('shows initial fields correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const ClaimSubmissionScreen()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('flightNumberField')), findsOneWidget);
      expect(find.byKey(const Key('departureAirportField')), findsOneWidget);
      expect(find.byKey(const Key('arrivalAirportField')), findsOneWidget);
      expect(find.byKey(const Key('flightDateField')), findsOneWidget);
      expect(find.byKey(const Key('submitClaimButton')), findsOneWidget);
    });

    testWidgets('shows validation error for empty fields on submit', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const ClaimSubmissionScreen()));
        await tester.pumpAndSettle();

        // Tap submit without entering data
        await tester.tap(find.byKey(const Key('submitClaimButton')));
        await tester.pumpAndSettle();

        // The real validation service is complex and static. We can't easily mock its response.
        // Instead, we check for a generic error message that appears when fields are empty.
        expect(find.text('Please fill in all required fields.'), findsOneWidget);
    });

    testWidgets('pre-fills data from widget constructor', (WidgetTester tester) async {
      const flightNumber = 'LH123';
      const departureAirport = 'FRA';
      final flightDate = DateTime.now();

      await tester.pumpWidget(createTestWidget(ClaimSubmissionScreen(
        prefillFlightNumber: flightNumber,
        prefillDepartureAirport: departureAirport,
        prefillFlightDate: flightDate,
      )));
      await tester.pumpAndSettle();

      final flightNumberField = tester.widget<TextFormField>(find.byKey(const Key('flightNumberField')));
      expect(flightNumberField.controller!.text, flightNumber);

      final departureAirportField = tester.widget<TextFormField>(find.byKey(const Key('departureAirportField')));
      expect(departureAirportField.controller!.text, departureAirport);

      // Verify date is reflected in the UI.
      expect(find.text(DateFormat.yMd().format(flightDate)), findsOneWidget);
    });
  });
}
