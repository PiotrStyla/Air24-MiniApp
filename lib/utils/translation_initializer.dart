import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '../services/manual_localization_service.dart';
import '../services/localization_service.dart';

/// Helper class to ensure translations are properly loaded throughout the app
class TranslationInitializer {
  // Singleton instance
  static final TranslationInitializer _instance = TranslationInitializer._internal();
  factory TranslationInitializer() => _instance;
  TranslationInitializer._internal();
  
  // Cache of loaded translations to avoid reloading
  static final Map<String, Map<String, dynamic>> _loadedTranslations = {};

  /// Initialize translations for the app
  /// Ensures all languages are properly loaded and synchronized
  static Future<void> ensureAllTranslations() async {
    try {
      debugPrint('TranslationInitializer: Ensuring all translations are loaded');
      final manualLocalizationService = GetIt.instance<ManualLocalizationService>();
      final localizationService = GetIt.instance<LocalizationService>();
      
      // Force preload all supported languages
      for (final locale in LocalizationService.supportedLocales) {
        await _loadTranslationFile(locale.languageCode);
        manualLocalizationService.ensureLanguageLoaded(locale.languageCode);
      }
      
      // Then ensure the current locale is fully loaded and active
      final currentLocale = localizationService.currentLocale;
      
      debugPrint('All translations initialized for ${LocalizationService.supportedLocales.length} languages');
      debugPrint('Current locale set to: ${currentLocale.languageCode}');
    } catch (e) {
      debugPrint('Error initializing translations: $e');
    }
  }
  
  /// Load translation file for the specified language
  static Future<Map<String, dynamic>> _loadTranslationFile(String languageCode) async {
    try {
      if (_loadedTranslations.containsKey(languageCode)) {
        return _loadedTranslations[languageCode]!;
      }
      
      final String path = 'lib/l10n2/app_$languageCode.arb';
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> translations = json.decode(jsonString) as Map<String, dynamic>;
      
      // Cache the translations
      _loadedTranslations[languageCode] = translations;
      
      debugPrint('Loaded ${translations.length} translations for $languageCode');
      return translations;
    } catch (e) {
      debugPrint('Error loading translation file for $languageCode: $e');
      return {};
    }
  }
  
  /// Clear any cached translations and reload them fresh from source files
  /// This is useful when translations are not appearing correctly
  static Future<void> clearTranslationCaches() async {
    debugPrint('TranslationInitializer: Clearing translation caches');
    
    // Clear internal caches
    _loadedTranslations.clear();
    
    try {
      // Get services
      final manualLocalizationService = GetIt.instance<ManualLocalizationService>();
      final localizationService = GetIt.instance<LocalizationService>();
      
      // Force reload for current locale
      final currentLocale = localizationService.currentLocale;
      await manualLocalizationService.reloadLanguage(currentLocale.languageCode);
      
      // Reload all translations fresh
      for (final locale in LocalizationService.supportedLocales) {
        await _loadTranslationFile(locale.languageCode);
      }
      
      // Force UI rebuild
      ManualLocalizationService.forceAppRebuild();
      
      debugPrint('TranslationInitializer: Translation caches cleared and reloaded');
    } catch (e) {
      debugPrint('Error clearing translation caches: $e');
    }
  }
  
  /// For backward compatibility - calls ensureAllTranslations()
  static Future<void> ensurePolishTranslations() async {
    debugPrint('Warning: ensurePolishTranslations is deprecated. Use ensureAllTranslations instead.');
    await ensureAllTranslations();
  }
}
