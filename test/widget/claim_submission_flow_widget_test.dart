import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:f35_flight_compensation/main.dart' as app;
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/services/auth_service.dart';
import 'package:f35_flight_compensation/screens/auth_screen.dart';
import 'package:f35_flight_compensation/screens/main_navigation.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/services/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Mocks ---

class MockUser extends Mock implements User {
  @override
  String get uid => 'test_uid';
  @override
  String? get email => 'test@example.com';
  @override
  String? get displayName => 'Test User';
}

// Create a fake FirebaseAuth to pass to the real AuthService constructor,
// preventing it from calling the real FirebaseAuth.instance.
class FakeFirebaseAuth extends Mock implements FirebaseAuth {
  // The real AuthService constructor accesses this stream. We must provide a valid, empty stream
  // to prevent a null error during the test setup.
  @override
  Stream<User?> authStateChanges() => Stream.empty();
}

// A proper mock for AuthService that implements ChangeNotifier
class MockAuthService extends AuthService with ChangeNotifier {
  User? _currentUser;

  MockAuthService({User? currentUser})
      : _currentUser = currentUser,
        super(firebaseAuth: FakeFirebaseAuth());

  @override
  User? get currentUser => _currentUser;

  // Simulate a user logging in or out and notify listeners
  void simulateLogin(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  @override
  Future<void> signOut() async {
    simulateLogin(null);
  }
}

class MockLocalizationService extends Mock implements LocalizationService {
  // Override the getter directly to avoid issues with mockito's 'when()'
  @override
  Locale get currentLocale => const Locale('en');
}

class MockAccessibilityService extends Mock implements AccessibilityService {
  // Override the method directly in the mock to avoid compile-time issues with mockito's 'when()'.
  @override
  ThemeData getThemeData(ThemeData baseTheme) => ThemeData.light();

  // Override the getter directly to avoid issues with mockito's 'when()'
  @override
  bool get largeTextMode => false;

  // Override initialize to return a completed Future, preventing the 'null' cast error.
  @override
  Future<void> initialize() => Future.value();
}

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


void main() {
  late MockAuthService mockAuthService;
  late MockAccessibilityService mockAccessibilityService;
  late MockLocalizationService mockLocalizationService;
  late User mockUser;

  setUp(() async {
    // Initialize mocks
    mockUser = MockUser();
    mockAuthService = MockAuthService(); // Starts logged out
    mockAccessibilityService = MockAccessibilityService();
    mockLocalizationService = MockLocalizationService();

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
      AuthService: mockAuthService,
      AccessibilityService: mockAccessibilityService,
      LocalizationService: mockLocalizationService,
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