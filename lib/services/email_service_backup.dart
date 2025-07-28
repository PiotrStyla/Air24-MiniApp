import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// Enhanced service for handling cross-platform email operations
/// Supports Android, iOS, and other platforms with robust error handling
class EmailService {
  
  /// Main method to compose and send email using the device's default email app
  /// Returns true if email app was successfully opened, false otherwise
  Future<EmailLaunchResult> composeEmail({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
  }) async {
    try {
      // Validate email addresses
      if (!_isValidEmail(toEmail)) {
        return EmailLaunchResult(
          success: false,
          errorType: EmailErrorType.invalidEmail,
          errorMessage: 'Invalid recipient email address: $toEmail',
        );
      }

      // Try platform-specific approaches in order of preference
      final result = await _tryLaunchEmail(
        toEmail: toEmail,
        ccEmail: ccEmail,
        bccEmail: bccEmail,
        subject: subject,
        body: body,
      );

      return result;
    } catch (e) {
      return EmailLaunchResult(
        success: false,
        errorType: EmailErrorType.unknown,
        errorMessage: 'Unexpected error: ${e.toString()}',
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
    final result = await composeEmail(
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
      
      final Uri emailUri = Uri.parse(mailtoUrl);
      
      if (await canLaunchUrl(emailUri)) {
        final launched = await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
        
        if (launched) {
          return EmailLaunchResult(
            success: true,
            method: 'mailto',
          );
        }
      }
      
      return EmailLaunchResult(
        success: false,
        errorType: EmailErrorType.cannotLaunch,
        errorMessage: 'Cannot launch mailto URL',
      );
    } catch (e) {
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
    // Try Android SENDTO intent (better for Gmail)
    try {
      final String intentUrl = _buildAndroidSendToIntent(
        toEmail: toEmail,
        ccEmail: ccEmail,
        bccEmail: bccEmail,
        subject: subject,
        body: body,
      );
      
      final Uri intentUri = Uri.parse(intentUrl);
      
      if (await canLaunchUrl(intentUri)) {
        final launched = await launchUrl(
          intentUri,
          mode: LaunchMode.externalApplication,
        );
        
        if (launched) {
          return EmailLaunchResult(
            success: true,
            method: 'android_sendto_intent',
          );
        }
      }
    } catch (e) {
      // Continue to next approach
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
      
      final Uri intentUri = Uri.parse(intentUrl);
      
      if (await canLaunchUrl(intentUri)) {
        final launched = await launchUrl(
          intentUri,
          mode: LaunchMode.externalApplication,
        );
        
        if (launched) {
          return EmailLaunchResult(
            success: true,
            method: 'android_send_intent',
          );
        }
      }
    } catch (e) {
      // Continue to fallback
    }

    return EmailLaunchResult(
      success: false,
      errorType: EmailErrorType.noEmailApp,
      errorMessage: 'No compatible email app found on Android device',
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
}

/// Types of email launch errors
enum EmailErrorType {
  noEmailApp,
  invalidEmail,
  cannotLaunch,
  unknown,
}
    required String delayReason,
    required String compensationAmount,
    required String locale,
  }) {
    // Basic template - can be enhanced with localization
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

I am writing to request compensation for my delayed/cancelled flight under EU Regulation 261/2004.

Flight Details:
- Passenger Name: $passengerName
- Flight Number: $flightNumber
- Flight Date: $flightDate
- Route: $departureAirport → $arrivalAirport
- Reason for Claim: $delayReason
- Compensation Amount: €$compensationAmount

According to EU Regulation 261/2004, I am entitled to compensation for this flight disruption. I have attached all relevant documentation to support my claim.

Please process my compensation request and confirm receipt of this email. I look forward to your prompt response within the legally required timeframe.

Best regards,
$passengerName

---
This email was generated by the Flight Compensation App
''';
  }

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

hiermit beantrage ich eine Entschädigung für meinen verspäteten/annullierten Flug gemäß EU-Verordnung 261/2004.

Flugdetails:
- Passagiername: $passengerName
- Flugnummer: $flightNumber
- Flugdatum: $flightDate
- Strecke: $departureAirport → $arrivalAirport
- Grund für den Anspruch: $delayReason
- Entschädigungsbetrag: €$compensationAmount

Gemäß EU-Verordnung 261/2004 habe ich Anspruch auf Entschädigung für diese Flugstörung. Ich habe alle relevanten Dokumente zur Unterstützung meines Anspruchs beigefügt.

Bitte bearbeiten Sie meinen Entschädigungsantrag und bestätigen Sie den Erhalt dieser E-Mail. Ich freue mich auf Ihre prompte Antwort innerhalb der gesetzlich vorgeschriebenen Frist.

Mit freundlichen Grüßen,
$passengerName

---
Diese E-Mail wurde von der Flugentschädigungs-App generiert
''';
  }

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

Por la presente solicito compensación por mi vuelo retrasado/cancelado bajo el Reglamento UE 261/2004.

Detalles del vuelo:
- Nombre del pasajero: $passengerName
- Número de vuelo: $flightNumber
- Fecha del vuelo: $flightDate
- Ruta: $departureAirport → $arrivalAirport
- Motivo de la reclamación: $delayReason
- Cantidad de compensación: €$compensationAmount

Según el Reglamento UE 261/2004, tengo derecho a compensación por esta interrupción del vuelo. He adjuntado toda la documentación relevante para respaldar mi reclamación.

Por favor procesen mi solicitud de compensación y confirmen la recepción de este correo electrónico. Espero su pronta respuesta dentro del plazo legalmente requerido.

Atentamente,
$passengerName

---
Este correo electrónico fue generado por la App de Compensación de Vuelos
''';
  }

  /// Simple in-app email composition - always succeeds by showing content to user
  Future<bool> _showInAppEmailComposition(String toEmail, String ccEmail, String subject, String body) async {
    try {
      // This method always returns true because it shows the email content to the user
      // The actual email sending is handled by the UI layer
      print('Showing in-app email composition');
      print('To: $toEmail');
      print('CC: $ccEmail');
      print('Subject: $subject');
      print('Body length: ${body.length} characters');
      
      // Always return true - the UI will handle showing the email content
      return true;
      
    } catch (e) {
      print('In-app email composition failed: $e');
      return false;
    }
  }

  /// Generate web Gmail URL for browser-based email composition
  String _generateWebGmailUrl({
    required String toEmail,
    required String ccEmail,
    required String subject,
    required String body,
  }) {
    final encodedTo = Uri.encodeComponent(toEmail);
    final encodedCc = Uri.encodeComponent(ccEmail);
    final encodedSubject = Uri.encodeComponent(subject);
    final encodedBody = Uri.encodeComponent(body);
    
    return 'https://mail.google.com/mail/?view=cm&fs=1&to=$encodedTo&cc=$encodedCc&su=$encodedSubject&body=$encodedBody';
  }

  /// Generate web Outlook URL for browser-based email composition
  String _generateWebOutlookUrl({
    required String toEmail,
    required String ccEmail,
    required String subject,
    required String body,
  }) {
    final encodedTo = Uri.encodeComponent(toEmail);
    final encodedCc = Uri.encodeComponent(ccEmail);
    final encodedSubject = Uri.encodeComponent(subject);
    final encodedBody = Uri.encodeComponent(body);
    
    return 'https://outlook.live.com/mail/0/deeplink/compose?to=$encodedTo&cc=$encodedCc&subject=$encodedSubject&body=$encodedBody';
  }
}
