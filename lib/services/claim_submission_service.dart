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
  Future<Claim?> submitClaim(Flight flight, String reason) async {
    _setSubmitting(true);
    _setSubmissionError(null);

    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      _setSubmissionError('User not authenticated.');
      _setSubmitting(false);
      return null;
    }

    try {
      final newClaim = Claim(
        compensationAmount: 0.0, // Default value, to be updated later
        bookingReference: '', // Placeholder for submission
        id: _uuid.v4(),
        userId: userId,
        flightNumber: flight.flightNumber,
        flightDate: flight.flightDate,
        departureAirport: flight.departureAirport,
        arrivalAirport: flight.arrivalAirport,
        reason: reason,
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
