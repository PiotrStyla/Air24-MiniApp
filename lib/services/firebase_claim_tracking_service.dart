import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/claim.dart';
import 'claim_tracking_service.dart';
import 'auth_service_firebase.dart';

/// Service for tracking claims and their progress using Firebase Firestore.
class FirebaseClaimTrackingService implements ClaimTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService;
  late final StreamController<List<Claim>> _claimsController;

  StreamSubscription? _claimsSubscription;

  FirebaseClaimTrackingService(this._authService) {
    _claimsController = StreamController<List<Claim>>.broadcast();
    // Listen to auth changes to resubscribe when user logs in/out
    _authService.addListener(_onAuthChanged);
    _subscribeToClaims();
  }

  String? get _currentUserId => _authService.currentUser?.uid;

  void _subscribeToClaims() {
    // Cancel any existing subscription first
    _claimsSubscription?.cancel();
    // If user is not logged in, emit empty list and return
    if (_currentUserId == null) {
      _claimsController.add([]);
      return;
    }

    _claimsSubscription = _firestore
        .collection('claims')
        .where('userId', isEqualTo: _currentUserId)
        .snapshots()
        .listen((snapshot) {
      final claims = snapshot.docs.map((doc) => Claim.fromFirestore(doc.data(), doc.id)).toList();
      _claimsController.add(claims);
    }, onError: (error) {
      print('Error listening to claims stream: $error');
      _claimsController.addError(error);
    });
  }

  void _onAuthChanged() {
    // Resubscribe whenever auth state changes
    _subscribeToClaims();
  }

  @override
  Stream<List<Claim>> get claimsStream => _claimsController.stream;

  @override
  Future<List<Claim>> getClaimsForUser(String userId) async {
    if (userId.isEmpty) return [];

    try {
      final snapshot = await _firestore
          .collection('claims')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) => Claim.fromFirestore(doc.data(), doc.id)).toList();
    } on FirebaseException catch (e) {
      print('Error getting claims for user: ${e.message}');
      return [];
    }
  }

  @override
  Stream<List<Claim>> getUserClaimsStream(String userId) {
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('claims')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Claim.fromFirestore(doc.data(), doc.id)).toList());
  }

  @override
  Future<Claim?> getClaimDetails(String claimId) async {
    try {
      final doc = await _firestore.collection('claims').doc(claimId).get();
      if (doc.exists) {
        return Claim.fromFirestore(doc.data()!, doc.id);
      }
    } on FirebaseException catch (e) {
      print('Error getting claim details: ${e.message}');
    }
    return null;
  }

  @override
  Future<void> saveClaim(Claim claim) async {
    try {
      await _firestore.collection('claims').doc(claim.id).set(claim.toFirestore());
    } on FirebaseException catch (e) {
      print('Error saving claim: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> deleteClaim(String claimId) async {
    try {
      await _firestore.collection('claims').doc(claimId).delete();
    } on FirebaseException catch (e) {
      print('Error deleting claim: ${e.message}');
      rethrow;
    }
  }

  @override
  void dispose() {
    _claimsSubscription?.cancel();
    _authService.removeListener(_onAuthChanged);
    _claimsController.close();
  }
}
