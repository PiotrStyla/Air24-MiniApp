import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/claim.dart';
import '../models/flight.dart';
import '../models/claim_status.dart';
import 'claim_tracking_service.dart';
import 'claim_validation_service.dart';
import 'auth_service.dart';

/// Service for submitting and managing compensation claims.
class ClaimSubmissionService extends ChangeNotifier {
  final ClaimTrackingService _claimTrackingService;
  final AuthService _authService;
  final Uuid _uuid = const Uuid();

  bool _isSubmitting = false;
  String? _submissionError;

  bool get isSubmitting => _isSubmitting;
  String? get submissionError => _submissionError;

  ClaimSubmissionService({
    required ClaimTrackingService claimTrackingService,
    required AuthService authService,
  })  : _claimTrackingService = claimTrackingService,
        _authService = authService;

  void _setSubmitting(bool submitting) {
    _isSubmitting = submitting;
    notifyListeners();
  }

  void _setSubmissionError(String? error) {
    _submissionError = error;
    notifyListeners();
  }

  /// Submit a new compensation claim.
  Uri constructClaimMailtoUri({
    required Claim claim,
    required String airlineEmail,
    required String userEmail,
  }) {
    final subject = 'Flight Compensation Claim - Flight ${claim.flightNumber}';
    final attachmentsSection = claim.attachmentUrls.isNotEmpty
        ? '\n\nSupporting Documents:\n${claim.attachmentUrls.map((url) => '- $url').join('\n')}'
        : '';

    final body = '''
Dear Sir or Madam,

I am writing to claim compensation under EC Regulation 261/2004 for the flight detailed below:

- Flight Number: ${claim.flightNumber}
- Flight Date: ${claim.flightDate.toIso8601String().split('T').first}
- Departure Airport: ${claim.departureAirport}
- Arrival Airport: ${claim.arrivalAirport}
- Reason for Claim: ${claim.reason}

Please find my details and the flight information above for your processing.$attachmentsSection

Sincerely,
${_authService.currentUser?.displayName ?? 'Awaiting your reply'}
''';

    final Uri mailtoUri = Uri(
      scheme: 'mailto',
      path: airlineEmail,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}&cc=${Uri.encodeComponent(userEmail)}',
    );

    return mailtoUri;
  }

  /// Submit a new compensation claim.
  Future<Claim?> submitClaim(Claim claim) async {
    _setSubmitting(true);
    _setSubmissionError(null);

    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      _setSubmissionError('User not authenticated.');
      _setSubmitting(false);
      return null;
    }

    try {
      final newClaim = claim.copyWith(
        id: _uuid.v4(),
        userId: userId,
        status: ClaimStatus.submitted.name,
      );

      final userClaims = await _claimTrackingService.getClaimsForUser(userId);
      final validationResult = await ClaimValidationService.validateClaim(newClaim, userClaims);

      if (!validationResult.isValid) {
        throw Exception(validationResult.errors.join('\n'));
      }

      await _claimTrackingService.saveClaim(newClaim);

      _setSubmitting(false);
      return newClaim;
    } on FirebaseException catch (e) {
      debugPrint('Firebase error submitting claim: ${e.message}');
      _setSubmissionError('Failed to submit claim: ${e.message}');
      _setSubmitting(false);
      return null;
    } catch (e, stackTrace) {
      debugPrint('Error submitting claim: $e\n$stackTrace');
      _setSubmissionError('Failed to submit claim: ${e.toString()}');
      _setSubmitting(false);
      return null;
    }
  }
}
