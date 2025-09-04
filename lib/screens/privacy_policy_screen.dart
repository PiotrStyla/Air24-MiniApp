import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('AIR24 Privacy Policy', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text('Controller: Piotr Styla, Poland'),
              const Text('Contact: contact@air24.app'),
              const SizedBox(height: 12),
              const Text('We process data to operate the flight compensation service, including account/claim handling, security, and—if you consent—analytics and marketing.'),
              const SizedBox(height: 12),
              const Text('Legal bases include performance of contract (Art. 6(1)(b) GDPR), legitimate interests (Art. 6(1)(f)), consent (Art. 6(1)(a)) for non-essential cookies, and legal obligations (Art. 6(1)(c)).'),
              const SizedBox(height: 12),
              const Text('Processors/Recipients include hosting (LH.pl), Google/Firebase services (if enabled), email providers, and analytics/marketing platforms (only with consent).'),
              const SizedBox(height: 12),
              const Text('International transfers may occur; where they do, we rely on appropriate safeguards such as Standard Contractual Clauses or adequacy decisions.'),
              const SizedBox(height: 12),
              const Text('Retention: we keep data only as long as necessary for the purposes stated and to comply with legal obligations.'),
              const SizedBox(height: 12),
              const Text('Your rights: access, rectification, erasure, restriction, portability, objection, withdraw consent at any time, and complain to the Polish supervisory authority (UODO).'),
              const SizedBox(height: 12),
              const Text('Contact: contact@air24.app'),
              const SizedBox(height: 24),
              Text('Regional Addenda', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              const Text('UK: UK GDPR alignment. US (California): additional CCPA/CPRA rights. Canada (PIPEDA/Law 25) and Brazil (LGPD): similar rights and transparency. Contact us for details.'),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/cookies'),
                child: const Text('See also: Cookie Policy'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
