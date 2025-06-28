import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';
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
                  AppLocalizations.of(context)!.profileInformation, 
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
                          AppLocalizations.of(context)!.profileInfoCardTitle,
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
                      AppLocalizations.of(context)!.accountSettings,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Profile Information Card
                  AccessibleCard(
                    title: AppLocalizations.of(context)!.profileInformation,
                    semanticLabel: AppLocalizations.of(context)!.editPersonalInfo,
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
                                                    child: Text(AppLocalizations.of(context)!.editPersonalInfoDescription),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Accessibility Settings Card
                  AccessibleCard(
                    title: AppLocalizations.of(context)!.accessibilitySettings,
                    semanticLabel: AppLocalizations.of(context)!.configureAccessibility,
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
                              Text(AppLocalizations.of(context)!.accessibilityOptions),
                              const SizedBox(height: 4),
                              Text(
                                                                  AppLocalizations.of(context)!.configureAccessibilityDescription,
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
                    title: AppLocalizations.of(context)!.notificationSettings,
                    semanticLabel: AppLocalizations.of(context)!.configureNotifications,
                    onTap: () {
                      // Show a toast message that this will be implemented in a future update
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text(AppLocalizations.of(context)!.notificationSettingsComingSoon),
                        duration: const Duration(seconds: 2),
                      ));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active),
                        const SizedBox(width: 16),
                        Expanded(
                                                    child: Text(AppLocalizations.of(context)!.configureNotificationsDescription),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Language Settings Card
                  AccessibleCard(
                    title: localizations.languageSelection,
                                        semanticLabel: AppLocalizations.of(context)!.changeApplicationLanguage,
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
                          child: Text(AppLocalizations.of(context)!.selectLanguage),
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
                  AppLocalizations.of(context)!.tipsAndReminders, 
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
                          AppLocalizations.of(context)!.tipsAndReminders,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Each tip is separated semantically for better screen reader experience
                      ...[  
                        AppLocalizations.of(context)!.tipProfileUpToDate,
                        AppLocalizations.of(context)!.tipInformationPrivate,
                        AppLocalizations.of(context)!.tipContactDetails,
                        AppLocalizations.of(context)!.tipAccessibilitySettings
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
