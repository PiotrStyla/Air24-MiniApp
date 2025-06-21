import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/claim.dart';
import '../models/claim_status.dart';
import 'claim_tracking_service.dart';

/// Mock service for tracking claims and their progress using in-memory storage.
class MockClaimTrackingService implements ClaimTrackingService {
  final List<Claim> _claims = [];
  final _uuid = Uuid();

  final StreamController<List<Claim>> _claimsController = StreamController<List<Claim>>.broadcast();

  @override
  Stream<List<Claim>> get claimsStream => _claimsController.stream;

  MockClaimTrackingService() {
    _claims.addAll([
      Claim(
        id: _uuid.v4(),
        userId: 'mock_user_id',
        flightNumber: 'BA2490',
        flightDate: DateTime.now().subtract(const Duration(days: 10)),
        departureAirport: 'LHR',
        arrivalAirport: 'JFK',
        reason: 'delay',
        compensationAmount: 600.0,
        status: ClaimStatus.paid.name,
        bookingReference: 'ABCDEF',
      ),
    ]);
    _claimsController.add(_claims);
  }

  @override
  Future<List<Claim>> getClaimsForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Claim>.from(_claims.where((c) => c.userId == userId));
  }

  @override
  Stream<List<Claim>> getUserClaimsStream(String userId) {
    final userClaims = _claims.where((c) => c.userId == userId).toList();
    // Use a new controller for each stream subscription to avoid issues with broadcast streams
    final controller = StreamController<List<Claim>>();
    controller.add(userClaims);
    // In a real mock, you might want to simulate updates. For now, just return a stream with initial data.
    return controller.stream;
  }

  @override
  Future<Claim?> getClaimDetails(String claimId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _claims.firstWhere((claim) => claim.id == claimId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveClaim(Claim claim) async {
    final index = _claims.indexWhere((c) => c.id == claim.id);
    if (index != -1) {
      _claims[index] = claim;
    } else {
      _claims.add(claim);
    }
    _claimsController.add(List<Claim>.from(_claims));
  }

  @override
  void dispose() {
    _claimsController.close();
  }
}
