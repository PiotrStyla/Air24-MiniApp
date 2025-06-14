import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../core/accessibility/accessibility_service.dart';
import '../core/accessibility/accessible_widgets.dart';
import '../utils/translation_helper.dart';
import '../services/manual_localization_service.dart';

/// Screen for configuring accessibility settings
class AccessibilitySettingsScreen extends StatelessWidget {
  /// Route name for navigation
  static const routeName = '/accessibility-settings';

  /// Create a new accessibility settings screen
  const AccessibilitySettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Force reload Polish translations if needed
    final manualLocalizationService = GetIt.I<ManualLocalizationService>();
    if (manualLocalizationService.currentLocale?.languageCode == 'pl') {
      manualLocalizationService.forceReload(manualLocalizationService.currentLocale!);
    }
    return Consumer<AccessibilityService>(
      builder: (context, accessibilityService, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(TranslationHelper.getString(context, 'accessibilitySettings', fallback: 'Accessibility Settings')),
            // Add semantics to back button
            leading: Semantics(
              label: TranslationHelper.getString(context, 'backToPreviousScreen', fallback: 'Back to previous screen'),
              button: true,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          body: FocusTraversalGroup(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction text
                  Semantics(
                    header: true,
                    child: Text(
                      TranslationHelper.getString(context, 'accessibilityOptions', fallback: 'Accessibility Options'),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    TranslationHelper.getString(context, 'configureAccessibilitySettings', fallback: 'Configure settings to improve the accessibility of the app.'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  
                  // High Contrast Mode
                  AccessibleCard(
                    title: TranslationHelper.getString(context, 'displaySettings', fallback: 'Display Settings'),
                    semanticLabel: TranslationHelper.getString(context, 'displayAndVisualSettingsSection', fallback: 'Display and visual settings section'),
                    child: Column(
                      children: [
                        AccessibleToggle(
                          label: TranslationHelper.getString(context, 'highContrastMode', fallback: 'High Contrast Mode'),
                          semanticLabel: TranslationHelper.getString(context, 'enableHighContrastMode', fallback: 'Enable high contrast mode for better visibility'),
                          value: accessibilityService.highContrastMode,
                          onChanged: (_) => accessibilityService.toggleHighContrastMode(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          TranslationHelper.getString(context, 'highContrastDescription', fallback: 'High contrast mode increases the color contrast to improve readability for users with low vision.'),
                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        
                        AccessibleToggle(
                          label: TranslationHelper.getString(context, 'largeText', fallback: 'Large Text'),
                          semanticLabel: TranslationHelper.getString(context, 'enableLargeText', fallback: 'Enable large text for better readability'),
                          value: accessibilityService.largeTextMode,
                          onChanged: (_) => accessibilityService.toggleLargeTextMode(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          TranslationHelper.getString(context, 'largeTextDescription', fallback: 'Large text mode increases the font size throughout the app for better readability.'),
                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Screen Reader Settings
                  AccessibleCard(
                    title: TranslationHelper.getString(context, 'screenReaderSettings', fallback: 'Screen Reader Settings'),
                    semanticLabel: TranslationHelper.getString(context, 'screenReaderEnhancementSettings', fallback: 'Screen reader enhancement settings'),
                    child: Column(
                      children: [
                        AccessibleToggle(
                          label: TranslationHelper.getString(context, 'enhancedScreenReaderDescriptions', fallback: 'Enhanced Screen Reader Descriptions'),
                          semanticLabel: TranslationHelper.getString(context, 'enableMoreDetailedDescriptions', fallback: 'Enable more detailed descriptions for screen readers'),
                          value: accessibilityService.screenReaderEmphasis,
                          onChanged: (_) => accessibilityService.toggleScreenReaderEmphasis(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          TranslationHelper.getString(context, 'providesMoreDetailedDescriptions', fallback: 'Provides more detailed descriptions for screen readers to better explain interface elements.'),
                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Keyboard Navigation Guide
                  AccessibleCard(
                    title: TranslationHelper.getString(context, 'keyboardNavigation', fallback: 'Keyboard Navigation'),
                    semanticLabel: TranslationHelper.getString(context, 'keyboardNavigationGuide', fallback: 'Keyboard navigation guide'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(TranslationHelper.getString(context, 'useTheFollowingKeyboardShortcuts', fallback: 'Use the following keyboard shortcuts:')),
                        const SizedBox(height: 12),
                        _buildKeyboardShortcutRow(context, 'Tab', TranslationHelper.getString(context, 'moveToNextItem', fallback: 'Move to next item')),
                        _buildKeyboardShortcutRow(context, 'Shift+Tab', TranslationHelper.getString(context, 'moveToPreviousItem', fallback: 'Move to previous item')),
                        _buildKeyboardShortcutRow(context, 'Space/Enter', TranslationHelper.getString(context, 'activateFocusedItem', fallback: 'Activate focused item')),
                        _buildKeyboardShortcutRow(context, 'Arrow Keys', TranslationHelper.getString(context, 'navigateWithinComponents', fallback: 'Navigate within components')),
                        _buildKeyboardShortcutRow(context, 'Esc', TranslationHelper.getString(context, 'closeDialogsOrMenus', fallback: 'Close dialogs or menus')),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Test Area
                  AccessibleCard(
                    title: TranslationHelper.getString(context, 'testYourSettings', fallback: 'Test Your Settings'),
                    semanticLabel: TranslationHelper.getString(context, 'areaToTestSettings', fallback: 'Area to test your accessibility settings'),
                    child: Column(
                      children: [
                        Text(
                          TranslationHelper.getString(context, 'useThisAreaToTest', fallback: 'Use this area to test how your settings affect the appearance and behavior of the app.'),
                        ),
                        const SizedBox(height: 16),
                        
                        // Sample input field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: TranslationHelper.getString(context, 'sampleInputField', fallback: 'Sample Input Field'),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Sample buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AccessibleButton(
                              label: TranslationHelper.getString(context, 'primaryButton', fallback: 'Primary Button'),
                              semanticLabel: TranslationHelper.getString(context, 'samplePrimaryButton', fallback: 'Sample primary button for testing'),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(TranslationHelper.getString(context, 'primaryButtonPressed', fallback: 'Primary button pressed')),
                                  ),
                                );
                              },
                              filled: true,
                            ),
                            AccessibleButton(
                              label: TranslationHelper.getString(context, 'secondaryButton', fallback: 'Secondary Button'),
                              semanticLabel: TranslationHelper.getString(context, 'sampleSecondaryButton', fallback: 'Sample secondary button for testing'),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(TranslationHelper.getString(context, 'secondaryButtonPressed', fallback: 'Secondary button pressed')),
                                  ),
                                );
                              },
                              filled: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Apply Settings Button
                  Center(
                    child: AccessibleButton(
                      label: TranslationHelper.getString(context, 'saveSettings', fallback: 'Save Settings'),
                      semanticLabel: TranslationHelper.getString(context, 'saveAccessibilitySettings', fallback: 'Save accessibility settings and return to previous screen'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Settings saved'),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      icon: Icons.save,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  /// Build a row displaying a keyboard shortcut and its description
  Widget _buildKeyboardShortcutRow(BuildContext context, String key, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Text(
              key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(description),
          ),
        ],
      ),
    );
  }
}
