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
              const SizedBox(height: 8),
              Text('Last Updated: October 8, 2025', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
              const SizedBox(height: 16),
              
              Text('1. Service Provider', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Operator: Piotr Styła, Poland'),
              const Text('Email: contact@air24.app'),
              const Text('Website: https://air24.app'),
              const SizedBox(height: 16),
              
              Text('2. Service Description', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('AIR24 provides:'),
              const Text('• Flight compensation eligibility checking tool'),
              const Text('• Claim preparation and submission assistance'),
              const Text('• Automatic email parsing using AI (GPT-4)'),
              const Text('• Claim status tracking and updates'),
              const Text('• Document management for claims'),
              const Text('• Push notifications for claim updates'),
              const SizedBox(height: 12),
              const Text('Important: AIR24 is a tool to assist you. We do not guarantee:'),
              const Text('• Successful claim outcomes'),
              const Text('• Airline response times'),
              const Text('• Compensation amounts'),
              const Text('• Legal representation'),
              const SizedBox(height: 16),
              
              Text('3. Email Forwarding Service', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('You may forward airline emails to claims@unshaken-strategy.eu:'),
              const Text('• Our AI will automatically extract claim status information'),
              const Text('• Your claim will be updated automatically'),
              const Text('• We do not permanently store email content'),
              const Text('• You remain responsible for the accuracy of forwarded emails'),
              const Text('• Do not forward emails containing sensitive financial data'),
              const SizedBox(height: 16),
              
              Text('4. User Obligations', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('You agree to:'),
              const Text('• Provide accurate and truthful information'),
              const Text('• Use the service lawfully and ethically'),
              const Text('• Not misuse or abuse the service'),
              const Text('• Not forward spam or malicious emails'),
              const Text('• Keep your account credentials secure'),
              const Text('• Comply with EU Regulation 261/2004 requirements'),
              const Text('• Update your information when it changes'),
              const SizedBox(height: 16),
              
              Text('5. AI Processing Disclaimer', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Our AI email parsing service:'),
              const Text('• Uses OpenAI GPT-4 for text analysis'),
              const Text('• May not be 100% accurate'),
              const Text('• Should be verified by you'),
              const Text('• Does not constitute legal advice'),
              const Text('• May miss nuanced information'),
              const Text('You remain responsible for reviewing and confirming all extracted information.'),
              const SizedBox(height: 16),
              
              Text('6. No Legal Advice', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('AIR24 does not provide legal advice. The service provides:'),
              const Text('• General information about EU261 regulations'),
              const Text('• Tools to prepare claims'),
              const Text('• Assistance with documentation'),
              const Text('For legal advice, consult a qualified attorney.'),
              const SizedBox(height: 16),
              
              Text('7. Fees and Pricing', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• Basic features are currently free'),
              const Text('• Premium features may be introduced with advance notice'),
              const Text('• No hidden fees or commissions'),
              const Text('• Any compensation you receive goes directly to you'),
              const SizedBox(height: 16),
              
              Text('8. Service Availability', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• We aim for 99.9% uptime but cannot guarantee uninterrupted service'),
              const Text('• Maintenance may require temporary downtime'),
              const Text('• Third-party services (Firebase, OpenAI) may affect availability'),
              const Text('• We are not liable for service interruptions'),
              const SizedBox(height: 16),
              
              Text('9. Intellectual Property', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• AIR24 app, website, and content are owned by Piotr Styła'),
              const Text('• You may not copy, modify, or distribute our content'),
              const Text('• Your claim data remains your property'),
              const Text('• You grant us license to process your data to provide the service'),
              const SizedBox(height: 16),
              
              Text('10. Limitation of Liability', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('To the extent permitted by law:'),
              const Text('• We are not liable for indirect, consequential, or special damages'),
              const Text('• We are not liable for lost profits or data'),
              const Text('• Maximum liability is limited to fees paid (if any)'),
              const Text('• Nothing excludes liability that cannot be excluded by law'),
              const Text('• We are not liable for airline decisions or actions'),
              const Text('• We are not liable for AI parsing errors'),
              const SizedBox(height: 16),
              
              Text('11. Termination', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• You may delete your account at any time'),
              const Text('• We may suspend accounts for violation of these terms'),
              const Text('• We may terminate the service with 30 days notice'),
              const Text('• Your data will be handled per our Privacy Policy'),
              const SizedBox(height: 16),
              
              Text('12. Changes to Terms', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• We may update these terms with notice'),
              const Text('• Continued use constitutes acceptance'),
              const Text('• Material changes will be highlighted'),
              const SizedBox(height: 16),
              
              Text('13. Governing Law', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• These terms are governed by the laws of Poland'),
              const Text('• Disputes will be resolved in Polish courts'),
              const Text('• EU consumers retain protection under EU consumer law'),
              const SizedBox(height: 16),
              
              Text('14. Contact', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Questions or concerns: contact@air24.app'),
              const SizedBox(height: 24),
              
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/privacy'),
                child: const Text('See also: Privacy Policy'),
              ),
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
