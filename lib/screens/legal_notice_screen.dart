import 'package:flutter/material.dart';

class LegalNoticeScreen extends StatelessWidget {
  const LegalNoticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Legal Notice / Imprint')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('AIR24 Legal Notice', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text('Service operator: Piotr Styla (individual)'),
              const Text('Country: Poland'),
              const Text('Email: contact@air24.app'),
              const SizedBox(height: 12),
              const Text('Hosting provider: LH.pl (hosting for air24.app)'),
              const SizedBox(height: 12),
              const Text('Postal address: [to be added — recommend virtual office/PO Box]'),
              const SizedBox(height: 12),
              const Text('If you believe any content infringes your rights, please contact us at contact@air24.app.'),
            ],
          ),
        ),
      ),
    );
  }
}
