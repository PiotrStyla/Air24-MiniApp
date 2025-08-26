import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../models/claim.dart';
import '../services/claim_tracking_service.dart';
import '../services/push_notification_service.dart';
import '../services/secure_email_service.dart';
import '../services/auth_service_firebase.dart';

import '../services/localization_service.dart';
import '../core/services/service_initializer.dart';

/// Enhanced claims service that integrates with notifications and email
class EnhancedClaimsService extends ChangeNotifier {
  final ClaimTrackingService _claimTrackingService;
  final SecureEmailService _emailService;
  
  // Stream controllers for real-time updates
  // Note: controllers are initialized in the constructor to safely reference
  // instance members from onListen.
  late final StreamController<List<Claim>> _claimsController;
  late final StreamController<ClaimEvent> _claimEventsController;
  StreamSubscription<List<Claim>>? _claimsSubscription;
  
  // Current claims state
  List<Claim> _claims = [];
  Map<String, ClaimEmailStatus> _emailStatuses = {};
  
  EnhancedClaimsService(this._claimTrackingService, this._emailService) {
    _claimsController = StreamController<List<Claim>>.broadcast(
      onListen: () {
        // Immediately emit current cache so new listeners don't wait forever
        final current = _claims;
        if (current.isNotEmpty) {
          _claimsController.add(current);
        } else {
          _claimsController.add(const <Claim>[]);
        }
      },
    );
    _claimEventsController = StreamController<ClaimEvent>.broadcast();
    _initializeService();
  }
  
  // Getters
  List<Claim> get claims => _claims;
  Stream<List<Claim>> get claimsStream => _claimsController.stream;
  Stream<ClaimEvent> get claimEventsStream => _claimEventsController.stream;
  Map<String, ClaimEmailStatus> get emailStatuses => _emailStatuses;
  
  /// Initialize the service and set up listeners
  Future<void> _initializeService() async {
    try {
      // Listen to claim updates from the tracking service
      _claimsSubscription = _claimTrackingService.claimsStream.listen((claims) {
        _handleClaimsUpdate(claims);
      });
      
      debugPrint('✅ Enhanced Claims Service initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize Enhanced Claims Service: $e');
    }
  }
  
  /// Handle claims updates and trigger notifications
  void _handleClaimsUpdate(List<Claim> newClaims) {
    final previousClaims = Map.fromIterable(_claims, key: (c) => c.id, value: (c) => c);
    
    for (final claim in newClaims) {
      final previousClaim = previousClaims[claim.id];
      
      if (previousClaim == null) {
        // New claim created
        _handleNewClaim(claim);
      } else if (previousClaim.status != claim.status) {
        // Claim status changed
        _handleClaimStatusChange(claim, previousClaim.status, claim.status);
      }
    }
    
    _claims = newClaims;
    _claimsController.add(_claims);
    notifyListeners();
  }
  
  /// Handle new claim creation
  void _handleNewClaim(Claim claim) {
    debugPrint('📋 New claim created: ${claim.id}');
    
    // Emit claim event
    _claimEventsController.add(ClaimEvent(
      type: ClaimEventType.created,
      claimId: claim.id,
      message: 'Claim created successfully',
      timestamp: DateTime.now(),
    ));
  }
  
  /// Handle claim status changes
  void _handleClaimStatusChange(Claim claim, String oldStatus, String newStatus) {
    debugPrint('📋 Claim status changed: ${claim.id} from $oldStatus to $newStatus');
    
    // Only notify when airline provides meaningful updates
    final airlineNotifiableStatuses = {
      'approved', 'rejected', 'paid', 'requires_documents'
    };
    if (airlineNotifiableStatuses.contains(newStatus.toLowerCase())) {
      final notificationTitle = 'Claim Update';
      final notificationBody = _getStatusChangeMessage(claim, newStatus);
      PushNotificationService.sendClaimStatusNotification(
        title: notificationTitle,
        body: notificationBody,
        claimId: claim.id,
      );
    }
    
    // Emit claim event
    _claimEventsController.add(ClaimEvent(
      type: ClaimEventType.statusChanged,
      claimId: claim.id,
      message: 'Status changed from $oldStatus to $newStatus',
      timestamp: DateTime.now(),
      oldStatus: oldStatus,
      newStatus: newStatus,
    ));
    
    // Handle specific status changes
    switch (newStatus.toLowerCase()) {
      case 'under_review':
        _handleClaimUnderReview(claim);
        break;
      case 'approved':
        _handleClaimApproved(claim);
        break;
      case 'rejected':
        _handleClaimRejected(claim);
        break;
      case 'paid':
        _handleClaimPaid(claim);
        break;
      case 'requires_documents':
        _handleDocumentsRequired(claim);
        break;
    }
  }
  
  /// Send compensation email to airline
  Future<bool> sendCompensationEmail(Claim claim, {
    String? customMessage,
    List<String>? attachmentPaths,
  }) async {
    try {
      debugPrint('📧 Sending compensation email for claim: ${claim.id}');
      
      // Update email status to sending (no user notification)
      _updateEmailStatus(claim.id, ClaimEmailStatus.sending);
      
      // Prepare email content with user's preferred language
      // Get user's language preference from stored locale settings
      final localizationService = GetIt.instance.get<LocalizationService>();
      final currentLocale = localizationService.currentLocale;
      final language = currentLocale.languageCode; // Use stored language preference
      
      debugPrint('🌍 EnhancedClaimsService: Using language "$language" for email generation');
      debugPrint('📧 Current locale: $currentLocale');
      
      final emailSubject = _getLocalizedEmailSubject(claim.flightNumber, language);
      final emailBody = _emailService.generateCompensationEmailBody(
        passengerName: await _getCurrentUserName(),
        flightNumber: claim.flightNumber,
        flightDate: claim.flightDate.toLocal().toString().split(' ')[0],
        departureAirport: claim.departureAirport,
        arrivalAirport: claim.arrivalAirport,
        delayReason: claim.reason,
        compensationAmount: claim.compensationAmount.toStringAsFixed(0),
        locale: language, // Use user's stored app language preference
      );
      
      // Send email using secure email service
      final result = await _emailService.sendEmail(
        toEmail: _getAirlineEmail(claim.airlineName),
        subject: emailSubject,
        body: emailBody,
        userEmail: await _getCurrentUserEmail(),
      );
      
      final success = result.success;
      
      if (success) {
        // Update email status to sent
        _updateEmailStatus(claim.id, ClaimEmailStatus.sent);
        
        // Notify once when the new claim is sent to the airline
        PushNotificationService.sendEmailStatusNotification(
          title: 'Claim Sent',
          body: 'Your claim for flight ${claim.flightNumber} was sent to ${claim.airlineName}.',
          emailId: '${claim.id}_email',
          isSuccess: true,
        );
        
        // Update claim status to submitted if it wasn't already
        if (claim.status == 'draft') {
          await updateClaimStatus(claim.id, 'submitted');
        }
        
        // Schedule a reminder to check/resend after 14 days
        _scheduleDeadlineReminder(claim);
        
        debugPrint('✅ Compensation email sent successfully for claim: ${claim.id}');
        return true;
      } else {
        // Update email status to failed
        _updateEmailStatus(claim.id, ClaimEmailStatus.failed);
        
        // Optional: notify user of failure (single concise message)
        PushNotificationService.sendEmailStatusNotification(
          title: 'Send Failed',
          body: 'Could not send your claim to ${claim.airlineName}. Please try again.',
          emailId: '${claim.id}_email',
          isSuccess: false,
        );
        
        debugPrint('❌ Failed to send compensation email for claim: ${claim.id}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error sending compensation email: $e');
      _updateEmailStatus(claim.id, ClaimEmailStatus.failed);
      
      // Send error notification
      PushNotificationService.sendEmailStatusNotification(
        title: 'Email Error',
        body: 'Error sending compensation email: ${e.toString()}',
        emailId: '${claim.id}_email',
        isSuccess: false,
      );
      
      return false;
    }
  }
  
  /// Update claim status
  Future<void> updateClaimStatus(String claimId, String newStatus) async {
    try {
      final claim = _claims.firstWhere((c) => c.id == claimId);
      final updatedClaim = claim.copyWith(status: newStatus);
      await _claimTrackingService.saveClaim(updatedClaim);
      debugPrint('✅ Updated claim status: $claimId to $newStatus');
    } catch (e) {
      debugPrint('❌ Failed to update claim status: $e');
    }
  }

  /// Delete a claim and notify listeners and event stream
  Future<void> deleteClaim(String claimId) async {
    try {
      // Keep a reference for notifications and events
      final claim = _claims.firstWhere((c) => c.id == claimId);

      // Optimistically update local state
      _claims = _claims.where((c) => c.id != claimId).toList();
      _claimsController.add(_claims);
      notifyListeners();

      // Emit claim deleted event
      _claimEventsController.add(ClaimEvent(
        type: ClaimEventType.deleted,
        claimId: claimId,
        message: 'Claim deleted',
        timestamp: DateTime.now(),
      ));

      // Localized push notification about deletion
      final localizationService = GetIt.instance.get<LocalizationService>();
      final language = localizationService.currentLocale.languageCode;
      PushNotificationService.sendClaimStatusNotification(
        title: _getLocalizedDeletionTitle(language),
        body: _getLocalizedDeletionBody(claim, language),
        claimId: claimId,
      );

      // Persist deletion via tracking service
      await _claimTrackingService.deleteClaim(claimId);
      debugPrint('🗑️ Claim deleted: $claimId');
    } catch (e) {
      debugPrint('❌ Failed to delete claim: $e');
    }
  }

  /// Mark a claim as complete (maps to 'paid' status)
  Future<void> markClaimAsComplete(String claimId) async {
    await updateClaimStatus(claimId, 'paid');
  }
  
  /// Get email status for a claim
  ClaimEmailStatus getEmailStatus(String claimId) {
    return _emailStatuses[claimId] ?? ClaimEmailStatus.notSent;
  }
  
  /// Update email status for a claim
  void _updateEmailStatus(String claimId, ClaimEmailStatus status) {
    _emailStatuses[claimId] = status;
    notifyListeners();
  }
  
  /// Handle claim under review
  void _handleClaimUnderReview(Claim claim) {
    // Could send additional notifications or perform other actions
    debugPrint('📋 Claim ${claim.id} is now under review');
  }
  
  /// Handle claim approved
  void _handleClaimApproved(Claim claim) {
    debugPrint('🎉 Claim ${claim.id} has been approved!');
  }
  
  /// Handle claim rejected
  void _handleClaimRejected(Claim claim) {
    debugPrint('❌ Claim ${claim.id} has been rejected');
  }
  
  /// Handle claim paid
  void _handleClaimPaid(Claim claim) {
    debugPrint('💰 Claim ${claim.id} has been paid!');
  }
  
  /// Handle documents required
  void _handleDocumentsRequired(Claim claim) {
    debugPrint('📄 Additional documents required for claim ${claim.id}');
    
    // No extra reminders here. A single airline update notification is sufficient.
  }
  
  /// Schedule deadline reminder
  void _scheduleDeadlineReminder(Claim claim) {
    // Calculate deadline (14 days from now)
    final deadline = DateTime.now().add(const Duration(days: 14));
    
    // In-app simple scheduling (best effort while app is running)
    Future.delayed(const Duration(days: 14), () {
      PushNotificationService.sendDeadlineReminderNotification(
        title: 'Reminder to Follow Up',
        body: 'It has been 2 weeks since you sent your claim for flight ${claim.flightNumber}. Consider resending or following up.',
        deadlineId: claim.id,
        deadlineDate: deadline,
      );
    });
  }
  
  /// Schedule document reminder
  void _scheduleDocumentReminder(Claim claim) {
    Future.delayed(const Duration(seconds: 3), () {
      PushNotificationService.sendDeadlineReminderNotification(
        title: 'Documents Required',
        body: 'Please submit additional documents for your claim ${claim.flightNumber}',
        deadlineId: '${claim.id}_docs',
        deadlineDate: DateTime.now().add(const Duration(days: 7)),
      );
    });
  }
  

  
  /// Get airline email address
  String _getAirlineEmail(String airlineName) {
    // In a real app, you'd have a database of airline contact emails
    // For now, return a placeholder
    return 'claims@${airlineName.toLowerCase().replaceAll(' ', '')}.com';
  }
  
  /// Get current user email
  Future<String> _getCurrentUserEmail() async {
    try {
      final authService = ServiceInitializer.get<FirebaseAuthService>();
      return authService.currentUser?.email ?? 'user@example.com';
    } catch (e) {
      return 'user@example.com';
    }
  }

  /// Get current user name for email personalization
  Future<String> _getCurrentUserName() async {
    try {
      final authService = ServiceInitializer.get<FirebaseAuthService>();
      return authService.userDisplayName ?? 'Passenger';
    } catch (e) {
      return 'Passenger';
    }
  }

  /// Extract airline code from flight number (e.g., "LH123" -> "LH")
  String _extractAirlineCode(String flightNumber) {
    // Extract airline code from flight number
    final match = RegExp(r'^([A-Z]{2,3})').firstMatch(flightNumber.toUpperCase());
    return match?.group(1) ?? 'XX'; // Default to 'XX' if no match
  }

  /// Get localized email subject based on language
  String _getLocalizedEmailSubject(String flightNumber, String language) {
    switch (language) {
      case 'de':
        return 'Entschädigungsanspruch nach EU-Verordnung 261/2004 - Flug $flightNumber';
      case 'es':
        return 'Reclamación de compensación según el Reglamento UE 261/2004 - Vuelo $flightNumber';
      case 'fr':
        return 'Demande d\'indemnisation selon le Règlement UE 261/2004 - Vol $flightNumber';
      case 'pl':
        return 'Roszczenie o odszkodowanie zgodnie z Rozporządzeniem UE 261/2004 - Lot $flightNumber';
      default:
        return 'Flight Compensation Claim under EU Regulation 261/2004 - Flight $flightNumber';
    }
  }
  
  /// Get status change message
  String _getStatusChangeMessage(Claim claim, String newStatus) {
    switch (newStatus.toLowerCase()) {
      case 'submitted':
        return 'Your claim for flight ${claim.flightNumber} has been submitted to ${claim.airlineName}';
      case 'under_review':
        return 'Your claim for flight ${claim.flightNumber} is now under review by ${claim.airlineName}';
      case 'approved':
        return 'Great news! Your claim for flight ${claim.flightNumber} has been approved';
      case 'rejected':
        return 'Your claim for flight ${claim.flightNumber} has been rejected. You may appeal this decision.';
      case 'paid':
        return 'Excellent! Your compensation for flight ${claim.flightNumber} has been paid';
      case 'requires_documents':
        return 'Additional documents are required for your claim ${claim.flightNumber}';
      default:
        return 'Your claim for flight ${claim.flightNumber} status has been updated to $newStatus';
    }
  }

  /// Localized deletion notification title
  String _getLocalizedDeletionTitle(String language) {
    switch (language) {
      case 'de':
        return 'Anspruch gelöscht';
      case 'es':
        return 'Reclamación eliminada';
      case 'fr':
        return 'Réclamation supprimée';
      case 'pl':
        return 'Wniosek usunięty';
      case 'pt':
        return 'Reclamação eliminada';
      default:
        return 'Claim Deleted';
    }
  }

  /// Localized deletion notification body
  String _getLocalizedDeletionBody(Claim claim, String language) {
    switch (language) {
      case 'de':
        return 'Ihr Anspruch für Flug ${claim.flightNumber} wurde gelöscht.';
      case 'es':
        return 'Tu reclamación para el vuelo ${claim.flightNumber} ha sido eliminada.';
      case 'fr':
        return 'Votre réclamation pour le vol ${claim.flightNumber} a été supprimée.';
      case 'pl':
        return 'Twój wniosek dotyczący lotu ${claim.flightNumber} został usunięty.';
      case 'pt':
        return 'A sua reclamação para o voo ${claim.flightNumber} foi eliminada.';
      default:
        return 'Your claim for flight ${claim.flightNumber} has been deleted.';
    }
  }
  
  @override
  void dispose() {
    _claimsSubscription?.cancel();
    _claimsController.close();
    _claimEventsController.close();
    super.dispose();
  }
}

/// Claim event types
enum ClaimEventType {
  created,
  statusChanged,
  emailSent,
  documentRequired,
  deadlineReminder,
  deleted,
}

/// Claim event model
class ClaimEvent {
  final ClaimEventType type;
  final String claimId;
  final String message;
  final DateTime timestamp;
  final String? oldStatus;
  final String? newStatus;
  final Map<String, dynamic>? metadata;
  
  ClaimEvent({
    required this.type,
    required this.claimId,
    required this.message,
    required this.timestamp,
    this.oldStatus,
    this.newStatus,
    this.metadata,
  });
}

/// Email status for claims
enum ClaimEmailStatus {
  notSent,
  sending,
  sent,
  failed,
  bounced,
}
