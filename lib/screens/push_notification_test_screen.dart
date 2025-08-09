import 'package:flutter/material.dart';
import 'package:f35_flight_compensation/services/push_notification_service.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class PushNotificationTestScreen extends StatefulWidget {
  const PushNotificationTestScreen({super.key});

  @override
  State<PushNotificationTestScreen> createState() => _PushNotificationTestScreenState();
}

class _PushNotificationTestScreenState extends State<PushNotificationTestScreen> {
  late PushNotificationService _pushNotificationService;
  String _fcmToken = 'Loading...';
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _pushNotificationService = ServiceInitializer.get<PushNotificationService>();
    _loadNotificationStatus();
  }

  Future<void> _loadNotificationStatus() async {
    try {
      final token = PushNotificationService.fcmToken;
      final permission = await PushNotificationService.areNotificationsEnabled();
      
      setState(() {
        _fcmToken = token ?? 'No token available';
        _permissionGranted = permission;
      });
    } catch (e) {
      setState(() {
        _fcmToken = 'Error loading token: $e';
        _permissionGranted = false;
      });
    }
  }

  Future<void> _requestNotificationPermission() async {
    try {
      // Request notification permission
      final status = await Permission.notification.request();
      
      if (status.isGranted) {
        // Permission granted, reload status
        await _loadNotificationStatus();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification permission granted!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (status.isDenied) {
        // Permission denied
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification permission denied. You can enable it in system settings.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else if (status.isPermanentlyDenied) {
        // Permission permanently denied, show settings dialog
        _showSettingsDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error requesting permission: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification Permission Required'),
          content: const Text(
            'Notifications are permanently disabled. To enable notifications, please go to your device settings and allow notifications for this app.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _testClaimUpdateNotification() async {
    await PushNotificationService.sendClaimStatusNotification(
      title: 'Claim Update',
      body: 'Your claim TEST123 is now being reviewed by the airline.',
      claimId: 'TEST123',
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Claim update notification sent!')),
      );
    }
  }

  Future<void> _testEmailStatusNotification() async {
    await PushNotificationService.sendEmailStatusNotification(
      title: 'Email Sent',
      body: 'Your compensation email was successfully sent to airline@example.com',
      emailId: 'EMAIL456',
      isSuccess: true,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email status notification sent!')),
      );
    }
  }

  Future<void> _testDeadlineReminderNotification() async {
    final deadline = DateTime.now().add(const Duration(days: 7));
    await PushNotificationService.sendDeadlineReminderNotification(
      title: 'Deadline Reminder',
      body: 'You have 7 days remaining to submit documents for claim DEADLINE789',
      deadlineId: 'DEADLINE789',
      deadlineDate: deadline,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deadline reminder notification sent!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notification Status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Permission Granted: ${_permissionGranted ? "Yes" : "No"}'),
                        const SizedBox(width: 8),
                        Icon(
                          _permissionGranted ? Icons.check_circle : Icons.error,
                          color: _permissionGranted ? Colors.green : Colors.red,
                          size: 20,
                        ),
                      ],
                    ),
                    if (!_permissionGranted) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Notifications are disabled. Grant permission to test notifications.',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text('FCM Token:'),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _fcmToken,
                        style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Test Notifications',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (!_permissionGranted) ...[
              ElevatedButton.icon(
                onPressed: _requestNotificationPermission,
                icon: const Icon(Icons.notifications),
                label: const Text('Request Notification Permission'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: _permissionGranted ? _testClaimUpdateNotification : null,
              icon: const Icon(Icons.update),
              label: const Text('Test Claim Update'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _permissionGranted ? _testEmailStatusNotification : null,
              icon: const Icon(Icons.email),
              label: const Text('Test Email Status'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _permissionGranted ? _testDeadlineReminderNotification : null,
              icon: const Icon(Icons.schedule),
              label: const Text('Test Deadline Reminder'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadNotificationStatus,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Status'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
