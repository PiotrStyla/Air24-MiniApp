import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:f35_flight_compensation/generated/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'faq_screen.dart';
import 'profile_edit_screen.dart';
import 'accessibility_settings_screen.dart';
import 'language_selection_screen.dart';
import '../core/accessibility/accessibility_service.dart';
import '../core/accessibility/accessible_widgets.dart';
import '../services/localization_service.dart';
import '../services/manual_localization_service.dart';
import '../utils/translation_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Force refresh of translations when screen loads to ensure consistency
    Future.delayed(Duration.zero, () {
      if (mounted) {
        debugPrint('ProfileScreen: Ensuring translations are loaded correctly');
        TranslationHelper.forceReloadTranslations(context);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Get accessibility service and localizations
    final accessibilityService = Provider.of<AccessibilityService>(context);
    final localizations = AppLocalizations.of(context)!;
    final manualLocalizations = GetIt.instance<ManualLocalizationService>();
    
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: accessibilityService.semanticLabel(
            localizations.settings, 
            'Your Profile and Settings'
          ),
          child: Text(localizations.settings),
        ),
        actions: [
          Semantics(
            button: true,
            label: accessibilityService.semanticLabel(
              'Help', 
              'Access Frequently Asked Questions and Help'
            ),
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Colors.blue),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FAQScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info banner with enhanced accessibility
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Semantics(
                label: accessibilityService.semanticLabel(
                  TranslationHelper.getString(context, 'profileInformation', fallback: 'Profile Information'), 
                  'Information about your profile data usage'
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          TranslationHelper.getString(context, 'profileInfoCardTitle', fallback: 'Your profile contains your personal and contact information. This is used to process your flight compensation claims and keep you updated.'),
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Account Settings Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Semantics(
                    header: true,
                    child: Text(
                      TranslationHelper.getString(context, 'accountSettings', fallback: 'Account Settings'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Profile Information Card
                  AccessibleCard(
                    title: TranslationHelper.getString(context, 'profileInformation', fallback: 'Profile Information'),
                    semanticLabel: TranslationHelper.getString(context, 'editPersonalInfo', fallback: 'Edit your personal information'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 16),
                        Expanded(
                                                    child: Text(TranslationHelper.getString(context, 'editPersonalInfoDescription', fallback: 'Edit your personal and contact information')),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Accessibility Settings Card
                  AccessibleCard(
                    title: TranslationHelper.getString(context, 'accessibilitySettings', fallback: 'Accessibility Settings'),
                    semanticLabel: TranslationHelper.getString(context, 'configureAccessibility', fallback: 'Configure accessibility options for the app'),
                    hasFocus: true, // Highlight as an important option
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccessibilitySettingsScreen(),
                        ),
                      ).then((_) {
                        // Force rebuild when returning from accessibility settings
                        setState(() {});
                      });
                    },
                    backgroundColor: Colors.purple.shade50,
                    borderColor: Colors.purple.shade200,
                    child: Row(
                      children: [
                        const Icon(Icons.accessibility_new, color: Colors.purple),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(TranslationHelper.getString(context, 'accessibilityOptions', fallback: 'Accessibility Options')),
                              const SizedBox(height: 4),
                              Text(
                                                                  TranslationHelper.getString(context, 'configureAccessibilityDescription', fallback: 'Configure high contrast, large text, and screen reader support'),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Application Preferences Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Semantics(
                    header: true,
                    child: Text(
                      localizations.settings,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Notification Settings Card
                  AccessibleCard(
                    title: TranslationHelper.getString(context, 'notificationSettings', fallback: 'Notification Settings'),
                    semanticLabel: TranslationHelper.getString(context, 'configureNotifications', fallback: 'Configure notification preferences'),
                    onTap: () {
                      // Show a toast message that this will be implemented in a future update
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text(TranslationHelper.getString(context, 'notificationSettingsComingSoon', fallback: 'Notification Settings coming soon')),
                        duration: const Duration(seconds: 2),
                      ));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active),
                        const SizedBox(width: 16),
                        Expanded(
                                                    child: Text(TranslationHelper.getString(context, 'configureNotificationsDescription', fallback: 'Configure how you receive claim updates')),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Language Settings Card
                  AccessibleCard(
                    title: localizations.languageSelection,
                                        semanticLabel: TranslationHelper.getString(context, 'changeApplicationLanguage', fallback: 'Change application language'),
                    onTap: () async {
                      final targetLocale = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LanguageSelectionScreen(),
                        ),
                      );
                      if (targetLocale is Locale) {
                        final localizationService = GetIt.I<LocalizationService>();
                        await localizationService.setLocale(targetLocale);
                        if (mounted) {
                          setState(() {});
                        }
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.language),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(TranslationHelper.getString(context, 'selectLanguage', fallback: 'Select your preferred language')),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tips & Reminders Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Semantics(
                label: accessibilityService.semanticLabel(
                  TranslationHelper.getString(context, 'tipsAndReminders', fallback: 'Tips and Reminders'), 
                  'Important tips about your profile information'
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          TranslationHelper.getString(context, 'tipsAndReminders', fallback: 'Tips & Reminders'),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Each tip is separated semantically for better screen reader experience
                      ...[  
                        TranslationHelper.getString(context, 'tipProfileUpToDate', fallback: 'Keep your profile up to date for smooth claim processing.'),
                        TranslationHelper.getString(context, 'tipInformationPrivate', fallback: 'Your information is private and only used for compensation claims.'),
                        TranslationHelper.getString(context, 'tipContactDetails', fallback: 'Make sure your contact details are correct so we can reach you about your claim.'),
                        TranslationHelper.getString(context, 'tipAccessibilitySettings', fallback: 'Check the Accessibility Settings to customize the app for your needs.')
                      ].map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(child: Text(tip)),
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
