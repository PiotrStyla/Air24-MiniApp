import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/claim_status.dart';

/// Service for tracking claims and their progress
class ClaimTrackingService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  
  /// Stream controller for claim status updates
  final StreamController<ClaimSummary> _claimUpdateController = StreamController<ClaimSummary>.broadcast();
  
  /// Stream of claim status updates for notifications
  Stream<ClaimSummary> get claimUpdates => _claimUpdateController.stream;

  ClaimTrackingService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;
       
  /// Get the current user ID
  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }
       
  /// Get all claims for the current user
  Future<List<ClaimSummary>> getUserClaims() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return [];
      }
      
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('claims')
          .orderBy('submissionDate', descending: true)
          .get();
          
      return querySnapshot.docs
          .map((doc) => ClaimSummary.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching user claims: $e');
      return [];
    }
  }
  
  /// Get a stream of claims for the current user
  Stream<List<ClaimSummary>> getUserClaimsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('claims')
        .orderBy('submissionDate', descending: true)
        .snapshots()
        .map((snapshot) {
          final claims = snapshot.docs
              .map((doc) => ClaimSummary.fromMap(doc.data()))
              .toList();
              
          // Check for claim status updates for notifications
          _checkForStatusUpdates(claims);
          
          return claims;
        });
  }
  
  /// Get detailed information for a specific claim
  Future<ClaimSummary?> getClaimDetails(String claimId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      
      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('claims')
          .doc(claimId)
          .get();
          
      if (!docSnapshot.exists) return null;
      
      return ClaimSummary.fromMap(docSnapshot.data()!);
    } catch (e) {
      debugPrint('Error fetching claim details: $e');
      return null;
    }
  }
  
  /// Submit action for a claim that requires user input
  Future<bool> submitRequiredAction(String claimId, Map<String, dynamic> actionData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('claims')
          .doc(claimId)
          .collection('actions')
          .add({
            'timestamp': FieldValue.serverTimestamp(),
            'data': actionData,
            'status': 'submitted',
          });
          
      // Update the main claim to remove required action
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('claims')
          .doc(claimId)
          .update({
            'status': ClaimStatus.processing.name,
            'requiredAction': null,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
          
      return true;
    } catch (e) {
      debugPrint('Error submitting action: $e');
      return false;
    }
  }
  
  /// Get historical status updates for a claim
  Future<List<Map<String, dynamic>>> getClaimHistory(String claimId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];
      
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('claims')
          .doc(claimId)
          .collection('statusHistory')
          .orderBy('timestamp', descending: true)
          .get();
          
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error fetching claim history: $e');
      return [];
    }
  }
  
  /// Submit appeal for a rejected claim
  Future<bool> submitAppeal(String claimId, String appealReason, List<String> documentIds) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;
      
      final appealData = {
        'reason': appealReason,
        'documentIds': documentIds,
        'submissionDate': FieldValue.serverTimestamp(),
      };
      
      // Create appeal document
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('claims')
          .doc(claimId)
          .collection('appeals')
          .add(appealData);
          
      // Update claim status
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('claims')
          .doc(claimId)
          .update({
            'status': ClaimStatus.appealing.name,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
          
      return true;
    } catch (e) {
      debugPrint('Error submitting appeal: $e');
      return false;
    }
  }
  
  /// Check for status updates in claims to notify user
  void _checkForStatusUpdates(List<ClaimSummary> currentClaims) {
    // This would typically compare with cached claims and notify of changes
    // For now, we'll just send all claims through the controller for demonstration
    for (final claim in currentClaims) {
      _claimUpdateController.add(claim);
    }
  }
  
  /// Get analytics for user claims
  Future<Map<String, dynamic>> getClaimAnalytics() async {
    try {
      final claims = await getUserClaims();
      
      // Calculate statistics
      final totalClaims = claims.length;
      final approvedClaims = claims.where((c) => 
          c.status == ClaimStatus.approved || 
          c.status == ClaimStatus.paid).length;
      final pendingClaims = claims.where((c) => 
          c.status == ClaimStatus.submitted || 
          c.status == ClaimStatus.reviewing || 
          c.status == ClaimStatus.processing).length;
      
      // Calculate total compensation
      double totalCompensation = 0;
      for (final claim in claims) {
        if (claim.compensationAmount != null) {
          totalCompensation += claim.compensationAmount!;
        }
      }
      
      return {
        'totalClaims': totalClaims,
        'approvedClaims': approvedClaims,
        'pendingClaims': pendingClaims,
        'rejectedClaims': totalClaims - approvedClaims - pendingClaims,
        'totalCompensation': totalCompensation,
        'successRate': totalClaims > 0 ? approvedClaims / totalClaims : 0,
      };
    } catch (e) {
      debugPrint('Error calculating claim analytics: $e');
      return {
        'totalClaims': 0,
        'approvedClaims': 0,
        'pendingClaims': 0,
        'rejectedClaims': 0,
        'totalCompensation': 0.0,
        'successRate': 0.0,
      };
    }
  }
  
  /// Clean up resources
  void dispose() {
    _claimUpdateController.close();
  }
}
