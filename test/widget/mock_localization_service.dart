import 'package:flutter/material.dart';
import 'package:f35_flight_compensation/services/localization_service.dart'; // To ensure interface compatibility

class MockLocalizationService extends ChangeNotifier implements LocalizationService {
  static final List<Locale> _mockSupportedLocales = [
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
    const Locale('pl', 'PL'),
  ];

  static final Map<String, String> _mockLanguageNames = {
    'en': 'English (Mock)',
    'es': 'Español (Mock)',
    'pl': 'Polski (Mock)',
  };

  Locale _currentLocale = const Locale('en', 'US');

  @override
  Locale get currentLocale => _currentLocale;

  // Static getter to match the real service
  static List<Locale> get supportedLocales => _mockSupportedLocales;
  
  // Static getter to match the real service
  static Map<String, String> get languageNames => _mockLanguageNames;

  @override
  String getDisplayLanguage(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }

  @override
  Future<void> changeLanguage(Locale locale) async {
    if (!isSupported(locale)) return;
    if (_currentLocale.languageCode == locale.languageCode &&
        _currentLocale.countryCode == locale.countryCode) {
      return;
    }
    _currentLocale = locale;
    print('[MockLocalizationService] Language changed to: ${locale.languageCode}_${locale.countryCode}');
    notifyListeners();
  }

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.any((sl) => sl.languageCode == locale.languageCode);
  }

  // Mocked methods that are part of the real service's interface but might not be called in this test flow
  // Or are static/factory methods not directly part of the instance interface for mocking via GetIt.
  // The `implements LocalizationService` will guide us if any instance methods are missing.
  
  // The real service has a private constructor and a static `create` factory.
  // For mocking, we just need a public constructor for GetIt to instantiate.
  MockLocalizationService() {
    print('[MockLocalizationService] Initialized with locale: ${_currentLocale.languageCode}');
  }

  // If LocalizationService had other instance methods, they would be mocked here.
  // For example, if it had _init(), we wouldn't mock it directly as it's private,
  // but ensure the mock behaves as if initialized.
}
