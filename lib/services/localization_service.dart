import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract class defining the contract for localization services.
abstract class LocalizationService extends ChangeNotifier {
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
  
  /// Get the current locale
  Locale get currentLocale;
  
  /// Get display language name based on language code
  String getDisplayLanguage(String languageCode);

  /// Set the current locale and persist the choice.
  Future<void> setLocale(Locale locale);

  /// Get a localized string for the given key.
  String getString(String key, {String fallback = ''});

  /// Initialize the service.
  Future<void> init();

  /// Check if the service is ready.
  bool get isReady;
}

/// Service that manages language preferences and localization settings.
class DefaultLocalizationService extends LocalizationService {
  /// Current locale
  Locale _currentLocale = const Locale('en', 'US');
  
  /// Get the current locale
  @override
  Locale get currentLocale => _currentLocale;
  
  /// Get display language name based on language code
  @override
  String getDisplayLanguage(String languageCode) {
    return LocalizationService.languageNames[languageCode] ?? languageCode;
  }
  
  /// Private constructor
  DefaultLocalizationService._();
  
  /// Factory constructor to create a new instance
  static Future<DefaultLocalizationService> create() async {
    final instance = DefaultLocalizationService._();
    await instance._init();
    return instance;
  }
  
  /// Initialize the service by loading stored preferences
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLangCode = prefs.getString(LocalizationService.LANGUAGE_CODE);
    final storedCountryCode = prefs.getString(LocalizationService.COUNTRY_CODE);
    
    if (storedLangCode != null) {
      for (var locale in LocalizationService.supportedLocales) {
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
      for (var locale in LocalizationService.supportedLocales) {
        if (locale.languageCode == platformLocale.languageCode) {
          _currentLocale = locale;
          break;
        }
      }
    }
  }
  
  /// Set the current locale and persist the choice.
  @override
  Future<void> setLocale(Locale locale) async {
    if (!isSupported(locale)) return;
    
    // Only proceed if the locale is actually different
    if (_currentLocale.languageCode == locale.languageCode &&
        _currentLocale.countryCode == locale.countryCode) {
      return;
    }
    
    _currentLocale = locale;
    
    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LocalizationService.LANGUAGE_CODE, locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString(LocalizationService.COUNTRY_CODE, locale.countryCode!);
    } else {
      await prefs.remove(LocalizationService.COUNTRY_CODE);
    }
    
    // Notify listeners that the locale has changed
    // This will trigger a rebuild of any widgets listening to this service
    notifyListeners();
    
    // Log the language change for debugging
    print('Language changed to: ${locale.languageCode}_${locale.countryCode}');
  }
  
  /// Get a localized string for the given key.
  @override
  String getString(String key, {String fallback = ''}) {
    // Implementation of localized string retrieval
    // This service integrates with Flutter's built-in localization system
    // For now, we return the fallback as the app uses Flutter's l10n system directly
    // through context.l10n in the UI components
    return fallback.isNotEmpty ? fallback : key;
  }
  
  /// Initialize the service.
  @override
  Future<void> init() async {
    await _init();
  }
  
  /// Check if the service is ready.
  @override
  bool get isReady => true;
  
  /// Check if a locale is supported
  bool isSupported(Locale locale) {
    for (var supportedLocale in LocalizationService.supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
  
  // We already have a getDisplayLanguage method that was added earlier
}
