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
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/services/localization_service.dart';
import 'package:f35_flight_compensation/services/manual_localization_service.dart';
import 'package:f35_flight_compensation/services/notification_service.dart';
import 'package:f35_flight_compensation/core/error/error_handler.dart';
import 'package:f35_flight_compensation/services/document_storage_service.dart';
import 'package:f35_flight_compensation/services/mock_document_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For User
// Use ChangeNotifier-based test doubles instead of Mockito
import 'widget/mock_localization_service.dart';
import 'widget/mock_manual_localization_service.dart';
import 'mock/mock_accessibility_service.dart';

// --- Minimal Mocks for widget_test.dart ---
class MockAuthService extends ChangeNotifier implements FirebaseAuthService {
  User? _currentUser;

  // Simulate auth state changes
  void simulateLogin(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  @override
  User? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  String get userDisplayName => _currentUser?.displayName ?? 'Test User';

  @override
  Future<String> getUserDisplayNameAsync() async => userDisplayName;

  @override
  Future<void> signOut() async => simulateLogin(null);

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async => MockUserCredential(user: _currentUser);

  @override
  Future<UserCredential> createUserWithEmail(String email, String password) async => MockUserCredential(user: _currentUser);

  @override
  Future<bool> checkEmailVerified(String email) async => true;

  @override
  Future<UserCredential> signInWithGoogle() async => MockUserCredential(user: _currentUser);

  @override
  Future<void> resetPassword(String email) async {}
}

class MockUserCredential implements UserCredential {
  @override
  final User? user;

  MockUserCredential({this.user});

  @override
  AdditionalUserInfo? get additionalUserInfo => null;

  @override
  AuthCredential? get credential => null;
}

class MockNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {}
}

class MockErrorHandler implements ErrorHandler {
  @override
  Future<void> initialize() async {}
  @override
  Future<void> handleError(dynamic error, {StackTrace? stackTrace, Map<String, dynamic>? context}) async {}
}

void main() {
  setUp(() async {
    // Register mock services before each test
    await ServiceInitializer.overrideForTesting({
      FirebaseAuthService: MockAuthService(),
      AccessibilityService: MockAccessibilityService(),
      LocalizationService: MockLocalizationService(),
      DocumentStorageService: MockDocumentStorageService(),
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

    // Verify AuthScreen UI renders for logged-out state
    expect(find.text('Welcome back'), findsOneWidget); // Screen headline
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget); // Primary action button
    expect(find.text('Sign in with Google'), findsOneWidget); // Google button
  });
}
