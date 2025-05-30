import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'faq_screen.dart';
import 'profile_edit_screen.dart';
import 'accessibility_settings_screen.dart';
import '../core/accessibility/accessibility_service.dart';
import '../core/accessibility/accessible_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get accessibility service
    final accessibilityService = Provider.of<AccessibilityService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: accessibilityService.semanticLabel(
            'Profile', 
            'Your Profile and Settings'
          ),
          child: const Text('Profile'),
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
      body: Column(
        children: [
          // Info banner with enhanced accessibility
          Semantics(
            label: accessibilityService.semanticLabel(
              'Information banner', 
              'Information about your profile data usage'
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
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
                      'Your profile contains your personal and contact information. This is used to process your flight compensation claims and keep you updated.',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Main profile options section with accessibility support
          Expanded(
            child: FocusTraversalGroup(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Profile settings section
                  Semantics(
                    header: true,
                    child: Text(
                      'Account Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Edit Profile Button
                  AccessibleCard(
                    title: 'Profile Information',
                    semanticLabel: 'Edit your personal information',
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
                        const Expanded(
                          child: Text('Edit your personal and contact information'),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Accessibility Settings Button - NEW
                  AccessibleCard(
                    title: 'Accessibility Settings',
                    semanticLabel: 'Configure accessibility options for the app',
                    hasFocus: true, // Highlight as an important option
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccessibilitySettingsScreen(),
                        ),
                      );
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
                              const Text('Accessibility Options'),
                              const SizedBox(height: 4),
                              Text(
                                'Configure high contrast, large text, and screen reader support',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Application preferences section
                  Semantics(
                    header: true,
                    child: Text(
                      'Application Preferences',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Notification Settings Card
                  AccessibleCard(
                    title: 'Notification Settings',
                    semanticLabel: 'Configure notification preferences',
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text('Configure how you receive claim updates'),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Tips & Reminders section with enhanced accessibility
          Semantics(
            label: accessibilityService.semanticLabel(
              'Tips and Reminders', 
              'Important tips about your profile information'
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
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
                    child: const Text(
                      'Tips & Reminders',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Each tip is separated semantically for better screen reader experience
                  ...[  
                    'Keep your profile up to date for smooth claim processing.',
                    'Your information is private and only used for compensation claims.',
                    'Make sure your contact details are correct so we can reach you about your claim.',
                    'Check the Accessibility Settings to customize the app for your needs.'
                  ].map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Text(tip)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
