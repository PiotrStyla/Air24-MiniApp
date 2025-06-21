import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/claim.dart';
import 'claim_tracking_service.dart';

/// Service for tracking claims and their progress using Firebase Firestore.
class FirebaseClaimTrackingService implements ClaimTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final StreamController<List<Claim>> _claimsController;

  StreamSubscription? _claimsSubscription;

  FirebaseClaimTrackingService() {
    _claimsController = StreamController<List<Claim>>.broadcast();
    _subscribeToClaims();
  }

  String? get _currentUserId => _auth.currentUser?.uid;

  void _subscribeToClaims() {
    if (_currentUserId == null) return;

    _claimsSubscription?.cancel();
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
  void dispose() {
    _claimsSubscription?.cancel();
    _claimsController.close();
  }
}
