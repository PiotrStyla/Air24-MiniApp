import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:f35_flight_compensation/services/manual_localization_service.dart';
import 'package:f35_flight_compensation/services/localization_service.dart';

class MockManualLocalizationService extends ChangeNotifier implements ManualLocalizationService {
  Locale _currentLocale = const Locale('en', 'US');
  bool _isReady = true;
  Map<String, String> _mockStrings = {
    'appTitle': 'Mock App Title',
    'profile_screen_title': 'Profile',
    'accessibility_settings_title': 'Accessibility Settings',
    'home': 'Home',
    'claims': 'Claims',
    'settings': 'Settings',
    'newClaim': 'New Claim',
    'checkCompensationEligibility': 'Check Compensation Eligibility',
    'euWideEligibleFlights': 'EU Wide Eligible Flights',
    'signInToTrackClaims': 'Sign in to track your claims and manage your profile.',
    'createAccountDescription': 'Create an account to easily submit and track claims.',
    'signInOrSignUp': 'Sign In / Sign Up',
    'welcomeUser': 'Welcome, {userName}!',
    'signOut': 'Sign Out',
    'profileInformation': 'Profile Information',
    'profileDescription': 'View and edit your personal details.',
    'accountSettings': 'Account Settings',
    'editPersonalInfo': 'Edit Personal Information',
    'accessibilitySettings': 'Accessibility',
    'configureAccessibility': 'Configure accessibility options.',
    'accessibilityOptions': 'Accessibility Options',
    'notificationSettings': 'Notification Settings',
    'configureNotifications': 'Manage your notification preferences.',
    'selectLanguage': 'Select Language',
    'tipsAndReminders': 'Tips & Reminders',
    'tipProfileUpToDate': 'Keep your profile up to date for faster claim processing.',
    'tipInformationPrivate': 'Your personal information is kept private and secure.',
    'tipContactDetails': 'Ensure your contact details are current to receive updates.',
    'tipAccessibilitySettings': 'Customize accessibility settings for a better experience.',
    'backToPreviousScreen': 'Back',
    'configureAccessibilitySettings': 'Configure Accessibility Settings',
    'displaySettings': 'Display Settings',
    'displayAndVisualSettingsSection': 'Display & Visual Settings',
    'highContrastMode': 'High Contrast Mode',
    'enableHighContrastMode': 'Enable High Contrast Mode',
    'highContrastDescription': 'Increases contrast for better readability.',
    'largeText': 'Large Text',
    'enableLargeText': 'Enable Large Text',
    'largeTextDescription': 'Increases font size for all text.',
    'screenReaderSettings': 'Screen Reader Settings',
    'screenReaderEnhancementSettings': 'Screen Reader Enhancement Settings',
    'enhancedScreenReaderDescriptions': 'Enhanced Screen Reader Descriptions',
    'enableMoreDetailedDescriptions': 'Enable more detailed descriptions for screen readers.',
    'providesMoreDetailedDescriptions': 'Provides more context for UI elements.',
    'keyboardNavigation': 'Keyboard Navigation',
    'keyboardNavigationGuide': 'Keyboard Navigation Guide',
    'useTheFollowingKeyboardShortcuts': 'Use the following keyboard shortcuts:',
    'moveToNextItem': 'Tab: Move to next item',
    'moveToPreviousItem': 'Shift + Tab: Move to previous item',
    'activateFocusedItem': 'Enter/Space: Activate focused item',
    'navigateWithinComponents': 'Arrow Keys: Navigate within components',
    'closeDialogsOrMenus': 'Esc: Close dialogs or menus',
    'testYourSettings': 'Test Your Settings',
    'areaToTestSettings': 'Area to Test Settings',
    'useThisAreaToTest': 'Use this area to test your new accessibility settings.',
    'sampleInputField': 'Sample Input Field',
    'primaryButton': 'Primary Button',
    'samplePrimaryButton': 'Sample Primary Button',
    'secondaryButton': 'Secondary Button',
    'sampleSecondaryButton': 'Sample Secondary Button',
    'saveSettings': 'Save Settings',
    'saveAccessibilitySettings': 'Save Accessibility Settings'
    // Add other keys your test might need
  };

  @override
  Locale get currentLocale => _currentLocale;

  @override
  bool get isReady => _isReady;

  @override
  Future<void> init() async {
    _isReady = true;
    await ensureLanguageLoaded(_currentLocale.languageCode);
  }

  @override
  String getString(String key, {String fallback = ''}) {
    String? value = _mockStrings[key];
    print('[MockManualLocalizationService] getString called for key: $key, returning: $value');
    return value ?? (fallback.isNotEmpty ? fallback : 'Mock for $key');
  }

  @override
  Future<void> setLocale(Locale locale) async {
    print('[MockManualLocalizationService] setLocale called with $locale');
    _currentLocale = locale;
    await ensureLanguageLoaded(locale.languageCode);
    notifyListeners();
    ManualLocalizationService.forceAppRebuild();
  }

  // ensureAllTranslationsLoaded() removed: not part of ManualLocalizationService interface

  @override
  Future<void> ensureLanguageLoaded(String languageCode) async {
    print('[MockManualLocalizationService] ensureLanguageLoaded called for $languageCode');
    // No-op for mock
    return Future.value();
  }

  @override
  Future<void> reloadLanguage(String languageCode) async {
    print('[MockManualLocalizationService] reloadLanguage called for $languageCode');
    _isReady = false;
    // Simulate a tiny delay to mimic reload behavior in tests
    await Future<void>.delayed(const Duration(milliseconds: 1));
    _isReady = true;
    if (languageCode == _currentLocale.languageCode) {
      notifyListeners();
      ManualLocalizationService.forceAppRebuild();
    }
  }

  @override
  void addStringDirectly(String languageCode, String key, String value) {
    print('[MockManualLocalizationService] addStringDirectly: ($languageCode) $key = $value');
    // In this simplified mock we only maintain one map; update when targeting current or EN locale
    if (languageCode == _currentLocale.languageCode || languageCode == 'en') {
      _mockStrings[key] = value;
      notifyListeners();
    }
  }

  // changeLocale() removed: use setLocale(Locale) instead.
  // forceReload() removed: use reloadLanguage(String languageCode) instead.

  // getCurrentLocale() removed: use currentLocale getter instead.

  @override
  String getDisplayLanguage(String languageCode) {
    print('[MockManualLocalizationService] getDisplayLanguage for $languageCode');
    return LocalizationService.languageNames[languageCode] ?? languageCode;
  }

  @override
  String getLocalizedString(String key, [Map<String, String>? replacements, String? fallback]) {
    print('[MockManualLocalizationService] getLocalizedString for key: $key');
    String? value = _mockStrings[key];
    if (value == null && _currentLocale.languageCode != 'en') {
      // Simple fallback to a generic mock string if not found and not English
      // In a real mock, you might have separate mock string maps per language
      value = 'Mock EN for $key'; 
    }
    value ??= fallback ?? 'Fallback Mock for $key';

    if (replacements != null) {
      replacements.forEach((placeholder, replacementValue) {
        value = value!.replaceAll('{$placeholder}', replacementValue);
      });
    }
    return value!;
  }

  // Helper for tests to load custom translations (not part of the real interface)
  void loadTranslationsForTests(Map<String, String> translations) {
    _mockStrings.addAll(translations);
    notifyListeners();
  }
}
