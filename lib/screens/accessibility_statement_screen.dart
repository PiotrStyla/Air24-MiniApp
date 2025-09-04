import 'package:flutter/material.dart';

class AccessibilityStatementScreen extends StatelessWidget {
  const AccessibilityStatementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility Statement')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('AIR24 Accessibility Statement', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text('We aim to conform to WCAG 2.1 AA as far as possible. If you encounter accessibility barriers, please contact us:'),
              const SizedBox(height: 8),
              const Text('Email: contact@air24.app'),
              const SizedBox(height: 12),
              const Text('Measures include: semantic labels for interactive elements, sufficient contrast, scalable text, and keyboard navigation support on web.'),
            ],
          ),
        ),
      ),
    );
  }
}
