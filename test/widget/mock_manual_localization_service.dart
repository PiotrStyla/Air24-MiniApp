import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:f35_flight_compensation/services/manual_localization_service.dart';

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
  String getString(String key, {String fallback = ''}) {
    String? value = _mockStrings[key];
    print('[MockManualLocalizationService] getString called for key: $key, returning: $value');
    return value ?? (fallback.isNotEmpty ? fallback : 'Mock for $key');
  }

  @override
  Future<void> changeLanguage(Locale newLocale) async {
    print('[MockManualLocalizationService] changeLanguage called with $newLocale');
    _currentLocale = newLocale;
    // Potentially load different mock strings or just notify
    notifyListeners();
    ManualLocalizationService.forceAppRebuild(); // Call static method if necessary for test behavior
  }

  @override
  Future<void> ensureAllTranslationsLoaded() async {
    print('[MockManualLocalizationService] ensureAllTranslationsLoaded called');
    // No-op for mock
    _isReady = true;
    return Future.value();
  }

  @override
  Future<void> ensureLanguageLoaded(String languageCode) async {
    print('[MockManualLocalizationService] ensureLanguageLoaded called for $languageCode');
    // No-op for mock
    return Future.value();
  }

  // Mocking static members isn't straightforward in Dart for instance methods.
  // Tests needing these should interact with the real static members if absolutely necessary
  // or the design should be reconsidered for better testability of static interactions.
  // For the purpose of this mock, we are focusing on the instance methods.

  // Other methods from ManualLocalizationService can be added here with mock implementations if needed by tests.
  // For example:
  // @override
  // Map<String, String> get languageNames => ManualLocalizationService.languageNames;

  // @override
  // List<Locale> get supportedLocales => ManualLocalizationService.supportedLocales;

  // Not mocking static rebuildNotifier or forceAppRebuild directly as they are static.
  // The call to ManualLocalizationService.forceAppRebuild() in changeLanguage is an example
  // of how the mock might interact with static parts if needed, though it calls the real static method.

  @override
  Future<void> changeLocale(Locale locale) async {
    print('[MockManualLocalizationService] changeLocale (new) called with $locale');
    _currentLocale = locale;
    notifyListeners();
    ManualLocalizationService.forceAppRebuild();
  }

  @override
  Future<void> forceReload(Locale locale) async {
    print('[MockManualLocalizationService] forceReload called with $locale');
    // Simulate reloading strings for the locale or just notify
    _currentLocale = locale; // Ensure current locale is updated
    _isReady = false;
    // In a real scenario, you might reload mock strings here if they depend on locale
    _isReady = true;
    notifyListeners();
    ManualLocalizationService.forceAppRebuild();
  }

  @override
  Locale getCurrentLocale() {
    print('[MockManualLocalizationService] getCurrentLocale called, returning: $_currentLocale');
    return _currentLocale;
  }

  @override
  String getDisplayLanguage(String languageCode) {
    print('[MockManualLocalizationService] getDisplayLanguage for $languageCode');
    return ManualLocalizationService.languageNames[languageCode] ?? languageCode;
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

   @override
  Map<String, Map<String, dynamic>> get allStrings => {'en': _mockStrings.map((key, value) => MapEntry(key, value as dynamic))};

  @override
  ValueNotifier<int> get rebuildNotifier => ManualLocalizationService.rebuildNotifier; // Delegate to actual static member

  @override
  void loadTranslationsForTests(Map<String, String> translations) {
    // This method doesn't exist in the original class, but can be useful for tests
    // to set up specific strings. Or, adjust _mockStrings directly in tests.
    _mockStrings.addAll(translations);
    notifyListeners();
  }
}
