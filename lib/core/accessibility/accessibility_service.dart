import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage accessibility features throughout the app
class AccessibilityService extends ChangeNotifier {
  /// Key for storing high contrast mode preference
  static const String _highContrastKey = 'high_contrast_mode';
  
  /// Key for storing large text preference
  static const String _largeTextKey = 'large_text_mode';
  
  /// Key for storing screen reader emphasis preference
  static const String _screenReaderEmphasisKey = 'screen_reader_emphasis';
  
  /// Whether high contrast mode is enabled
  bool _highContrastMode = false;
  
  /// Whether large text is enabled
  bool _largeTextMode = false;
  
  /// Whether screen reader emphasis is enabled (adds more descriptive labels)
  bool _screenReaderEmphasis = false;

  /// Get high contrast mode state
  bool get highContrastMode => _highContrastMode;
  
  /// Get large text mode state
  bool get largeTextMode => _largeTextMode;
  
  /// Get screen reader emphasis state
  bool get screenReaderEmphasis => _screenReaderEmphasis;

  /// Initialize the service with saved preferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _highContrastMode = prefs.getBool(_highContrastKey) ?? false;
    _largeTextMode = prefs.getBool(_largeTextKey) ?? false;
    _screenReaderEmphasis = prefs.getBool(_screenReaderEmphasisKey) ?? false;
    notifyListeners();
  }

  /// Toggle high contrast mode
  Future<void> toggleHighContrastMode() async {
    _highContrastMode = !_highContrastMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highContrastKey, _highContrastMode);
    notifyListeners();
    
    // Provide haptic feedback for mode change
    HapticFeedback.mediumImpact();
  }

  /// Toggle large text mode
  Future<void> toggleLargeTextMode() async {
    _largeTextMode = !_largeTextMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_largeTextKey, _largeTextMode);
    notifyListeners();
    
    // Provide haptic feedback for mode change
    HapticFeedback.mediumImpact();
  }

  /// Toggle screen reader emphasis
  Future<void> toggleScreenReaderEmphasis() async {
    _screenReaderEmphasis = !_screenReaderEmphasis;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_screenReaderEmphasisKey, _screenReaderEmphasis);
    notifyListeners();
    
    // Provide haptic feedback for mode change
    HapticFeedback.mediumImpact();
  }

  /// Get theme data based on current accessibility settings
  ThemeData getThemeData(ThemeData baseTheme) {
    if (!_highContrastMode) {
      return baseTheme;
    }
    
    // Create high contrast theme
    return baseTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: baseTheme.primaryColor,
        brightness: baseTheme.brightness,
        // Increase contrast
        primary: baseTheme.brightness == Brightness.dark 
            ? Colors.white 
            : Colors.black,
        onPrimary: baseTheme.brightness == Brightness.dark 
            ? Colors.black 
            : Colors.white,
        secondary: baseTheme.brightness == Brightness.dark 
            ? Colors.yellow 
            : Colors.blue.shade900,
        onSecondary: baseTheme.brightness == Brightness.dark 
            ? Colors.black 
            : Colors.white,
        background: baseTheme.brightness == Brightness.dark 
            ? Colors.black 
            : Colors.white,
        onBackground: baseTheme.brightness == Brightness.dark 
            ? Colors.white 
            : Colors.black,
        surface: baseTheme.brightness == Brightness.dark 
            ? Colors.black 
            : Colors.white,
        onSurface: baseTheme.brightness == Brightness.dark 
            ? Colors.white 
            : Colors.black,
        error: Colors.red.shade800,
        onError: Colors.white,
      ),
      // Don't scale text here, we'll use MediaQuery's textScaler instead
      // This avoids double-scaling issues and assertion errors
      textTheme: baseTheme.textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: baseTheme.brightness == Brightness.dark 
              ? Colors.black 
              : Colors.white,
          backgroundColor: baseTheme.brightness == Brightness.dark 
              ? Colors.white 
              : Colors.black,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 2.0,
            color: baseTheme.brightness == Brightness.dark 
                ? Colors.white 
                : Colors.black,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: baseTheme.brightness == Brightness.dark 
                ? Colors.white70 
                : Colors.black87,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.0,
            color: baseTheme.brightness == Brightness.dark 
                ? Colors.white70 
                : Colors.black87,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3.0,
            color: baseTheme.brightness == Brightness.dark 
                ? Colors.yellow 
                : Colors.blue.shade900,
          ),
        ),
      ),
    );
  }

  /// Get text scale factor based on current settings
  double getTextScaleFactor() {
    // Using exact 1.0 or specific values to avoid assertion errors
    return _largeTextMode ? 1.3 : 1.0;
  }
  
  /// Generate semantic label with proper descriptions based on settings
  String semanticLabel(String shortLabel, String detailedLabel) {
    return _screenReaderEmphasis ? detailedLabel : shortLabel;
  }
}
