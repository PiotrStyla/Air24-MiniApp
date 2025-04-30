import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/claim.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save or update user profile
  Future<void> setUserProfile(UserProfile profile) async {
    await _db.collection('users').doc(profile.uid).set(profile.toMap(), SetOptions(merge: true));
  }

  // Get user profile by UID
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserProfile.fromMap(doc.data()!, uid);
    }
    return null;
  }

  // Listen to user profile changes
  Stream<UserProfile?> streamUserProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromMap(doc.data()!, uid);
      }
      return null;
    });
  }

  // Save or update a claim
  Future<void> setClaim(Claim claim) async {
    await _db.collection('claims').doc(claim.id).set(claim.toMap(), SetOptions(merge: true));
  }

  // Get a claim by ID
  Future<Claim?> getClaim(String claimId) async {
    final doc = await _db.collection('claims').doc(claimId).get();
    if (doc.exists && doc.data() != null) {
      return Claim.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Get all claims for a user
  Future<List<Claim>> getClaimsForUser(String userId) async {
    final query = await _db.collection('claims').where('userId', isEqualTo: userId).get();
    return query.docs.map((doc) => Claim.fromMap(doc.data(), doc.id)).toList();
  }

  // Stream claims for a user
  Stream<List<Claim>> streamClaimsForUser(String userId) {
    return _db
        .collection('claims')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Claim.fromMap(doc.data(), doc.id)).toList());
  }

  // Delete a claim by ID
  Future<void> deleteClaim(String claimId) async {
    await _db.collection('claims').doc(claimId).delete();
  }
}
