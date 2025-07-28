import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart';
import 'package:get_it/get_it.dart';

import '../services/localization_service.dart';
import '../utils/translation_initializer.dart';
import 'localization_debug_screen.dart';

/// A screen that allows users to select their preferred language.
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late LocalizationService _localizationService;
  bool _developerModeEnabled = false;
  int _devModeClickCount = 0;
  
  @override
  void initState() {
    super.initState();
    _localizationService = GetIt.instance<LocalizationService>();
    _checkDeveloperMode();
  }
  
  Future<void> _checkDeveloperMode() async {
    // In a real app, this would check a secure storage or preferences
    setState(() {
      _developerModeEnabled = false; // Default to false in production
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final currentLocale = _localizationService.currentLocale;
    final localizations = context.l10n;
    
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            // Secret tap to enable developer mode
            setState(() {
              _devModeClickCount++;
              if (_devModeClickCount >= 5) {
                _developerModeEnabled = true;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Developer Mode Enabled')),
                );
              }
            });
          },
          child: Text(localizations.languageSelection),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: localizations.back,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: LocalizationService.supportedLocales.length,
              itemBuilder: (context, index) {
                final locale = LocalizationService.supportedLocales[index];
                final isSelected = locale.languageCode == currentLocale.languageCode;
                final countryFlag = _getCountryFlag(locale.languageCode);
                
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected 
                          ? Theme.of(context).primaryColor.withOpacity(0.2) 
                          : Colors.grey.withOpacity(0.2),
                        child: Text(
                          countryFlag,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      title: Text(
                        _localizationService.getDisplayLanguage(locale.languageCode),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected 
                        ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                        : null,
                      onTap: () async {
                        // First update the main localization service
                        await _localizationService.setLocale(locale);
                        
                        // Ensure all translations are loaded for the new language
                        TranslationInitializer.ensureAllTranslations();
                        
                        // Additional step for all languages to ensure UI is updated
                        if (mounted) {
                          setState(() {});
                          
                          // Show feedback to the user that language has changed
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Language changed to ${_localizationService.getDisplayLanguage(locale.languageCode)}'))
                          );
                        }
                      },
                    ),
                    const Divider(height: 1),
                  ],
                );
              },
            ),
          ),
          
          // Developer Mode Section
          if (_developerModeEnabled) ...[  // Using spread operator for conditional widgets
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Developer Tools',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.code, color: Colors.white),
              ),
              title: const Text('Localization Debug'),
              subtitle: const Text('View and test all translations'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LocalizationDebugScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
  
  /// Returns a country flag emoji based on language code
  String _getCountryFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸'; // US flag
      case 'pt':
        return '🇧🇷'; // Brazil flag
      case 'pl':
        return '🇵🇱'; // Poland flag
      default:
        return languageCode.toUpperCase();
    }
  }
}
