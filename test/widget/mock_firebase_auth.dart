import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_auth_platform_interface/src/pigeon/messages.pigeon.dart' 
  as pigeon;
import 'package:firebase_core/firebase_core.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:f35_flight_compensation/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Used by AuthService and MockAuthService
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart'; // Used by MockFirebaseAuth and other platform-level mocks
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import the generated mocks file (will be created by build_runner)
// The name 'mock_firebase_auth.mocks.dart' is a convention.
// Ensure your build.yaml or build_runner setup is configured if using a different name.
import 'mock_firebase_auth.mocks.dart';

// --- Mock Auth Service ---
class MockAuthService implements AuthService {
  final FirebaseAuth _auth;
  final MockGoogleSignIn _googleSignIn = MockGoogleSignIn(); // Uses generated mock

  MockAuthService(this._auth) { // Constructor now accepts FirebaseAuth instance
    print('[MockAuthService Constructor] Initialized with _auth type: ${_auth.runtimeType}');
    print('[MockAuthService Constructor] _auth.currentUser?.uid: ${_auth.currentUser?.uid}, _auth.currentUser type: ${_auth.currentUser.runtimeType}');
  }

  @override
  User? get currentUser {
    final user = _auth.currentUser;
    print('[MockAuthService currentUser getter] Called. Underlying _auth.currentUser is: ${user?.uid}, ${_auth.runtimeType}');
    return user;
  }

  @override
  Stream<User?> get userChanges => _auth.authStateChanges();

  @override
  String get userDisplayName {
    final user = _auth.currentUser;
    return user?.displayName ?? user?.email ?? 'Guest User (Mock)';
  }

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e); // Use the same error handling as original
    }
  }

  @override
  Future<UserCredential> createUserWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    // This part might need a MockGoogleSignIn if used, or can throw UnimplementedError
    // if not essential for the current tests.
    // For now, let's assume it might be called and make it throw like the original if it fails.
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // Setup mock responses for googleUser and its authentication if needed for specific test cases
      // For example, if googleUser is not null:
      // when(googleUser.authentication).thenAnswer((_) async => MockGoogleSignInAuthentication());
      if (googleUser == null) return null; 
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      // Catching general exceptions that GoogleSignIn might throw if not fully mocked
      throw AuthException('mock_google_sign_in_failed', 'Mock Google sign-in failed: $e');
    }
  }

  @override
  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      // when(_googleSignIn.signOut()).thenAnswer((_) async => null); // Example of setting up mock response
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Re-include _handleAuthError or ensure AuthService's one is accessible/used.
  // For a mock, it's often simpler to let exceptions pass through or mock specific outcomes.
  // However, to match the AuthService interface, we can include it.
  AuthException _handleAuthError(FirebaseAuthException e) {
    // This is a simplified version or could be identical to AuthService._handleAuthError
    // For mock purposes, often you'd control the exceptions thrown by _auth directly in MockFirebaseAuth.
    return AuthException(e.code, e.message ?? 'An authentication error occurred in mock.');
  }
}

@GenerateMocks([GoogleSignIn, GoogleSignInAccount, GoogleSignInAuthentication])
// --- Mock Pigeon Types ---
// MockPigeonUserDetails and MockPigeonIdTokenResult removed and inlined.

// Ensure MultiFactorInfo, MultiFactorSession are imported if not already.
// import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart'; 
// This import should already be at the top of the file.

class MockMultiFactorPlatform extends MultiFactorPlatform {
 MockMultiFactorPlatform(FirebaseAuthPlatform auth) : super(auth);

  @override
  Future<void> enroll(MultiFactorAssertionPlatform multiFactorAssertion, {String? displayName}) {
    throw UnimplementedError();
  }

  @override
  Future<List<MultiFactorInfo>> getEnrolledFactors() async {
    throw UnimplementedError();
  }

  @override
  Future<MultiFactorSession> getSession() async {
    throw UnimplementedError();
  }

  @override
  Future<void> unenroll({String? factorUid, MultiFactorInfo? multiFactorInfo}) async {
    throw UnimplementedError();
  }
}

// --- Mock Platform Types ---

class MockUser extends UserPlatform {
  final String? _email;
  final String? _displayName;
  final String? _photoURL;
  final bool _emailVerified;
  final bool _isAnonymous;
  final UserMetadata _metadata;
  final String? _phoneNumber;
  final List<UserInfo> _providerData;
  final String? _refreshToken;
  final String? _tenantId;

  MockUser({
    required FirebaseAuthPlatform auth,
    String uid = 'mock_uid',
    String? email = 'mock_email@example.com',
    String? displayName = 'Mock User',
    String? photoURL = 'mock_photo_url',
    bool emailVerified = true,
    bool isAnonymous = false,
    UserMetadata? metadata,
    String? phoneNumber = 'mock_phone_number',
    List<UserInfo>? providerData = const [],
    String? refreshToken = 'mock_refresh_token',
    String? tenantId,
  })  : _email = email,
        _displayName = displayName,
        _photoURL = photoURL,
        _emailVerified = emailVerified,
        _isAnonymous = isAnonymous,
        _metadata = metadata ?? UserMetadata(DateTime.now().millisecondsSinceEpoch, DateTime.now().millisecondsSinceEpoch),
        _phoneNumber = phoneNumber,
        _providerData = providerData ?? [],
        _refreshToken = refreshToken,
        _tenantId = tenantId,
        super(
          auth,
          MockMultiFactorPlatform(auth),
          pigeon.PigeonUserDetails(
            userInfo: pigeon.PigeonUserInfo(
              uid: uid,
              email: email,
              displayName: displayName,
              photoUrl: photoURL, // Note: PigeonUserInfo uses photoUrl
              phoneNumber: phoneNumber,
              isAnonymous: isAnonymous,
              isEmailVerified: emailVerified,
              providerId: 'firebase', // Assuming 'firebase' as primary providerId for the main user info
              tenantId: tenantId,
              refreshToken: refreshToken, // from MockUser constructor
              creationTimestamp: metadata?.creationTime?.millisecondsSinceEpoch,
              lastSignInTimestamp: metadata?.lastSignInTime?.millisecondsSinceEpoch,
            ),
            providerData: (providerData?.map<Map<String, dynamic>?>((info) {
              return {
                'providerId': info.providerId,
                'uid': info.uid,
                'displayName': info.displayName,
                'email': info.email,
                'photoURL': info.photoURL,
                'phoneNumber': info.phoneNumber,
              };
            }).toList()) ?? [],
          ),
        );

  @override
  String? get email => _email;
  @override
  String? get displayName => _displayName;
  @override
  String? get photoURL => _photoURL;
  @override
  bool get emailVerified => _emailVerified;
  @override
  bool get isAnonymous => _isAnonymous;
  @override
  UserMetadata get metadata => _metadata;
  @override
  String? get phoneNumber => _phoneNumber;
  @override
  List<UserInfo> get providerData => _providerData;
  @override
  String? get refreshToken => _refreshToken;
  @override
  String? get tenantId => _tenantId;

  @override
  Future<void> delete() async {}
  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => 'mock_id_token';

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async {
    return IdTokenResult(pigeon.PigeonIdTokenResult(
      token: 'mock_id_token',
      expirationTimestamp: DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch,
      authTimestamp: DateTime.now().millisecondsSinceEpoch,
      issuedAtTimestamp: DateTime.now().millisecondsSinceEpoch,
      signInProvider: 'custom',
      signInSecondFactor: null,
      claims: {},
    ));
  }

  @override
  Future<UserCredentialPlatform> linkWithCredential(AuthCredential credential) async =>
      throw UnimplementedError();
  @override
  Future<UserCredentialPlatform> reauthenticateWithCredential(
          AuthCredential credential) async =>
      throw UnimplementedError();
  @override
  Future<void> reload() async {}
  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {}
  @override
  Future<UserPlatform> unlink(String providerId) async => throw UnimplementedError();
  @override
  Future<void> updateDisplayName(String? displayName) async {}
  @override
  Future<void> updateEmail(String newEmail) async {}
  @override
  Future<void> updatePassword(String newPassword) async {}
  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential credential) async {}
  @override
  Future<void> updatePhotoURL(String? photoURL) async {}

  @override
  Future<void> updateProfile(Map<String, String?> profile) async {}

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail,
      [ActionCodeSettings? actionCodeSettings]) async {}
}

class MockFirebaseAuth extends Fake with MockPlatformInterfaceMixin implements FirebaseAuthPlatform {
  late final MockUser _mockUser;
  final FirebaseApp app;

  MockFirebaseAuth({MockUser? mockUser, FirebaseApp? appInstance})
      : app = appInstance ?? Firebase.app() {
    print('[MockFirebaseAuth constructor] Called with mockUser: $mockUser, appInstance: $appInstance');
    if (mockUser != null) {
      _mockUser = mockUser;
    } else {
      // Ensure a default, non-null MockUser with a UID is always created
      _mockUser = MockUser(auth: this, uid: 'default_mock_uid_123', email: 'default@example.com');
    }
    print('[MockFirebaseAuth constructor] _mockUser initialized to: ${_mockUser.uid}');
  }

  @override
  UserPlatform? get currentUser {
    print('[MockFirebaseAuth currentUser getter] Returning _mockUser (uid: ${_mockUser.uid}, type: ${_mockUser.runtimeType})');
    return _mockUser;
  }

  @override
  Stream<UserPlatform?> authStateChanges() {
    return Stream.value(_mockUser);
  }

  @override
  Stream<UserPlatform?> idTokenChanges() {
    return Stream.value(_mockUser);
  }

  @override
  Stream<UserPlatform?> userChanges() {
    return Stream.value(_mockUser);
  }

  @override
  Future<UserCredentialPlatform> signInAnonymously() async {
    return MockUserCredential(user: _mockUser, auth: this);
  }

  @override
  Future<UserCredentialPlatform> signInWithCredential(AuthCredential credential) async {
    return MockUserCredential(user: _mockUser, auth: this);
  }
  
  @override
  Future<void> signOut() async {}

  @override
  Future<List<String>> fetchSignInMethodsForEmail(String email) async => ['password'];

  @override
  Future<UserCredentialPlatform> createUserWithEmailAndPassword(
      String email, String password) async {
    return MockUserCredential(user: _mockUser, auth: this);
  }

  @override
  Future<UserCredentialPlatform> signInWithEmailAndPassword(
      String email, String password) async {
    return MockUserCredential(user: _mockUser, auth: this);
  }
  // Ensure all abstract members from FirebaseAuthPlatform are implemented
  // Add stubs for any missing methods, for example:
  @override
  Future<ConfirmationResultPlatform> signInWithPhoneNumber(
    String phoneNumber,
    RecaptchaVerifierFactoryPlatform recaptchaVerifierFactory,
  ) async {
    throw UnimplementedError('signInWithPhoneNumber has not been implemented.');
  }

  @override
  Future<UserCredentialPlatform> signInWithPopup(AuthProvider provider) async {
    throw UnimplementedError('signInWithPopup has not been implemented.');
  }

  @override
  Future<UserCredentialPlatform> signInWithRedirect(AuthProvider provider) async {
    throw UnimplementedError('signInWithRedirect has not been implemented.');
  }

  @override
  Future<void> verifyPhoneNumber({
    String? phoneNumber, // Changed to nullable and not required
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    String? autoRetrievedSmsCodeForTesting,
    Duration timeout = const Duration(seconds: 30),
    int? forceResendingToken,
    MultiFactorSession? multiFactorSession,
    MultiFactorInfo? multiFactorInfo, // Corrected type to MultiFactorInfo (not Platform)
  }) async {
    throw UnimplementedError('verifyPhoneNumber has not been implemented.');
  }
  // Add other necessary overrides if compilation errors persist for FirebaseAuthPlatform
  @override
  Future<void> sendPasswordResetEmail(String email, [ActionCodeSettings? actionCodeSettings]) async {
    throw UnimplementedError('sendPasswordResetEmail has not been implemented.');
  }

  @override
  Future<void> sendSignInLinkToEmail(String email, ActionCodeSettings actionCodeSettings) async {
    throw UnimplementedError('sendSignInLinkToEmail has not been implemented.');
  }

   @override
  bool isSignInWithEmailLink(String emailLink) {
    return false;
  }

  @override
  Future<UserCredentialPlatform> signInWithEmailLink(String email, String emailLink) async {
    return MockUserCredential(user: _mockUser, auth: this);
  }

  @override
  Future<void> applyActionCode(String code) async {
     throw UnimplementedError('applyActionCode has not been implemented.');
  }

  @override
  Future<ActionCodeInfo> checkActionCode(String code) async {
    throw UnimplementedError('checkActionCode has not been implemented.');
  }

  @override
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    throw UnimplementedError('confirmPasswordReset has not been implemented.');
  }

  @override
  Future<void> setLanguageCode(String? languageCode) async {
    throw UnimplementedError('setLanguageCode has not been implemented.');
  }

  @override
  Future<void> setSettings({bool? appVerificationDisabledForTesting, String? userAccessGroup, String? phoneNumber, String? smsCode, bool? forceRecaptchaFlow}) async {
    throw UnimplementedError('setSettings has not been implemented.');
  }

  @override
  Future<void> useAuthEmulator(String host, int port, {bool forceUseEmulator = false}) async {
    throw UnimplementedError('useAuthEmulator has not been implemented.');
  }

  @override
  Future<String> verifyPasswordResetCode(String code) async {
    return 'mock_email@example.com';
  }

  @override
  FirebaseAuthPlatform delegateFor({required FirebaseApp app}) {
    return this; // Or a new instance if appropriate
  }

  @override
  FirebaseAuthPlatform setInitialValues({
    pigeon.PigeonUserDetails? currentUser,
    String? languageCode, // Added missing languageCode
    String? currentUserToken,
    bool? isCurrentUserAnonymous,
  }) {
    if (currentUser != null) {
      // Potentially update _mockUser if needed, carefully constructing MockUser
      // _mockUser = MockUser(
      //   auth: this,
      //   uid: currentUser.uid,
      //   email: currentUser.email,
      //   displayName: currentUser.displayName,
      //   // ... and other fields from PigeonUserDetails
      //   isAnonymous: isCurrentUserAnonymous ?? false, // Example usage
      // );
    }
    return this;
  }
}

class MockAdditionalUserInfo extends AdditionalUserInfo {
  MockAdditionalUserInfo({
    this.providerId = 'firebase',
    this.profile,
    this.username,
    bool isNewUser = false, // Default to false, can be overridden
  }) : super(
    providerId: providerId,
    profile: profile ?? {'is_new_user': isNewUser}, // Keep this for direct profile access if needed
    username: username,
    isNewUser: isNewUser, // Pass it directly to super constructor
  );

  @override
  final String? providerId;

  @override
  final Map<String, dynamic>? profile;

  @override
  final String? username;

  // The getter is already in the base AdditionalUserInfo class:
  // @override
  // bool get isNewUser => profile?['is_new_user'] == true;
}

class MockUserCredential extends UserCredentialPlatform {
  MockUserCredential({MockUser? user, required FirebaseAuthPlatform auth})
      : super(
          auth: auth,
          user: user, 
          credential: null, 
          additionalUserInfo: MockAdditionalUserInfo(isNewUser: false) // Provide a default mock
          );
}
