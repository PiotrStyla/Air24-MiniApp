import 'package:flutter/material.dart';
import '../core/app_localizations_patch.dart';
import '../screens/donation_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';
import 'faq_screen.dart';
import 'profile_edit_screen.dart';
import 'accessibility_settings_screen.dart';
import 'language_selection_screen.dart';
import '../core/accessibility/accessibility_service.dart';
import '../core/accessibility/accessible_widgets.dart';
import '../services/localization_service.dart';
import '../core/privacy/consent_banner.dart';
import '../services/manual_localization_service.dart';
import '../utils/translation_helper.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/services/world_id_service.dart';
import 'package:f35_flight_compensation/services/world_id_oidc_service.dart';
import 'dart:convert';
import 'package:f35_flight_compensation/services/world_id_interop.dart' as worldid_interop;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Force refresh of translations when screen loads to ensure consistency
    Future.delayed(Duration.zero, () {
      if (mounted) {
        debugPrint('ProfileScreen: Ensuring translations are loaded correctly');
        TranslationHelper.forceReloadTranslations(context);
      }
    });
  }

  Future<void> _startWorldIdFlow() async {
    if (!kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('World ID is only available on web for now.')),
      );
      return;
    }

    // Try opening IDKit
    final available = await worldid_interop.worldIdAvailable();
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('World ID is temporarily unavailable. Please try again later.')),
      );
      return;
    }

    Map<String, dynamic>? result;
    try {
      result = await worldid_interop.openWorldId();
    } catch (e) {
      debugPrint('WorldId open error: $e');
      result = null;
    }

    if (result == null) {
      // User cancelled or error
      return;
    }

    // Extract expected fields defensively
    String? _pick(Map m, String a, [String? b]) {
      if (m.containsKey(a) && m[a] != null) return m[a].toString();
      if (b != null && m.containsKey(b) && m[b] != null) return m[b].toString();
      return null;
    }

    final nullifierHash = _pick(result, 'nullifier_hash', 'nullifierHash');
    final merkleRoot = _pick(result, 'merkle_root', 'merkleRoot');
    var proofVal = result['proof'];
    final verificationLevel = _pick(result, 'verification_level', 'credential_type') ?? 'orb';
    final fallbackAction = await worldid_interop.configuredAction() ?? 'verify';
    final action = _pick(result, 'action') ?? fallbackAction;
    final signalHash = _pick(result, 'signal_hash');

    if (nullifierHash == null || merkleRoot == null || proofVal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incomplete World ID response. Please try again.')),
      );
      return;
    }

    // Ensure proof is a string
    final proof = (proofVal is String) ? proofVal : jsonEncode(proofVal);

    final svc = GetIt.I<WorldIdService>();
    final res = await svc.verify(
      nullifierHash: nullifierHash,
      merkleRoot: merkleRoot,
      proof: proof,
      verificationLevel: verificationLevel,
      action: action,
      signalHash: signalHash,
    );

    if (!mounted) return;
    final msg = res.success
        ? 'World ID verified'
        : (res.isConfiguredError
            ? 'Backend missing WLD_APP_ID. Configure it and redeploy.'
            : 'Verification failed: ${res.errorCode ?? ''} ${res.message ?? ''}'.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _openWorldAppFlow() async {
    // Deep link into World App MiniKit. Fallback opens the mini-app page in browser.
    final miniAppUrl = Uri.parse('https://air24.app/miniapp/?action=flight-compensation-verify');
    final deepLink = Uri.parse('worldapp://link?url=${Uri.encodeComponent(miniAppUrl.toString())}');
    try {
      final canOpen = await canLaunchUrl(deepLink);
      final target = canOpen ? deepLink : miniAppUrl;
      final ok = await launchUrl(
        target,
        mode: LaunchMode.externalApplication,
      );
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open World App. Please try again.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening World App: $e')),
        );
      }
    }
  }

  void _showWorldIdVerifyDialog() {
    assert(kDebugMode, 'World ID debug dialog should only be used in debug mode');
    final nullifierCtrl = TextEditingController();
    final merkleRootCtrl = TextEditingController();
    final proofCtrl = TextEditingController();
    final verificationLevelCtrl = TextEditingController(text: 'orb');
    final actionCtrl = TextEditingController();
    final signalHashCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('World ID Verify (debug)'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nullifierCtrl,
                    decoration: const InputDecoration(labelText: 'nullifier_hash'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: merkleRootCtrl,
                    decoration: const InputDecoration(labelText: 'merkle_root'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: proofCtrl,
                    decoration: const InputDecoration(labelText: 'proof'),
                    maxLines: 3,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: verificationLevelCtrl,
                    decoration: const InputDecoration(labelText: 'verification_level (orb/device/phone)'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: actionCtrl,
                    decoration: const InputDecoration(labelText: 'action (slug)'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: signalHashCtrl,
                    decoration: const InputDecoration(labelText: 'signal_hash (optional)'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                Navigator.of(ctx).pop();
                final svc = GetIt.I<WorldIdService>();
                final res = await svc.verify(
                  nullifierHash: nullifierCtrl.text.trim(),
                  merkleRoot: merkleRootCtrl.text.trim(),
                  proof: proofCtrl.text.trim(),
                  verificationLevel: verificationLevelCtrl.text.trim(),
                  action: actionCtrl.text.trim(),
                  signalHash: signalHashCtrl.text.trim().isEmpty ? null : signalHashCtrl.text.trim(),
                );
                if (!mounted) return;
                final msg = res.success
                    ? 'World ID verified'
                    : (res.isConfiguredError
                        ? 'Backend missing WLD_APP_ID. Configure it and redeploy.'
                        : 'Verification failed: ${res.errorCode ?? ''} ${res.message ?? ''}'.trim());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(msg)),
                );
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get accessibility service and localizations with null safety
    final accessibilityService = Provider.of<AccessibilityService>(context);
    final localizations = AppLocalizations.of(context);
    final manualLocalizations = GetIt.instance<ManualLocalizationService>();
    
    // If localizations are not ready yet, show loading indicator
    if (localizations == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: accessibilityService.semanticLabel(
            localizations.settings, 
            'Your Profile and Settings'
          ),
          child: Text(localizations.settings),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info banner with enhanced accessibility
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Semantics(
                label: accessibilityService.semanticLabel(
                  context.l10n.profileInformation, 
                  context.l10n.profileInfoBannerSemanticLabel
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                          context.l10n.profileInfoCardTitle,
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Account Settings Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Semantics(
                    header: true,
                    child: Text(
                      context.l10n.accountSettings,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Profile Information Card
                  AccessibleCard(
                    title: context.l10n.profileInformation,
                    semanticLabel: context.l10n.editPersonalInfo,
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
                        Expanded(
                          child: Text(context.l10n.editPersonalInfoDescription),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Accessibility Settings Card
                  AccessibleCard(
                    title: context.l10n.accessibilitySettings,
                    semanticLabel: context.l10n.configureAccessibility,
                    hasFocus: true, // Highlight as an important option
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccessibilitySettingsScreen(),
                        ),
                      ).then((_) {
                        // Force rebuild when returning from accessibility settings
                        setState(() {});
                      });
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
                              Text(context.l10n.accessibilityOptions),
                              const SizedBox(height: 4),
                              Text(
                                context.l10n.configureAccessibilityDescription,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Legal & Privacy Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      context.l10n.legalPrivacySectionTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),

                  AccessibleCard(
                    title: context.l10n.privacyPolicy,
                    semanticLabel: context.l10n.privacyPolicy,
                    onTap: () => Navigator.of(context).pushNamed('/privacy'),
                    child: Row(
                      children: [
                        const Icon(Icons.privacy_tip_outlined),
                        const SizedBox(width: 16),
                        Expanded(child: Text(context.l10n.privacyPolicyDesc)),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  AccessibleCard(
                    title: context.l10n.termsOfService,
                    semanticLabel: context.l10n.termsOfService,
                    onTap: () => Navigator.of(context).pushNamed('/terms'),
                    child: Row(
                      children: [
                        const Icon(Icons.rule_folder_outlined),
                        const SizedBox(width: 16),
                        Expanded(child: Text(context.l10n.termsOfServiceDesc)),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  AccessibleCard(
                    title: context.l10n.cookiePolicy,
                    semanticLabel: context.l10n.cookiePolicy,
                    onTap: () => Navigator.of(context).pushNamed('/cookies'),
                    child: Row(
                      children: [
                        const Icon(Icons.cookie_outlined),
                        const SizedBox(width: 16),
                        Expanded(child: Text(context.l10n.cookiePolicyDesc)),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  AccessibleCard(
                    title: context.l10n.legalNoticeImprint,
                    semanticLabel: context.l10n.legalNoticeImprint,
                    onTap: () => Navigator.of(context).pushNamed('/legal'),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(width: 16),
                        Expanded(child: Text(context.l10n.legalNoticeImprintDesc)),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  AccessibleCard(
                    title: context.l10n.accessibilityStatement,
                    semanticLabel: context.l10n.accessibilityStatement,
                    onTap: () => Navigator.of(context).pushNamed('/accessibility'),
                    child: Row(
                      children: [
                        const Icon(Icons.accessibility_new_outlined),
                        const SizedBox(width: 16),
                        Expanded(child: Text(context.l10n.accessibilityStatementDesc)),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  AccessibleCard(
                    title: context.l10n.manageCookiePreferences,
                    semanticLabel: context.l10n.manageCookiePreferences,
                    onTap: () => ConsentManager.openPreferences(context),
                    child: Row(
                      children: [
                        const Icon(Icons.tune_outlined),
                        const SizedBox(width: 16),
                        Expanded(child: Text(context.l10n.manageCookiePreferencesDesc)),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Application Preferences Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section header
                  Semantics(
                    header: true,
                    child: Text(
                      localizations.settings,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Notification Settings Card
                  AccessibleCard(
                    title: context.l10n.notificationSettings,
                    semanticLabel: context.l10n.configureNotifications,
                    onTap: () {
                      // Navigate to push notification test screen
                      Navigator.of(context).pushNamed('/push-notification-test');
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(context.l10n.configureNotificationsDescription),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  if (kIsWeb) ...[
                    AccessibleCard(
                      title: 'Verify with World ID',
                      semanticLabel: 'Verify your humanity with Worldcoin World ID. Web only for now.',
                      onTap: () async {
                        // Always try to open IDKit on web; fallback to debug dialog only if unavailable
                        final available = await worldid_interop.worldIdAvailable();
                        if (available) {
                          await _startWorldIdFlow();
                        } else {
                          if (kDebugMode) {
                            _showWorldIdVerifyDialog();
                          } else {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('World ID is temporarily unavailable. Please try again later.')),
                            );
                          }
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.verified_user, color: Colors.green),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Verify your identity privately using World ID. This helps us prevent abuse while keeping the app free.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (!kIsWeb) ...[
                    AccessibleCard(
                      title: 'Sign in with World App',
                      semanticLabel: 'Sign in with World App (World ID) to verify your account.',
                      onTap: () async {
                        await _openWorldAppFlow();
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.verified_user, color: Colors.green),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Sign in with World App to verify your identity. This helps prevent abuse while keeping the app free.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Icon(Icons.launch, color: Theme.of(context).disabledColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Native OIDC Login with World ID (via flutter_appauth)
                    AccessibleCard(
                      title: 'Sign in with World ID (OIDC)',
                      semanticLabel: 'Sign in with World ID using OIDC (recommended for Play Store).',
                      onTap: () async {
                        final svc = GetIt.I<WorldIdOidcService>();
                        try {
                          final ok = await svc.signIn();
                          if (!mounted) return;
                          final msg = ok ? 'Signed in with World ID' : 'World ID sign-in cancelled';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(msg)),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('OIDC sign-in failed: $e')),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.lock_open, color: Colors.blue),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Sign in with World ID via secure OIDC + PKCE.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (ServiceInitializer.donationsEnabled) ...[
                    // Support Our Mission Card
                    AccessibleCard(
                      title: context.l10n.supportOurMission,
                      semanticLabel: 'Support the app and hospice care with a donation',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DonationScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pink.shade50, Colors.purple.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.pink.shade300, Colors.red.shade400],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.supportOurMission,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.l10n.helpKeepAppFree,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '50% Hospice',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red.shade600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '50% App Dev',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue.shade600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).disabledColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Language Settings Card
                  AccessibleCard(
                    title: localizations.languageSelection,
                    semanticLabel: context.l10n.changeApplicationLanguage,
                    onTap: () async {
                      final targetLocale = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LanguageSelectionScreen(),
                        ),
                      );
                      if (targetLocale is Locale) {
                        final localizationService = GetIt.I<LocalizationService>();
                        await localizationService.setLocale(targetLocale);
                        if (mounted) {
                          setState(() {});
                        }
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.language),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(context.l10n.selectLanguage),
                        ),
                        Icon(Icons.chevron_right, color: Theme.of(context).disabledColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tips & Reminders Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Semantics(
                label: accessibilityService.semanticLabel(
                  context.l10n.tipsAndReminders, 
                  'Important tips about your profile information'
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                        child: Text(
                          context.l10n.tipsAndReminders,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Each tip is separated semantically for better screen reader experience
                      ...[  
                        context.l10n.tipProfileUpToDate,
                        context.l10n.tipInformationPrivate,
                        context.l10n.tipContactDetails,
                        context.l10n.tipAccessibilitySettings
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
            ),
          ],
        ),
      ),
    );
  }
}
