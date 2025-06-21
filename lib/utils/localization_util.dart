import 'package:flutter/material.dart';
import '../services/manual_localization_service.dart';
import '../core/services/service_initializer.dart';

/// A utility class that provides easy access to localized strings
/// throughout the app, replacing the Flutter's unstable AppLocalizations
class LocalizationUtil {
  /// Always get a fresh instance of ManualLocalizationService to avoid stale data
  static ManualLocalizationService get _localizationService {
    return ServiceInitializer.get<ManualLocalizationService>();
  }
  
  /// Get a localized string with optional placeholder replacements and fallback text
  /// 
  /// @param key The key of the localized string in the ARB files
  /// @param replacements Optional map of placeholder replacements
  /// @param fallback Fallback text if the key is not found
  /// @return The localized string
  static String getText(String key, {Map<String, String>? replacements, String? fallback}) {
    // Print debug information to help diagnose issues
    debugPrint('LocalizationUtil: Getting text for key "$key" with locale ${currentLocale}');
    final result = _localizationService.getLocalizedString(key, replacements, fallback ?? key);
    
    // Check if we're returning the key (indicating translation not found)
    if (result == key && fallback == null) {
      debugPrint('LocalizationUtil: WARNING - No translation found for "$key" in ${currentLocale.languageCode}');
    }
    
    return result;
  }
  
  /// Get the current locale from the localization service
  static Locale get currentLocale => _localizationService.currentLocale;
  
  /// Change the current locale - updated to ensure full reload
  static Future<void> changeLocale(Locale locale) async {
    debugPrint('LocalizationUtil: Changing locale to $locale');
    await _localizationService.setLocale(locale);
    debugPrint('LocalizationUtil: Locale changed to ${_localizationService.currentLocale}');
  }
}
