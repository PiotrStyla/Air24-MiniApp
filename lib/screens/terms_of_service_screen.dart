import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('AIR24 Terms of Service', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text('Operator: Piotr Styla, Poland  |  Contact: contact@air24.app'),
              const SizedBox(height: 12),
              const Text('Service: AIR24 provides tools to check potential eligibility for flight compensation and to prepare claim submissions. We do not guarantee outcomes and do not provide legal advice.'),
              const SizedBox(height: 12),
              const Text('User obligations: provide accurate information and use the service lawfully.'),
              const SizedBox(height: 12),
              const Text('Liability: to the extent permitted by law, we are not liable for indirect or consequential losses. Nothing excludes liability where it cannot be excluded by law.'),
              const SizedBox(height: 12),
              const Text('Governing law and jurisdiction: laws of Poland; Polish courts have jurisdiction.'),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/privacy'),
                child: const Text('See also: Privacy Policy'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
