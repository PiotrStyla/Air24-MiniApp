import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/donation_popup.dart';

/// Service to manage when and how often to show the donation popup
class DonationPopupService {
  static const String _lastShownKey = 'donation_popup_last_shown';
  static const String _dismissCountKey = 'donation_popup_dismiss_count';
  static const String _neverShowKey = 'donation_popup_never_show';
  
  // Show popup every 7 days if dismissed, or after 3 dismissals show less frequently
  static const int _showIntervalDays = 7;
  static const int _maxDismissalsBeforeReducedFrequency = 3;
  static const int _reducedFrequencyDays = 30;

  /// Check if we should show the donation popup
  static Future<bool> shouldShowPopup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if user has opted to never show
      final neverShow = prefs.getBool(_neverShowKey) ?? false;
      if (neverShow) return false;
      
      // Check last shown date
      final lastShownTimestamp = prefs.getInt(_lastShownKey) ?? 0;
      final lastShown = DateTime.fromMillisecondsSinceEpoch(lastShownTimestamp);
      final now = DateTime.now();
      
      // Check dismiss count to determine frequency
      final dismissCount = prefs.getInt(_dismissCountKey) ?? 0;
      final daysSinceLastShown = now.difference(lastShown).inDays;
      
      // If never shown before, show it
      if (lastShownTimestamp == 0) return true;
      
      // Determine interval based on dismiss count
      final requiredInterval = dismissCount >= _maxDismissalsBeforeReducedFrequency
          ? _reducedFrequencyDays
          : _showIntervalDays;
      
      return daysSinceLastShown >= requiredInterval;
    } catch (e) {
      debugPrint('Error checking if should show donation popup: $e');
      return false;
    }
  }

  /// Show the donation popup if conditions are met
  static Future<void> showPopupIfNeeded(BuildContext context) async {
    if (await shouldShowPopup()) {
      // Wait a bit for the app to fully load
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          builder: (context) => const DonationPopup(),
        );
        await _recordPopupShown();
      }
    }
  }

  /// Record that the popup was shown
  static Future<void> _recordPopupShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastShownKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('Error recording popup shown: $e');
    }
  }

  /// Record that the popup was dismissed
  static Future<void> recordPopupDismissed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt(_dismissCountKey) ?? 0;
      await prefs.setInt(_dismissCountKey, currentCount + 1);
    } catch (e) {
      debugPrint('Error recording popup dismissed: $e');
    }
  }

  /// Record that user chose to never show the popup again
  static Future<void> setNeverShowAgain() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_neverShowKey, true);
    } catch (e) {
      debugPrint('Error setting never show again: $e');
    }
  }

  /// Reset popup preferences (for testing or user request)
  static Future<void> resetPopupPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastShownKey);
      await prefs.remove(_dismissCountKey);
      await prefs.remove(_neverShowKey);
    } catch (e) {
      debugPrint('Error resetting popup preferences: $e');
    }
  }

  /// Get popup statistics for debugging
  static Future<Map<String, dynamic>> getPopupStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastShownTimestamp = prefs.getInt(_lastShownKey) ?? 0;
      final dismissCount = prefs.getInt(_dismissCountKey) ?? 0;
      final neverShow = prefs.getBool(_neverShowKey) ?? false;
      
      return {
        'lastShown': lastShownTimestamp > 0 
            ? DateTime.fromMillisecondsSinceEpoch(lastShownTimestamp).toIso8601String()
            : 'Never',
        'dismissCount': dismissCount,
        'neverShow': neverShow,
        'shouldShow': await shouldShowPopup(),
      };
    } catch (e) {
      debugPrint('Error getting popup stats: $e');
      return {'error': e.toString()};
    }
  }
}
