import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'in_app_messaging_service.dart';

/// Service for handling push notifications using Firebase Cloud Messaging
/// Supports both remote push notifications and local notifications
class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  static String? _fcmToken;
  static bool _isInitialized = false;

  /// Initialize push notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      debugPrint('🔔 PushNotificationService: Initializing...');
      
      // Request notification permissions
      await _requestPermissions();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Initialize Firebase messaging
      await _initializeFirebaseMessaging();
      
      // Get FCM token
      await _getFCMToken();
      
      // Set up message handlers
      _setupMessageHandlers();
      
      _isInitialized = true;
      debugPrint('✅ PushNotificationService: Initialized successfully');
    } catch (e) {
      debugPrint('❌ PushNotificationService: Initialization failed: $e');
    }
  }

  /// Request notification permissions
  static Future<void> _requestPermissions() async {
    // Request Firebase messaging permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('🔔 Notification permission status: ${settings.authorizationStatus}');

    // Request system notification permissions (Android 13+)
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      debugPrint('🔔 Android notification permission: $status');
    }
  }

  /// Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  /// Create notification channels for Android
  static Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel claimChannel = AndroidNotificationChannel(
      'claim_updates',
      'Claim Updates',
      description: 'Notifications about compensation claim status updates',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    const AndroidNotificationChannel emailChannel = AndroidNotificationChannel(
      'email_status',
      'Email Status',
      description: 'Notifications about email sending status',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    const AndroidNotificationChannel deadlineChannel = AndroidNotificationChannel(
      'deadlines',
      'Deadline Reminders',
      description: 'Important deadline reminders for claims',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(claimChannel);
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(emailChannel);
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(deadlineChannel);
  }

  /// Initialize Firebase messaging
  static Future<void> _initializeFirebaseMessaging() async {
    // Configure foreground notification presentation options
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Get FCM token for this device
  static Future<String?> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('🔑 FCM Token: $_fcmToken');
      return _fcmToken;
    } catch (e) {
      debugPrint('❌ Failed to get FCM token: $e');
      return null;
    }
  }

  /// Set up message handlers for different app states
  static void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle messages when app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    
    // Handle messages when app is terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped: ${response.payload}');
    
    if (response.payload != null) {
      final data = jsonDecode(response.payload!);
      _handleNotificationAction(data);
    }
  }

  /// Handle foreground messages
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('🔔 Foreground message received: ${message.messageId}');
    
    // Show local notification when app is in foreground
    await _showLocalNotification(
      title: message.notification?.title ?? 'Flight Compensation',
      body: message.notification?.body ?? 'New update available',
      data: message.data,
    );
  }

  /// Handle background messages
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('🔔 Background message opened: ${message.messageId}');
    _handleNotificationAction(message.data);
  }

  /// Handle notification actions
  static void _handleNotificationAction(Map<String, dynamic> data) {
    debugPrint('🔔 PushNotificationService: Handling notification action');
    
    // Delegate to InAppMessagingService for proper navigation and UI handling
    InAppMessagingService.handleNotificationAction(data);
  }

  /// Show local notification
  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
    String channelId = 'claim_updates',
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'claim_updates',
      'Claim Updates',
      channelDescription: 'Notifications about compensation claim status updates',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF2E7D32), // Green color for Flight Compensation
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
      payload: data != null ? jsonEncode(data) : null,
    );
  }

  // MARK: - Public Notification Methods

  /// Send claim status update notification
  static Future<void> sendClaimStatusNotification({
    required String title,
    required String body,
    String? claimId,
  }) async {
    await _showLocalNotification(
      title: title,
      body: body,
      data: {
        'type': 'claim_update',
        'claimId': claimId,
        'timestamp': DateTime.now().toIso8601String(),
      },
      channelId: 'claim_updates',
    );
  }

  /// Send email status notification
  static Future<void> sendEmailStatusNotification({
    required String title,
    required String body,
    String? emailId,
    bool isSuccess = true,
  }) async {
    await _showLocalNotification(
      title: title,
      body: body,
      data: {
        'type': 'email_status',
        'emailId': emailId,
        'success': isSuccess,
        'timestamp': DateTime.now().toIso8601String(),
      },
      channelId: 'email_status',
    );
  }

  /// Send deadline reminder notification
  static Future<void> sendDeadlineReminderNotification({
    required String title,
    required String body,
    String? deadlineId,
    DateTime? deadlineDate,
  }) async {
    await _showLocalNotification(
      title: title,
      body: body,
      data: {
        'type': 'deadline_reminder',
        'deadlineId': deadlineId,
        'deadlineDate': deadlineDate?.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      },
      channelId: 'deadlines',
    );
  }

  /// Get current FCM token
  static String? get fcmToken => _fcmToken;

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Subscribe to topic for targeted notifications
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('✅ Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('❌ Failed to subscribe to topic $topic: $e');
    }
  }

  /// Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Failed to unsubscribe from topic $topic: $e');
    }
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background message received: ${message.messageId}');
  // Handle background message processing here
}
