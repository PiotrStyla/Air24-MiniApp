import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/accessibility/accessibility_service.dart';
import '../core/accessibility/accessible_widgets.dart';

/// Screen for configuring accessibility settings
class AccessibilitySettingsScreen extends StatelessWidget {
  /// Route name for navigation
  static const routeName = '/accessibility-settings';

  /// Create a new accessibility settings screen
  const AccessibilitySettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityService>(
      builder: (context, accessibilityService, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Accessibility Settings'),
            // Add semantics to back button
            leading: Semantics(
              label: 'Back to previous screen',
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
                      'Accessibility Options',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Configure settings to improve the accessibility of the app.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  
                  // High Contrast Mode
                  AccessibleCard(
                    title: 'Display Settings',
                    semanticLabel: 'Display and visual settings section',
                    child: Column(
                      children: [
                        AccessibleToggle(
                          label: 'High Contrast Mode',
                          semanticLabel: 'Enable high contrast mode for better visibility',
                          value: accessibilityService.highContrastMode,
                          onChanged: (_) => accessibilityService.toggleHighContrastMode(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'High contrast mode increases the color contrast to improve readability for users with low vision.',
                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        
                        AccessibleToggle(
                          label: 'Large Text',
                          semanticLabel: 'Enable large text for better readability',
                          value: accessibilityService.largeTextMode,
                          onChanged: (_) => accessibilityService.toggleLargeTextMode(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Large text mode increases the font size throughout the app for better readability.',
                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Screen Reader Settings
                  AccessibleCard(
                    title: 'Screen Reader Settings',
                    semanticLabel: 'Screen reader enhancement settings',
                    child: Column(
                      children: [
                        AccessibleToggle(
                          label: 'Enhanced Screen Reader Descriptions',
                          semanticLabel: 'Enable more detailed descriptions for screen readers',
                          value: accessibilityService.screenReaderEmphasis,
                          onChanged: (_) => accessibilityService.toggleScreenReaderEmphasis(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Provides more detailed descriptions for screen readers to better explain interface elements.',
                          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Keyboard Navigation Guide
                  AccessibleCard(
                    title: 'Keyboard Navigation',
                    semanticLabel: 'Keyboard navigation guide',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Use the following keyboard shortcuts:'),
                        const SizedBox(height: 12),
                        _buildKeyboardShortcutRow(context, 'Tab', 'Move to next item'),
                        _buildKeyboardShortcutRow(context, 'Shift+Tab', 'Move to previous item'),
                        _buildKeyboardShortcutRow(context, 'Space/Enter', 'Activate focused item'),
                        _buildKeyboardShortcutRow(context, 'Arrow Keys', 'Navigate within components'),
                        _buildKeyboardShortcutRow(context, 'Esc', 'Close dialogs or menus'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Test Area
                  AccessibleCard(
                    title: 'Test Your Settings',
                    semanticLabel: 'Area to test your accessibility settings',
                    child: Column(
                      children: [
                        const Text(
                          'Use this area to test how your settings affect the appearance and behavior of the app.',
                        ),
                        const SizedBox(height: 16),
                        
                        // Sample input field
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Sample Input Field',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Sample buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AccessibleButton(
                              label: 'Primary Button',
                              semanticLabel: 'Sample primary button for testing',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Primary button pressed'),
                                  ),
                                );
                              },
                              filled: true,
                            ),
                            AccessibleButton(
                              label: 'Secondary Button',
                              semanticLabel: 'Sample secondary button for testing',
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Secondary button pressed'),
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
                      label: 'Save Settings',
                      semanticLabel: 'Save accessibility settings and return to previous screen',
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
