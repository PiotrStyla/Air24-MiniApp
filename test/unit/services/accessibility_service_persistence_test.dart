import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Ensure a clean in-memory SharedPreferences for each test
    SharedPreferences.setMockInitialValues({});
  });

  test('AccessibilityService initializes with defaults (all false)', () async {
    final service = AccessibilityService();
    await service.initialize();

    expect(service.highContrastMode, isFalse);
    expect(service.largeTextMode, isFalse);
    expect(service.screenReaderEmphasis, isFalse);
  });

  test('Toggles persist across new AccessibilityService instances', () async {
    final s1 = AccessibilityService();
    await s1.initialize();

    await s1.toggleHighContrastMode();
    await s1.toggleLargeTextMode();
    await s1.toggleScreenReaderEmphasis();

    expect(s1.highContrastMode, isTrue);
    expect(s1.largeTextMode, isTrue);
    expect(s1.screenReaderEmphasis, isTrue);

    // New instance should read persisted values
    final s2 = AccessibilityService();
    await s2.initialize();

    expect(s2.highContrastMode, isTrue);
    expect(s2.largeTextMode, isTrue);
    expect(s2.screenReaderEmphasis, isTrue);
  });

  test('getTextScaleFactor reflects largeTextMode', () async {
    final service = AccessibilityService();
    await service.initialize();

    expect(service.getTextScaleFactor(), 1.0);
    await service.toggleLargeTextMode();
    expect(service.getTextScaleFactor(), 1.3);
  });

  test('getThemeData applies high-contrast overrides when enabled', () async {
    final baseTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    );

    final service = AccessibilityService();
    await service.initialize();

    final themeDefault = service.getThemeData(baseTheme);
    // No explicit background override when high contrast is off
    expect(themeDefault.elevatedButtonTheme.style?.backgroundColor?.resolve({}), isNull);

    await service.toggleHighContrastMode();
    final themeHighContrast = service.getThemeData(baseTheme);

    expect(themeHighContrast.elevatedButtonTheme.style?.backgroundColor?.resolve({}), Colors.black);
    expect(themeHighContrast.elevatedButtonTheme.style?.foregroundColor?.resolve({}), Colors.white);
    // Color scheme contrast adjustments
    expect(themeHighContrast.colorScheme.primary, Colors.black);
    expect(themeHighContrast.colorScheme.onPrimary, Colors.white);
  });
}
