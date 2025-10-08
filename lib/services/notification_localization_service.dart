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
      case 'fr': // French
        return _getFrenchStatusNotification(status, claimId);
      case 'de': // German
        return _getGermanStatusNotification(status, claimId);
      case 'pl': // Polish
        return _getPolishStatusNotification(status, claimId);
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
  
  /// French notifications
  static NotificationContent _getFrenchStatusNotification(String status, String claimId) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return NotificationContent(
          title: '✈️ Réclamation Envoyée',
          body: 'Votre réclamation $claimId a été envoyée avec succès.',
        );
      case 'reviewing':
        return NotificationContent(
          title: '🔍 En Cours d\'Examen',
          body: 'Votre réclamation $claimId est en cours d\'examen par la compagnie aérienne.',
        );
      case 'requiresaction':
      case 'requires_action':
        return NotificationContent(
          title: '⚠️ Action Requise',
          body: 'Votre réclamation $claimId nécessite des informations supplémentaires. Veuillez consulter l\'application.',
        );
      case 'approved':
        return NotificationContent(
          title: '🎉 Réclamation Approuvée!',
          body: 'Bonne nouvelle! Votre réclamation $claimId a été approuvée pour indemnisation.',
        );
      case 'paid':
        return NotificationContent(
          title: '💰 Paiement Reçu',
          body: 'Votre indemnisation pour la réclamation $claimId a été payée!',
        );
      case 'rejected':
        return NotificationContent(
          title: '❌ Réclamation Rejetée',
          body: 'Votre réclamation $claimId a été rejetée. Appuyez pour voir les options de recours.',
        );
      case 'processing':
        return NotificationContent(
          title: '⏳ En Traitement',
          body: 'Votre réclamation $claimId est en cours de traitement pour le paiement.',
        );
      case 'appealing':
        return NotificationContent(
          title: '⚖️ En Appel',
          body: 'Votre recours pour la réclamation $claimId est en cours de traitement.',
        );
      default:
        return NotificationContent(
          title: '📬 Mise à Jour de la Réclamation',
          body: 'Votre réclamation $claimId a été mise à jour. Appuyez pour voir les détails.',
        );
    }
  }
  
  /// German notifications
  static NotificationContent _getGermanStatusNotification(String status, String claimId) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return NotificationContent(
          title: '✈️ Anspruch Eingereicht',
          body: 'Ihr Anspruch $claimId wurde erfolgreich eingereicht.',
        );
      case 'reviewing':
        return NotificationContent(
          title: '🔍 In Prüfung',
          body: 'Ihr Anspruch $claimId wird von der Fluggesellschaft geprüft.',
        );
      case 'requiresaction':
      case 'requires_action':
        return NotificationContent(
          title: '⚠️ Aktion Erforderlich',
          body: 'Ihr Anspruch $claimId benötigt zusätzliche Informationen. Bitte überprüfen Sie die App.',
        );
      case 'approved':
        return NotificationContent(
          title: '🎉 Anspruch Genehmigt!',
          body: 'Gute Nachrichten! Ihr Anspruch $claimId wurde zur Entschädigung genehmigt.',
        );
      case 'paid':
        return NotificationContent(
          title: '💰 Zahlung Erhalten',
          body: 'Ihre Entschädigung für Anspruch $claimId wurde ausgezahlt!',
        );
      case 'rejected':
        return NotificationContent(
          title: '❌ Anspruch Abgelehnt',
          body: 'Ihr Anspruch $claimId wurde abgelehnt. Tippen Sie, um Einspruchsoptionen zu sehen.',
        );
      case 'processing':
        return NotificationContent(
          title: '⏳ In Bearbeitung',
          body: 'Ihr Anspruch $claimId wird zur Zahlung bearbeitet.',
        );
      case 'appealing':
        return NotificationContent(
          title: '⚖️ Im Einspruch',
          body: 'Ihr Einspruch für Anspruch $claimId wird bearbeitet.',
        );
      default:
        return NotificationContent(
          title: '📬 Anspruch Aktualisiert',
          body: 'Ihr Anspruch $claimId wurde aktualisiert. Tippen Sie für Details.',
        );
    }
  }
  
  /// Polish notifications
  static NotificationContent _getPolishStatusNotification(String status, String claimId) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return NotificationContent(
          title: '✈️ Roszczenie Wysłane',
          body: 'Twoje roszczenie $claimId zostało pomyślnie wysłane.',
        );
      case 'reviewing':
        return NotificationContent(
          title: '🔍 W Trakcie Weryfikacji',
          body: 'Twoje roszczenie $claimId jest weryfikowane przez linię lotniczą.',
        );
      case 'requiresaction':
      case 'requires_action':
        return NotificationContent(
          title: '⚠️ Wymagana Akcja',
          body: 'Twoje roszczenie $claimId wymaga dodatkowych informacji. Sprawdź aplikację.',
        );
      case 'approved':
        return NotificationContent(
          title: '🎉 Roszczenie Zatwierdzone!',
          body: 'Świetne wiadomości! Twoje roszczenie $claimId zostało zatwierdzone do wypłaty odszkodowania.',
        );
      case 'paid':
        return NotificationContent(
          title: '💰 Płatność Otrzymana',
          body: 'Twoje odszkodowanie za roszczenie $claimId zostało wypłacone!',
        );
      case 'rejected':
        return NotificationContent(
          title: '❌ Roszczenie Odrzucone',
          body: 'Twoje roszczenie $claimId zostało odrzucone. Kliknij, aby zobaczyć opcje odwołania.',
        );
      case 'processing':
        return NotificationContent(
          title: '⏳ W Trakcie Przetwarzania',
          body: 'Twoje roszczenie $claimId jest przetwarzane do wypłaty.',
        );
      case 'appealing':
        return NotificationContent(
          title: '⚖️ W Odwołaniu',
          body: 'Twoje odwołanie dotyczące roszczenia $claimId jest przetwarzane.',
        );
      default:
        return NotificationContent(
          title: '📬 Aktualizacja Roszczenia',
          body: 'Twoje roszczenie $claimId zostało zaktualizowane. Kliknij, aby zobaczyć szczegóły.',
        );
    }
  }
  
  /// Detect user's preferred language
  /// Returns 'en', 'es', 'pt', 'fr', 'de', or 'pl'
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
      case 'fr':
        return 'fr'; // French
      case 'de':
        return 'de'; // German
      case 'pl':
        return 'pl'; // Polish
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
        case 'fr':
          return 'fr';
        case 'de':
          return 'de';
        case 'pl':
          return 'pl';
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
      case 'fr':
        return NotificationContent(
          title: '👋 Bienvenue!',
          body: 'Merci d\'utiliser notre application d\'indemnisation de vol.',
        );
      case 'de':
        return NotificationContent(
          title: '👋 Willkommen!',
          body: 'Vielen Dank, dass Sie unsere Flugentschädigungs-App verwenden.',
        );
      case 'pl':
        return NotificationContent(
          title: '👋 Witaj!',
          body: 'Dziękujemy za korzystanie z naszej aplikacji do odszkodowań lotniczych.',
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
      case 'fr':
        return NotificationContent(
          title: '🔔 Rappel',
          body: 'N\'oubliez pas de transférer les e-mails de la compagnie aérienne pour votre réclamation $claimId.',
        );
      case 'de':
        return NotificationContent(
          title: '🔔 Erinnerung',
          body: 'Vergessen Sie nicht, die E-Mails der Fluggesellschaft für Ihren Anspruch $claimId weiterzuleiten.',
        );
      case 'pl':
        return NotificationContent(
          title: '🔔 Przypomnienie',
          body: 'Nie zapomnij przekazać e-maili od linii lotniczej dla swojego roszczenia $claimId.',
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
