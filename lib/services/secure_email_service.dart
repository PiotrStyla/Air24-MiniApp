import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Types of email sending errors
enum EmailErrorType {
  networkError,
  serverError,
  invalidEmail,
  authenticationError,
  rateLimitExceeded,
  unknown,
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
class SecureEmailService {
  // Backend endpoint URL - using local development server for testing
  static const String _backendUrl = 'http://localhost:3000/api/sendEmail';
  
  // Timeout for HTTP requests
  static const Duration _requestTimeout = Duration(seconds: 30);
  
  /// Main method to send email via secure backend endpoint
  /// Returns EmailSendResult indicating success/failure and error details
  Future<EmailSendResult> sendEmail({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
    String? replyTo,
  }) async {
    debugPrint('🚀 SecureEmailService: Starting sendEmail...');
    debugPrint('📧 SecureEmailService: To: $toEmail');
    debugPrint('📧 SecureEmailService: Subject: $subject');
    
    try {
      // Validate email addresses
      if (!_isValidEmail(toEmail)) {
        debugPrint('❌ SecureEmailService: Invalid recipient email');
        return const EmailSendResult(
          success: false,
          errorType: EmailErrorType.invalidEmail,
          errorMessage: 'Invalid recipient email address',
        );
      }
      
      if (ccEmail != null && ccEmail.isNotEmpty && !_isValidEmail(ccEmail)) {
        debugPrint('❌ SecureEmailService: Invalid CC email');
        return const EmailSendResult(
          success: false,
          errorType: EmailErrorType.invalidEmail,
          errorMessage: 'Invalid CC email address',
        );
      }
      
      // Prepare request payload
      final Map<String, dynamic> payload = {
        'to': toEmail,
        'subject': subject,
        'body': body,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      if (ccEmail != null && ccEmail.isNotEmpty) {
        payload['cc'] = ccEmail;
      }
      
      if (bccEmail != null && bccEmail.isNotEmpty) {
        payload['bcc'] = bccEmail;
      }
      
      if (replyTo != null && replyTo.isNotEmpty) {
        payload['replyTo'] = replyTo;
      }
      
      debugPrint('📤 SecureEmailService: Sending request to backend...');
      debugPrint('🚀 SecureEmailService: Sending POST request to backend...');
      
      try {
        final response = await http.post(
          Uri.parse(_backendUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(payload),
        ).timeout(_requestTimeout);
        
        debugPrint('📡 SecureEmailService: Response status: ${response.statusCode}');
        debugPrint('📡 SecureEmailService: Response body: ${response.body}');
        
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final emailId = responseData['emailId'] as String?;
          
          debugPrint('✅ SecureEmailService: Email sent successfully, ID: $emailId');
          return EmailSendResult(
            success: true,
            emailId: emailId,
            statusCode: response.statusCode,
          );
        } else if (response.statusCode == 404) {
          debugPrint('⚠️ SecureEmailService: Backend not found (404), using fallback...');
          return _fallbackEmailSend(toEmail, ccEmail, subject, body);
        } else {
          final errorType = _mapStatusCodeToErrorType(response.statusCode);
          String errorMessage = 'Failed to send email';
          
          try {
            final responseData = jsonDecode(response.body);
            errorMessage = responseData['error'] ?? errorMessage;
          } catch (e) {
            // If response body is not valid JSON, use default message
          }
          
          debugPrint('❌ SecureEmailService: Error ${response.statusCode}: $errorMessage');
          return EmailSendResult(
            success: false,
            errorType: errorType,
            errorMessage: errorMessage,
            statusCode: response.statusCode,
          );
        }
        
      } on TimeoutException {
        debugPrint('⏰ SecureEmailService: Request timeout, using fallback...');
        return _fallbackEmailSend(toEmail, ccEmail, subject, body);
      } on SocketException {
        debugPrint('🌐 SecureEmailService: Network error, using fallback...');
        return _fallbackEmailSend(toEmail, ccEmail, subject, body);
      } catch (e) {
        debugPrint('❌ SecureEmailService: Unexpected error: $e');
        return EmailSendResult(
          success: false,
          errorType: EmailErrorType.networkError,
          errorMessage: 'Network error: ${e.toString()}',
        );
      }
      
    } on SocketException catch (e) {
      debugPrint('❌ SecureEmailService: Network error: $e');
      return const EmailSendResult(
        success: false,
        errorType: EmailErrorType.networkError,
        errorMessage: 'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      debugPrint('❌ SecureEmailService: HTTP error: $e');
      return const EmailSendResult(
        success: false,
        errorType: EmailErrorType.networkError,
        errorMessage: 'HTTP request failed',
      );
    } on FormatException catch (e) {
      debugPrint('❌ SecureEmailService: JSON format error: $e');
      return const EmailSendResult(
        success: false,
        errorType: EmailErrorType.serverError,
        errorMessage: 'Invalid response format from server',
      );
    } catch (e) {
      debugPrint('❌ SecureEmailService: Unexpected error: $e');
      return EmailSendResult(
        success: false,
        errorType: EmailErrorType.unknown,
        errorMessage: 'Unexpected error: ${e.toString()}',
      );
    }
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
  
  /// Validate email address format
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }
  
  /// Direct email sending using mailto URL scheme when backend is unavailable
  Future<EmailSendResult> _fallbackEmailSend(
    String toEmail,
    String? ccEmail,
    String subject,
    String body,
  ) async {
    debugPrint('📧 SecureEmailService: Using direct email sending via mailto...');
    
    try {
      // Create mailto URL with all email details
      final StringBuffer mailtoUrl = StringBuffer('mailto:$toEmail');
      
      // Add query parameters
      final List<String> params = [];
      
      if (ccEmail != null && ccEmail.isNotEmpty) {
        params.add('cc=${Uri.encodeComponent(ccEmail)}');
      }
      
      params.add('subject=${Uri.encodeComponent(subject)}');
      params.add('body=${Uri.encodeComponent(body)}');
      
      if (params.isNotEmpty) {
        mailtoUrl.write('?${params.join('&')}');
      }
      
      final Uri emailUri = Uri.parse(mailtoUrl.toString());
      debugPrint('🚀 SecureEmailService: Launching email app with: $emailUri');
      
      // Launch email app with pre-filled content
      final bool launched = await launchUrl(emailUri);
      
      if (launched) {
        debugPrint('✅ SecureEmailService: Email app launched successfully');
        return EmailSendResult(
          success: true,
          errorMessage: 'Email app opened with pre-filled content. Please review and send.',
        );
      } else {
        debugPrint('❌ SecureEmailService: Failed to launch email app, falling back to clipboard...');
        return _clipboardFallback(toEmail, ccEmail, subject, body);
      }
    } catch (e) {
      debugPrint('❌ SecureEmailService: Direct email failed: $e, falling back to clipboard...');
      return _clipboardFallback(toEmail, ccEmail, subject, body);
    }
  }
  
  /// Final fallback - copy to clipboard if email app can't be launched
  Future<EmailSendResult> _clipboardFallback(
    String toEmail,
    String? ccEmail,
    String subject,
    String body,
  ) async {
    try {
      final StringBuffer emailContent = StringBuffer();
      emailContent.writeln('To: $toEmail');
      if (ccEmail != null && ccEmail.isNotEmpty) {
        emailContent.writeln('CC: $ccEmail');
      }
      emailContent.writeln('Subject: $subject');
      emailContent.writeln('');
      emailContent.writeln(body);
      
      await Clipboard.setData(ClipboardData(text: emailContent.toString()));
      
      return EmailSendResult(
        success: true,
        errorMessage: 'No email app available. Content copied to clipboard - paste into any email service.',
      );
    } catch (e) {
      return EmailSendResult(
        success: false,
        errorType: EmailErrorType.unknown,
        errorMessage: 'All email methods failed: ${e.toString()}',
      );
    }
  }

  /// Map HTTP status codes to error types
  EmailErrorType _mapStatusCodeToErrorType(int statusCode) {
    switch (statusCode) {
      case 400:
        return EmailErrorType.invalidEmail;
      case 401:
      case 403:
        return EmailErrorType.authenticationError;
      case 429:
        return EmailErrorType.rateLimitExceeded;
      case 500:
      case 502:
      case 503:
      case 504:
        return EmailErrorType.serverError;
      default:
        return EmailErrorType.networkError;
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

I am writing to request compensation for my delayed/cancelled flight under EU Regulation 261/2004.

Flight Details:
- Passenger Name: $passengerName
- Flight Number: $flightNumber
- Flight Date: $flightDate
- Route: $departureAirport to $arrivalAirport
- Reason for Claim: $delayReason
- Compensation Amount: $compensationAmount

According to EU Regulation 261/2004, I am entitled to compensation for this flight disruption. I request that you process my claim and provide the compensation amount within the legally required timeframe.

Please confirm receipt of this claim and provide an estimated timeline for resolution.

Thank you for your prompt attention to this matter.

Best regards,
$passengerName

---
This claim was generated by Flight Compensation App
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
- Passagiername: $passengerName
- Flugnummer: $flightNumber
- Datum: $flightDate
- Strecke: $departureAirport nach $arrivalAirport
- Verspätungsgrund: $delayReason

Gemäß EU-Verordnung 261/2004 habe ich Anspruch auf eine Entschädigung von €$compensationAmount für diese Verspätung.

Bitte fügen Sie die folgenden Dokumente zu dieser E-Mail hinzu, bevor Sie sie senden:
• Bordkarte (Boarding Pass)
• Buchungsbestätigung
• Belege für zusätzliche Ausgaben
• Ausweis/Reisepass (Kopie)

Bitte bearbeiten Sie meinen Entschädigungsanspruch und bestätigen Sie den Erhalt dieser Anfrage.

Vielen Dank für Ihre Aufmerksamkeit in dieser Angelegenheit.

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
- Nombre del pasajero: $passengerName
- Número de vuelo: $flightNumber
- Fecha: $flightDate
- Ruta: $departureAirport a $arrivalAirport
- Motivo del retraso: $delayReason

Según el Reglamento UE 261/2004, tengo derecho a una compensación de €$compensationAmount por este retraso.

📎 ARCHIVOS ADJUNTOS IMPORTANTES:
Por favor adjunte los siguientes documentos a este correo antes de enviarlo:
• Tarjeta de embarque
• Confirmación de reserva
• Recibos de gastos adicionales
• Identificación/Pasaporte (copia)

He preparado documentación de apoyo que adjuntaré a este correo.

Por favor procesen mi reclamo de compensación y confirmen la recepción de esta solicitud.

Gracias por su atención a este asunto.

Atentamente,
$passengerName
''';
  }
}
