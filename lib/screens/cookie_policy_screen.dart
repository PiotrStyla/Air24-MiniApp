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
              const SizedBox(height: 8),
              Text('Last Updated: October 8, 2025', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
              const SizedBox(height: 16),
              
              Text('What Are Cookies?', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Cookies are small text files stored on your device when you visit our website or use our app. They help us provide a better experience and understand how our service is used.'),
              const SizedBox(height: 16),
              
              Text('Cookie Categories', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              
              Text('1. Strictly Necessary Cookies (Always Active)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('Essential for core functionality. You cannot opt out of these.'),
              const SizedBox(height: 6),
              const Text('• Authentication: Keep you logged in'),
              const Text('• Security: Protect against fraud and attacks'),
              const Text('• Session management: Remember your preferences during visit'),
              const Text('• API access: Enable communication with our servers'),
              const SizedBox(height: 12),
              
              Text('2. Analytics Cookies (Optional)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('Help us understand how users interact with our service.'),
              const SizedBox(height: 6),
              const Text('• Usage patterns: Which features are used most'),
              const Text('• Performance: How fast pages load'),
              const Text('• Errors: Where technical issues occur'),
              const Text('• Demographics: General user statistics (anonymized)'),
              const SizedBox(height: 6),
              const Text('Third parties: Google Analytics, Firebase Analytics'),
              const SizedBox(height: 12),
              
              Text('3. Marketing Cookies (Optional)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('Enable personalized content and advertising.'),
              const SizedBox(height: 6),
              const Text('• Personalization: Customize content for you'),
              const Text('• Advertising: Show relevant ads'),
              const Text('• Social media: Enable sharing features'),
              const Text('• Remarketing: Show ads after you leave our site'),
              const SizedBox(height: 6),
              const Text('Third parties: Google Ads, Facebook Pixel (when enabled)'),
              const SizedBox(height: 16),
              
              Text('Local Storage & Similar Technologies', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('We also use:'),
              const Text('• Local Storage: Store preferences and session data'),
              const Text('• IndexedDB: Cache flight data for offline access'),
              const Text('• Service Workers: Enable offline functionality'),
              const Text('These follow the same consent rules as cookies.'),
              const SizedBox(height: 16),
              
              Text('Cookie Duration', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('• Session cookies: Deleted when you close the app/browser'),
              const Text('• Persistent cookies: Remain for specified duration'),
              const Text('• Authentication: Up to 90 days'),
              const Text('• Analytics: Up to 26 months'),
              const Text('• Marketing: Up to 13 months'),
              const SizedBox(height: 16),
              
              Text('Your Choices', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('You can control cookies by:'),
              const Text('• Using our cookie preferences banner'),
              const Text('• Adjusting browser settings'),
              const Text('• Using browser "Do Not Track" feature'),
              const Text('• Deleting cookies from your device'),
              const SizedBox(height: 12),
              const Text('Note: Blocking necessary cookies may prevent some features from working.'),
              const SizedBox(height: 16),
              
              Text('Third-Party Cookies', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Some cookies are set by third parties:'),
              const Text('• Google/Firebase: Authentication, analytics'),
              const Text('• SendGrid: Email delivery'),
              const Text('• Vercel: Web hosting'),
              const Text('These services have their own privacy policies.'),
              const SizedBox(height: 16),
              
              Text('Contact', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Questions about cookies: contact@air24.app'),
              const SizedBox(height: 24),
              
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/privacy'),
                child: const Text('See also: Privacy Policy'),
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
