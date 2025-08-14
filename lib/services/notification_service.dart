import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import '../models/claim_status.dart';

/// Service for handling push notifications and local notifications
class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Stream controller for notification taps
  final StreamController<String> _notificationTapController = StreamController<String>.broadcast();
  
  // Getters
  Stream<String> get notificationTaps => _notificationTapController.stream;
  
  /// Initialize the notification service
  Future<void> initialize() async {
    // Request permission for notifications
    await _requestPermissions();
    
    // Configure FirebaseMessaging
    await _configureFirebaseMessaging();
    
    // Initialize local notifications
    await _initializeLocalNotifications();
    
    // Subscribe to notification topics
    await _subscribeToTopics();
  }
  
  /// Request notification permissions from the user
  Future<void> _requestPermissions() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      
      debugPrint('Notification authorization status: ${settings.authorizationStatus}');
    } on FirebaseException catch (e) {
      debugPrint('Firebase error requesting notification permissions: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('Error requesting notification permissions: $e\n$stackTrace');
    }
  }
  
  /// Configure Firebase Messaging
  Future<void> _configureFirebaseMessaging() async {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });
    
    // Handle when user taps on notification from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });
    
    // Handle when user taps on notification in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }
  
  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        if (response.payload != null) {
          _notificationTapController.add(response.payload!);
        }
      },
    );
    
    // Create notification channels for Android
    await _createAndroidNotificationChannel();
  }
  
  /// Create notification channel for Android
  Future<void> _createAndroidNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'claim_updates_channel',
      'Claim Updates',
      description: 'Notifications about your compensation claims',
      importance: Importance.high,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  
  /// Subscribe to topics based on user data
  Future<void> _subscribeToTopics() async {
    final authService = ServiceInitializer.get<FirebaseAuthService>();
    final user = authService.currentUser;
    if (user != null) {
      // Subscribe to user-specific topic
      await _firebaseMessaging.subscribeToTopic('user_${user.uid}');
      
      // Subscribe to general updates
      await _firebaseMessaging.subscribeToTopic('all_users');
    }
  }
  
  /// Show a local notification based on a remote message
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    
    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'claim_updates_channel',
            'Claim Updates',
            channelDescription: 'Notifications about your compensation claims',
            icon: android?.smallIcon ?? 'ic_launcher',
            importance: Importance.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data['claimId'],
      );
    }
  }
  
  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    if (message.data.containsKey('claimId')) {
      _notificationTapController.add(message.data['claimId']);
    }
  }
  
  /// Send a local notification for claim status change
  Future<void> sendClaimStatusNotification(ClaimSummary claim) async {
    final title = 'Claim Status Update';
    String body;
    
    switch (claim.status) {
      case ClaimStatus.reviewing:
        body = 'Your claim for ${claim.flightNumber} is now under review.';
        break;
      case ClaimStatus.requiresAction:
        body = 'Your claim for ${claim.flightNumber} requires your attention.';
        break;
      case ClaimStatus.processing:
        body = 'Your claim for ${claim.flightNumber} is being processed.';
        break;
      case ClaimStatus.approved:
        body = 'Good news! Your claim for ${claim.flightNumber} has been approved.';
        break;
      case ClaimStatus.rejected:
        body = 'Your claim for ${claim.flightNumber} has been rejected. You can appeal this decision.';
        break;
      case ClaimStatus.paid:
        body = 'Payment for your claim ${claim.flightNumber} has been processed.';
        break;
      case ClaimStatus.appealing:
        body = 'Your appeal for claim ${claim.flightNumber} is being processed.';
        break;
      default:
        body = 'There is an update on your claim for ${claim.flightNumber}.';
    }
    
    await _localNotifications.show(
      claim.claimId.hashCode,
      title,
      body,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'claim_updates_channel',
          'Claim Updates',
          channelDescription: 'Notifications about your compensation claims',
          importance: Importance.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: claim.claimId,
    );
  }
  
  /// Register device token with backend
  Future<void> saveDeviceToken() async {
    try {
      final user = ServiceInitializer.get<FirebaseAuthService>().currentUser;
      if (user == null) return;
      
      final token = await _firebaseMessaging.getToken();
      if (token == null) return;
      
      // Save token to Firestore
      // This would typically be implemented in a user service or profile service
      debugPrint('Device token saved: $token');
    } on FirebaseException catch (e) {
      debugPrint('Firebase error saving device token: ${e.message}');
    } catch (e, stackTrace) {
      debugPrint('Error saving device token: $e\n$stackTrace');
    }
  }
  
  /// Unsubscribe from topics when user logs out
  Future<void> unsubscribeFromTopics() async {
    final user = ServiceInitializer.get<FirebaseAuthService>().currentUser;
    if (user != null) {
      await _firebaseMessaging.unsubscribeFromTopic('user_${user.uid}');
      await _firebaseMessaging.unsubscribeFromTopic('all_users');
    }
  }
  
  /// Dispose resources
  void dispose() {
    _notificationTapController.close();
  }
}
