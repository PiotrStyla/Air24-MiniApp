import 'package:flutter/material.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';

class MockAccessibilityService extends ChangeNotifier implements AccessibilityService {
  bool _highContrastMode = false;
  bool _largeTextMode = false;
  bool _screenReaderEmphasis = false;

  @override
  bool get highContrastMode => _highContrastMode;

  @override
  bool get largeTextMode => _largeTextMode;

  @override
  bool get screenReaderEmphasis => _screenReaderEmphasis;

  @override
  Future<void> initialize() async {
    // No-op for mock
    return Future.value();
  }

  @override
  Future<void> toggleHighContrastMode() async {
    _highContrastMode = !_highContrastMode;
    notifyListeners();
  }

  @override
  Future<void> toggleLargeTextMode() async {
    _largeTextMode = !_largeTextMode;
    notifyListeners();
  }

  @override
  Future<void> toggleScreenReaderEmphasis() async {
    _screenReaderEmphasis = !_screenReaderEmphasis;
    notifyListeners();
  }

  @override
  ThemeData getThemeData(ThemeData baseTheme) {
    // Return baseTheme or a simplified mock theme if needed
    return baseTheme;
  }

  @override
  double getTextScaleFactor() {
    return _largeTextMode ? 1.3 : 1.0;
  }

  @override
  String semanticLabel(String shortLabel, String detailedLabel) {
    return _screenReaderEmphasis ? detailedLabel : shortLabel;
  }

  // ChangeNotifier stubs (can be more elaborate if needed with a listener list)
  @override
  void addListener(VoidCallback listener) {
    // No-op or basic listener tracking
  }

  @override
  void removeListener(VoidCallback listener) {
    // No-op or basic listener tracking
  }

  @override
  void dispose() {
    // No-op
    super.dispose(); // Call super.dispose if extending ChangeNotifier directly
  }

  // notifyListeners is already part of ChangeNotifier
}
