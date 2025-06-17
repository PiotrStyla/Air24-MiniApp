import 'package:flutter/material.dart';
import '../utils/localization_migration_helper.dart';
import 'package:provider/provider.dart';
import '../services/localization_service.dart';
import '../services/manual_localization_service.dart';

/// Widget that ensures localization is properly initialized before building children
class LocalizationWrapper extends StatefulWidget {
  final Widget child;
  final Widget? loadingWidget;
  
  const LocalizationWrapper({
    super.key,
    required this.child,
    this.loadingWidget,
  });

  @override
  State<LocalizationWrapper> createState() => _LocalizationWrapperState();
}

class _LocalizationWrapperState extends State<LocalizationWrapper> {
  // Used to force rebuilds when language changes
  late int _rebuildCounter;
  
  @override
  void initState() {
    super.initState();
    _rebuildCounter = ManualLocalizationService.rebuildNotifier.value;
    
    // Listen to the rebuildNotifier to trigger rebuilds when language changes
    ManualLocalizationService.rebuildNotifier.addListener(_onRebuildRequested);
    
    debugPrint('LocalizationWrapper initialized with rebuild counter: $_rebuildCounter');
  }
  
  @override
  void dispose() {
    // Remove the listener when widget is disposed
    ManualLocalizationService.rebuildNotifier.removeListener(_onRebuildRequested);
    super.dispose();
  }
  
  void _onRebuildRequested() {
    debugPrint('LocalizationWrapper - Rebuild requested, counter: ${ManualLocalizationService.rebuildNotifier.value}');
    if (mounted) {
      setState(() {
        _rebuildCounter = ManualLocalizationService.rebuildNotifier.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final localizationService = Provider.of<LocalizationService>(context);
    
    // Debug information
    debugPrint('LocalizationWrapper - Context locale: $locale');
    debugPrint('LocalizationWrapper - Service locale: ${localizationService.currentLocale}');
    debugPrint('LocalizationWrapper - Rebuild counter: $_rebuildCounter');
    
    // Get localization using our migration helper
    // Rebuild counter is used in the key to force recreation of the widget
    final localizations = MigrationLocalizations.of(context);
    
    // MigrationLocalizations is never null, but we'll keep this check for safety
    if (localizations == null) {
      debugPrint('WARNING: MigrationLocalizations is NULL! Showing loading widget.');
      return widget.loadingWidget ?? const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    debugPrint('LocalizationWrapper - Localizations available, building child');
    return KeyedSubtree(
      // Using KeyedSubtree with a key based on the rebuild counter
      // forces the entire subtree to rebuild when language changes
      key: ValueKey('localization_wrapper_$_rebuildCounter'),
      child: widget.child,
    );
  }
}
