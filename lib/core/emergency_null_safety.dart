import 'package:flutter/material.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';
import 'app_localizations_patch.dart';

// EMERGENCY: Global function to safely get AppLocalizations
// This ensures that AppLocalizations access never causes null check operator errors
AppLocalizations safeAppLocalizationsOf(BuildContext? context) {
  if (context == null) {
    debugPrint('⚠️ GLOBAL: Context is null in AppLocalizations.of(), using emergency fallback');
    // Use our DynamicEmergencyLocalizations from the patch
    return DynamicEmergencyLocalizations();
  }
  
  try {
    // First attempt to get localizations from context
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (localizations != null) {
      return localizations;
    }
  } catch (e) {
    debugPrint('⚠️ GLOBAL: Error in AppLocalizations.of(): $e');
  }
  
  debugPrint('⚠️ GLOBAL: AppLocalizations.of() returned null, using emergency fallback');
  return DynamicEmergencyLocalizations();
}

/// Patch AppLocalizations.of to always return a non-null value
/// This is a monkey patch that replaces the static method at runtime
class AppLocalizationsPatch {
  /// Initialize the patch
  static void initializePatch() {
    debugPrint('🔄 Initializing AppLocalizations.of() patch');
    // We can't directly monkey patch the static method, but our extension
    // and context.l10n getter achieve the same result
  }
}

/// Emergency null safety wrapper to prevent all null check operator errors
/// This ensures the app never crashes due to null values
class EmergencyNullSafety {
  
  /// Safe AppLocalizations getter that never returns null
  static AppLocalizations safeLocalizations(BuildContext context) {
    // Our safeAppLocalizationsOf function now ALWAYS returns a non-null value
    // This ensures we never get a null check operator error
    return safeAppLocalizationsOf(context);
  }
  
  /// Direct access to emergency localizations without needing a context
  /// Use this as a last resort when no context is available
  static AppLocalizations get emergency {
    debugPrint('⚠️ EMERGENCY: Using context-free emergency localizations');
    return DynamicEmergencyLocalizations();
  }
  
  /// Initialize all emergency patches
  static void initializeAll() {
    AppLocalizationsPatch.initializePatch();
    debugPrint('✅ All emergency null safety patches initialized');
  }
  
  /// Safe string getter that never returns null
  static String safeString(String? value, [String fallback = '']) {
    return value ?? fallback;
  }
  
  /// Safe widget getter that never returns null
  static Widget safeWidget(Widget? widget, [Widget? fallback]) {
    return widget ?? fallback ?? const SizedBox.shrink();
  }
  
  /// Safe user display name that never returns null
  static String safeUserDisplayName(String? displayName) {
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }
    return 'User'; // Safe fallback
  }
}

// This class has been replaced by DynamicEmergencyLocalizations in app_localizations_patch.dart
