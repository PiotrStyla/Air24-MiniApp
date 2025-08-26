import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:f35_flight_compensation/screens/document_ocr_result_screen.dart';
import 'package:f35_flight_compensation/models/document_ocr_result.dart';
import 'package:f35_flight_compensation/core/services/service_initializer.dart';
import 'package:f35_flight_compensation/services/document_ocr_service.dart';
import 'package:f35_flight_compensation/services/auth_service_firebase.dart';
import 'package:f35_flight_compensation/viewmodels/document_scanner_viewmodel.dart';
import 'package:f35_flight_compensation/l10n2/app_localizations.dart';

import '../../mock/unified_mock_auth_service.dart';

class TestNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];
  @override
  void didPush(Route route, Route? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}

// Simple placeholder pages for named routes
class _DummyPage extends StatelessWidget {
  final String title;
  const _DummyPage(this.title);
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Clipboard channel mock
  String? clipboardText;
  setUp(() {
    clipboardText = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (MethodCall call) async {
      if (call.method == 'Clipboard.setData') {
        clipboardText = (call.arguments as Map<dynamic, dynamic>)['text'] as String?;
        return null;
      }
      if (call.method == 'Clipboard.getData') {
        return <String, dynamic>{'text': clipboardText};
      }
      return null;
    });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    await ServiceInitializer.resetForTesting();
  });

  // Helper to create a sample OCR result
  DocumentOcrResult buildSampleResult({
    Map<String, String>? fields,
    String raw = 'RAW OCR SAMPLE',
    DocumentType type = DocumentType.boardingPass,
  }) {
    return DocumentOcrResult(
      documentId: 'doc_1',
      imagePath: 'nonexistent.png',
      scanDate: DateTime(2025, 1, 1),
      extractedFields: fields ?? <String, String>{
        // Keep insertion order stable for deterministic tests
        'flight_number': 'LH1234',
        'departure_airport': 'MUC',
        'arrival_airport': 'MAD',
        'departure_date': '01 JUN 2025',
        'passenger_name': 'DOE JOHN',
      },
      rawText: raw,
      documentType: type,
    );
  }

  // Prepare DI for tests to satisfy ServiceInitializer.get<DocumentScannerViewModel>() calls
  Future<void> setupServiceOverrides() async {
    final auth = UnifiedMockAuthService();
    final ocr = DocumentOcrService();
    // We register only what is needed; the screen retrieves DocumentScannerViewModel,
    // but does not actually use it afterwards. Provide a lightweight instance.
    final vm = DocumentScannerViewModel(ocrService: ocr, authService: auth);

    await ServiceInitializer.overrideForTesting({
      FirebaseAuthService: auth,
      DocumentOcrService: ocr,
      DocumentScannerViewModel: vm,
    });
  }

  // Build app with routes and observer
  Widget buildApp({required DocumentOcrResult result, required VoidCallback onDone, TestNavigatorObserver? observer}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      routes: {
        '/compensation-claim-form': (_) => const _DummyPage('Claim Form'),
        '/flight-search': (_) => const _DummyPage('Flight Search'),
        '/expense-record': (_) => const _DummyPage('Expense Record'),
      },
      navigatorObservers: [if (observer != null) observer],
      home: DocumentOcrResultScreen(ocrResult: result, onDone: onDone),
    );
  }

  group('DocumentOcrResultScreen - UI structure and editing', () {
    testWidgets('renders tabs and formatted field labels; editing updates model', (tester) async {
      await setupServiceOverrides();
      final result = buildSampleResult();
      var doneCalled = false;

      await tester.pumpWidget(buildApp(result: result, onDone: () => doneCalled = true));
      await tester.pumpAndSettle();

      // Tabs exist
      expect(find.text('Extracted Fields'), findsOneWidget);
      expect(find.text('Full Text'), findsOneWidget);

      // Formatted labels
      expect(find.text('Flight Number'), findsOneWidget);
      expect(find.text('Departure Airport'), findsOneWidget);

      // The field shows initial value
      final flightField = find.widgetWithText(TextFormField, 'LH1234');
      expect(flightField, findsOneWidget);

      // Edit the field and verify underlying map updated
      await tester.enterText(flightField, 'LH9999');
      await tester.pumpAndSettle();
      expect(result.extractedFields['flight_number'], 'LH9999');

      // AppBar check should call onDone
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      expect(doneCalled, isTrue);
    });

    testWidgets('copy icon copies field value and shows snackbar', (tester) async {
      await setupServiceOverrides();
      final result = buildSampleResult();

      await tester.pumpWidget(buildApp(result: result, onDone: () {}));
      await tester.pumpAndSettle();

      // Tap the first field copy icon (associated with flight_number due to insertion order)
      final copyButtons = find.byTooltip('Copy to clipboard');
      expect(copyButtons, findsWidgets);
      await tester.tap(copyButtons.first);
      await tester.pump();

      // Clipboard updated and snackbar message shown
      expect(clipboardText, anyOf('LH1234', 'LH9999'));
      expect(find.text('Copied to clipboard'), findsOneWidget);
    });
  });

  group('DocumentOcrResultScreen - Raw text tab', () {
    testWidgets('displays raw OCR text and copy-all copies content', (tester) async {
      await setupServiceOverrides();
      final result = buildSampleResult(raw: 'This is RAW OCR text');

      await tester.pumpWidget(buildApp(result: result, onDone: () {}));
      await tester.pumpAndSettle();

      // Switch to Full Text tab
      await tester.tap(find.text('Full Text'));
      await tester.pumpAndSettle();

      expect(find.text('This is RAW OCR text'), findsOneWidget);

      // Copy all (only one copy icon on this tab)
      final copyAll = find.byIcon(Icons.content_copy);
      expect(copyAll, findsOneWidget);
      await tester.tap(copyAll);
      await tester.pump();

      expect(clipboardText, 'This is RAW OCR text');
      expect(find.text('Copied to clipboard'), findsOneWidget);
    });
  });

  group('DocumentOcrResultScreen - Use Extracted Data dialog and navigation', () {
    testWidgets('navigates to Compensation Claim Form with prefilled data', (tester) async {
      await setupServiceOverrides();
      final result = buildSampleResult();
      final observer = TestNavigatorObserver();

      await tester.pumpWidget(buildApp(result: result, onDone: () {}, observer: observer));
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.text('Use Extracted Data'));
      await tester.pumpAndSettle();

      // Tap Compensation Claim Form option
      await tester.tap(find.text('Compensation Claim Form'));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(observer.pushedRoutes.isNotEmpty, isTrue);
      final route = observer.pushedRoutes.last;
      expect(route.settings.name, '/compensation-claim-form');
      final args = route.settings.arguments as Map<dynamic, dynamic>;
      expect(args.containsKey('prefillData'), isTrue);
      final prefill = (args['prefillData'] as Map).cast<String, String>();
      expect(prefill['flightNumber'], 'LH1234');
      expect(prefill['departureAirport'], 'MUC');

      // Snackbar shown informing prefill
      expect(find.text('Form fields have been prefilled with document data'), findsOneWidget);
    });

    testWidgets('navigates to Flight Search when flight number exists', (tester) async {
      await setupServiceOverrides();
      final result = buildSampleResult();
      final observer = TestNavigatorObserver();

      await tester.pumpWidget(buildApp(result: result, onDone: () {}, observer: observer));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Use Extracted Data'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flight Search'));
      await tester.pumpAndSettle();

      expect(observer.pushedRoutes.last.settings.name, '/flight-search');
      final args = observer.pushedRoutes.last.settings.arguments as Map<dynamic, dynamic>;
      expect(args['flightNumber'], 'LH1234');
    });

    testWidgets('shows error snackbar and does not navigate when flight number missing', (tester) async {
      await setupServiceOverrides();
      // Remove flight_number from fields
      final result = buildSampleResult(fields: {
        'departure_airport': 'MUC',
      });
      final observer = TestNavigatorObserver();

      await tester.pumpWidget(buildApp(result: result, onDone: () {}, observer: observer));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Use Extracted Data'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flight Search'));
      await tester.pump();

      expect(find.text('No flight number found in this document'), findsOneWidget);
      // No push should occur to flight-search
      expect(observer.pushedRoutes.where((r) => r.settings.name == '/flight-search'), isEmpty);
    });

    testWidgets('Expense Record shows warning for non-receipt but still navigates', (tester) async {
      await setupServiceOverrides();
      final result = buildSampleResult(type: DocumentType.boardingPass, fields: {
        'merchant_name': 'Cafe',
        'date': '01/01/2025',
        'total_amount': '12.50',
        'currency': 'EUR',
      });
      final observer = TestNavigatorObserver();

      await tester.pumpWidget(buildApp(result: result, onDone: () {}, observer: observer));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Use Extracted Data'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Expense Record'));
      await tester.pump();

      // Warning snackbar visible
      expect(find.text('This document is not a receipt'), findsOneWidget);

      // Navigation still occurs
      await tester.pumpAndSettle();
      expect(observer.pushedRoutes.last.settings.name, '/expense-record');
      final args = observer.pushedRoutes.last.settings.arguments as Map<dynamic, dynamic>;
      expect((args['expenseData'] as Map)['merchantName'], 'Cafe');
    });
  });

  group('DocumentOcrResultScreen - Empty state', () {
    testWidgets('shows no-fields-extracted message when map empty', (tester) async {
      await setupServiceOverrides();
      final result = buildSampleResult(fields: {});

      await tester.pumpWidget(buildApp(result: result, onDone: () {}));
      await tester.pumpAndSettle();

      expect(find.text('No fields extracted'), findsOneWidget);
    });
  });
}
