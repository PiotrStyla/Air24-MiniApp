import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service for submitting and managing compensation claims
class ClaimSubmissionService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Collection reference for claims
  CollectionReference get _claimsCollection => 
      _firestore.collection('compensation_claims');
  
  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;
  
  /// Submit a new compensation claim
  Future<String> submitClaim(Map<String, dynamic> claimData) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      // Add user ID to claim data
      final enhancedClaimData = {
        ...claimData,
        'userId': _currentUserId,
        'submissionDate': FieldValue.serverTimestamp(),
        'status': 'pending',
        'lastUpdated': FieldValue.serverTimestamp(),
      };
      
      // Save to Firestore
      final docRef = await _claimsCollection.add(enhancedClaimData);
      
      // Return the document ID
      return docRef.id;
    } catch (e) {
      debugPrint('Error submitting claim: $e');
      throw Exception('Failed to submit claim: $e');
    }
  }
  
  /// Get claims for the current user
  Future<List<Map<String, dynamic>>> getUserClaims() async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final querySnapshot = await _claimsCollection
          .where('userId', isEqualTo: _currentUserId)
          .orderBy('submissionDate', descending: true)
          .get();
      
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching user claims: $e');
      throw Exception('Failed to fetch claims: $e');
    }
  }
  
  /// Get a specific claim by ID
  Future<Map<String, dynamic>> getClaimById(String claimId) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      final docSnapshot = await _claimsCollection.doc(claimId).get();
      
      if (!docSnapshot.exists) {
        throw Exception('Claim not found');
      }
      
      final data = docSnapshot.data() as Map<String, dynamic>;
      
      // Verify ownership
      if (data['userId'] != _currentUserId) {
        throw Exception('Claim does not belong to current user');
      }
      
      return {
        'id': docSnapshot.id,
        ...data,
      };
    } catch (e) {
      debugPrint('Error fetching claim: $e');
      throw Exception('Failed to fetch claim: $e');
    }
  }
  
  /// Update claim status (for admin use)
  Future<void> updateClaimStatus(String claimId, String newStatus) async {
    try {
      await _claimsCollection.doc(claimId).update({
        'status': newStatus,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating claim status: $e');
      throw Exception('Failed to update claim status: $e');
    }
  }
  
  /// Delete a claim
  Future<void> deleteClaim(String claimId) async {
    try {
      if (_currentUserId == null) {
        throw Exception('User not authenticated');
      }
      
      // Verify ownership before deletion
      final docSnapshot = await _claimsCollection.doc(claimId).get();
      
      if (!docSnapshot.exists) {
        throw Exception('Claim not found');
      }
      
      final data = docSnapshot.data() as Map<String, dynamic>;
      
      if (data['userId'] != _currentUserId) {
        throw Exception('Claim does not belong to current user');
      }
      
      // Delete the claim
      await _claimsCollection.doc(claimId).delete();
    } catch (e) {
      debugPrint('Error deleting claim: $e');
      throw Exception('Failed to delete claim: $e');
    }
  }
}
