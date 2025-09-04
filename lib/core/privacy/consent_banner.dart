import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';
import 'package:f35_flight_compensation/screens/cookie_policy_screen.dart';
import 'package:f35_flight_compensation/services/in_app_messaging_service.dart';

/// Simple web-only consent banner for analytics/marketing cookies.
/// Uses SharedPreferences (works on web) to persist choices.
class ConsentBanner extends StatefulWidget {
  const ConsentBanner({super.key});

  @override
  State<ConsentBanner> createState() => _ConsentBannerState();
}

/// Public helper to open the cookie preferences dialog from anywhere
class ConsentManager {
  static const _keySet = 'consent.set';
  static const _keyAnalytics = 'consent.analytics';
  static const _keyMarketing = 'consent.marketing';

  static Future<void> openPreferences(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool analytics = prefs.getBool(_keyAnalytics) ?? false;
    bool marketing = prefs.getBool(_keyMarketing) ?? false;
    final rootCtx = InAppMessagingService.navigatorKey.currentContext ?? context;
    final l10n = AppLocalizations.of(rootCtx);
    await showDialog(
      context: rootCtx,
      useRootNavigator: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: Text(l10n?.cookiePreferencesTitle ?? 'Cookie Preferences'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n?.cookiePreferencesIntro ?? 'We use cookies to improve your experience. Necessary cookies are always on.'),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: analytics,
                  onChanged: (v) => setState(() => analytics = v),
                  title: Text(l10n?.analyticsLabel ?? 'Analytics'),
                  subtitle: Text(l10n?.analyticsDesc ?? 'Helps us understand usage. Optional.'),
                ),
                SwitchListTile(
                  value: marketing,
                  onChanged: (v) => setState(() => marketing = v),
                  title: Text(l10n?.marketingLabel ?? 'Marketing'),
                  subtitle: Text(l10n?.marketingDesc ?? 'Personalized content/ads. Optional.'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n?.cancel ?? 'Cancel')),
              FilledButton(
                onPressed: () async {
                  await prefs.setBool(_keySet, true);
                  await prefs.setBool(_keyAnalytics, analytics);
                  await prefs.setBool(_keyMarketing, marketing);
                  Navigator.pop(ctx);
                },
                child: Text(l10n?.savePreferences ?? 'Save preferences'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ConsentBannerState extends State<ConsentBanner> {
  bool _visible = false;
  bool _analytics = false;
  bool _marketing = false;
  bool _loading = true;
  OverlayEntry? _overlayEntry;
  bool _overlayInserted = false;

  static const _keySet = 'consent.set';
  static const _keyAnalytics = 'consent.analytics';
  static const _keyMarketing = 'consent.marketing';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (!kIsWeb) {
      // Banner is only relevant for web
      setState(() {
        _visible = false;
        _loading = false;
      });
      _removeOverlayIfNeeded();
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final set = prefs.getBool(_keySet) ?? false;
    if (!set) {
      // default: non-essential OFF per GDPR
      setState(() {
        _visible = true;
        _analytics = false;
        _marketing = false;
        _loading = false;
      });
      _insertOrUpdateOverlay();
    } else {
      setState(() {
        _visible = false;
        _analytics = prefs.getBool(_keyAnalytics) ?? false;
        _marketing = prefs.getBool(_keyMarketing) ?? false;
        _loading = false;
      });
      _removeOverlayIfNeeded();
    }
  }

  Future<void> _save({required bool analytics, required bool marketing}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySet, true);
    await prefs.setBool(_keyAnalytics, analytics);
    await prefs.setBool(_keyMarketing, marketing);
    if (mounted) {
      setState(() => _visible = false);
      _removeOverlayIfNeeded();
    }
  }

  void _acceptAll() => _save(analytics: true, marketing: true);
  void _rejectNonEssential() => _save(analytics: false, marketing: false);

  void _openPreferencesSheet() {
    // Debug feedback to confirm tap
    // ignore: avoid_print
    print('[ConsentBanner] Opening preferences dialog');
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      const SnackBar(content: Text('Opening preferences…')),
    );
    final rootCtx = InAppMessagingService.navigatorKey.currentContext ?? context;
    showDialog(
      context: rootCtx,
      useRootNavigator: true,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx);
        return AlertDialog(
          title: Text(l10n?.cookiePreferencesTitle ?? 'Cookie Preferences'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n?.cookiePreferencesIntro ?? 'We use cookies to improve your experience. Necessary cookies are always on.'),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _analytics,
                onChanged: (v) => setState(() => _analytics = v),
                title: Text(l10n?.analyticsLabel ?? 'Analytics'),
                subtitle: Text(l10n?.analyticsDesc ?? 'Helps us understand usage. Optional.'),
              ),
              SwitchListTile(
                value: _marketing,
                onChanged: (v) {
                  setState(() => _marketing = v);
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(content: Text('${l10n?.marketingLabel ?? 'Marketing'}: ${v ? 'on' : 'off'}')),
                  );
                },
                title: Text(l10n?.marketingLabel ?? 'Marketing'),
                subtitle: Text(l10n?.marketingDesc ?? 'Personalized content/ads. Optional.'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                  SnackBar(content: Text(l10n?.cancel ?? 'Cancel')),
                );
              },
              child: Text(l10n?.cancel ?? 'Cancel'),
            ),
            FilledButton(
              onPressed: () {
                _save(analytics: _analytics, marketing: _marketing);
                Navigator.of(rootCtx, rootNavigator: true).pop();
              },
              child: Text(l10n?.savePreferences ?? 'Save preferences'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Always return an empty widget; actual UI is shown via OverlayEntry
    // attached to the app's Navigator overlay. This guarantees dialogs and
    // route pushes work on web.
    // Ensure overlay state matches current visibility each build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_loading) {
        if (_visible) {
          _insertOrUpdateOverlay();
        } else {
          _removeOverlayIfNeeded();
        }
      }
    });
    return const SizedBox.shrink();
  }

  // Overlay management
  void _insertOrUpdateOverlay() {
    if (!_visible) return;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(builder: (ctx) => _buildBannerBox(ctx));
    } else {
      _overlayEntry!.markNeedsBuild();
    }
    if (!_overlayInserted) {
      final navOverlay = InAppMessagingService.navigatorKey.currentState?.overlay;
      final overlay = navOverlay ?? Overlay.of(context, rootOverlay: true);
      overlay.insert(_overlayEntry!);
      _overlayInserted = true;
    }
  }

  void _removeOverlayIfNeeded() {
    if (_overlayInserted && _overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayInserted = false;
    }
  }

  Widget _buildBannerBox(BuildContext context) {
    if (_loading || !_visible) return const SizedBox.shrink();
    return IgnorePointer(
      ignoring: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          minimum: const EdgeInsets.all(12),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surface,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)?.privacyPolicy ?? 'We value your privacy', style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(AppLocalizations.of(context)?.cookiePreferencesIntro ?? 'We use necessary cookies to make this site work. With your permission, we will also use analytics and marketing cookies.'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(onPressed: _acceptAll, child: Text(AppLocalizations.of(context)?.continueAction ?? 'Accept all')),
                        const SizedBox(width: 8),
                        OutlinedButton(onPressed: _rejectNonEssential, child: Text(AppLocalizations.of(context)?.cancel ?? 'Reject non-essential')),
                        const SizedBox(width: 8),
                        TextButton(onPressed: _openPreferencesSheet, child: Text(AppLocalizations.of(context)?.manageCookiePreferences ?? 'Manage preferences')),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // Debug feedback to confirm tap
                            // ignore: avoid_print
                            print('[ConsentBanner] Navigating to Cookie Policy');
                            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                              const SnackBar(content: Text('Opening Cookie Policy…')),
                            );
                            final nav = InAppMessagingService.navigatorKey.currentState;
                            if (nav != null) {
                              nav.push(
                                MaterialPageRoute(builder: (_) => const CookiePolicyScreen()),
                              );
                            } else {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(builder: (_) => const CookiePolicyScreen()),
                              );
                            }
                          },
                          child: Text(AppLocalizations.of(context)?.cookiePolicy ?? 'Cookie Policy'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlayIfNeeded();
    _overlayEntry = null;
    super.dispose();
  }
}
