import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Types of email sending errors
enum EmailErrorType {
  networkError,
  serverError,
  invalidEmail,
  authenticationError,
  rateLimitExceeded,
  cannotLaunch,
  noEmailApp,
  unknown,
}

/// Result class for email launch operations
class EmailLaunchResult {
  final bool success;
  final String? errorMessage;
  final EmailErrorType? errorType;
  final String? method;

  EmailLaunchResult({
    required this.success,
    this.errorMessage,
    this.errorType,
    this.method,
  });
}

/// Result class for email sending operations
class EmailSendResult {
  final bool success;
  final EmailErrorType? errorType;
  final String? errorMessage;
  final String? emailId;
  final int? statusCode;

  const EmailSendResult({
    required this.success,
    this.errorType,
    this.errorMessage,
    this.emailId,
    this.statusCode,
  });

  @override
  String toString() {
    if (success) {
      return 'EmailSendResult(success: true, emailId: $emailId)';
    } else {
      return 'EmailSendResult(success: false, error: $errorType, message: $errorMessage, statusCode: $statusCode)';
    }
  }
}

/// Secure service for sending emails via backend endpoint
/// Uses third-party email service (Resend) through Firebase Cloud Function
class EmailService {
  // Backend endpoint URL - replace with your actual Firebase Cloud Function URL
  static const String _backendUrl = 'https://us-central1-your-project-id.cloudfunctions.net/sendEmail';
  
  // Timeout for HTTP requests
  static const Duration _requestTimeout = Duration(seconds: 30);
  
  /// Main method to send email via secure backend endpoint
  /// Returns EmailSendResult indicating success/failure and error details
  Future<EmailSendResult> sendEmail({
    required String toEmail,
    String? ccEmail,
    required String subject,
    required String body,
  }) async {
    try {
      print('📧 EmailService: Starting email send process...');
      
      // Validate email addresses
      if (!_isValidEmail(toEmail)) {
        print('❌ EmailService: Invalid email address: $toEmail');
        return EmailSendResult(
          success: false,
          errorMessage: 'Invalid recipient email address: $toEmail',
          errorType: EmailErrorType.invalidEmail,
        );
      }
      
      // Note: This is a legacy service. Use SecureEmailService instead.
      print('⚠️ EmailService: This is deprecated. Use SecureEmailService instead.');
      
      return EmailSendResult(
        success: false,
        errorMessage: 'This email service is deprecated. Please use SecureEmailService.',
        errorType: EmailErrorType.unknown,
      );
    } catch (e) {
      print('💥 EmailService: Unexpected error: $e');
      return EmailSendResult(
        success: false,
        errorMessage: 'Failed to send email: ${e.toString()}',
        errorType: EmailErrorType.unknown,
      );
    }
  }

  /// Legacy method for backward compatibility
  Future<bool> sendClaimEmail({
    required String toEmail,
    required String ccEmail,
    required String subject,
    required String body,
    List<String>? attachments,
  }) async {
    final result = await sendEmail(
      toEmail: toEmail,
      ccEmail: ccEmail,
      subject: subject,
      body: body,
    );
    return result.success;
  }

  /// Try to launch email using platform-specific approaches
  Future<EmailLaunchResult> _tryLaunchEmail({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) async {
    // Approach 1: Standard mailto URL (works on all platforms)
    final mailtoResult = await _tryMailtoApproach(
      toEmail: toEmail,
      ccEmail: ccEmail,
      bccEmail: bccEmail,
      subject: subject,
      body: body,
    );
    
    if (mailtoResult.success) {
      return mailtoResult;
    }

    // Approach 2: Platform-specific fallbacks
    if (Platform.isAndroid) {
      return await _tryAndroidSpecificApproaches(
        toEmail: toEmail,
        ccEmail: ccEmail,
        bccEmail: bccEmail,
        subject: subject,
        body: body,
      );
    } else if (Platform.isIOS) {
      return await _tryIOSSpecificApproaches(
        toEmail: toEmail,
        ccEmail: ccEmail,
        bccEmail: bccEmail,
        subject: subject,
        body: body,
      );
    }

    // No email app available
    return EmailLaunchResult(
      success: false,
      errorType: EmailErrorType.noEmailApp,
      errorMessage: 'No email app is installed on this device',
    );
  }

  /// Try standard mailto URL approach
  Future<EmailLaunchResult> _tryMailtoApproach({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) async {
    try {
      final String mailtoUrl = _generateMailtoUrl(
        toEmail: toEmail,
        ccEmail: ccEmail,
        bccEmail: bccEmail,
        subject: subject,
        body: body,
      );
      
      print('🚀 EmailService: Trying mailto URL: $mailtoUrl');
      
      final Uri emailUri = Uri.parse(mailtoUrl);
      
      print('📱 EmailService: Checking if can launch URL...');
      final canLaunch = await canLaunchUrl(emailUri);
      print('📱 EmailService: Can launch URL: $canLaunch');
      
      if (canLaunch) {
        print('📧 EmailService: Attempting to launch email app...');
        final launched = await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
        
        print('📧 EmailService: Launch result: $launched');
        
        if (launched) {
          print('✅ EmailService: Successfully launched email app via mailto');
          return EmailLaunchResult(
            success: true,
            method: 'mailto',
          );
        } else {
          print('❌ EmailService: Launch returned false');
        }
      } else {
        print('❌ EmailService: Cannot launch mailto URL');
      }
      
      return EmailLaunchResult(
        success: false,
        errorType: EmailErrorType.cannotLaunch,
        errorMessage: 'Cannot launch mailto URL - canLaunch: $canLaunch',
      );
    } catch (e) {
      print('💥 EmailService: Mailto approach exception: $e');
      return EmailLaunchResult(
        success: false,
        errorType: EmailErrorType.cannotLaunch,
        errorMessage: 'Mailto approach failed: ${e.toString()}',
      );
    }
  }

  /// Try Android-specific email launching approaches
  Future<EmailLaunchResult> _tryAndroidSpecificApproaches({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) async {
    print('🤖 EmailService: Trying Android-specific approaches...');
    
    // Try Android SENDTO intent (better for Gmail)
    try {
      final String intentUrl = _buildAndroidSendToIntent(
        toEmail: toEmail,
        ccEmail: ccEmail,
        bccEmail: bccEmail,
        subject: subject,
        body: body,
      );
      
      print('🤖 EmailService: Trying SENDTO intent: $intentUrl');
      
      final Uri intentUri = Uri.parse(intentUrl);
      
      final canLaunch = await canLaunchUrl(intentUri);
      print('🤖 EmailService: SENDTO intent canLaunch: $canLaunch');
      
      if (canLaunch) {
        print('📧 EmailService: Launching SENDTO intent...');
        final launched = await launchUrl(
          intentUri,
          mode: LaunchMode.externalApplication,
        );
        
        print('📧 EmailService: SENDTO intent launch result: $launched');
        
        if (launched) {
          print('✅ EmailService: Successfully launched via Android SENDTO intent');
          return EmailLaunchResult(
            success: true,
            method: 'android_sendto_intent',
          );
        }
      }
    } catch (e) {
      print('💥 EmailService: SENDTO intent exception: $e');
    }

    // Try generic Android SEND intent
    try {
      final String intentUrl = _buildAndroidSendIntent(
        toEmail: toEmail,
        ccEmail: ccEmail,
        bccEmail: bccEmail,
        subject: subject,
        body: body,
      );
      
      print('🤖 EmailService: Trying SEND intent: $intentUrl');
      
      final Uri intentUri = Uri.parse(intentUrl);
      
      final canLaunch = await canLaunchUrl(intentUri);
      print('🤖 EmailService: SEND intent canLaunch: $canLaunch');
      
      if (canLaunch) {
        print('📧 EmailService: Launching SEND intent...');
        final launched = await launchUrl(
          intentUri,
          mode: LaunchMode.externalApplication,
        );
        
        print('📧 EmailService: SEND intent launch result: $launched');
        
        if (launched) {
          print('✅ EmailService: Successfully launched via Android SEND intent');
          return EmailLaunchResult(
            success: true,
            method: 'android_send_intent',
          );
        }
      }
    } catch (e) {
      print('💥 EmailService: SEND intent exception: $e');
    }

    // Try Samsung-specific approaches as last resort
    try {
      print('📱 EmailService: Trying Samsung-specific approaches...');
      
      // Try direct Samsung Email intent
      final samsungEmailResult = await _trySamsungEmailIntent(
        toEmail: toEmail,
        ccEmail: ccEmail,
        bccEmail: bccEmail,
        subject: subject,
        body: body,
      );
      
      if (samsungEmailResult.success) {
        return samsungEmailResult;
      }
      
      // Try generic email chooser
      final chooserResult = await _tryEmailChooser(
        toEmail: toEmail,
        ccEmail: ccEmail,
        bccEmail: bccEmail,
        subject: subject,
        body: body,
      );
      
      if (chooserResult.success) {
        return chooserResult;
      }
      
    } catch (e) {
      print('💥 EmailService: Samsung approaches exception: $e');
    }

    print('❌ EmailService: All Android approaches failed');
    return EmailLaunchResult(
      success: false,
      errorType: EmailErrorType.noEmailApp,
      errorMessage: 'No compatible email app found on Android device. Please install Gmail, Samsung Email, or another email app.',
    );
  }

  /// Try iOS-specific email launching approaches
  Future<EmailLaunchResult> _tryIOSSpecificApproaches({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) async {
    // iOS typically handles mailto URLs well, so if we get here,
    // it means the standard approach failed
    return EmailLaunchResult(
      success: false,
      errorType: EmailErrorType.noEmailApp,
      errorMessage: 'No email app is configured on this iOS device',
    );
  }

  /// Build Android SENDTO intent URL
  String _buildAndroidSendToIntent({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) {
    final List<String> extras = [];
    
    if (ccEmail != null && ccEmail.isNotEmpty) {
      extras.add('S.android.intent.extra.CC=${Uri.encodeComponent(ccEmail)}');
    }
    
    if (bccEmail != null && bccEmail.isNotEmpty) {
      extras.add('S.android.intent.extra.BCC=${Uri.encodeComponent(bccEmail)}');
    }
    
    extras.add('S.android.intent.extra.SUBJECT=${Uri.encodeComponent(subject)}');
    extras.add('S.android.intent.extra.TEXT=${Uri.encodeComponent(body)}');
    
    return 'intent://send/#Intent;'
        'action=android.intent.action.SENDTO;'
        'data=mailto:${Uri.encodeComponent(toEmail)};'
        '${extras.join(';')};'
        'end';
  }

  /// Build Android SEND intent URL
  String _buildAndroidSendIntent({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) {
    final List<String> emailLines = ['To: $toEmail'];
    
    if (ccEmail != null && ccEmail.isNotEmpty) {
      emailLines.add('CC: $ccEmail');
    }
    
    if (bccEmail != null && bccEmail.isNotEmpty) {
      emailLines.add('BCC: $bccEmail');
    }
    
    emailLines.add('Subject: $subject');
    emailLines.add('');
    emailLines.add(body);
    
    final String emailContent = emailLines.join('\n');
    
    return 'intent://send/#Intent;'
        'action=android.intent.action.SEND;'
        'type=text/plain;'
        'S.android.intent.extra.TEXT=${Uri.encodeComponent(emailContent)};'
        'end';
  }

  /// Generate properly encoded mailto URL
  String _generateMailtoUrl({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) {
    // Encode parameters to handle special characters
    final String encodedSubject = Uri.encodeComponent(subject);
    final String encodedBody = Uri.encodeComponent(body);
    
    // Build the mailto URL
    String mailtoUrl = 'mailto:${Uri.encodeComponent(toEmail)}';
    
    // Add query parameters
    List<String> queryParams = [];
    
    if (ccEmail != null && ccEmail.isNotEmpty) {
      queryParams.add('cc=${Uri.encodeComponent(ccEmail)}');
    }
    
    if (bccEmail != null && bccEmail.isNotEmpty) {
      queryParams.add('bcc=${Uri.encodeComponent(bccEmail)}');
    }
    
    queryParams.add('subject=$encodedSubject');
    queryParams.add('body=$encodedBody');
    
    if (queryParams.isNotEmpty) {
      mailtoUrl += '?${queryParams.join('&')}';
    }

    return mailtoUrl;
  }

  /// Validate email address format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Show user-friendly error dialog when email cannot be launched
  static Future<void> showEmailErrorDialog(
    BuildContext context,
    EmailLaunchResult result,
  ) async {
    String title;
    String message;
    List<Widget> actions = [];

    switch (result.errorType) {
      case EmailErrorType.noEmailApp:
        title = 'No Email App Found';
        message = 'No email app is installed on your device. '
            'Please install an email app like Gmail, Outlook, or Apple Mail '
            'to send emails.';
        actions = [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ];
        break;
      case EmailErrorType.invalidEmail:
        title = 'Invalid Email';
        message = result.errorMessage ?? 'The email address is not valid.';
        actions = [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ];
        break;
      case EmailErrorType.cannotLaunch:
        title = 'Cannot Open Email App';
        message = 'Unable to open your email app. Please try again or '
            'copy the email details manually.';
        actions = [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () async {
              await copyEmailToClipboard(
                toEmail: result.errorMessage?.contains('To: ') == true 
                    ? result.errorMessage!.split('To: ')[1].split('\n')[0] 
                    : '',
                subject: result.errorMessage?.contains('Subject: ') == true 
                    ? result.errorMessage!.split('Subject: ')[1].split('\n')[0] 
                    : '',
                body: result.errorMessage ?? '',
              );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Email details copied to clipboard'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Copy Details'),
          ),
        ];
        break;
      case EmailErrorType.unknown:
      default:
        title = 'Email Error';
        message = result.errorMessage ?? 'An unexpected error occurred '
            'while trying to open your email app.';
        actions = [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ];
        break;
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions,
      ),
    );
  }

  /// Copy email details to clipboard as fallback
  static Future<void> copyEmailToClipboard({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) async {
    final List<String> emailLines = ['To: $toEmail'];
    
    if (ccEmail != null && ccEmail.isNotEmpty) {
      emailLines.add('CC: $ccEmail');
    }
    
    if (bccEmail != null && bccEmail.isNotEmpty) {
      emailLines.add('BCC: $bccEmail');
    }
    
    emailLines.add('Subject: $subject');
    emailLines.add('');
    emailLines.add(body);
    
    final String emailContent = emailLines.join('\n');
    
    await Clipboard.setData(ClipboardData(text: emailContent));
  }

  /// Generate professional email template for flight compensation claims
  String generateCompensationEmailBody({
    required String passengerName,
    required String flightNumber,
    required String flightDate,
    required String departureAirport,
    required String arrivalAirport,
    required String delayReason,
    required String compensationAmount,
    required String locale,
  }) {
    switch (locale.toLowerCase()) {
      case 'de':
        return _generateGermanEmailTemplate(
          passengerName: passengerName,
          flightNumber: flightNumber,
          flightDate: flightDate,
          departureAirport: departureAirport,
          arrivalAirport: arrivalAirport,
          delayReason: delayReason,
          compensationAmount: compensationAmount,
        );
      case 'es':
        return _generateSpanishEmailTemplate(
          passengerName: passengerName,
          flightNumber: flightNumber,
          flightDate: flightDate,
          departureAirport: departureAirport,
          arrivalAirport: arrivalAirport,
          delayReason: delayReason,
          compensationAmount: compensationAmount,
        );
      default:
        return _generateEnglishEmailTemplate(
          passengerName: passengerName,
          flightNumber: flightNumber,
          flightDate: flightDate,
          departureAirport: departureAirport,
          arrivalAirport: arrivalAirport,
          delayReason: delayReason,
          compensationAmount: compensationAmount,
        );
    }
  }

  /// Generate English email template
  String _generateEnglishEmailTemplate({
    required String passengerName,
    required String flightNumber,
    required String flightDate,
    required String departureAirport,
    required String arrivalAirport,
    required String delayReason,
    required String compensationAmount,
  }) {
    return '''
Dear Sir/Madam,

I am writing to formally request compensation for the delayed flight $flightNumber on $flightDate from $departureAirport to $arrivalAirport.

Flight Details:
- Passenger Name: $passengerName
- Flight Number: $flightNumber
- Date: $flightDate
- Route: $departureAirport to $arrivalAirport
- Delay Reason: $delayReason

According to EU Regulation 261/2004, I am entitled to compensation of €$compensationAmount for this delay.

I have attached supporting documentation including my boarding pass and any relevant receipts.

Please process my compensation claim and confirm receipt of this request.

Thank you for your attention to this matter.

Sincerely,
$passengerName
''';
  }

  /// Generate German email template
  String _generateGermanEmailTemplate({
    required String passengerName,
    required String flightNumber,
    required String flightDate,
    required String departureAirport,
    required String arrivalAirport,
    required String delayReason,
    required String compensationAmount,
  }) {
    return '''
Sehr geehrte Damen und Herren,

hiermit beantrage ich förmlich eine Entschädigung für den verspäteten Flug $flightNumber am $flightDate von $departureAirport nach $arrivalAirport.

Flugdetails:
- Passagier: $passengerName
- Flugnummer: $flightNumber
- Datum: $flightDate
- Strecke: $departureAirport nach $arrivalAirport
- Verspätungsgrund: $delayReason

Gemäß EU-Verordnung 261/2004 steht mir eine Entschädigung von €$compensationAmount für diese Verspätung zu.

Ich habe entsprechende Belege wie Bordkarte und relevante Quittungen beigefügt.

Bitte bearbeiten Sie meinen Entschädigungsantrag und bestätigen Sie den Erhalt dieser Anfrage.

Vielen Dank für Ihre Aufmerksamkeit.

Mit freundlichen Grüßen,
$passengerName
''';
  }

  /// Generate Spanish email template
  String _generateSpanishEmailTemplate({
    required String passengerName,
    required String flightNumber,
    required String flightDate,
    required String departureAirport,
    required String arrivalAirport,
    required String delayReason,
    required String compensationAmount,
  }) {
    return '''
Estimados señores,

Por la presente solicito formalmente una compensación por el vuelo retrasado $flightNumber el $flightDate de $departureAirport a $arrivalAirport.

Detalles del vuelo:
- Pasajero: $passengerName
- Número de vuelo: $flightNumber
- Fecha: $flightDate
- Ruta: $departureAirport a $arrivalAirport
- Motivo del retraso: $delayReason

Según el Reglamento UE 261/2004, tengo derecho a una compensación de €$compensationAmount por este retraso.

He adjuntado la documentación de apoyo incluyendo mi tarjeta de embarque y recibos relevantes.

Por favor procesen mi solicitud de compensación y confirmen la recepción de esta solicitud.

Gracias por su atención a este asunto.

Atentamente,
$passengerName
''';
  }

  /// Try Samsung Email app specifically
  Future<EmailLaunchResult> _trySamsungEmailIntent({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) async {
    try {
      // Samsung Email package name: com.samsung.android.email.provider
      final String samsungEmailUrl = 'intent://compose/#Intent;'
          'action=android.intent.action.SEND;'
          'type=text/plain;'
          'S.android.intent.extra.EMAIL=${Uri.encodeComponent(toEmail)};'
          '${ccEmail != null ? 'S.android.intent.extra.CC=${Uri.encodeComponent(ccEmail)};' : ''}'
          'S.android.intent.extra.SUBJECT=${Uri.encodeComponent(subject)};'
          'S.android.intent.extra.TEXT=${Uri.encodeComponent(body)};'
          'package=com.samsung.android.email.provider;'
          'end';
      
      print('📱 EmailService: Trying Samsung Email intent: $samsungEmailUrl');
      
      final Uri samsungUri = Uri.parse(samsungEmailUrl);
      
      final canLaunch = await canLaunchUrl(samsungUri);
      print('📱 EmailService: Samsung Email canLaunch: $canLaunch');
      
      if (canLaunch) {
        print('📧 EmailService: Launching Samsung Email...');
        final launched = await launchUrl(
          samsungUri,
          mode: LaunchMode.externalApplication,
        );
        
        print('📧 EmailService: Samsung Email launch result: $launched');
        
        if (launched) {
          print('✅ EmailService: Successfully launched Samsung Email');
          return EmailLaunchResult(
            success: true,
            method: 'samsung_email',
          );
        }
      }
      
      return EmailLaunchResult(
        success: false,
        errorType: EmailErrorType.cannotLaunch,
        errorMessage: 'Samsung Email not available',
      );
    } catch (e) {
      print('💥 EmailService: Samsung Email exception: $e');
      return EmailLaunchResult(
        success: false,
        errorType: EmailErrorType.cannotLaunch,
        errorMessage: 'Samsung Email failed: ${e.toString()}',
      );
    }
  }

  /// Try generic email chooser dialog
  Future<EmailLaunchResult> _tryEmailChooser({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) async {
    try {
      // Create a generic email chooser intent
      final String chooserUrl = 'intent://send/#Intent;'
          'action=android.intent.action.CHOOSER;'
          'S.android.intent.extra.INTENT='
          'intent://send/%23Intent%3B'
          'action%3Dandroid.intent.action.SEND%3B'
          'type%3Dtext/plain%3B'
          'S.android.intent.extra.EMAIL%3D${Uri.encodeComponent(toEmail)}%3B'
          '${ccEmail != null ? 'S.android.intent.extra.CC%3D${Uri.encodeComponent(ccEmail)}%3B' : ''}'
          'S.android.intent.extra.SUBJECT%3D${Uri.encodeComponent(subject)}%3B'
          'S.android.intent.extra.TEXT%3D${Uri.encodeComponent(body)}%3B'
          'end%3B'
          'S.android.intent.extra.TITLE=Send email;'
          'end';
      
      print('📱 EmailService: Trying email chooser: $chooserUrl');
      
      final Uri chooserUri = Uri.parse(chooserUrl);
      
      final canLaunch = await canLaunchUrl(chooserUri);
      print('📱 EmailService: Email chooser canLaunch: $canLaunch');
      
      if (canLaunch) {
        print('📧 EmailService: Launching email chooser...');
        final launched = await launchUrl(
          chooserUri,
          mode: LaunchMode.externalApplication,
        );
        
        print('📧 EmailService: Email chooser launch result: $launched');
        
        if (launched) {
          print('✅ EmailService: Successfully launched email chooser');
          return EmailLaunchResult(
            success: true,
            method: 'email_chooser',
          );
        }
      }
      
      return EmailLaunchResult(
        success: false,
        errorType: EmailErrorType.cannotLaunch,
        errorMessage: 'Email chooser not available',
      );
    } catch (e) {
      print('💥 EmailService: Email chooser exception: $e');
      return EmailLaunchResult(
        success: false,
        errorType: EmailErrorType.cannotLaunch,
        errorMessage: 'Email chooser failed: ${e.toString()}',
      );
    }
  }
}
