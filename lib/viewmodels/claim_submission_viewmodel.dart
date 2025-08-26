import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../models/flight.dart';
import '../models/claim.dart';
import '../services/claim_submission_service.dart';
import '../core/services/service_initializer.dart';

class ClaimSubmissionViewModel extends ChangeNotifier {
  final ClaimSubmissionService _claimSubmissionService = ServiceInitializer.get<ClaimSubmissionService>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> submitClaim(Flight flight, String reason) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Construct a minimal Claim from available flight details and provided reason
      final newClaim = Claim(
        id: '', // will be set by service
        userId: '', // will be set by service (from auth)
        airlineName: '', // unknown at this stage
        flightNumber: flight.flightNumber,
        flightDate: flight.flightDate,
        departureAirport: flight.departureAirport,
        arrivalAirport: flight.arrivalAirport,
        reason: reason,
        compensationAmount: 0,
        status: 'Draft',
        bookingReference: '',
        attachmentUrls: const [],
      );

      final submitted = await _claimSubmissionService.submitClaim(newClaim);
      if (submitted == null) {
        _errorMessage = _claimSubmissionService.submissionError ?? 'An unknown error occurred.';
      }
    } on FirebaseException catch (e) {
      _errorMessage = e.message ?? 'A Firebase error occurred during claim submission.';
    } catch (e, stackTrace) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      print('Submit claim error: $e\n$stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
