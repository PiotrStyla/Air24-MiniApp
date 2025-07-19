import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

/// A mock User class that implements the User interface from Firebase Auth
/// This is used for development mode when Firebase Auth isn't available
class MockUser implements User {
  @override
  final String uid;
  
  @override
  final String? displayName;
  
  @override
  final String? email;
  
  @override
  final String? photoURL;
  
  @override
  final bool isAnonymous;
  
  @override
  final bool emailVerified;

  const MockUser({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.isAnonymous,
    required this.emailVerified,
  });

  // Implementing all required User interface methods with mock values
  
  @override
  Future<void> delete() async {}
  
  @override
  Future<String?> getIdToken([bool forceRefresh = false]) async => 'mock-id-token';
  
  // This is not needed as we directly implement emailVerified
  
  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) async {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) async {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<void> reload() async {}
  
  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {}
  
  @override
  Future<User> unlink(String providerId) async {
    return this;
  }
  
  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {}
  
  @override
  MultiFactor get multiFactor => MockMultiFactor();
  
  // Additional methods needed by the User interface
  @override
  Future<ConfirmationResult> linkWithPhoneNumber(String phoneNumber, [RecaptchaVerifier? verifier]) {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<UserCredential> linkWithPopup(AuthProvider provider) {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<void> linkWithRedirect(AuthProvider provider) {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<UserCredential> reauthenticateWithPopup(AuthProvider provider) {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<void> reauthenticateWithRedirect(AuthProvider provider) {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<UserCredential> reauthenticateWithProvider(AuthProvider provider) {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<void> updateDisplayName(String? displayName) async {}
  
  @override
  Future<void> updateEmail(String newEmail) async {}
  
  @override
  Future<void> updatePassword(String newPassword) async {}
  
  @override
  Future<void> updatePhotoURL(String? photoURL) async {}
  
  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) async {}

  // Additional properties required by the User interface with mock values
  @override
  String? get phoneNumber => null;
  
  @override
  String? get tenantId => null;
  
  @override
  String? get refreshToken => 'mock-refresh-token';
  
  @override
  List<UserInfo> get providerData => [];
  
  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail, [ActionCodeSettings? actionCodeSettings]) async {}
  
  @override
  UserMetadata get metadata => MockUserMetadata();
}

/// A mock UserCredential class for development without Firebase
class MockUserCredential implements UserCredential {
  final MockUser _mockUser;
  
  MockUserCredential(this._mockUser);
  
  @override
  User? get user => _mockUser;
  
  @override
  AdditionalUserInfo? get additionalUserInfo => null;
  
  @override
  AuthCredential? get credential => null;
}

/// Mock MultiFactor implementation
class MockMultiFactor implements MultiFactor {
  @override
  Future<MultiFactorSession> getSession() async {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<void> enroll(MultiFactorAssertion assertion, {String? displayName}) async {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<void> unenroll({String? factorUid, MultiFactorInfo? multiFactorInfo}) async {
    throw UnimplementedError('Not available in mock mode');
  }
  
  @override
  Future<List<MultiFactorInfo>> getEnrolledFactors() async => [];
  
  // This is for newer Firebase versions if needed
  List<MultiFactorInfo> get enrolledFactors => [];
}

/// Mock UserMetadata implementation
class MockUserMetadata implements UserMetadata {
  @override
  DateTime get creationTime => DateTime.now();
  
  @override
  DateTime get lastSignInTime => DateTime.now();
}

/// Mock credential providers
class MockAuthCredential implements AuthCredential {
  @override
  String get providerId => 'mock-provider';
  
  @override
  String get signInMethod => 'mock-sign-in-method';
  
  @override
  Map<String, dynamic> asMap() => {
    'providerId': providerId,
    'signInMethod': signInMethod,
  };
  
  @override
  String? get accessToken => null;
  
  @override
  int? get token => null;
}
