import 'package:flutter/material.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';

// Refactored to extend ChangeNotifier directly and implement AccessibilityService interface
class MockAccessibilityService extends ChangeNotifier implements AccessibilityService {
  bool _mockHighContrast = false;
  bool _mockLargeText = false;
  bool _mockScreenReaderEmphasis = false;

  @override
  bool get highContrastMode => _mockHighContrast;

  @override
  bool get largeTextMode => _mockLargeText;

  @override
  bool get screenReaderEmphasis => _mockScreenReaderEmphasis;

  @override
  Future<void> initialize() async {
    print('MockAccessibilityService: initialize called');
    // No actual SharedPreferences access in mock
    // Simulate loading initial state if necessary for tests
    // _mockHighContrast = ...
    // _mockLargeText = ...
    // _mockScreenReaderEmphasis = ...
    notifyListeners(); 
  }

  @override
  Future<void> toggleHighContrastMode() async {
    _mockHighContrast = !_mockHighContrast;
    print('MockAccessibilityService: toggleHighContrastMode called, new value: $_mockHighContrast');
    notifyListeners();
  }

  @override
  Future<void> toggleLargeTextMode() async {
    _mockLargeText = !_mockLargeText;
    print('MockAccessibilityService: toggleLargeTextMode called, new value: $_mockLargeText');
    notifyListeners();
  }

  @override
  Future<void> toggleScreenReaderEmphasis() async {
    _mockScreenReaderEmphasis = !_mockScreenReaderEmphasis;
    print('MockAccessibilityService: toggleScreenReaderEmphasis called, new value: $_mockScreenReaderEmphasis');
    notifyListeners();
  }

  @override
  ThemeData getThemeData(ThemeData baseTheme) {
    print('MockAccessibilityService: getThemeData called');
    if (_mockHighContrast) {
      return baseTheme.copyWith(
        // Example high contrast modifications, align with actual service if needed for tests
        colorScheme: ColorScheme.fromSeed(
          seedColor: baseTheme.primaryColor,
          brightness: baseTheme.brightness,
          primary: baseTheme.brightness == Brightness.dark ? Colors.white : Colors.black,
          onPrimary: baseTheme.brightness == Brightness.dark ? Colors.black : Colors.white,
        ),
      );
    }
    return baseTheme;
  }

  @override
  double getTextScaleFactor() {
    print('MockAccessibilityService: getTextScaleFactor called, returning ${_mockLargeText ? 1.3 : 1.0}');
    return _mockLargeText ? 1.3 : 1.0; // Consistent with actual service logic
  }

  @override
  String semanticLabel(String shortLabel, String detailedLabel) {
    final label = _mockScreenReaderEmphasis ? detailedLabel : shortLabel;
    print('MockAccessibilityService: semanticLabel called, short: "$shortLabel", detailed: "$detailedLabel", emphasis: $_mockScreenReaderEmphasis, returning: "$label"');
    return label; // Consistent with actual service logic
  }

  // --- Test utility methods to control mock state --- 
  void setMockHighContrast(bool value, {bool notify = true}) {
    _mockHighContrast = value;
    if (notify) notifyListeners();
  }

  void setMockLargeText(bool value, {bool notify = true}) {
    _mockLargeText = value;
    if (notify) notifyListeners();
  }

  void setMockScreenReaderEmphasis(bool value, {bool notify = true}) {
    _mockScreenReaderEmphasis = value;
    if (notify) notifyListeners();
  }

  // ChangeNotifier methods like addListener, removeListener, dispose, notifyListeners are inherited.
}
