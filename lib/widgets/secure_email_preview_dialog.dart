import 'package:flutter/material.dart';
import '../services/secure_email_service.dart';
import '../services/push_notification_service.dart';
import '../core/app_localizations_patch.dart';

/// A dialog that shows the email content and provides secure email sending
class SecureEmailPreviewDialog extends StatefulWidget {
  final String toEmail;
  final String? ccEmail;
  final String subject;
  final String body;
  final String? userEmail; // User's email for reply-to functionality

  const SecureEmailPreviewDialog({
    super.key,
    required this.toEmail,
    this.ccEmail,
    required this.subject,
    required this.body,
    this.userEmail,
  });

  @override
  State<SecureEmailPreviewDialog> createState() => _SecureEmailPreviewDialogState();
}

class _SecureEmailPreviewDialogState extends State<SecureEmailPreviewDialog> {
  final SecureEmailService _emailService = SecureEmailService();
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Ensure system back closes only this dialog and returns to the app with a `false` result
        if (!didPop) {
          Navigator.of(context).pop(false);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                  Icon(
                    Icons.email_outlined,
                    size: 48,
                    color: Colors.green.shade600,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.emailReadyTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.emailWillBeSentSecurely,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  ],
                ),
              ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Details
                    _buildEmailField(context.l10n.toLabel, widget.toEmail),
                    const SizedBox(height: 12),
                    if (widget.ccEmail != null && widget.ccEmail!.isNotEmpty) ...[
                      _buildEmailField(context.l10n.ccLabel, widget.ccEmail!),
                      const SizedBox(height: 12),
                    ],
                    _buildEmailField(context.l10n.subjectLabel, widget.subject),
                    const SizedBox(height: 16),
                    // Attachment guidance (compact)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.attach_file, color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.l10n.emailPreviewAttachmentGuidance,
                              style: TextStyle(fontSize: 12, color: Colors.orange.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Email Body
                    Text(
                      context.l10n.emailBodyLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            widget.body,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  // Security Notice
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Colors.blue.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.secureTransmissionNotice,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSending ? null : () => Navigator.of(context).pop(false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(context.l10n.cancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isSending ? null : _sendEmailSecurely,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSending
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(context.l10n.sendingEllipsis),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.send, size: 18),
                                    const SizedBox(width: 8),
                                    Text(context.l10n.sendEmailSecurely),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildEmailField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendEmailSecurely() async {
    setState(() {
      _isSending = true;
    });

    try {
      debugPrint('🚀 SecureEmailPreviewDialog: Starting secure email send...');
      
      // Show brief guidance while launching external email app
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.l10n.openingEmailApp),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.tipReturnBackGesture,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
      
      final result = await _emailService.sendEmail(
        toEmail: widget.toEmail,
        ccEmail: (widget.ccEmail != null && widget.ccEmail!.isNotEmpty) ? widget.ccEmail : null,
        subject: widget.subject,
        body: widget.body,
        userEmail: widget.userEmail, // Pass user email for reply-to functionality
      );

      if (mounted) {
        setState(() {
          _isSending = false;
        });

        if (result.success) {
          debugPrint('✅ SecureEmailPreviewDialog: Email sent successfully');
          // Send a local notification to help user return to the app
          try {
            await PushNotificationService.sendReturnToAppReminder(
              title: context.l10n.returnToAppTitle,
              body: context.l10n.returnToAppBody,
            );
          } catch (e) {
            debugPrint('ℹ️ Local notification not available on this platform: $e');
          }
          _showSuccessMessage();
        } else {
          debugPrint('❌ SecureEmailPreviewDialog: Email send failed: ${result.errorMessage}');
          _showErrorMessage(result.errorMessage ?? context.l10n.errorFailedToSendEmail);
        }
      }
    } catch (e) {
      debugPrint('❌ SecureEmailPreviewDialog: Unexpected error: $e');
      if (mounted) {
        setState(() {
          _isSending = false;
        });
        _showErrorMessage(context.l10n.unexpectedErrorSendingEmail);
      }
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.emailSentSuccessfully,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Close the dialog after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    });
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: context.l10n.retry,
          textColor: Colors.white,
          onPressed: _sendEmailSecurely,
        ),
      ),
    );
  }
}
