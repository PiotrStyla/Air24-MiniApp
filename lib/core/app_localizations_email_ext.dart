import 'package:f35_flight_compensation/l10n2/app_localizations.dart';

/// Lightweight localization extension for email clipboard fallback texts.
/// Mirrors the pattern used in `app_localizations_worldid_ext.dart` and keeps
/// us unblocked even if ARB keys are not yet generated.
extension EmailL10nExt on AppLocalizations {
  bool get _isPl => localeName.startsWith('pl');

  /// Primary banner text when no email app is available and clipboard is used
  String get emailClipboardFallbackPrimary => _isPl
      ? 'Brak aplikacji e‑mail. Treść wiadomości skopiowano do schowka. Wklej ją w dowolnej usłudze e‑mail.'
      : 'No email app available. Email content copied to your clipboard. Paste it into any email service.';

  /// Advisory text explaining next steps and supported attachments
  String get emailClipboardFallbackAdvisory => _isPl
      ? 'Po wklejeniu możesz przejrzeć i poprawić treść oraz dołączyć załączniki (JPG, PNG, PDF).'
      : 'After pasting, you can review and make corrections, and attach documents like tickets or boarding passes (JPG, PNG, PDF).';
}
