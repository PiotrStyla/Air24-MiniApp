import 'dart:async';
import 'package:f35_flight_compensation/models/claim_status.dart';
import 'package:f35_flight_compensation/services/notification_service.dart';

class MockNotificationService implements NotificationService {
  final _tapController = StreamController<String>.broadcast();
  List<ClaimSummary> sentNotifications = [];

  @override
  Future<void> initialize() async {
    print('[MockNotificationService] initialize called');
    // No-op for mock
    return Future.value();
  }

  @override
  Stream<String> get notificationTaps => _tapController.stream;

  @override
  Future<void> sendClaimStatusNotification(ClaimSummary claim) async {
    print('[MockNotificationService] sendClaimStatusNotification called for claim: ${claim.claimId}');
    sentNotifications.add(claim);
    // No-op for mock, or simulate tap if needed by test logic
    // _tapController.add(claim.claimId);
    return Future.value();
  }

  @override
  Future<void> saveDeviceToken() async {
    print('[MockNotificationService] saveDeviceToken called');
    // No-op for mock
    return Future.value();
  }

  @override
  Future<void> unsubscribeFromTopics() async {
    print('[MockNotificationService] unsubscribeFromTopics called');
    // No-op for mock
    return Future.value();
  }

  void dispose() {
    _tapController.close();
  }

  // Helper to simulate a notification tap for testing
  void simulateNotificationTap(String payload) {
    _tapController.add(payload);
  }
}
