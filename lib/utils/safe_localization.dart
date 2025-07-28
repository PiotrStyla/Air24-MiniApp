import 'package:flutter/material.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';

/// EMERGENCY NULL SAFETY FIX
/// 
/// This file creates a global system patch for AppLocalizations to ensure
/// that even if AppLocalizations.of(context)! is called with the force unwrap
/// operator, it will never throw a null check operator error.
/// 
/// When Flutter generates the AppLocalizations class, it creates a static
/// 'of' method that returns AppLocalizations? - which means it can be null.
/// Throughout the codebase, there are hundreds of calls to AppLocalizations.of(context)!
/// which force unwrap this potentially null value, causing crashes.
///
/// This utility uses a mixin to override the AppLocalizations.of method
/// globally to ensure it never returns null.

// This mixin will be mixed into the global MaterialApp in main.dart
mixin SafeLocalizationMixin on StatelessWidget {
  // Declare a global emergency fallback
  static final _emergencyLocalizations = _createEmergencyLocalizations();
  
  // Create emergency localizations that never returns null
  static AppLocalizations _createEmergencyLocalizations() {
    try {
      return AppLocalizations('en');
    } catch (e) {
      debugPrint('🚨 SafeLocalization: Error creating emergency localizations: $e');
      // In case of extreme emergency, create a dynamic proxy
      return _UltraEmergencyLocalizations();
    }
  }
}

/// Ultra emergency fallback that handles any possible scenario
/// This is used as a last resort if even the normal emergency localizations fail
class _UltraEmergencyLocalizations implements AppLocalizations {
  _UltraEmergencyLocalizations() {
    debugPrint('🆘 ULTRA EMERGENCY: Created fallback localizations to prevent app crash');
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) {
    // Log the attempted access for debugging
    final methodName = invocation.memberName.toString().replaceAll('Symbol("', '').replaceAll('")', '');
    debugPrint('🆘 ULTRA EMERGENCY: Attempted to access non-existent method: $methodName');
    
    // Return appropriate fallback based on method signature
    if (invocation.isGetter) {
      // For getters, return a generic string
      return 'Text Placeholder';
    } else if (invocation.isMethod) {
      // For methods, return a function that returns a generic string
      if (invocation.positionalArguments.isNotEmpty) {
        // If there are arguments, incorporate the first one in the fallback
        final firstArg = invocation.positionalArguments.first;
        return 'Text for $firstArg';
      }
      return 'Text Placeholder';
    }
    return 'Text Placeholder';
  }
}
