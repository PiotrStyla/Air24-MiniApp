import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service that manages language preferences and localization settings.
class LocalizationService extends ChangeNotifier {
  /// Storage key for the selected language code
  static const String LANGUAGE_CODE = 'languageCode';
  
  /// Storage key for the selected country code
  static const String COUNTRY_CODE = 'countryCode';
  
  // All supported languages
  static final List<Locale> supportedLocales = [
    const Locale('en', 'US'), // English
    const Locale('es', 'ES'), // Spanish
    const Locale('fr', 'FR'), // French
    const Locale('de', 'DE'), // German
    const Locale('pt', 'BR'), // Portuguese
    const Locale('pl', 'PL'), // Polish
  ];
  
  /// Language names for the UI
  static final Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'pt': 'Português',
    'pl': 'Polski',
  };
  
  /// Current locale
  Locale _currentLocale = const Locale('en', 'US');
  
  /// Get the current locale
  Locale get currentLocale => _currentLocale;
  
  /// Private constructor
  LocalizationService._();
  
  /// Factory constructor to create a new instance
  static Future<LocalizationService> create() async {
    final instance = LocalizationService._();
    await instance._init();
    return instance;
  }
  
  /// Initialize the service by loading stored preferences
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLangCode = prefs.getString(LANGUAGE_CODE);
    final storedCountryCode = prefs.getString(COUNTRY_CODE);
    
    if (storedLangCode != null) {
      for (var locale in supportedLocales) {
        if (locale.languageCode == storedLangCode && 
            (storedCountryCode == null || locale.countryCode == storedCountryCode)) {
          _currentLocale = locale;
          break;
        }
      }
    } else {
      // Try to match device locale
      final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
      
      // Check if the platform locale is supported
      for (var locale in supportedLocales) {
        if (locale.languageCode == platformLocale.languageCode) {
          _currentLocale = locale;
          break;
        }
      }
    }
  }
  
  /// Change the current language
  Future<void> changeLanguage(Locale locale) async {
    if (!isSupported(locale)) return;
    
    // Only proceed if the locale is actually different
    if (_currentLocale.languageCode == locale.languageCode &&
        _currentLocale.countryCode == locale.countryCode) {
      return;
    }
    
    _currentLocale = locale;
    
    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_CODE, locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString(COUNTRY_CODE, locale.countryCode!);
    } else {
      await prefs.remove(COUNTRY_CODE);
    }
    
    // Notify listeners that the locale has changed
    // This will trigger a rebuild of any widgets listening to this service
    notifyListeners();
    
    // Log the language change for debugging
    print('Language changed to: ${locale.languageCode}_${locale.countryCode}');
  }
  
  /// Check if a locale is supported
  bool isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
  
  /// Get the display name for a language code
  String getDisplayLanguage(String code) {
    return languageNames[code] ?? code;
  }
}
