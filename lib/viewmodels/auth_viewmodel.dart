import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import '../services/auth_service_firebase.dart';
import '../models/auth_exception.dart';
import '../services/world_id_interop.dart' if (dart.library.html) '../services/world_id_interop_web.dart';
import '../services/world_id_service.dart';

/// ViewModel for authentication screens
/// Follows MVVM pattern with ChangeNotifier for state management
class AuthViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService;
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Getters
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isAuthenticated => _authService.currentUser != null;
  User? get currentUser => _authService.currentUser;

  // Constructor
  AuthViewModel(this._authService) {
    print('[AuthViewModel Constructor] Initialized with FirebaseAuthService: ${_authService.runtimeType}');
  }

  // Input handlers
  void setEmail(String email) {
    _email = email;
    _errorMessage = null;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    _errorMessage = null;
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _errorMessage = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Validation
  bool validateEmail() {
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(_email);
  }

  bool validatePassword() {
    // Password should be at least 6 characters
    return _password.length >= 6;
  }

  bool validateSignUp() {
    if (!validateEmail()) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }
    
    if (!validatePassword()) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }
    
    if (_password != _confirmPassword) {
      _errorMessage = 'Passwords do not match';
      notifyListeners();
      return false;
    }
    
    return true;
  }

  bool validateSignIn() {
    if (_email.isEmpty) {
      _errorMessage = 'Please enter your email';
      notifyListeners();
      return false;
    }
    
    if (_password.isEmpty) {
      _errorMessage = 'Please enter your password';
      notifyListeners();
      return false;
    }
    
    return true;
  }

  // Authentication actions
  Future<bool> signIn() async {
    if (!validateSignIn()) return false;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _authService.signInWithEmail(_email, _password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      // Log the error for debugging
      print('Sign-in error: $e\n$stackTrace');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp() async {
    print('🔴 AuthViewModel: signUp() called with email=${_email.split('@')[0]}@...');
    if (!validateSignUp()) {
      print('🔴 AuthViewModel: Validation failed: ${_errorMessage}');
      return false;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    print('🔴 AuthViewModel: Validation passed, calling _authService.createUserWithEmail()');
    
    try {
      print('🔴 AuthViewModel: Trying to create user with email/password...');
      final result = await _authService.createUserWithEmail(_email, _password);
      print('🔴 AuthViewModel: User created successfully: ${result.user?.email}');
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print('❌ AuthViewModel: FirebaseAuthException during sign-up: ${e.code} - ${e.message}');
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } on AuthException catch (e) {
      print('❌ AuthViewModel: AuthException during sign-up: ${e.code} - ${e.message}');
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      print('❌ AuthViewModel: Unhandled exception during sign-up: $e');
      print('📋 AuthViewModel: Stack trace: $stackTrace');
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithWorldID() async {
    print('🌍 AuthViewModel: World ID Sign-In button pressed - starting process...');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      print('🌍 AuthViewModel: Checking World ID availability...');
      final available = await worldIdAvailable();
      
      if (!available) {
        throw AuthException(
          'world-id-unavailable',
          'World ID is not available. Please try another sign-in method.',
        );
      }
      
      print('🌍 AuthViewModel: Opening World ID verification...');
      final proof = await openWorldId(
        appId: 'app_6f4b07c9d84438a94414813a89974ab0',
        action: 'flight-compensation-mini-app-verify',
      );
      
      if (proof == null) {
        throw AuthException(
          'world-id-cancelled',
          'World ID verification was cancelled.',
        );
      }
      
      print('🌍 AuthViewModel: World ID proof received: ${proof.keys}');
      
      // Verify the proof on backend
      final worldIdService = WorldIdService();
      final verification = await worldIdService.verify(
        nullifierHash: proof['nullifier_hash'] ?? '',
        merkleRoot: proof['merkle_root'] ?? '',
        proof: proof['proof'] ?? '',
        verificationLevel: proof['verification_level'] ?? 'device',
        action: 'flight-compensation-mini-app-verify',
      );
      
      if (!verification.success) {
        throw AuthException(
          'world-id-verify-failed',
          verification.message ?? 'World ID verification failed.',
        );
      }
      
      print('✅ AuthViewModel: World ID verified successfully!');
      
      // World ID verified - now create/sign in user
      // For World App integration, we'll use email/password with the nullifier hash
      final worldIdHash = proof['nullifier_hash'] ?? '';
      final tempEmail = 'worldid_$worldIdHash@air24.app';
      final tempPassword = worldIdHash.substring(0, 20); // Use part of hash as password
      
      try {
        // Try to sign in first
        await _authService.signInWithEmail(tempEmail, tempPassword);
      } catch (e) {
        // If sign in fails, create new account
        await _authService.createUserWithEmail(tempEmail, tempPassword);
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      print('❌ AuthViewModel: AuthException during World ID: ${e.code} - ${e.message}');
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      print('❌ AuthViewModel: Unexpected error during World ID: $e');
      print('📋 AuthViewModel: Stack trace: $stackTrace');
      _errorMessage = 'World ID sign-in failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    print('AuthViewModel: Google Sign-In button pressed - starting process...');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      print('AuthViewModel: Calling AuthService.signInWithGoogle()...');
      final result = await _authService.signInWithGoogle();
      print('AuthViewModel: AuthService.signInWithGoogle() completed. Result: $result');
      
      // UserCredential object cannot be null as per Firebase SDK design
      print('AuthViewModel: Google Sign-In result: User: ${result.user?.displayName ?? "Unknown"} (${result.user?.email ?? "Unknown"})');
      
      _isLoading = false;
      notifyListeners();
      return true;  // Success - UserCredential is always non-null when returned
    } on FirebaseAuthException catch (e) {
      print('AuthViewModel: Firebase auth error during Google Sign-In: ${e.code} - ${e.message}');
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } on AuthException catch (e) {
      // Special handling for web redirect flow: this is not an error
      if (e.code == 'redirect') {
        print('AuthViewModel: Web redirect initiated for Google Sign-In; suppressing error and keeping loading state.');
        // Keep loading true so the UI shows a spinner until the page navigates away.
        // The app will reload and complete the redirect via FirebaseAuthService._completeWebRedirectIfPending().
        return false;
      }
      print('AuthViewModel: AuthException during Google Sign-In: ${e.code} - ${e.message}');
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      print('AuthViewModel: Unexpected error during Google Sign-In: $e');
      print('AuthViewModel: Stack trace: $stackTrace');
      _errorMessage = 'Google sign-in failed. Please try again.';
      // Log the error for debugging
      print('Google sign-in error: $e\n$stackTrace');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword() async {
    if (!validateEmail()) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _authService.resetPassword(_email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Password reset failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _authService.signOut();
      _email = '';
      _password = '';
      _confirmPassword = '';
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Sign out failed. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
