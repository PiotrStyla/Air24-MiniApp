import 'dart:io' as io;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:f35_flight_compensation/main.dart' as app;
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import 'package:f35_flight_compensation/screens/auth_screen.dart';
import 'package:f35_flight_compensation/screens/main_navigation.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/services/localization_service.dart';
import 'package:f35_flight_compensation/services/manual_localization_service.dart';
import 'package:f35_flight_compensation/services/notification_service.dart';
import 'package:f35_flight_compensation/core/error/error_handler.dart';
import 'package:f35_flight_compensation/services/document_storage_service.dart';
import 'package:f35_flight_compensation/services/mock_document_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:f35_flight_compensation/services/mock_user.dart' as mu;
import '../mock/unified_mock_auth_service.dart';
import 'mock_localization_service.dart';
import 'mock_manual_localization_service.dart';
import '../mock/mock_accessibility_service.dart';
import 'mock_notification_service.dart';

// --- Mocks ---

// Mock for HttpClient to prevent network errors for images
class MockHttpClient extends Mock implements io.HttpClient {
  @override
  Future<io.HttpClientRequest> getUrl(Uri url) {
    final request = MockHttpClientRequest();
    final response = MockHttpClientResponse();
    when(request.close()).thenAnswer((_) async => response);
    when(response.statusCode).thenReturn(io.HttpStatus.ok);
    when(response.contentLength).thenReturn(0);
    when(response.listen(any, onDone: anyNamed('onDone'), onError: anyNamed('onError'), cancelOnError: anyNamed('cancelOnError')))
        .thenAnswer((invocation) {
      invocation.namedArguments[#onDone]?.call();
      return Stream<List<int>>.empty().listen(null);
    });
    return Future.value(request);
  }
}
class MockHttpClientRequest extends Mock implements io.HttpClientRequest {}
class MockHttpClientResponse extends Mock implements io.HttpClientResponse {}

// Using shared MockNotificationService from test/widget/mock_notification_service.dart

class MockErrorHandler implements ErrorHandler {
  final _controller = StreamController<AppError>.broadcast();

  @override
  Stream<AppError> get errorStream => _controller.stream;

  @override
  Future<void> handleError(dynamic error, {StackTrace? stackTrace, Map<String, dynamic>? context}) async {
    _controller.add(AppError(
      type: ErrorType.unknown,
      message: error.toString(),
      originalError: error,
      stackTrace: stackTrace,
      context: context,
    ));
  }

  @override
  void showErrorUI(BuildContext context, AppError error) {
    // no-op in tests
  }

  @override
  void dispose() {
    _controller.close();
  }
}

void main() {
  late UnifiedMockAuthService mockAuthService;
  late MockAccessibilityService mockAccessibilityService;
  late MockLocalizationService mockLocalizationService;
  late MockNotificationService mockNotificationService;
  late MockManualLocalizationService mockManualLocalizationService;
  late MockErrorHandler mockErrorHandler;
  late MockDocumentStorageService mockDocumentStorageService;
  late mu.MockUser mockUser;

  setUp(() async {
    // Initialize mocks
    mockUser = mu.MockUser(
      uid: 'widget-test-user',
      displayName: 'Widget Tester',
      email: 'widget@test.com',
      photoURL: null,
      isAnonymous: false,
      emailVerified: true,
    );
    mockAuthService = UnifiedMockAuthService(); // Starts logged out
    mockAccessibilityService = MockAccessibilityService();
    mockLocalizationService = MockLocalizationService();
    mockNotificationService = MockNotificationService();
    mockManualLocalizationService = MockManualLocalizationService();
    mockErrorHandler = MockErrorHandler();
    mockDocumentStorageService = MockDocumentStorageService();

    // Set up default behaviors for mocks
        // The currentLocale getter is now overridden directly in the MockLocalizationService class.
    // No 'when()' stub is needed here.
    // 'supportedLocales' is a static member and cannot be stubbed on an instance. This line is removed.

    // The getThemeData method is now overridden directly in the MockAccessibilityService class.
    // No 'when()' stub is needed here.
        // The largeTextMode getter is now overridden directly in the MockAccessibilityService class.
    // No 'when()' stub is needed here.
    // 'isInitialized' getter does not exist on AccessibilityService. This line is removed.

    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Override all necessary services for the test environment
    // This is the key step: we inject our MockAuthService.
    await ServiceInitializer.overrideForTesting({
      FirebaseAuthService: mockAuthService,
      AccessibilityService: mockAccessibilityService,
      LocalizationService: mockLocalizationService,
      DocumentStorageService: mockDocumentStorageService,
      NotificationService: mockNotificationService,
      ManualLocalizationService: mockManualLocalizationService,
      ErrorHandler: mockErrorHandler,
    });
  });

  tearDown(() async {
    await ServiceInitializer.resetForTesting();
  });

  testWidgets('AuthGate correctly shows AuthScreen when logged out and MainNavigation when logged in', (WidgetTester tester) async {
    // Use runZoned to capture network requests (like for images) and mock them
    await io.HttpOverrides.runZoned(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const app.F35FlightCompensationApp());

      // Let the widget tree settle.
      await tester.pumpAndSettle();

      // **Assert Initial State (Logged Out)**
      // At this point, MockAuthService has a null user.
      expect(find.byType(AuthScreen), findsOneWidget, reason: 'AuthScreen should be visible when the user is logged out');
      expect(find.byType(MainNavigation), findsNothing, reason: 'MainNavigation should not be visible when the user is logged out');

      // **Act: Simulate User Login**
      // This will update the MockAuthService and call notifyListeners().
      mockAuthService.simulateLogin(mockUser);

      // Rebuild the widget tree to reflect the state change.
      await tester.pumpAndSettle();

      // **Assert Final State (Logged In)**
      // The AuthGate should now show the MainNavigation widget.
      expect(find.byType(MainNavigation), findsOneWidget, reason: 'MainNavigation should be visible after a user logs in');
      expect(find.byType(AuthScreen), findsNothing, reason: 'AuthScreen should not be visible after a user logs in');

    }, createHttpClient: (_) => MockHttpClient());
  });
}