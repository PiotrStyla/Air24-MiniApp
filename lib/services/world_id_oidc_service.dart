import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Minimal OIDC Sign-in with World ID service using PKCE via flutter_appauth.
///
/// Reads configuration from --dart-define to avoid hardcoding credentials:
/// - WLD_OIDC_ISSUER (e.g., https://id.worldcoin.org)
/// - WLD_OIDC_CLIENT_ID (Worldcoin client_id)
/// - WLD_OIDC_REDIRECT_URI (e.g., air24://worldid-auth)
///
/// No client secret is used on mobile apps (PKCE recommended).
class WorldIdOidcService {
  static const _issuer = String.fromEnvironment(
    'WLD_OIDC_ISSUER',
    defaultValue: 'https://id.worldcoin.org',
  );
  static const _clientId = String.fromEnvironment(
    'WLD_OIDC_CLIENT_ID',
    defaultValue: '',
  );
  static const _redirectUri = String.fromEnvironment(
    'WLD_OIDC_REDIRECT_URI',
    defaultValue: 'air24://worldid-auth',
  );

  static const _scopes = <String>['openid'];

  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _secureStorage;

  WorldIdOidcService({FlutterAppAuth? appAuth, FlutterSecureStorage? storage})
      : _appAuth = appAuth ?? const FlutterAppAuth(),
        _secureStorage = storage ?? const FlutterSecureStorage();

  /// Returns true if a valid sign-in token is present (basic check only).
  Future<bool> isSignedIn() async {
    final idToken = await _secureStorage.read(key: 'worldid_id_token');
    return idToken != null && idToken.isNotEmpty;
  }

  Future<void> signOut() async {
    await _secureStorage.delete(key: 'worldid_id_token');
    await _secureStorage.delete(key: 'worldid_access_token');
    await _secureStorage.delete(key: 'worldid_refresh_token');
  }

  /// Starts OIDC Authorization Code + PKCE flow via the discovery document.
  /// Stores tokens securely. Throws with a helpful message on configuration errors.
  Future<bool> signIn() async {
    if (kIsWeb) {
      // flutter_appauth does not support Flutter web. Use server/web auth if needed.
      throw StateError('OIDC sign-in is not supported on web in this flow.');
    }
    if (_clientId.isEmpty) {
      throw StateError('Missing WLD_OIDC_CLIENT_ID. Pass via --dart-define.');
    }

    final discoveryUrl = '$_issuer/.well-known/openid-configuration';

    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUri,
          discoveryUrl: discoveryUrl,
          scopes: _scopes,
          promptValues: const ['login'],
          preferEphemeralSession: true,
        ),
      );

      if (result == null) {
        return false;
      }

      await _secureStorage.write(
          key: 'worldid_id_token', value: result.idToken ?? '');
      await _secureStorage.write(
          key: 'worldid_access_token', value: result.accessToken ?? '');
      if (result.refreshToken != null) {
        await _secureStorage.write(
            key: 'worldid_refresh_token', value: result.refreshToken!);
      }

      return (result.idToken?.isNotEmpty ?? false);
    } catch (e) {
      debugPrint('WorldIdOidcService.signIn error: $e');
      rethrow;
    }
  }
}
