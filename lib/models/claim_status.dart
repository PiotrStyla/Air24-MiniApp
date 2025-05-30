import 'package:flutter/material.dart';

/// Status of a compensation claim
enum ClaimStatus {
  submitted,
  reviewing,
  requiresAction,
  processing,
  approved,
  rejected,
  paid,
  appealing,
}

/// Extension to provide display properties for claim statuses
extension ClaimStatusExtension on ClaimStatus {
  String get displayName {
    switch (this) {
      case ClaimStatus.submitted:
        return 'Submitted';
      case ClaimStatus.reviewing:
        return 'Under Review';
      case ClaimStatus.requiresAction:
        return 'Action Required';
      case ClaimStatus.processing:
        return 'Processing';
      case ClaimStatus.approved:
        return 'Approved';
      case ClaimStatus.rejected:
        return 'Rejected';
      case ClaimStatus.paid:
        return 'Paid';
      case ClaimStatus.appealing:
        return 'Under Appeal';
    }
  }

  Color get color {
    switch (this) {
      case ClaimStatus.submitted:
        return Colors.blue;
      case ClaimStatus.reviewing:
        return Colors.orange;
      case ClaimStatus.requiresAction:
        return Colors.red;
      case ClaimStatus.processing:
        return Colors.purple;
      case ClaimStatus.approved:
        return Colors.green;
      case ClaimStatus.rejected:
        return Colors.red;
      case ClaimStatus.paid:
        return Colors.green.shade800;
      case ClaimStatus.appealing:
        return Colors.amber;
    }
  }

  IconData get icon {
    switch (this) {
      case ClaimStatus.submitted:
        return Icons.send;
      case ClaimStatus.reviewing:
        return Icons.search;
      case ClaimStatus.requiresAction:
        return Icons.warning_amber;
      case ClaimStatus.processing:
        return Icons.loop;
      case ClaimStatus.approved:
        return Icons.check_circle;
      case ClaimStatus.rejected:
        return Icons.cancel;
      case ClaimStatus.paid:
        return Icons.paid;
      case ClaimStatus.appealing:
        return Icons.gavel;
    }
  }

  int get progressValue {
    switch (this) {
      case ClaimStatus.submitted:
        return 1;
      case ClaimStatus.reviewing:
        return 2;
      case ClaimStatus.requiresAction:
        return 2;
      case ClaimStatus.processing:
        return 3;
      case ClaimStatus.approved:
        return 4;
      case ClaimStatus.rejected:
        return 4;
      case ClaimStatus.paid:
        return 5;
      case ClaimStatus.appealing:
        return 3;
    }
  }

  List<String> get nextSteps {
    switch (this) {
      case ClaimStatus.submitted:
        return [
          'Your claim has been received',
          'Our team will review your submission',
          'You will be notified of status changes'
        ];
      case ClaimStatus.reviewing:
        return [
          'Your claim is being reviewed by our team',
          'We may contact the airline for verification',
          'This process typically takes 5-7 business days'
        ];
      case ClaimStatus.requiresAction:
        return [
          'Additional information is needed',
          'Please check requested documents',
          'Submit required documents within 7 days'
        ];
      case ClaimStatus.processing:
        return [
          'Your claim is being processed with the airline',
          'We are following up on your behalf',
          'Typical airline response time is 2-3 weeks'
        ];
      case ClaimStatus.approved:
        return [
          'Your claim has been approved!',
          'Payment is being processed',
          'You will receive funds within 5-10 business days'
        ];
      case ClaimStatus.rejected:
        return [
          'Your claim was denied by the airline',
          'You can appeal this decision',
          'Contact us for assistance with your appeal'
        ];
      case ClaimStatus.paid:
        return [
          'Your compensation has been paid',
          'Funds have been transferred to your account',
          'Please allow 2-3 business days for it to appear'
        ];
      case ClaimStatus.appealing:
        return [
          'Your appeal is being processed',
          'We are advocating on your behalf',
          'Appeals typically take 15-20 business days'
        ];
    }
  }
}

/// Model for a tracked claim in the dashboard
class ClaimSummary {
  final String claimId;
  final String flightNumber;
  final String airline;
  final DateTime flightDate;
  final DateTime submissionDate;
  final ClaimStatus status;
  final double? compensationAmount;
  final String? requiredAction;
  final DateTime lastUpdated;

  ClaimSummary({
    required this.claimId,
    required this.flightNumber,
    required this.airline,
    required this.flightDate,
    required this.submissionDate,
    required this.status,
    this.compensationAmount,
    this.requiredAction,
    required this.lastUpdated,
  });

  /// Create from Firestore map data
  factory ClaimSummary.fromMap(Map<String, dynamic> data) {
    return ClaimSummary(
      claimId: data['claimId'] ?? '',
      flightNumber: data['flightNumber'] ?? '',
      airline: data['airline'] ?? '',
      flightDate: data['flightDate']?.toDate() ?? DateTime.now(),
      submissionDate: data['submissionDate']?.toDate() ?? DateTime.now(),
      status: _parseStatus(data['status']),
      compensationAmount: data['compensationAmount'],
      requiredAction: data['requiredAction'],
      lastUpdated: data['lastUpdated']?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'claimId': claimId,
      'flightNumber': flightNumber,
      'airline': airline,
      'flightDate': flightDate,
      'submissionDate': submissionDate,
      'status': status.name,
      'compensationAmount': compensationAmount,
      'requiredAction': requiredAction,
      'lastUpdated': lastUpdated,
    };
  }

  /// Parse claim status from string
  static ClaimStatus _parseStatus(String? statusStr) {
    if (statusStr == null) return ClaimStatus.submitted;
    
    try {
      return ClaimStatus.values.firstWhere(
        (e) => e.name == statusStr, 
        orElse: () => ClaimStatus.submitted
      );
    } catch (e) {
      return ClaimStatus.submitted;
    }
  }
}
