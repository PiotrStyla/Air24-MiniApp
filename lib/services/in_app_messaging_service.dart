import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Service for handling in-app messaging and navigation from push notifications
/// Connects push notifications to actual app screens and user interactions
class InAppMessagingService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final List<InAppMessage> _messageQueue = [];
  static bool _isInitialized = false;

  /// Initialize in-app messaging service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    debugPrint('💬 InAppMessagingService: Initializing...');
    _isInitialized = true;
    debugPrint('✅ InAppMessagingService: Initialized successfully');
  }

  /// Handle notification tap and navigate to appropriate screen
  static Future<void> handleNotificationAction(Map<String, dynamic> data) async {
    final type = data['type'] as String?;
    final context = navigatorKey.currentContext;
    
    if (context == null) {
      debugPrint('⚠️ InAppMessagingService: No navigation context available');
      return;
    }
    
    debugPrint('💬 InAppMessagingService: Handling notification action: $type');
    
    switch (type) {
      case 'claim_update':
        await _handleClaimUpdate(context, data);
        break;
      case 'email_status':
        await _handleEmailStatus(context, data);
        break;
      case 'deadline_reminder':
        await _handleDeadlineReminder(context, data);
        break;
      default:
        debugPrint('⚠️ InAppMessagingService: Unknown notification type: $type');
        await _showGenericMessage(context, data);
    }
  }

  /// Handle claim update notification
  static Future<void> _handleClaimUpdate(BuildContext context, Map<String, dynamic> data) async {
    final claimId = data['claimId'] as String?;
    debugPrint('💬 InAppMessagingService: Opening claim details for: $claimId');
    
    // Show in-app message about claim update
    await _showInAppMessage(
      context: context,
      title: 'Claim Update',
      message: 'Your compensation claim has been updated. Tap to view details.',
      actionText: 'View Claim',
      onAction: () => _navigateToClaimsScreen(context, claimId),
    );
  }

  /// Handle email status notification
  static Future<void> _handleEmailStatus(BuildContext context, Map<String, dynamic> data) async {
    final emailId = data['emailId'] as String?;
    final isSuccess = data['success'] as bool? ?? true;
    debugPrint('💬 InAppMessagingService: Opening email status for: $emailId (success: $isSuccess)');
    
    final message = isSuccess 
        ? 'Your compensation email was sent successfully!'
        : 'There was an issue sending your compensation email. Please try again.';
    
    await _showInAppMessage(
      context: context,
      title: 'Email Status',
      message: message,
      actionText: 'View Details',
      onAction: () => _navigateToEmailHistory(context, emailId),
    );
  }

  /// Handle deadline reminder notification
  static Future<void> _handleDeadlineReminder(BuildContext context, Map<String, dynamic> data) async {
    final deadlineId = data['deadlineId'] as String?;
    debugPrint('💬 InAppMessagingService: Opening deadline reminder for: $deadlineId');
    
    await _showInAppMessage(
      context: context,
      title: 'Deadline Reminder',
      message: 'Important: You have an upcoming deadline for your compensation claim.',
      actionText: 'View Deadline',
      onAction: () => _navigateToDeadlines(context, deadlineId),
    );
  }

  /// Show generic message for unknown notification types
  static Future<void> _showGenericMessage(BuildContext context, Map<String, dynamic> data) async {
    await _showInAppMessage(
      context: context,
      title: 'Flight Compensation',
      message: 'You have a new update in your Flight Compensation app.',
      actionText: 'Open App',
      onAction: () => _navigateToHome(context),
    );
  }

  /// Show in-app message dialog
  static Future<void> _showInAppMessage({
    required BuildContext context,
    required String title,
    required String message,
    String actionText = 'OK',
    VoidCallback? onAction,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Dismiss'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onAction?.call();
              },
              child: Text(actionText),
            ),
          ],
        );
      },
    );
  }

  /// Navigate to claims screen
  static void _navigateToClaimsScreen(BuildContext context, String? claimId) {
    debugPrint('💬 InAppMessagingService: Navigating to claims screen');
    
    // Navigate to main navigation (home) - Claims tab is index 1 in bottom navigation
    // The user will need to manually tap the Claims tab after navigation
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
    
    // Show a brief message to help user find the Claims tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text('Tap the "Claims" tab to view your claim details'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
    
    if (claimId != null) {
      debugPrint('💬 InAppMessagingService: Claim ID context: $claimId');
    }
  }

  /// Navigate to email history
  static void _navigateToEmailHistory(BuildContext context, String? emailId) {
    debugPrint('💬 InAppMessagingService: Navigating to email history');
    
    // Navigate to main navigation (home) - Profile tab is index 3 in bottom navigation
    // The user will need to manually tap the Profile tab after navigation
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
    
    // Show a brief message to help user find the Profile tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text('Tap the "Profile" tab to view your email history'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
    
    if (emailId != null) {
      debugPrint('💬 InAppMessagingService: Email ID context: $emailId');
    }
  }

  /// Navigate to deadlines screen
  static void _navigateToDeadlines(BuildContext context, String? deadlineId) {
    debugPrint('💬 InAppMessagingService: Navigating to deadlines');
    
    // Navigate to main navigation (home) - Claims tab is index 1 in bottom navigation
    // The user will need to manually tap the Claims tab after navigation
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
    
    // Show a brief message to help user find the Claims tab for deadline info
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text('Tap the "Claims" tab to view deadline information'),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
    
    if (deadlineId != null) {
      debugPrint('💬 InAppMessagingService: Deadline ID context: $deadlineId');
    }
  }

  /// Navigate to home screen
  static void _navigateToHome(BuildContext context) {
    debugPrint('💬 InAppMessagingService: Navigating to home');
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
  }

  /// Add message to queue for later processing
  static void queueMessage(InAppMessage message) {
    _messageQueue.add(message);
    debugPrint('💬 InAppMessagingService: Message queued: ${message.title}');
  }

  /// Process queued messages
  static Future<void> processQueuedMessages(BuildContext context) async {
    if (_messageQueue.isEmpty) return;
    
    debugPrint('💬 InAppMessagingService: Processing ${_messageQueue.length} queued messages');
    
    for (final message in List.from(_messageQueue)) {
      await _showInAppMessage(
        context: context,
        title: message.title,
        message: message.body,
        actionText: message.actionText ?? 'OK',
        onAction: message.onAction,
      );
      
      _messageQueue.remove(message);
    }
  }

  /// Show notification badge on app icon (if supported)
  static Future<void> updateAppBadge(int count) async {
    // This would integrate with platform-specific badge APIs
    debugPrint('💬 InAppMessagingService: Would update app badge to: $count');
  }

  /// Clear all notifications
  static void clearAllNotifications() {
    _messageQueue.clear();
    debugPrint('💬 InAppMessagingService: All notifications cleared');
  }


}

/// Data class for in-app messages
class InAppMessage {
  final String title;
  final String body;
  final String? actionText;
  final VoidCallback? onAction;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  InAppMessage({
    required this.title,
    required this.body,
    this.actionText,
    this.onAction,
    DateTime? timestamp,
    this.data,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'InAppMessage(title: $title, body: $body, timestamp: $timestamp)';
  }
}
