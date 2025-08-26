import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:f35_flight_compensation/core/accessibility/accessible_widgets.dart';
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'mock_accessibility_service.dart';

class _TestApp extends StatelessWidget {
  final AccessibilityService service;
  final Widget child;
  const _TestApp({required this.service, required this.child});

  @override
  Widget build(BuildContext context) {
    // Simulate app-level providers minimal wrapper
    return ChangeNotifierProvider<AccessibilityService>.value(
      value: service,
      child: MaterialApp(
        home: Scaffold(
          body: Center(child: child),
        ),
      ),
    );
  }
}

class _ToggleHost extends StatelessWidget {
  const _ToggleHost();
  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityService>(
      builder: (context, s, _) => AccessibleToggle(
        label: 'High Contrast',
        semanticLabel: 'Toggle high contrast mode',
        value: s.highContrastMode,
        onChanged: (_) => s.toggleHighContrastMode(),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AccessibleButton semantics label respects screenReaderEmphasis', (tester) async {
    final mock = MockAccessibilityService();

    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _TestApp(
        service: mock,
        child: AccessibleButton(
          label: 'Save',
          semanticLabel: 'Save changes',
          onPressed: () {},
        ),
      ),
    );

    // When emphasis is off, label should be the short label
    expect(
      tester.getSemantics(find.byType(AccessibleButton)),
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        label: 'Save',
        hasTapAction: true,
      ),
    );

    await mock.toggleScreenReaderEmphasis();
    await tester.pumpAndSettle();

    // With emphasis on, label should be the detailed label
    expect(
      tester.getSemantics(find.byType(AccessibleButton)),
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        label: 'Save changes',
        hasTapAction: true,
      ),
    );

    handle.dispose();
  });

  testWidgets('AccessibleToggle exposes toggled semantics and reacts to changes', (tester) async {
    final mock = MockAccessibilityService();
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _TestApp(
        service: mock,
        child: const _ToggleHost(),
      ),
    );

    // Initially off
    expect(
      tester.getSemantics(find.byType(AccessibleToggle)),
      matchesSemantics(
        label: 'High Contrast',
        hasToggledState: true,
        isToggled: false,
      ),
    );

    // Tap to toggle on
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byType(AccessibleToggle)),
      matchesSemantics(
        label: 'High Contrast',
        hasToggledState: true,
        isToggled: true,
      ),
    );

    handle.dispose();
  });
}
