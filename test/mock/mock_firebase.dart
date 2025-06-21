import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart'; // Assuming GetIt is used for service location

// Default mock user for convenience in tests
final mockUser = MockUser(
  isAnonymous: false,
  uid: 'mock_uid_123',
  email: 'test@example.com',
  displayName: 'Mock Test User',
  // Add other properties if your app uses them:
  // photoURL: 'https://example.com/avatar.png',
  // phoneNumber: '+11234567890',
  // emailVerified: true,
);

void setupFirebaseAuthMocks({MockUser? userToLogin, bool signedInByDefault = true}) {
  TestWidgetsFlutterBinding.ensureInitialized();

  final authInstance = MockFirebaseAuth(
    mockUser: userToLogin ?? (signedInByDefault ? mockUser : null),
    signedIn: signedInByDefault || (userToLogin != null),
  );

  // If GetIt is used and FirebaseAuth is registered, unregister and register the mock.
  // This is a common pattern for overriding services in tests.
  if (GetIt.instance.isRegistered<FirebaseAuth>()) {
    GetIt.instance.unregister<FirebaseAuth>();
  }
  GetIt.instance.registerSingleton<FirebaseAuth>(authInstance);
}

// Helper to simulate a logged-in state with a specific user
void simulateLogin({required MockUser user}) {
  final authInstance = GetIt.instance<FirebaseAuth>();
  if (authInstance is MockFirebaseAuth) {
    authInstance.mockUser = user; // This should trigger authStateChanges
  }
}

// Helper to simulate a logged-out state
Future<void> simulateLogout() async {
  final authInstance = GetIt.instance<FirebaseAuth>();
  if (authInstance is MockFirebaseAuth) {
    await authInstance.signOut(); // This handles internal state and notifies listeners
  }
}
