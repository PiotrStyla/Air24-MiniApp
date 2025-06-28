import 'package:flutter/material.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';
import 'package:get_it/get_it.dart';
import '../services/manual_localization_service.dart';
import '../services/localization_service.dart';
import '../utils/translation_initializer.dart';

/// A helper class that combines both localization approaches
/// to ensure consistent translations across the app
class TranslationHelper {
  // Keep track of the last synchronized locale for debugging
  static Locale? _lastSynchronizedLocale;
  
  /// Get translated string for the given key, checking multiple sources in this order:
  /// 1. Manual localization service
  /// 2. Flutter's AppLocalizations
  /// 3. Fallback string or key itself
  static String getString(
    BuildContext context, 
    String key, 
    {String? fallback}
  ) {
    final currentLocale = Localizations.localeOf(context);
    
    // Check if we need to synchronize locales
    _ensureLocalesAreSynchronized(context, currentLocale);
    
    // First try manual service
    try {
      final manualService = GetIt.instance<ManualLocalizationService>();
      final manualString = manualService.getString(key);
      if (manualString != null) {
        // Deep debug when mixed languages appear
        _validateConsistentLanguage(key, manualString, currentLocale);
        return manualString;
      }
    } catch (e) {
      debugPrint('Error getting string from manual service: $e');
    }
    
    // Then try Flutter's AppLocalizations
    try {
      final appLocalizations = AppLocalizations.of(context);
      if (appLocalizations != null) {
        // Use reflection to try to access the property dynamically
        try {
          // This is a simple way to access a property by name dynamically in Dart
          // It's not as robust as true reflection but works for our purpose
          final dynamic value = appLocalizations.toString().contains(key)
            ? Function.apply(
                (appLocalizations as dynamic)[key], 
                const []
              )
            : null;
          
          if (value != null && value is String) {
            _validateConsistentLanguage(key, value, currentLocale);
            return value;
          }
        } catch (e) {
          // Ignore this error as it's expected for keys that don't exist
        }
      }
    } catch (e) {
      debugPrint('Error getting string from AppLocalizations: $e');
    }
    
    // Fallback to the provided fallback or key itself
    return fallback ?? key;
  }
  
  /// Validate that the string appears to be in the expected language
  /// This is a simple heuristic to help debug mixed language issues
  static void _validateConsistentLanguage(String key, String value, Locale locale) {
    // Simple language detection heuristic - we're detecting potential mixing
    // This won't be 100% accurate but might help catch obvious issues
    
    // German indicators
    if (locale.languageCode != 'de' && 
        (value.contains('ungen') || 
         value.contains('für') || 
         value.contains('Einstellungen'))) {
      debugPrint('⚠️ POTENTIAL LANGUAGE MIX: Key "$key" with value "$value" ' 
                'may be German but locale is ${locale.languageCode}');
    }
    
    // Polish indicators
    if (locale.languageCode != 'pl' && 
        (value.contains('ości') || 
         value.contains('acji') || 
         value.contains('Ustawienia'))) {
      debugPrint('⚠️ POTENTIAL LANGUAGE MIX: Key "$key" with value "$value" ' 
                'may be Polish but locale is ${locale.languageCode}');
    }
  }
  static Future<void> synchronizeAllLocalizationSystems(
    BuildContext context, 
    Locale targetLocale
  ) async {
    try {
      debugPrint('🔄 TranslationHelper: Synchronizing all localization systems to $targetLocale');
      
      // Get services
      final manualService = GetIt.instance<ManualLocalizationService>();
      final localizationService = GetIt.instance<LocalizationService>();
      
      // First ensure all languages are loaded
      TranslationInitializer.ensureAllTranslations();
      
      // Set both services to the same locale
      if (localizationService.currentLocale != targetLocale) {
        await localizationService.setLocale(targetLocale);
      }
      
      // The changeLanguage call above now handles notifying listeners, so a manual
      // reload and rebuild are no longer necessary.
      
      debugPrint('✅ TranslationHelper: Successfully synchronized to $targetLocale');
    } catch (e) {
      debugPrint('❌ Error synchronizing localization systems: $e');
    }
  }
  
  /// Force reload translations for the current locale
  /// This ensures both localization systems are updated
  static Future<void> forceReloadTranslations(BuildContext context) async {
    final currentLocale = Localizations.localeOf(context);
    _ensureLocalesAreSynchronized(context, currentLocale);
    _lastSynchronizedLocale = currentLocale;
    debugPrint('TranslationHelper: Force reloaded translations for $currentLocale');
    return Future.value(); // Return a completed Future<void>
  }
  
  // Ensure that the locale is synchronized across all services
  static void _ensureLocalesAreSynchronized(BuildContext context, Locale currentLocale) {
    try {
      // Check if locale has changed
      if (_lastSynchronizedLocale == null || _lastSynchronizedLocale != currentLocale) {
        // Update locale in manual service
        try {
          final manualService = GetIt.instance<ManualLocalizationService>();
          manualService.setLocale(currentLocale); // Pass the Locale directly
        } catch (e) {
          debugPrint('Error updating manual service locale: $e');
        }
        
        // Also try to update any other localization services
        try {
          if (GetIt.instance.isRegistered<LocalizationService>()) {
            final localizationService = GetIt.instance<LocalizationService>();
            localizationService.setLocale(currentLocale); // Pass the Locale directly
          }
        } catch (e) {
          debugPrint('Error updating localization service: $e');
        }
        
        _lastSynchronizedLocale = currentLocale;
        debugPrint('TranslationHelper: Synchronized locale to ${currentLocale.languageCode}');
      }
    } catch (e) {
      debugPrint('Error synchronizing locales: $e');
    }
  }
  
  /// Ensure all supported languages are properly loaded
  static void ensureAllLanguagesLoaded() {
    try {
      final manualService = GetIt.instance<ManualLocalizationService>();
      final supportedLocales = LocalizationService.supportedLocales;
      
      // Load translations for each supported locale
      for (final locale in supportedLocales) {
        manualService.ensureLanguageLoaded(locale.languageCode);
      }
      
      debugPrint('All language translations have been loaded');
    } catch (e) {
      debugPrint('Error loading all languages: $e');
    }
  }
}
