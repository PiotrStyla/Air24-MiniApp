import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Utility class for haptic feedback (Day 11 - Priority 2)
/// Provides consistent haptic feedback throughout the app
class HapticFeedbackUtil {
  /// Light haptic feedback for button taps
  static Future<void> lightImpact() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }
  
  /// Medium haptic feedback for important actions
  static Future<void> mediumImpact() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }
  
  /// Heavy haptic feedback for critical actions
  static Future<void> heavyImpact() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }
  
  /// Selection feedback for toggles and switches
  static Future<void> selectionClick() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }
  
  /// Vibrate for success actions (claim submitted, email copied, etc.)
  static Future<void> success() async {
    try {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }
  
  /// Vibrate for error actions
  static Future<void> error() async {
    try {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }
  
  /// Vibrate for warning actions
  static Future<void> warning() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Haptic feedback error: $e');
    }
  }
}
