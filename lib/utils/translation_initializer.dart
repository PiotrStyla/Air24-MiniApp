import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/manual_localization_service.dart';
import '../services/localization_service.dart';

/// Helper class to ensure translations are properly loaded throughout the app
class TranslationInitializer {
  // Singleton instance
  static final TranslationInitializer _instance = TranslationInitializer._internal();
  factory TranslationInitializer() => _instance;
  TranslationInitializer._internal();

  /// Initialize translations for the app
  /// Ensures all languages are properly loaded and synchronized
  static void ensureAllTranslations() {
    try {
      final manualLocalizationService = GetIt.instance<ManualLocalizationService>();
      final localizationService = GetIt.instance<LocalizationService>();
      
      // Force preload all supported languages
      for (final locale in LocalizationService.supportedLocales) {
        manualLocalizationService.ensureLanguageLoaded(locale.languageCode);
      }
      
      // Then ensure the current locale is fully loaded and active
      final currentLocale = localizationService.currentLocale;
      manualLocalizationService.forceReload(currentLocale);
      
      debugPrint('All translations initialized for ${LocalizationService.supportedLocales.length} languages');
      debugPrint('Current locale set to: ${currentLocale.languageCode}');
    } catch (e) {
      debugPrint('Error initializing translations: $e');
    }
  }
  
  /// For backward compatibility - calls ensureAllTranslations()
  static void ensurePolishTranslations() {
    debugPrint('Warning: ensurePolishTranslations is deprecated. Use ensureAllTranslations instead.');
    ensureAllTranslations();
  }
}
