import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// Assuming these paths are correct relative to the project root
import 'package:f35_flight_compensation/core/accessibility/accessibility_service.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart'; // For MaterialApp

// Copied from claim_submission_test.dart
class MockAccessibilityService extends AccessibilityService with ChangeNotifier {
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
    print('[MockAccessibilityService MinimalTest] initialize called');
    // Potentially set initial mock values if needed
    notifyListeners(); 
  }

  @override
  Future<void> toggleHighContrastMode() async {
    print('[MockAccessibilityService MinimalTest] toggleHighContrastMode called');
    _mockHighContrast = !_mockHighContrast;
    notifyListeners();
  }

  @override
  Future<void> toggleLargeTextMode() async {
    print('[MockAccessibilityService MinimalTest] toggleLargeTextMode called');
    _mockLargeText = !_mockLargeText;
    notifyListeners();
  }

  @override
  Future<void> toggleScreenReaderEmphasis() async {
    print('[MockAccessibilityService MinimalTest] toggleScreenReaderEmphasis called');
    _mockScreenReaderEmphasis = !_mockScreenReaderEmphasis;
    notifyListeners();
  }

  @override
  double getTextScaleFactor() {
    print('[MockAccessibilityService MinimalTest] getTextScaleFactor called');
    return 1.0;
  }

  @override
  ThemeData getThemeData(ThemeData baseTheme) {
    print('[MockAccessibilityService MinimalTest] getThemeData called');
    return baseTheme;
  }
  
  @override
  String semanticLabel(String shortLabel, String detailedLabel) {
    print('[MockAccessibilityService MinimalTest] semanticLabel called');
    return shortLabel;
  }
}

// Simple widget consuming the service
class MinimalTestWidget extends StatelessWidget {
  const MinimalTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Provider.of for simplicity in this minimal test
    final service = Provider.of<AccessibilityService>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Service RuntimeType: ${service.runtimeType}'),
        Text('High Contrast: ${service.highContrastMode}'),
        ElevatedButton(
          key: const Key('toggleHighContrastButton'),
          onPressed: () async {
            // Accessing via Provider.of with listen:false for actions
            await Provider.of<AccessibilityService>(context, listen: false).toggleHighContrastMode();
          },
          child: const Text('Toggle High Contrast'),
        ),
      ],
    );
  }
}

// Global mock instance for registration
final mockAccessibilityService = MockAccessibilityService();

Widget createMinimalTestableWidget({required Widget child}) {
  final accessibilityServiceInstanceFromGetIt = GetIt.I<AccessibilityService>();

  // Diagnostic prints
  print('[MinimalTestableWidget] GetIt instance runtimeType: ${accessibilityServiceInstanceFromGetIt.runtimeType}');
  print('[MinimalTestableWidget] GetIt instance is ChangeNotifier: ${accessibilityServiceInstanceFromGetIt is ChangeNotifier}');
  print('[MinimalTestableWidget] GetIt instance is AccessibilityService: ${accessibilityServiceInstanceFromGetIt is AccessibilityService}');
  print('[MinimalTestableWidget] GetIt instance is MockAccessibilityService: ${accessibilityServiceInstanceFromGetIt is MockAccessibilityService}');

  // Defensive checks
  if (accessibilityServiceInstanceFromGetIt is! MockAccessibilityService) {
    print('[MinimalTestableWidget] ALARM! Instance from GetIt is NOT MockAccessibilityService. Actual Type: ${accessibilityServiceInstanceFromGetIt.runtimeType}');
  }
  if (accessibilityServiceInstanceFromGetIt is! ChangeNotifier) {
     print('[MinimalTestableWidget] ALARM! Instance from GetIt is NOT ChangeNotifier. Actual Type: ${accessibilityServiceInstanceFromGetIt.runtimeType}');
  }

  return ChangeNotifierProvider<AccessibilityService>(
    create: (_) {
      final instanceForProvider = accessibilityServiceInstanceFromGetIt;
      
      print('[MinimalTestableWidget Provider Create] InstanceForProvider runtimeType: ${instanceForProvider.runtimeType}');
      print('[MinimalTestableWidget Provider Create] InstanceForProvider is ChangeNotifier: ${instanceForProvider is ChangeNotifier}');
      print('[MinimalTestableWidget Provider Create] InstanceForProvider is AccessibilityService: ${instanceForProvider is AccessibilityService}');
      print('[MinimalTestableWidget Provider Create] InstanceForProvider is MockAccessibilityService: ${instanceForProvider is MockAccessibilityService}');
      
      return instanceForProvider;
    },
    child: MaterialApp(
      // Required for AppLocalizations if your widget tree needs it, otherwise can be simpler
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // No MockFirebase needed for this minimal test unless AccessibilityService depends on it.
    // Initialize ServiceInitializer for testing and register the mock
    await ServiceInitializer.overrideForTesting({
      AccessibilityService: mockAccessibilityService,
    });
  });

  tearDownAll(() async {
    await ServiceInitializer.resetForTesting();
  });
  
  testWidgets('Minimal AccessibilityService with Mock and GetIt works', (WidgetTester tester) async {
    // Pump the minimal test widget
    await tester.pumpWidget(createMinimalTestableWidget(child: const MinimalTestWidget()));
    await tester.pumpAndSettle(); // Allow time for async operations like initialize

    // Verify initial state (mock should be active)
    // MockAccessibilityService's initialize calls notifyListeners.
    // The GetIt instance should be our MockAccessibilityService.
    expect(find.text('Service RuntimeType: MockAccessibilityService'), findsOneWidget);
    expect(find.text('High Contrast: false'), findsOneWidget); // Initial mock state

    // Interact with the service
    await tester.tap(find.byKey(const Key('toggleHighContrastButton')));
    await tester.pumpAndSettle(); // Rebuild widget after state change

    // Verify updated state
    expect(find.text('High Contrast: true'), findsOneWidget);

    // Toggle back
    await tester.tap(find.byKey(const Key('toggleHighContrastButton')));
    await tester.pumpAndSettle();
    expect(find.text('High Contrast: false'), findsOneWidget);
  });
}
