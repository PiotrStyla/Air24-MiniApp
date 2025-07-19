import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

// Import mock user for development mode
import 'mock_user.dart';

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
  // Static flag to track if Firebase is unavailable for the app
  static bool isFirebaseUnavailable = false;
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  
  // Track if we're in development mode without Firebase
  bool _isDevMode = false;
  
  // Mock user for development mode
  late final MockUser _mockUser;
  
  User? _currentUser;

  // Private constructor
  AuthService._({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn}) {
    try {
      _auth = firebaseAuth ?? FirebaseAuth.instance;
      _googleSignIn = googleSignIn ?? GoogleSignIn();
    } catch (e) {
      debugPrint('Firebase Auth not available: $e');
      _isDevMode = true;
      AuthService.isFirebaseUnavailable = true;
      debugPrint('Running AuthService in development mode with mock authentication');
    }
    
    // Create mock user for development mode
    _mockUser = MockUser(
      uid: 'dev-user-123',
      displayName: 'Dev User',
      email: 'dev@example.com',
      photoURL: null,
      isAnonymous: false,
      emailVerified: true
    );
  }

  /// Public factory method for safe asynchronous creation
  static Future<AuthService> create({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn}) async {
    final authService = AuthService._(firebaseAuth: firebaseAuth, googleSignIn: googleSignIn);
    await authService._init();
    return authService;
  }

  /// Private method to handle asynchronous initialization
  Future<void> _init() async {
    // Check if we're in development mode without Firebase
    if (_isDevMode) {
      debugPrint('AuthService initializing in development mode with mock user');
      _currentUser = _mockUser;
      // Simulate delay for authentication
      await Future.delayed(const Duration(milliseconds: 300));
      notifyListeners();
      return;
    }
    
    try {
      // By awaiting the first event from the `authStateChanges` stream, we ensure
      // that the `AuthService` has a definitive initial state (either a user or null)
      // before its creation is considered complete. This resolves race conditions
      // during app startup without causing a deadlock.
      final initialUser = await _auth!.authStateChanges().first;
      _currentUser = initialUser;

      // After handling the initial state, we set up a listener for any subsequent
      // changes to keep the user state up-to-date.
      _auth!.authStateChanges().listen(_onAuthStateChanged);
    } catch (e) {
      debugPrint('Error initializing AuthService: $e');
      // Switch to development mode if Firebase auth fails
      _isDevMode = true;
      _currentUser = _mockUser;
      debugPrint('Switched to development mode with mock authentication');
      notifyListeners();
    }
  }

  // Current user getter
  User? get currentUser => _currentUser;

  // Stream for auth state changes
  Stream<User?> get userChanges {
    if (_isDevMode) {
      // Return a mock stream that just emits the current mock user
      return Stream.value(_mockUser);
    }
    return _auth!.authStateChanges();
  }

  // Get user display name or email
  String get userDisplayName {
    if (_isDevMode) {
      return _mockUser.displayName ?? _mockUser.email ?? 'Dev User';
    }
    final user = _auth!.currentUser;
    return user?.displayName ?? user?.email ?? 'Guest User';
  }

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    if (_isDevMode) {
      // In dev mode, just return a mock credential
      _currentUser = _mockUser;
      notifyListeners();
      return MockUserCredential(_mockUser);
    }
    
    try {
      return await _auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Email sign-in error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e, stackTrace) {
      debugPrint('Unexpected sign-in error: $e\n$stackTrace');
      throw AuthException('unknown', 'An unexpected error occurred. Please try again.');
    }
  }

  /// Create a new account with email and password
  Future<UserCredential> createUserWithEmail(String email, String password) async {
    if (_isDevMode) {
      // In dev mode, just return a mock credential
      _currentUser = _mockUser;
      notifyListeners();
      return MockUserCredential(_mockUser);
    }
    
    try {
      return await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Email sign-up error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e, stackTrace) {
      debugPrint('Unexpected sign-up error: $e\n$stackTrace');
      throw AuthException('unknown', 'An unexpected error occurred. Please try again.');
    }
  }

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    if (_isDevMode) {
      // In dev mode, just return a mock credential
      _currentUser = _mockUser;
      notifyListeners();
      return MockUserCredential(_mockUser);
    }
    
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth!.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint('Google sign-in error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e, stackTrace) {
      debugPrint('Unexpected Google sign-in error: $e\n$stackTrace');
      throw AuthException('google_sign_in_failed', 'Google sign-in failed. Please try again.');
    }
  }

  /// Sign in anonymously (for quick testing)
  Future<UserCredential> signInAnonymously() async {
    if (_isDevMode) {
      // In dev mode, just return a mock credential with anonymous user
      final anonymousMockUser = MockUser(
        uid: 'anon-user-${DateTime.now().millisecondsSinceEpoch}',
        displayName: null,
        email: null,
        photoURL: null,
        isAnonymous: true,
        emailVerified: false
      );
      _currentUser = anonymousMockUser;
      notifyListeners();
      return MockUserCredential(anonymousMockUser);
    }
    
    try {
      return await _auth!.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      debugPrint('Anonymous sign-in error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e, stackTrace) {
      debugPrint('Unexpected anonymous sign-in error: $e\n$stackTrace');
      throw AuthException('unknown', 'An unexpected error occurred. Please try again.');
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    if (_isDevMode) {
      // In dev mode, simulate a delay and return successfully
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }
    
    try {
      await _auth!.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e, stackTrace) {
      debugPrint('Unexpected password reset error: $e\n$stackTrace');
      throw AuthException('unknown', 'An unexpected error occurred. Please try again.');
    }
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _currentUser = user;
    notifyListeners();
  }

  /// Sign out
  Future<void> signOut() async {
    if (_isDevMode) {
      // In dev mode, just set current user to null
      _currentUser = null;
      notifyListeners();
      return;
    }
    
    try {
      if (_googleSignIn != null) {
        await _googleSignIn!.signOut(); // Sign out from Google if signed in
      }
      await _auth!.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint('Sign out error: ${e.code} - ${e.message}');
      throw _handleAuthError(e);
    } catch (e, stackTrace) {
      debugPrint('Unexpected sign out error: $e\n$stackTrace');
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