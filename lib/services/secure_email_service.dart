import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

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

/// Production-ready email service with reliable fallback mechanisms
/// Prioritizes direct email app integration over backend dependencies
class SecureEmailService {
  // Production-ready email service - uses direct email app integration
  // This ensures reliable email functionality without backend dependencies
  static const String _apiBase = String.fromEnvironment(
    'WLD_BASE_URL',
    defaultValue:
        'https://air24.app/api',
  );
  
  /// Main method to send email via secure backend endpoint
  /// Returns EmailSendResult indicating success/failure and error details
  Future<EmailSendResult> sendEmail({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
    String? replyTo,
    String? userEmail, // User's email for reply-to functionality
  }) async {
    debugPrint('🚀 SecureEmailService: Starting sendEmail...');
    debugPrint('📧 SecureEmailService: To (suppressed)');
    debugPrint('📧 SecureEmailService: Subject present? ${subject.isNotEmpty}');
    
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
      
      // Decide method by platform
      if (kIsWeb) {
        debugPrint('🌐 SecureEmailService: Web detected - attempting backend send via $_apiBase/sendEmail');
        final backendResult = await _sendViaBackend(
          toEmail: toEmail,
          ccEmail: ccEmail,
          bccEmail: bccEmail,
          subject: subject,
          body: body,
          replyTo: replyTo,
          userEmail: userEmail,
        );
        if (backendResult.success) {
          return backendResult;
        }
        debugPrint('⚠️ Backend send failed on Web, using clipboard fallback (no new tab)');
        return _clipboardFallback(toEmail, ccEmail, subject, body);
      } else {
        // Mobile/Desktop: prefer native email app via mailto
        debugPrint('📱 SecureEmailService: Mobile/Desktop detected - using mailto approach');
        return _fallbackEmailSend(toEmail, ccEmail, subject, body);
      }
      
    } catch (e) {
      debugPrint('❌ SecureEmailService: Unexpected error: $e');
      return EmailSendResult(
        success: false,
        errorType: EmailErrorType.unknown,
        errorMessage: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  Future<EmailSendResult> _sendViaBackend({
    required String toEmail,
    String? ccEmail,
    String? bccEmail,
    required String subject,
    required String body,
    String? replyTo,
    String? userEmail,
  }) async {
    try {
      final uri = Uri.parse('$_apiBase/sendEmail');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'to': toEmail,
              if (ccEmail != null && ccEmail.isNotEmpty) 'cc': ccEmail,
              if (bccEmail != null && bccEmail.isNotEmpty) 'bcc': bccEmail,
              'subject': subject,
              'body': body,
              if (replyTo != null && replyTo.isNotEmpty) 'replyTo': replyTo,
              if (userEmail != null && userEmail.isNotEmpty) 'userEmail': userEmail,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        String? emailId;
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          emailId = data['emailId']?.toString();
        } catch (_) {}
        return EmailSendResult(success: true, emailId: emailId);
      }

      return EmailSendResult(
        success: false,
        statusCode: response.statusCode,
        errorType: _mapStatusCodeToErrorType(response.statusCode),
        errorMessage:
            'Backend responded with status ${response.statusCode}: ${response.body}',
      );
    } on TimeoutException {
      return const EmailSendResult(
        success: false,
        errorType: EmailErrorType.networkError,
        errorMessage: 'Request to email backend timed out',
      );
    } catch (e) {
      return EmailSendResult(
        success: false,
        errorType: EmailErrorType.networkError,
        errorMessage: 'Failed to call email backend: ${e.toString()}',
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
    debugPrint('🔧 SecureEmailService: Generating email template for locale: "$locale"');
    // Format amount once and reuse in all templates (no decimals, locale-aware separators)
    final formattedAmount = _formatAmountNumber(compensationAmount, locale);
    switch (locale.toLowerCase()) {
      case 'de':
        return _generateGermanEmailTemplate(
          passengerName: passengerName,
          flightNumber: flightNumber,
          flightDate: flightDate,
          departureAirport: departureAirport,
          arrivalAirport: arrivalAirport,
          delayReason: delayReason,
          compensationAmount: formattedAmount,
        );
      case 'es':
        return _generateSpanishEmailTemplate(
          passengerName: passengerName,
          flightNumber: flightNumber,
          flightDate: flightDate,
          departureAirport: departureAirport,
          arrivalAirport: arrivalAirport,
          delayReason: delayReason,
          compensationAmount: formattedAmount,
        );
      case 'fr':
        return _generateFrenchEmailTemplate(
          passengerName: passengerName,
          flightNumber: flightNumber,
          flightDate: flightDate,
          departureAirport: departureAirport,
          arrivalAirport: arrivalAirport,
          delayReason: delayReason,
          compensationAmount: formattedAmount,
        );
      case 'pl':
        return _generatePolishEmailTemplate(
          passengerName: passengerName,
          flightNumber: flightNumber,
          flightDate: flightDate,
          departureAirport: departureAirport,
          arrivalAirport: arrivalAirport,
          delayReason: delayReason,
          compensationAmount: formattedAmount,
        );
      case 'pt':
        return _generatePortugueseEmailTemplate(
          passengerName: passengerName,
          flightNumber: flightNumber,
          flightDate: flightDate,
          departureAirport: departureAirport,
          arrivalAirport: arrivalAirport,
          delayReason: delayReason,
          compensationAmount: formattedAmount,
        );
      default:
        return _generateEnglishEmailTemplate(
          passengerName: passengerName,
          flightNumber: flightNumber,
          flightDate: flightDate,
          departureAirport: departureAirport,
          arrivalAirport: arrivalAirport,
          delayReason: delayReason,
          compensationAmount: formattedAmount,
        );
    }
  }

  /// Format a numeric amount (given as string) without decimals, with locale-aware grouping
  String _formatAmountNumber(String amount, String locale) {
    try {
      final value = double.tryParse(amount) ?? 0;
      final intValue = value.round();
      final formatter = NumberFormat.decimalPattern(locale);
      return formatter.format(intValue);
    } catch (_) {
      // Fallback: strip trailing .0 if present
      return amount.endsWith('.0') ? amount.substring(0, amount.length - 2) : amount;
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
      debugPrint('🚀 SecureEmailService: Launching email app (URI suppressed)');
      
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
- Compensation Amount: €$compensationAmount

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

  /// Generate French email template
  String _generateFrenchEmailTemplate({
    required String passengerName,
    required String flightNumber,
    required String flightDate,
    required String departureAirport,
    required String arrivalAirport,
    required String delayReason,
    required String compensationAmount,
  }) {
    return '''Objet: Demande d'indemnisation selon le Règlement UE 261/2004 - Vol $flightNumber

Mesdames, Messieurs,

Je vous écris pour demander une indemnisation conformément au Règlement européen 261/2004 concernant les droits des passagers aériens.

Mon vol a subi un retard/une annulation qui me donne droit à une compensation financière selon la réglementation européenne en vigueur.

Détails du vol :
- Nom du passager : $passengerName
- Numéro de vol : $flightNumber
- Date : $flightDate
- Itinéraire : $departureAirport vers $arrivalAirport
- Raison du retard : $delayReason

Je demande une compensation de $compensationAmount euros conformément au Règlement UE 261/2004.

Je vous prie de traiter cette demande dans les plus brefs délais et vous remercie par avance de votre coopération.

Cordialement,
$passengerName''';
  }

  /// Generate Polish email template
  String _generatePolishEmailTemplate({
    required String passengerName,
    required String flightNumber,
    required String flightDate,
    required String departureAirport,
    required String arrivalAirport,
    required String delayReason,
    required String compensationAmount,
  }) {
    return '''Temat: Roszczenie o odszkodowanie zgodnie z Rozporządzeniem UE 261/2004 - Lot $flightNumber

Szanowni Państwo,

Piszę w sprawie wniosku o odszkodowanie zgodnie z Rozporządzeniem Parlamentu Europejskiego i Rady (WE) nr 261/2004 dotyczącym praw pasażerów w transporcie lotniczym.

Mój lot został opóźniony/odwołany, co zgodnie z prawem europejskim uprawnia mnie do otrzymania rekompensaty finansowej.

Szczegóły lotu:
- Imię i nazwisko pasażera: $passengerName
- Numer lotu: $flightNumber
- Data: $flightDate
- Trasa: $departureAirport do $arrivalAirport
- Przyczyna opóźnienia: $delayReason

Żądam odszkodowania w wysokości $compensationAmount euro zgodnie z Rozporządzeniem UE 261/2004.

Proszę o rozpatrzenie mojego wniosku w możliwie najkrótszym czasie.

Z poważaniem,
$passengerName''';
  }

  /// Generate Portuguese email template
  String _generatePortugueseEmailTemplate({
    required String passengerName,
    required String flightNumber,
    required String flightDate,
    required String departureAirport,
    required String arrivalAirport,
    required String delayReason,
    required String compensationAmount,
  }) {
    return '''Assunto: Reclamação de Compensação de acordo com o Regulamento UE 261/2004 - Voo $flightNumber

Exmos. Senhores,

Venho por este meio solicitar compensação de acordo com o Regulamento (CE) n.º 261/2004 do Parlamento Europeu e do Conselho relativo aos direitos dos passageiros no transporte aéreo.

O meu voo foi atrasado/cancelado, o que, de acordo com a legislação europeia, me dá direito a receber compensação financeira.

Detalhes do voo:
- Nome do passageiro: $passengerName
- Número do voo: $flightNumber
- Data: $flightDate
- Rota: $departureAirport para $arrivalAirport
- Motivo do atraso: $delayReason

Solicito compensação no valor de $compensationAmount euros de acordo com o Regulamento UE 261/2004.

Peço que considerem o meu pedido no menor prazo possível.

Com os melhores cumprimentos,
$passengerName''';
  }
}
