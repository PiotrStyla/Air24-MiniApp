import 'package:flutter/material.dart';

/// Multi-language notification service (Day 11 - Priority 4)
/// Provides localized notification content for push notifications
class NotificationLocalizationService {
  
  /// Get notification content for claim status update
  static NotificationContent getClaimStatusNotification({
    required String status,
    required String claimId,
    required String locale,
  }) {
    switch (locale) {
      case 'es': // Spanish
        return _getSpanishStatusNotification(status, claimId);
      case 'pt': // Portuguese
        return _getPortugueseStatusNotification(status, claimId);
      default: // English (default)
        return _getEnglishStatusNotification(status, claimId);
    }
  }
  
  /// English notifications
  static NotificationContent _getEnglishStatusNotification(String status, String claimId) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return NotificationContent(
          title: '✈️ Claim Submitted',
          body: 'Your claim $claimId has been submitted successfully.',
        );
      case 'reviewing':
        return NotificationContent(
          title: '🔍 Under Review',
          body: 'Your claim $claimId is now being reviewed by the airline.',
        );
      case 'requiresaction':
      case 'requires_action':
        return NotificationContent(
          title: '⚠️ Action Required',
          body: 'Your claim $claimId needs additional information. Please check the app.',
        );
      case 'approved':
        return NotificationContent(
          title: '🎉 Claim Approved!',
          body: 'Great news! Your claim $claimId has been approved for compensation.',
        );
      case 'paid':
        return NotificationContent(
          title: '💰 Payment Received',
          body: 'Your compensation for claim $claimId has been paid!',
        );
      case 'rejected':
        return NotificationContent(
          title: '❌ Claim Rejected',
          body: 'Your claim $claimId was rejected. Tap to see appeal options.',
        );
      case 'processing':
        return NotificationContent(
          title: '⏳ Processing',
          body: 'Your claim $claimId is being processed for payment.',
        );
      case 'appealing':
        return NotificationContent(
          title: '⚖️ Under Appeal',
          body: 'Your appeal for claim $claimId is being processed.',
        );
      default:
        return NotificationContent(
          title: '📬 Claim Update',
          body: 'Your claim $claimId has been updated. Tap to view details.',
        );
    }
  }
  
  /// Spanish notifications
  static NotificationContent _getSpanishStatusNotification(String status, String claimId) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return NotificationContent(
          title: '✈️ Reclamación Enviada',
          body: 'Su reclamación $claimId ha sido enviada con éxito.',
        );
      case 'reviewing':
        return NotificationContent(
          title: '🔍 En Revisión',
          body: 'Su reclamación $claimId está siendo revisada por la aerolínea.',
        );
      case 'requiresaction':
      case 'requires_action':
        return NotificationContent(
          title: '⚠️ Acción Requerida',
          body: 'Su reclamación $claimId necesita información adicional. Por favor, revise la aplicación.',
        );
      case 'approved':
        return NotificationContent(
          title: '🎉 ¡Reclamación Aprobada!',
          body: '¡Buenas noticias! Su reclamación $claimId ha sido aprobada para compensación.',
        );
      case 'paid':
        return NotificationContent(
          title: '💰 Pago Recibido',
          body: '¡Su compensación por la reclamación $claimId ha sido pagada!',
        );
      case 'rejected':
        return NotificationContent(
          title: '❌ Reclamación Rechazada',
          body: 'Su reclamación $claimId fue rechazada. Toque para ver opciones de apelación.',
        );
      case 'processing':
        return NotificationContent(
          title: '⏳ Procesando',
          body: 'Su reclamación $claimId está siendo procesada para el pago.',
        );
      case 'appealing':
        return NotificationContent(
          title: '⚖️ En Apelación',
          body: 'Su apelación para la reclamación $claimId está siendo procesada.',
        );
      default:
        return NotificationContent(
          title: '📬 Actualización de Reclamación',
          body: 'Su reclamación $claimId ha sido actualizada. Toque para ver detalles.',
        );
    }
  }
  
  /// Portuguese notifications
  static NotificationContent _getPortugueseStatusNotification(String status, String claimId) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return NotificationContent(
          title: '✈️ Reclamação Enviada',
          body: 'Sua reclamação $claimId foi enviada com sucesso.',
        );
      case 'reviewing':
        return NotificationContent(
          title: '🔍 Em Revisão',
          body: 'Sua reclamação $claimId está sendo revisada pela companhia aérea.',
        );
      case 'requiresaction':
      case 'requires_action':
        return NotificationContent(
          title: '⚠️ Ação Necessária',
          body: 'Sua reclamação $claimId precisa de informações adicionais. Por favor, verifique o aplicativo.',
        );
      case 'approved':
        return NotificationContent(
          title: '🎉 Reclamação Aprovada!',
          body: 'Ótimas notícias! Sua reclamação $claimId foi aprovada para compensação.',
        );
      case 'paid':
        return NotificationContent(
          title: '💰 Pagamento Recebido',
          body: 'Sua compensação pela reclamação $claimId foi paga!',
        );
      case 'rejected':
        return NotificationContent(
          title: '❌ Reclamação Rejeitada',
          body: 'Sua reclamação $claimId foi rejeitada. Toque para ver opções de recurso.',
        );
      case 'processing':
        return NotificationContent(
          title: '⏳ Processando',
          body: 'Sua reclamação $claimId está sendo processada para pagamento.',
        );
      case 'appealing':
        return NotificationContent(
          title: '⚖️ Em Recurso',
          body: 'Seu recurso para a reclamação $claimId está sendo processado.',
        );
      default:
        return NotificationContent(
          title: '📬 Atualização da Reclamação',
          body: 'Sua reclamação $claimId foi atualizada. Toque para ver detalhes.',
        );
    }
  }
  
  /// Detect user's preferred language
  /// Returns 'en', 'es', or 'pt'
  static String detectUserLanguage(BuildContext? context) {
    if (context == null) {
      // Fallback to system locale
      return _getSystemLocale();
    }
    
    final locale = Localizations.localeOf(context);
    
    // Map language codes to supported languages
    switch (locale.languageCode) {
      case 'es':
        return 'es'; // Spanish
      case 'pt':
        return 'pt'; // Portuguese
      default:
        return 'en'; // English (default)
    }
  }
  
  /// Get system locale (fallback)
  static String _getSystemLocale() {
    try {
      final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
      switch (platformLocale.languageCode) {
        case 'es':
          return 'es';
        case 'pt':
          return 'pt';
        default:
          return 'en';
      }
    } catch (e) {
      return 'en'; // Ultimate fallback
    }
  }
  
  /// Get welcome notification
  static NotificationContent getWelcomeNotification(String locale) {
    switch (locale) {
      case 'es':
        return NotificationContent(
          title: '👋 ¡Bienvenido!',
          body: 'Gracias por usar nuestra aplicación de compensación de vuelos.',
        );
      case 'pt':
        return NotificationContent(
          title: '👋 Bem-vindo!',
          body: 'Obrigado por usar nosso aplicativo de compensação de voo.',
        );
      default:
        return NotificationContent(
          title: '👋 Welcome!',
          body: 'Thank you for using our flight compensation app.',
        );
    }
  }
  
  /// Get reminder notification
  static NotificationContent getReminderNotification({
    required String locale,
    required String claimId,
  }) {
    switch (locale) {
      case 'es':
        return NotificationContent(
          title: '🔔 Recordatorio',
          body: 'No olvide enviar los correos de la aerolínea para su reclamación $claimId.',
        );
      case 'pt':
        return NotificationContent(
          title: '🔔 Lembrete',
          body: 'Não se esqueça de encaminhar os e-mails da companhia aérea para sua reclamação $claimId.',
        );
      default:
        return NotificationContent(
          title: '🔔 Reminder',
          body: 'Don\'t forget to forward airline emails for your claim $claimId.',
        );
    }
  }
}

/// Notification content model
class NotificationContent {
  final String title;
  final String body;
  
  NotificationContent({
    required this.title,
    required this.body,
  });
  
  Map<String, String> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }
}
