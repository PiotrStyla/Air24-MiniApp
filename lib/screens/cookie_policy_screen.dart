import 'package:flutter/material.dart';

class CookiePolicyScreen extends StatelessWidget {
  const CookiePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cookie Policy')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('AIR24 Cookie Policy', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text('We use strictly necessary cookies to operate this site. With your consent, we also use analytics cookies to understand usage and marketing cookies to personalize content.'),
              const SizedBox(height: 16),
              Text('Categories', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              const Text('• Strictly Necessary: required for core functions (always on).'),
              const Text('• Analytics (optional): helps us improve the service.'),
              const Text('• Marketing (optional): personalized content/ads.'),
              const SizedBox(height: 16),
              const Text('You can change your preferences at any time using the “Manage preferences” link in the cookie banner or footer.'),
            ],
          ),
        ),
      ),
    );
  }
}
