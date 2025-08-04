import 'package:flutter/foundation.dart';

/// Service for managing email template localization based on airline carriers
/// Supports all 5 official EU languages + English fallback for non-EU carriers
class EmailLocalizationService {
  
  /// Map of airline codes to their primary country/language
  /// EU carriers get localized emails, non-EU carriers get English
  static const Map<String, String> _airlineToLanguage = {
    // German carriers
    'LH': 'de', // Lufthansa
    'DE': 'de', // Condor
    'EW': 'de', // Eurowings
    'AB': 'de', // Air Berlin (historical)
    'TU': 'de', // Tuifly
    
    // French carriers
    'AF': 'fr', // Air France
    'TO': 'fr', // Transavia France
    'XK': 'fr', // French Bee
    'BF': 'fr', // French Blue
    
    // Spanish carriers
    'IB': 'es', // Iberia
    'VY': 'es', // Vueling
    'UX': 'es', // Air Europa
    'YW': 'es', // Air Nostrum
    
    // Polish carriers
    'LO': 'pl', // LOT Polish Airlines
    'SP': 'pl', // Small Planet Airlines Poland
    'WZ': 'pl', // Wizz Air (Polish operations)
    
    // Other major EU carriers (using English as they operate internationally)
    'KL': 'en', // KLM (Netherlands)
    'AZ': 'en', // Alitalia (Italy)
    'SK': 'en', // SAS (Scandinavia)
    'TP': 'en', // TAP Air Portugal
    'OS': 'en', // Austrian Airlines
    'SN': 'en', // Brussels Airlines
    'A3': 'en', // Aegean Airlines (Greece)
    'EI': 'en', // Aer Lingus (Ireland)
    'FR': 'en', // Ryanair (Ireland)
    'U2': 'en', // easyJet (UK/EU)
    
    // Non-EU carriers (always English)
    'AA': 'en', // American Airlines
    'UA': 'en', // United Airlines
    'DL': 'en', // Delta Air Lines
    'BA': 'en', // British Airways
    'VS': 'en', // Virgin Atlantic
    'TK': 'en', // Turkish Airlines
    'EK': 'en', // Emirates
    'QR': 'en', // Qatar Airways
    'SV': 'en', // Saudi Arabian Airlines
    'MS': 'en', // EgyptAir
    'ET': 'en', // Ethiopian Airlines
    'KE': 'en', // Korean Air
    'NH': 'en', // ANA
    'JL': 'en', // JAL
    'SQ': 'en', // Singapore Airlines
    'TG': 'en', // Thai Airways
    'CX': 'en', // Cathay Pacific
    'AI': 'en', // Air India
    'AC': 'en', // Air Canada
    'WF': 'en', // Widerøe (Norway - not EU anymore)
  };

  /// Get the appropriate language for an airline
  /// Returns the language code or 'en' as fallback
  static String getLanguageForAirline(String airlineCode) {
    final language = _airlineToLanguage[airlineCode.toUpperCase()];
    debugPrint('📧 EmailLocalization: Airline $airlineCode -> Language ${language ?? 'en (fallback)'}');
    return language ?? 'en'; // Default to English for unknown carriers
  }

  /// Check if an airline is an EU carrier (gets localized email)
  static bool isEUCarrier(String airlineCode) {
    final language = _airlineToLanguage[airlineCode.toUpperCase()];
    final isEU = language != null && language != 'en';
    debugPrint('📧 EmailLocalization: Airline $airlineCode is ${isEU ? 'EU' : 'non-EU'} carrier');
    return isEU;
  }

  /// Get all supported languages
  static List<String> getSupportedLanguages() {
    return ['en', 'de', 'es', 'fr', 'pl'];
  }

  /// Get language name for display
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch (German)';
      case 'es':
        return 'Español (Spanish)';
      case 'fr':
        return 'Français (French)';
      case 'pl':
        return 'Polski (Polish)';
      default:
        return 'Unknown';
    }
  }

  /// Get EU regulation reference in appropriate language
  static String getEURegulationReference(String languageCode) {
    switch (languageCode) {
      case 'de':
        return 'EU-Verordnung 261/2004';
      case 'es':
        return 'Reglamento UE 261/2004';
      case 'fr':
        return 'Règlement UE 261/2004';
      case 'pl':
        return 'Rozporządzenie UE 261/2004';
      default:
        return 'EU Regulation 261/2004';
    }
  }

  /// Get compensation claim phrase in appropriate language
  static String getCompensationClaimPhrase(String languageCode) {
    switch (languageCode) {
      case 'de':
        return 'Entschädigungsanspruch nach EU-Verordnung 261/2004';
      case 'es':
        return 'Reclamación de compensación según el Reglamento UE 261/2004';
      case 'fr':
        return 'Demande d\'indemnisation selon le Règlement UE 261/2004';
      case 'pl':
        return 'Roszczenie o odszkodowanie zgodnie z Rozporządzeniem UE 261/2004';
      default:
        return 'Compensation Claim under EU Regulation 261/2004';
    }
  }

  /// Add or update airline language mapping
  /// Useful for adding new carriers or updating existing ones
  static void updateAirlineLanguageMapping(String airlineCode, String languageCode) {
    // This would update a persistent store in a real implementation
    debugPrint('📧 EmailLocalization: Updated $airlineCode -> $languageCode');
    // For now, just log the update
  }

  /// Get statistics about language distribution
  static Map<String, int> getLanguageStatistics() {
    final stats = <String, int>{};
    for (final language in _airlineToLanguage.values) {
      stats[language] = (stats[language] ?? 0) + 1;
    }
    return stats;
  }

  /// Validate if a language code is supported
  static bool isLanguageSupported(String languageCode) {
    return getSupportedLanguages().contains(languageCode);
  }

  /// Get debug information about airline mapping
  static Map<String, dynamic> getDebugInfo() {
    final euCarriers = <String>[];
    final nonEuCarriers = <String>[];
    
    for (final entry in _airlineToLanguage.entries) {
      if (entry.value == 'en') {
        nonEuCarriers.add(entry.key);
      } else {
        euCarriers.add('${entry.key} (${entry.value})');
      }
    }

    return {
      'totalCarriers': _airlineToLanguage.length,
      'euCarriers': euCarriers,
      'nonEuCarriers': nonEuCarriers,
      'languageStats': getLanguageStatistics(),
      'supportedLanguages': getSupportedLanguages(),
    };
  }
}
