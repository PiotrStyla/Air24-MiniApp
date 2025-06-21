// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:f35_flight_compensation/main.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/services/auth_service.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/services/localization_service.dart';
import 'package:f35_flight_compensation/services/manual_localization_service.dart';
import 'package:f35_flight_compensation/services/notification_service.dart';
import 'package:f35_flight_compensation/core/error/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For User
import 'package:mockito/mockito.dart'; // For Mock

// --- Minimal Mocks for widget_test.dart ---
class MockAuthService extends Mock implements AuthService {
  @override
  Stream<User?> get authStateChanges => Stream.value(null); // Default to logged out
  @override
  User? get currentUser => null;
}

class MockAccessibilityService extends Mock implements AccessibilityService {
  @override
  ThemeData getThemeData(ThemeData baseTheme) => baseTheme;
  @override
  bool get largeTextMode => false;
  @override
  Future<void> initialize() => Future.value();
}

class MockLocalizationService extends Mock implements LocalizationService {
  @override
  Locale get currentLocale => const Locale('en');
  @override
  Future<void> initialize() => Future.value();
  @override
  Future<void> changeLanguage(Locale locale) => Future.value();
  @override
  List<Locale> get supportedLocales => [const Locale('en')];
  @override
  String getDisplayLanguage(String languageCode) => languageCode;
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';
}

class MockManualLocalizationService extends Mock implements ManualLocalizationService {
  @override
  bool get isReady => true;

  @override
  Locale get currentLocale => const Locale('en');

  @override
  Future<void> init() => Future.value();

  @override
  Future<void> setLocale(Locale locale) => Future.value();

  @override
  String getString(String key, {String fallback = ''}) => key;

  @override
  Future<void> ensureLanguageLoaded(String languageCode) => Future.value();
}

class MockNotificationService extends Mock implements NotificationService {
  @override
  Future<void> initialize() => Future.value();
}

class MockErrorHandler extends Mock implements ErrorHandler {
  @override
  Future<void> initialize() => Future.value();
  @override
  Future<void> handleError(dynamic error, {StackTrace? stackTrace, Map<String, dynamic>? context}) async {}
}

void main() {
  setUp(() async {
    // Register mock services before each test
    await ServiceInitializer.overrideForTesting({
      AuthService: MockAuthService(),
      AccessibilityService: MockAccessibilityService(),
      LocalizationService: MockLocalizationService(),
      ManualLocalizationService: MockManualLocalizationService(),
      NotificationService: MockNotificationService(),
      ErrorHandler: MockErrorHandler(),
    });
  });

  tearDown(() async {
    // Reset the service locator after each test
    await ServiceInitializer.resetForTesting();
  });

  testWidgets('AuthGate loads initial screen when logged out', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const F35FlightCompensationApp());

    // Verify AuthGate is present initially.
    expect(find.byType(AuthGate), findsOneWidget);

    // Allow time for AuthGate to process auth state and build its child (e.g., AuthScreen).
    await tester.pumpAndSettle(); 

    // At this point, AuthGate should have built AuthScreen because MockAuthService defaults to logged out.
    // A more robust test would be to find a specific widget within AuthScreen.
    // For example, if AuthScreen has a title 'Login' or a specific Key:
    // expect(find.text('Login'), findsOneWidget); // Assuming AuthScreen shows 'Login'
    // expect(find.byKey(const Key('authScreenScaffold')), findsOneWidget);
  });
}
