import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'analytics_service.dart';
import '../core/services/service_initializer.dart';

/// Enhanced error tracking service for Day 11
/// Tracks critical errors and logs them to Firestore for monitoring
class ErrorTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Log a critical error to Firestore and analytics
  Future<void> logError({
    required String errorType,
    required String errorMessage,
    required String location,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      debugPrint('🚨 ErrorTracking: $errorType in $location: $errorMessage');
      
      // Log to Firestore for monitoring
      await _firestore.collection('error_logs').add({
        'errorType': errorType,
        'errorMessage': errorMessage,
        'location': location,
        'stackTrace': stackTrace?.toString(),
        'additionalData': additionalData,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': defaultTargetPlatform.toString(),
      });
      
      // Log to analytics
      try {
        final analytics = ServiceInitializer.get<AnalyticsService>();
        await analytics.logCustomEvent(
          eventName: 'error_occurred',
          parameters: {
            'error_type': errorType,
            'location': location,
            'platform': defaultTargetPlatform.toString(),
          },
        );
      } catch (e) {
        debugPrint('Failed to log error to analytics: $e');
      }
    } catch (e) {
      debugPrint('Failed to log error: $e');
    }
  }
  
  /// Track GPT-4 parsing failures
  Future<void> logGPT4ParseFailure({
    required String claimId,
    required String errorMessage,
    required int retryCount,
  }) async {
    await logError(
      errorType: 'gpt4_parse_failure',
      errorMessage: errorMessage,
      location: 'email_ingestion',
      additionalData: {
        'claim_id': claimId,
        'retry_count': retryCount,
      },
    );
  }
  
  /// Track FCM token refresh failures
  Future<void> logFCMTokenFailure({
    required String userId,
    required String errorMessage,
  }) async {
    await logError(
      errorType: 'fcm_token_failure',
      errorMessage: errorMessage,
      location: 'push_notification_service',
      additionalData: {
        'user_id': userId,
      },
    );
  }
  
  /// Track claim submission failures
  Future<void> logClaimSubmissionFailure({
    required String errorMessage,
    String? userId,
    Map<String, dynamic>? claimData,
  }) async {
    await logError(
      errorType: 'claim_submission_failure',
      errorMessage: errorMessage,
      location: 'claim_submission_service',
      additionalData: {
        if (userId != null) 'user_id': userId,
        if (claimData != null) 'claim_data': claimData,
      },
    );
  }
  
  /// Track email processing failures
  Future<void> logEmailProcessingFailure({
    required String claimId,
    required String errorMessage,
    required String failureType, // 'spam', 'not_found', 'parse_error', 'network_error'
  }) async {
    await logError(
      errorType: 'email_processing_failure',
      errorMessage: errorMessage,
      location: 'email_ingestion_function',
      additionalData: {
        'claim_id': claimId,
        'failure_type': failureType,
      },
    );
  }
  
  /// Track Firestore operation failures
  Future<void> logFirestoreFailure({
    required String operation,
    required String errorMessage,
    String? collection,
    String? documentId,
  }) async {
    await logError(
      errorType: 'firestore_failure',
      errorMessage: errorMessage,
      location: 'firestore_$operation',
      additionalData: {
        'operation': operation,
        if (collection != null) 'collection': collection,
        if (documentId != null) 'document_id': documentId,
      },
    );
  }
  
  /// Get recent errors for monitoring dashboard
  Future<List<Map<String, dynamic>>> getRecentErrors({
    int limit = 50,
    String? errorType,
  }) async {
    try {
      Query query = _firestore
          .collection('error_logs')
          .orderBy('timestamp', descending: true)
          .limit(limit);
      
      if (errorType != null) {
        query = query.where('errorType', isEqualTo: errorType);
      }
      
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      debugPrint('Failed to get recent errors: $e');
      return [];
    }
  }
  
  /// Get error statistics
  Future<Map<String, int>> getErrorStatistics({
    DateTime? since,
  }) async {
    try {
      Query query = _firestore.collection('error_logs');
      
      if (since != null) {
        query = query.where('timestamp', isGreaterThan: since);
      }
      
      final snapshot = await query.get();
      final stats = <String, int>{};
      
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final errorType = data['errorType'] as String? ?? 'unknown';
        stats[errorType] = (stats[errorType] ?? 0) + 1;
      }
      
      return stats;
    } catch (e) {
      debugPrint('Failed to get error statistics: $e');
      return {};
    }
  }
  
  /// Check if there are critical errors that need attention
  Future<bool> hasCriticalErrors({
    Duration window = const Duration(hours: 1),
    int threshold = 10,
  }) async {
    try {
      final since = DateTime.now().subtract(window);
      final query = _firestore
          .collection('error_logs')
          .where('timestamp', isGreaterThan: since)
          .where('errorType', whereIn: [
            'gpt4_parse_failure',
            'fcm_token_failure',
            'firestore_failure'
          ]);
      
      final snapshot = await query.get();
      return snapshot.docs.length >= threshold;
    } catch (e) {
      debugPrint('Failed to check critical errors: $e');
      return false;
    }
  }
}
