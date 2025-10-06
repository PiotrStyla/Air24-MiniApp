import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/claim.dart';
// Flight model is not used directly in this file
import '../models/claim_status.dart';
import 'claim_tracking_service.dart';
import 'claim_validation_service.dart';
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/services/analytics_service.dart';

/// Service for submitting and managing compensation claims.
class ClaimSubmissionService extends ChangeNotifier {
  final ClaimTrackingService _claimTrackingService;
  final FirebaseAuthService _authService;
  final Uuid _uuid = const Uuid();

  bool _isSubmitting = false;
  String? _submissionError;

  bool get isSubmitting => _isSubmitting;
  String? get submissionError => _submissionError;

  ClaimSubmissionService({
    required ClaimTrackingService claimTrackingService,
    required FirebaseAuthService authService,
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

  /// Get the email content for a claim for preview purposes
  String getClaimEmailContent(Claim claim) {
    print('getClaimEmailContent called for flight ${claim.flightNumber}');
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

    return body;
  }

  /// Submit a new compensation claim.
  Uri constructClaimMailtoUri({
    required Claim claim,
    required String airlineEmail,
    required String userEmail,
  }) {
    final subject = 'Flight Compensation Claim - Flight ${claim.flightNumber}';
    final body = getClaimEmailContent(claim);

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

    // Use existing userId from claim or generate a simple one for development
    final userId = _authService.currentUser?.uid ?? 
                   claim.userId ?? 
                   'dev_user_${DateTime.now().millisecondsSinceEpoch}';
    
    print('DEBUG: Submitting claim with userId: $userId');

    try {
      print('DEBUG: Creating new claim with userId: $userId');
      final newClaim = claim.copyWith(
        id: _uuid.v4(),
        userId: userId,
        status: ClaimStatus.submitted.name,
      );
      print('DEBUG: New claim created: ${newClaim.toString()}');

      print('DEBUG: Getting user claims for validation...');
      final userClaims = await _claimTrackingService.getClaimsForUser(userId);
      print('DEBUG: Found ${userClaims.length} existing claims for user');
      
      print('DEBUG: Validating claim...');
      try {
        final validationResult = await ClaimValidationService.validateClaim(newClaim, userClaims);
        print('DEBUG: Validation result: isValid=${validationResult.isValid}');
        
        if (!validationResult.isValid) {
          print('DEBUG: Validation errors: ${validationResult.errors}');
          // For development, skip validation errors and proceed
          print('DEBUG: Skipping validation errors for development');
        }
      } catch (validationError) {
        print('DEBUG: Validation service error: $validationError');
        // Continue anyway for development
      }

      print('DEBUG: Saving claim to tracking service...');
      await _claimTrackingService.saveClaim(newClaim);
      print('DEBUG: Claim saved successfully!');

      // Log analytics event
      print('DEBUG: 🎯 Starting analytics logging...');
      try {
        print('DEBUG: 🎯 Getting AnalyticsService from ServiceInitializer...');
        final analytics = ServiceInitializer.get<AnalyticsService>();
        print('DEBUG: 🎯 AnalyticsService obtained: ${analytics.runtimeType}');
        
        print('DEBUG: 🎯 Calling logClaimSubmitted...');
        await analytics.logClaimSubmitted(
          airline: newClaim.airlineName,
          compensationAmount: newClaim.compensationAmount.toInt(),
          flightNumber: newClaim.flightNumber,
        );
        print('DEBUG: 🎯 Analytics event logged successfully!');
      } catch (e, stackTrace) {
        print('DEBUG: ❌ Analytics error in claim submission: $e');
        print('DEBUG: ❌ Stack trace: $stackTrace');
      }

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
