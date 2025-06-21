import 'dart:async';
import '../models/claim.dart';

/// Abstract interface for a service that tracks compensation claims.
abstract class ClaimTrackingService {
  /// Stream of claim updates for the current user.
  Stream<List<Claim>> get claimsStream;

  /// Get all claims for a given user.
  Future<List<Claim>> getClaimsForUser(String userId);

  /// Get a stream of claims for the current user.
  Stream<List<Claim>> getUserClaimsStream(String userId);

  /// Get detailed information for a specific claim.
  Future<Claim?> getClaimDetails(String claimId);

  /// Add or update a claim.
  Future<void> saveClaim(Claim claim);

  /// Dispose of any resources used by the service.
  void dispose();
}

