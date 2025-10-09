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
              const SizedBox(height: 8),
              Text('Last Updated: October 9, 2025', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
              const SizedBox(height: 16),
              
              Text('1. Controller & Contact', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Data Controller: Piotr Styła, Poland'),
              const Text('Email: contact@air24.app'),
              const Text('Website: https://air24.app'),
              const SizedBox(height: 16),
              
              Text('2. Data We Collect', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• Account Information: Name, email address, profile photo (via World ID or Google Sign-In)'),
              const Text('• World ID Data: Nullifier hash for unique user identification (privacy-preserving, no personal data)'),
              const Text('• Flight Information: Flight numbers, dates, airlines, delays/cancellations'),
              const Text('• Claim Data: Compensation claims, status updates, supporting documents'),
              const Text('• Email Data: Emails forwarded to claims@unshaken-strategy.eu for automatic processing'),
              const Text('• Device Information: Device type, operating system, app version'),
              const Text('• Usage Data: Features used, timestamps, interactions (only with consent)'),
              const SizedBox(height: 16),
              
              Text('3. How We Use Your Data', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• Provide flight compensation eligibility checking'),
              const Text('• Process and manage compensation claims'),
              const Text('• Automatically parse airline emails using AI to update claim status'),
              const Text('• Send push notifications about claim updates'),
              const Text('• Authenticate and secure your account'),
              const Text('• Improve service quality and features (with consent)'),
              const Text('• Comply with legal obligations'),
              const SizedBox(height: 16),
              
              Text('4. AI Email Processing', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('When you forward airline emails to claims@unshaken-strategy.eu:'),
              const Text('• Emails are received via SendGrid'),
              const Text('• Content is analyzed using OpenAI GPT-4 to extract claim status'),
              const Text('• Extracted data updates your claim automatically'),
              const Text('• Original emails are not permanently stored'),
              const Text('• Processing occurs on secure servers in the US (Firebase, OpenAI)'),
              const SizedBox(height: 16),
              
              Text('5. Legal Basis (GDPR)', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• Performance of Contract (Art. 6(1)(b)): Account and claim processing'),
              const Text('• Legitimate Interests (Art. 6(1)(f)): Service improvement, security'),
              const Text('• Consent (Art. 6(1)(a)): Analytics, marketing cookies'),
              const Text('• Legal Obligation (Art. 6(1)(c)): Compliance with regulations'),
              const SizedBox(height: 16),
              
              Text('6. Third-Party Services', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• Worldcoin: World ID verification (privacy-preserving identity verification)'),
              const Text('• Google/Firebase: Authentication, database, cloud functions'),
              const Text('• SendGrid: Email receiving and forwarding'),
              const Text('• OpenAI: AI-powered email parsing (GPT-4)'),
              const Text('• Vercel: Web hosting'),
              const Text('• LH.pl: Server hosting'),
              const Text('• Analytics providers (only with consent)'),
              const SizedBox(height: 16),
              
              Text('7. International Data Transfers', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Your data may be transferred to:'),
              const Text('• United States (Firebase, OpenAI, SendGrid)'),
              const Text('• European Union (hosting servers)'),
              const Text('We rely on Standard Contractual Clauses (SCCs) and adequacy decisions to ensure protection equivalent to GDPR.'),
              const SizedBox(height: 16),
              
              Text('8. Data Retention', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• Active claims: Duration of claim process'),
              const Text('• Closed claims: 6 years (legal requirement)'),
              const Text('• Email content: Not stored permanently (processed and deleted)'),
              const Text('• Account data: Until account deletion requested'),
              const Text('• Analytics data: Up to 26 months (with consent)'),
              const SizedBox(height: 16),
              
              Text('9. Your Rights', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• Access: Request copy of your data'),
              const Text('• Rectification: Correct inaccurate data'),
              const Text('• Erasure: Request data deletion ("right to be forgotten")'),
              const Text('• Restriction: Limit processing'),
              const Text('• Portability: Receive data in machine-readable format'),
              const Text('• Object: Object to processing based on legitimate interests'),
              const Text('• Withdraw Consent: Anytime for consent-based processing'),
              const Text('• Complain: File complaint with Polish supervisory authority (UODO)'),
              const SizedBox(height: 12),
              const Text('To exercise your rights: contact@air24.app'),
              const SizedBox(height: 16),
              
              Text('10. Data Security', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• End-to-end encryption for data transmission'),
              const Text('• Secure cloud infrastructure (Firebase)'),
              const Text('• Access controls and authentication'),
              const Text('• Regular security audits'),
              const Text('• AI processing on secure, compliant platforms'),
              const SizedBox(height: 16),
              
              Text('11. Children\'s Privacy', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Our service is not intended for children under 16. We do not knowingly collect data from children.'),
              const SizedBox(height: 16),
              
              Text('12. Changes to Policy', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('We may update this policy. Significant changes will be notified via email or app notification.'),
              const SizedBox(height: 16),
              
              Text('13. Regional Addenda', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• UK: UK GDPR alignment, ICO complaint rights'),
              const Text('• California (US): CCPA/CPRA rights including "Do Not Sell"'),
              const Text('• Canada: PIPEDA/Quebec Law 25 compliance'),
              const Text('• Brazil: LGPD compliance, ANPD complaint rights'),
              const Text('Contact us for region-specific details.'),
              const SizedBox(height: 24),
              
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/cookies'),
                child: const Text('See also: Cookie Policy'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/terms'),
                child: const Text('See also: Terms of Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
