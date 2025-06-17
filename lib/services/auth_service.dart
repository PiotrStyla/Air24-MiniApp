import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

/// AuthException class to handle authentication errors in a user-friendly way
class AuthException implements Exception {
  final String code;
  final String message;

  AuthException(this.code, this.message);

  @override
  String toString() => message;
}

/// Service class for handling all authentication operations
/// Following MVVM pattern for separation of concerns
class AuthService with ChangeNotifier {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  User? _currentUser;

  // Allow injecting FirebaseAuth and GoogleSignIn for testing
  AuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _currentUser = _auth.currentUser;
  }

  // Current user getter
  User? get currentUser => _currentUser;

  // Stream for auth state changes
  Stream<User?> get userChanges => _auth.authStateChanges();

  // Get user display name or email
  String get userDisplayName {
    final user = _auth.currentUser;
    return user?.displayName ?? user?.email ?? 'Guest User';
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Email sign-in error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e) {
      debugPrint('Unexpected sign-in error: $e');
      throw AuthException('unknown', 'An unexpected error occurred. Please try again.');
    }
  }

  /// Create a new account with email and password
  Future<UserCredential> createUserWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Email sign-up error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e) {
      debugPrint('Unexpected sign-up error: $e');
      throw AuthException('unknown', 'An unexpected error occurred. Please try again.');
    }
  }

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint('Google sign-in error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e) {
      debugPrint('Unexpected Google sign-in error: $e');
      throw AuthException('google_sign_in_failed', 'Google sign-in failed. Please try again.');
    }
  }

  /// Sign in anonymously (for quick testing)
  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      debugPrint('Anonymous sign-in error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e) {
      debugPrint('Unexpected anonymous sign-in error: $e');
      throw AuthException('unknown', 'An unexpected error occurred. Please try again.');
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e) {
      debugPrint('Unexpected password reset error: $e');
      throw AuthException('unknown', 'An unexpected error occurred. Please try again.');
    }
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _currentUser = user;
    notifyListeners();
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google if signed in
      await _auth.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
      throw AuthException('sign_out_failed', 'Failed to sign out. Please try again.');
    }
  }

  /// Convert Firebase auth errors to user-friendly messages
  AuthException _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return AuthException(e.code, 'No account found with this email.');
      case 'wrong-password':
        return AuthException(e.code, 'Incorrect password. Please try again.');
      case 'email-already-in-use':
        return AuthException(e.code, 'This email is already registered. Please sign in instead.');
      case 'invalid-email':
        return AuthException(e.code, 'The email address is invalid.');
      case 'weak-password':
        return AuthException(e.code, 'Password is too weak. Please use a stronger password.');
      case 'operation-not-allowed':
        return AuthException(e.code, 'Operation not allowed. Please contact support.');
      case 'user-disabled':
        return AuthException(e.code, 'This account has been disabled. Please contact support.');
      case 'too-many-requests':
        return AuthException(e.code, 'Too many attempts. Please try again later.');
      case 'network-request-failed':
        return AuthException(e.code, 'Network error. Please check your connection and try again.');
      default:
        return AuthException(e.code, e.message ?? 'An authentication error occurred. Please try again.');
    }
  }
}