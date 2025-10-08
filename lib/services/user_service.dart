import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'auth_service_firebase.dart';
import 'push_notification_service.dart';

/// Service for managing user data in Firestore
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService;

  UserService({required FirebaseAuthService authService})
      : _authService = authService;

  /// Save or update user FCM token for push notifications
  Future<void> saveFcmToken() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        debugPrint('⚠️ UserService: No user ID, cannot save FCM token');
        return;
      }

      final fcmToken = PushNotificationService.fcmToken;
      if (fcmToken == null) {
        debugPrint('⚠️ UserService: No FCM token available');
        return;
      }

      debugPrint('💾 UserService: Saving FCM token for user: $userId');

      await _firestore.collection('users').doc(userId).set({
        'fcmToken': fcmToken,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
        'email': _authService.currentUser?.email,
        'displayName': _authService.currentUser?.displayName,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ UserService: FCM token saved successfully');
    } catch (e) {
      debugPrint('❌ UserService: Failed to save FCM token: $e');
    }
  }

  /// Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      debugPrint('❌ UserService: Failed to get user data: $e');
      return null;
    }
  }

  /// Update user profile data
  Future<void> updateUserProfile({
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) updates['displayName'] = displayName;
      if (email != null) updates['email'] = email;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      await _firestore
          .collection('users')
          .doc(userId)
          .set(updates, SetOptions(merge: true));

      debugPrint('✅ UserService: User profile updated');
    } catch (e) {
      debugPrint('❌ UserService: Failed to update user profile: $e');
    }
  }

  /// Delete user FCM token (call on logout)
  Future<void> deleteFcmToken() async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ UserService: FCM token deleted');
    } catch (e) {
      debugPrint('❌ UserService: Failed to delete FCM token: $e');
    }
  }
}
