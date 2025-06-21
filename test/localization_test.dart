import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:f35_flight_compensation/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('English Localization Test', (WidgetTester tester) async {
      await _pumpLocalizedWidget(tester, const Locale('en'));
      final localizations = AppLocalizations.of(tester.element(find.byType(TestLocalizations)));
      
      // Test some basic translations
      expect(localizations!.appTitle, 'Flight Compensation');
      expect(localizations.home, 'Home');
      expect(localizations.settings, 'Settings');
      expect(localizations.languageSelection, 'Language');
    });

    testWidgets('Polish Localization Test', (WidgetTester tester) async {
      await _pumpLocalizedWidget(tester, const Locale('pl'));
      final localizations = AppLocalizations.of(tester.element(find.byType(TestLocalizations)));
      
      // Test Polish translations
      expect(localizations!.appTitle, 'Odszkodowanie za Lot');
      expect(localizations.home, 'Strona Główna');
      expect(localizations.settings, 'Ustawienia');
    });

    testWidgets('Portuguese Localization Test', (WidgetTester tester) async {
      await _pumpLocalizedWidget(tester, const Locale('pt'));
      final localizations = AppLocalizations.of(tester.element(find.byType(TestLocalizations)));
      
      // Test Portuguese translations
      expect(localizations!.appTitle, 'Compensação de Voo');
      expect(localizations.home, 'Início');
      expect(localizations.settings, 'Definições');
    });
    
    testWidgets('Document Processing Localization Test', (WidgetTester tester) async {
      // Test English
      await _pumpLocalizedWidget(tester, const Locale('en'));
      var localizations = AppLocalizations.of(tester.element(find.byType(TestLocalizations)));
      expect(localizations!.cropDocument, 'Crop Document');
      expect(localizations.documentOcrResult, 'OCR Result');
      
      // Test Polish
      await _pumpLocalizedWidget(tester, const Locale('pl'));
      localizations = AppLocalizations.of(tester.element(find.byType(TestLocalizations)));
      expect(localizations!.cropDocument, 'Przytnij Dokument');
      expect(localizations.documentOcrResult, 'Wynik OCR');
      
      // Test Portuguese
      await _pumpLocalizedWidget(tester, const Locale('pt'));
      localizations = AppLocalizations.of(tester.element(find.byType(TestLocalizations)));
      expect(localizations!.cropDocument, 'Recortar Documento');
      expect(localizations.documentOcrResult, 'Resultado OCR');
    });
    
    testWidgets('Compensation Form Localization Test', (WidgetTester tester) async {
      // Test English
      await _pumpLocalizedWidget(tester, const Locale('en'));
      var localizations = AppLocalizations.of(tester.element(find.byType(TestLocalizations)));
      expect(localizations!.submitClaim, 'Submit Claim');
      expect(localizations.passengerDetails, 'Passenger Details');
      
      // Test Polish
      await _pumpLocalizedWidget(tester, const Locale('pl'));
      localizations = AppLocalizations.of(tester.element(find.byType(TestLocalizations)));
      expect(localizations!.submitClaim, 'Złóż Roszczenie');
      expect(localizations!.passengerDetails, 'Dane Pasażera');
      
      // Test Portuguese
      await _pumpLocalizedWidget(tester, const Locale('pt'));
      localizations = AppLocalizations.of(tester.element(find.byType(TestLocalizations)));
      expect(localizations!.submitClaim, 'Submeter Reclamação');
    });
  });
}

/// Helper widget for testing localization
class TestLocalizations extends StatelessWidget {
  const TestLocalizations({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/// Helper method to pump a localized widget
Future<void> _pumpLocalizedWidget(WidgetTester tester, Locale locale) async {
  await tester.pumpWidget(MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: const TestLocalizations(),
  ));
}
