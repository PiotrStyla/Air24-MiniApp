import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service to verify World ID proofs via our backend proxy.
///
/// Backend endpoint implemented at `vercel-backend/api/worldid-verify.js`.
/// Default baseUrl is a placeholder; inject your deployed Vercel backend URL
/// (pointing to the /api root) via constructor or DI registration.
class WorldIdService {
  // Example: https://your-vercel-backend-url.vercel.app/api
  final String baseUrl;
  final http.Client _httpClient;

  static const Duration _timeout = Duration(seconds: 25);

  WorldIdService({
    String? baseUrl,
    http.Client? httpClient,
  })  : baseUrl = baseUrl ?? (kDebugMode
            ? 'http://localhost:3000/api' // for `vercel dev`
            : 'https://air24.app/api'),
        _httpClient = httpClient ?? http.Client();

  /// Verify a World ID proof through the backend.
  ///
  /// Required fields mirror the backend contract:
  /// - nullifierHash, merkleRoot, proof, verificationLevel, action
  /// - Optional signalHash
  ///
  /// Returns [WorldIdVerificationResult].
  Future<WorldIdVerificationResult> verify({
    required String nullifierHash,
    required String merkleRoot,
    required String proof,
    required String verificationLevel, // 'orb' | 'device' | 'phone'
    required String action,
    String? signalHash,
  }) async {
    final uri = Uri.parse('$baseUrl/worldid-verify');
    debugPrint('🌐 WorldIdService.verify -> POST $uri');

    final body = <String, dynamic>{
      'nullifier_hash': nullifierHash,
      'merkle_root': merkleRoot,
      'proof': proof,
      'verification_level': verificationLevel,
      'action': action,
      if (signalHash != null && signalHash.isNotEmpty) 'signal_hash': signalHash,
    };

    try {
      final resp = await _httpClient
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      final respTextPreview = resp.body.length > 200
          ? '${resp.body.substring(0, 200)}...'
          : resp.body;
      debugPrint('↩️ WorldIdService.verify <- ${resp.statusCode} body: $respTextPreview');

      Map<String, dynamic> jsonResp;
      try {
        jsonResp = (jsonDecode(resp.body) as Map).cast<String, dynamic>();
      } catch (_) {
        return WorldIdVerificationResult(
          success: false,
          statusCode: resp.statusCode,
          errorCode: 'INVALID_JSON',
          message: 'Invalid or non-JSON response from backend',
          raw: resp.body,
        );
      }

      if (resp.statusCode == 200) {
        // Expected success response: { success: true, ... }
        final success = jsonResp['success'] == true;
        return WorldIdVerificationResult(
          success: success,
          statusCode: resp.statusCode,
          message: success ? 'Verified' : (jsonResp['error']?.toString() ?? 'Unknown error'),
          raw: jsonResp,
        );
      }

      // Forwarded error from backend (e.g., WORLDCOIN_VERIFY_FAILED, MISSING_APP_ID, etc.)
      return WorldIdVerificationResult(
        success: false,
        statusCode: resp.statusCode,
        errorCode: jsonResp['code']?.toString(),
        message: jsonResp['error']?.toString() ?? 'Verification failed',
        raw: jsonResp,
      );
    } on TimeoutException {
      return WorldIdVerificationResult(
        success: false,
        statusCode: 408,
        errorCode: 'TIMEOUT',
        message: 'Verification request timed out',
      );
    } catch (e) {
      debugPrint('❌ WorldIdService.verify error: $e');
      return WorldIdVerificationResult(
        success: false,
        statusCode: 500,
        errorCode: 'EXCEPTION',
        message: e.toString(),
      );
    }
  }

  void dispose() {
    _httpClient.close();
  }
}

class WorldIdVerificationResult {
  final bool success;
  final int statusCode;
  final String? errorCode;
  final String? message;
  final Object? raw;

  const WorldIdVerificationResult({
    required this.success,
    required this.statusCode,
    this.errorCode,
    this.message,
    this.raw,
  });

  bool get isConfiguredError => errorCode == 'MISSING_APP_ID';
}
