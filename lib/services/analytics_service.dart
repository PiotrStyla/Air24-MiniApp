import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Analytics service for tracking user events and behavior
/// 
/// Events tracked:
/// - claim_submitted: When user submits a compensation claim
/// - claim_status_checked: When user checks claim status
/// - premium_viewed: When user views premium/paywall screen
/// - premium_purchased: When user completes premium subscription purchase
/// - claim_shared: When user shares their claim/success story
/// - flight_tracking_setup: When user adds a flight to track
/// - email_tracking_setup: When user sets up email forwarding
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  /// Get the analytics observer for navigation tracking
  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);

  /// Log when a claim is submitted
  Future<void> logClaimSubmitted({
    required String airline,
    required int compensationAmount,
    String? flightNumber,
    int? delayMinutes,
  }) async {
    try {
      print('📊 AnalyticsService: logClaimSubmitted called with airline=$airline, amount=$compensationAmount');
      await _analytics.logEvent(
        name: 'claim_submitted',
        parameters: {
          'airline': airline,
          'compensation_amount': compensationAmount,
          if (flightNumber != null) 'flight_number': flightNumber,
          if (delayMinutes != null) 'delay_minutes': delayMinutes,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      print('📊 Analytics: claim_submitted - $airline (€$compensationAmount) - EVENT SENT TO FIREBASE');
      debugPrint('📊 Analytics: claim_submitted - $airline (€$compensationAmount)');
    } catch (e) {
      print('❌ Analytics error (claim_submitted): $e');
      debugPrint('❌ Analytics error (claim_submitted): $e');
    }
  }

  /// Log when user checks claim status
  Future<void> logClaimStatusChecked({
    required String claimId,
    required String status,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'claim_status_checked',
        parameters: {
          'claim_id': claimId,
          'status': status,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: claim_status_checked - $claimId ($status)');
    } catch (e) {
      debugPrint('❌ Analytics error (claim_status_checked): $e');
    }
  }

  /// Log when user views premium/paywall screen
  Future<void> logPremiumViewed({
    String? source, // Where did user come from? (e.g., 'flight_limit', 'settings', 'calculator')
  }) async {
    try {
      await _analytics.logEvent(
        name: 'premium_viewed',
        parameters: {
          if (source != null) 'source': source,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: premium_viewed${source != null ? ' from $source' : ''}');
    } catch (e) {
      debugPrint('❌ Analytics error (premium_viewed): $e');
    }
  }

  /// Log when user purchases premium subscription
  Future<void> logPremiumPurchased({
    required String plan, // 'monthly' or 'yearly'
    required double price,
    String? currency,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'premium_purchased',
        parameters: {
          'plan': plan,
          'price': price,
          'currency': currency ?? 'EUR',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: premium_purchased - $plan (${currency ?? 'EUR'}$price)');
    } catch (e) {
      debugPrint('❌ Analytics error (premium_purchased): $e');
    }
  }

  /// Log when user shares a claim or success story
  Future<void> logClaimShared({
    required String platform, // 'twitter', 'facebook', 'whatsapp', etc.
    String? claimId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'claim_shared',
        parameters: {
          'platform': platform,
          if (claimId != null) 'claim_id': claimId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: claim_shared - $platform');
    } catch (e) {
      debugPrint('❌ Analytics error (claim_shared): $e');
    }
  }

  /// Log when user sets up flight tracking
  Future<void> logFlightTrackingSetup({
    required String flightNumber,
    required String airline,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'flight_tracking_setup',
        parameters: {
          'flight_number': flightNumber,
          'airline': airline,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: flight_tracking_setup - $flightNumber ($airline)');
    } catch (e) {
      debugPrint('❌ Analytics error (flight_tracking_setup): $e');
    }
  }

  /// Log when user sets up email tracking/forwarding
  Future<void> logEmailTrackingSetup({
    required String claimId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'email_tracking_setup',
        parameters: {
          'claim_id': claimId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: email_tracking_setup - $claimId');
    } catch (e) {
      debugPrint('❌ Analytics error (email_tracking_setup): $e');
    }
  }

  /// Log user sign-in
  Future<void> logSignIn({
    required String method, // 'google', 'email', etc.
  }) async {
    try {
      await _analytics.logLogin(loginMethod: method);
      debugPrint('📊 Analytics: login - $method');
    } catch (e) {
      debugPrint('❌ Analytics error (login): $e');
    }
  }

  /// Log user sign-up
  Future<void> logSignUp({
    required String method,
  }) async {
    try {
      await _analytics.logSignUp(signUpMethod: method);
      debugPrint('📊 Analytics: sign_up - $method');
    } catch (e) {
      debugPrint('❌ Analytics error (sign_up): $e');
    }
  }

  /// Set user properties
  Future<void> setUserProperties({
    String? userId,
    bool? isPremium,
    int? totalClaims,
  }) async {
    try {
      if (userId != null) {
        await _analytics.setUserId(id: userId);
      }
      if (isPremium != null) {
        await _analytics.setUserProperty(
          name: 'premium_user',
          value: isPremium.toString(),
        );
      }
      if (totalClaims != null) {
        await _analytics.setUserProperty(
          name: 'total_claims',
          value: totalClaims.toString(),
        );
      }
      debugPrint('📊 Analytics: User properties updated');
    } catch (e) {
      debugPrint('❌ Analytics error (user properties): $e');
    }
  }

  /// Log screen view (for manual tracking if needed)
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      debugPrint('📊 Analytics: Screen view - $screenName');
    } catch (e) {
      debugPrint('❌ Analytics error (screen_view): $e');
    }
  }

  /// Log when a claim is created (Day 11)
  Future<void> logClaimCreated({
    required String claimId,
    required String airline,
    required int compensationAmount,
    String? flightNumber,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'claim_created',
        parameters: {
          'claim_id': claimId,
          'airline': airline,
          'compensation_amount': compensationAmount,
          if (flightNumber != null) 'flight_number': flightNumber,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: claim_created - $claimId ($airline, €$compensationAmount)');
    } catch (e) {
      debugPrint('❌ Analytics error (claim_created): $e');
    }
  }

  /// Log when user receives a push notification (Day 11)
  Future<void> logNotificationReceived({
    required String claimId,
    required String notificationType, // 'approved', 'rejected', 'needs_info', etc.
  }) async {
    try {
      await _analytics.logEvent(
        name: 'notification_received',
        parameters: {
          'claim_id': claimId,
          'notification_type': notificationType,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: notification_received - $claimId ($notificationType)');
    } catch (e) {
      debugPrint('❌ Analytics error (notification_received): $e');
    }
  }

  /// Log when user taps a push notification (Day 11)
  Future<void> logNotificationTapped({
    required String claimId,
    required String notificationType,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'notification_tapped',
        parameters: {
          'claim_id': claimId,
          'notification_type': notificationType,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: notification_tapped - $claimId ($notificationType)');
    } catch (e) {
      debugPrint('❌ Analytics error (notification_tapped): $e');
    }
  }

  /// Log when claim status changes (Day 11)
  Future<void> logClaimStatusChanged({
    required String claimId,
    required String oldStatus,
    required String newStatus,
    required String source, // 'email', 'manual', 'system'
  }) async {
    try {
      await _analytics.logEvent(
        name: 'claim_status_changed',
        parameters: {
          'claim_id': claimId,
          'old_status': oldStatus,
          'new_status': newStatus,
          'source': source,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: claim_status_changed - $claimId ($oldStatus → $newStatus via $source)');
    } catch (e) {
      debugPrint('❌ Analytics error (claim_status_changed): $e');
    }
  }

  /// Log when user copies email address (Day 11)
  Future<void> logEmailAddressCopied({
    required String claimId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'email_address_copied',
        parameters: {
          'claim_id': claimId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: email_address_copied - $claimId');
    } catch (e) {
      debugPrint('❌ Analytics error (email_address_copied): $e');
    }
  }

  /// Log when user views claim detail screen (Day 11)
  Future<void> logClaimDetailViewed({
    required String claimId,
    required String status,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'claim_detail_viewed',
        parameters: {
          'claim_id': claimId,
          'status': status,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: claim_detail_viewed - $claimId ($status)');
    } catch (e) {
      debugPrint('❌ Analytics error (claim_detail_viewed): $e');
    }
  }

  /// Log when email is processed by backend (Day 11)
  Future<void> logEmailProcessed({
    required String claimId,
    required String result, // 'success', 'spam', 'not_found'
    int? processingTimeMs,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'email_processed',
        parameters: {
          'claim_id': claimId,
          'result': result,
          if (processingTimeMs != null) 'processing_time_ms': processingTimeMs,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      debugPrint('📊 Analytics: email_processed - $claimId ($result)');
    } catch (e) {
      debugPrint('❌ Analytics error (email_processed): $e');
    }
  }

  /// Log custom event (for future flexibility)
  Future<void> logCustomEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
      debugPrint('📊 Analytics: $eventName${parameters != null ? ' - $parameters' : ''}');
    } catch (e) {
      debugPrint('❌ Analytics error ($eventName): $e');
    }
  }
}
