import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import 'package:f35_flight_compensation/models/auth_exception.dart';
import 'package:f35_flight_compensation/services/mock_user.dart' as mu;

/// Unified mock implementation of FirebaseAuthService for widget and integration tests.
/// - Simulates auth flows (email/password, Google, sign out)
/// - Notifies listeners on auth state changes
/// - Supports simple in-memory account store and email verification checks
class UnifiedMockAuthService extends ChangeNotifier implements FirebaseAuthService {
  User? _currentUser;

  // Simple in-memory account store for email/password flow
  // key: normalized email; value: {password, displayName, verified}
  final Map<String, Map<String, dynamic>> _accounts = {};

  UnifiedMockAuthService({User? initialUser}) : _currentUser = initialUser;

  // ----- Public API mirrored from FirebaseAuthService -----
  @override
  User? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  String get userDisplayName {
    if (_currentUser == null) return 'Guest';
    final dn = _currentUser!.displayName;
    if (dn != null && dn.isNotEmpty) return dn;
    final email = _currentUser!.email;
    if (email != null && email.isNotEmpty) return email.split('@').first;
    return 'User';
    }

  @override
  Future<String> getUserDisplayNameAsync() async => userDisplayName;

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final e = email.trim().toLowerCase();
    final p = password.trim();
    final acc = _accounts[e];
    if (acc == null) {
      throw AuthException('user-not-found', 'No user found with this email.');
    }
    if (acc['password'] != p) {
      throw AuthException('invalid-credentials', 'Invalid email or password. Please try again.');
    }
    if (acc['verified'] != true) {
      throw AuthException('email-not-verified', 'Please verify your email address first.');
    }
    final user = mu.MockUser(
      uid: 'mock-${e.hashCode}',
      displayName: acc['displayName'] as String?,
      email: e,
      photoURL: null,
      isAnonymous: false,
      emailVerified: true,
    );
    _currentUser = user;
    notifyListeners();
    return mu.MockUserCredential(user);
  }

  @override
  Future<UserCredential> createUserWithEmail(String email, String password) async {
    final e = email.trim().toLowerCase();
    if (_accounts.containsKey(e)) {
      throw AuthException('email-already-in-use', 'An account already exists with this email address.');
    }
    _accounts[e] = {
      'password': password.trim(),
      'displayName': e.split('@').first,
      'verified': false,
    };
    // Mimic real service: account created, verification required -> throw special exception
    throw AuthException(
      'verification-email-sent',
      'Your account has been created. Please check your email to verify your account before signing in.',
    );
  }

  @override
  Future<bool> checkEmailVerified(String email) async {
    final e = email.trim().toLowerCase();
    return _accounts[e]?['verified'] == true;
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // Create a simple Google user if none present
    if (_currentUser == null) {
      final user = mu.MockUser(
        uid: 'google-mock-uid',
        displayName: 'Test Google User',
        email: 'test.google.user@example.com',
        photoURL: null,
        isAnonymous: false,
        emailVerified: true,
      );
      _currentUser = user;
    }
    notifyListeners();
    return mu.MockUserCredential(_currentUser as mu.MockUser);
  }

  @override
  Future<void> resetPassword(String email) async {
    // No-op in mock; optionally ensure account exists
    // If strict behavior is needed, uncomment the following lines:
    // final e = email.trim().toLowerCase();
    // if (!_accounts.containsKey(e)) {
    //   throw AuthException('user-not-found', 'No user found with this email.');
    // }
    return;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }

  // ----- Test helpers -----
  void simulateLogin(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  void simulateLogout() {
    _currentUser = null;
    notifyListeners();
  }

  void seedAccount({
    required String email,
    required String password,
    String? displayName,
    bool verified = false,
  }) {
    final e = email.trim().toLowerCase();
    _accounts[e] = {
      'password': password.trim(),
      'displayName': displayName ?? e.split('@').first,
      'verified': verified,
    };
  }

  void setEmailVerified(String email, bool verified) {
    final e = email.trim().toLowerCase();
    if (_accounts.containsKey(e)) {
      _accounts[e]!['verified'] = verified;
    }
  }

  static Future<UnifiedMockAuthService> create() async => UnifiedMockAuthService();
}
