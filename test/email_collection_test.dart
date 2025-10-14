import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:f35_flight_compensation/widgets/email_collection_dialog.dart';

void main() {
  group('EmailCollectionDialog Tests', () {
    testWidgets('Dialog displays with correct UI elements', (WidgetTester tester) async {
      // Build the dialog
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const EmailCollectionDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Tap button to show dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify dialog content
      expect(find.text('Email Address Required'), findsOneWidget);
      expect(find.text('To receive claim updates and correspondence from the airline, please provide your email address.'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('Validates empty email', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const EmailCollectionDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Try to submit without entering email
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Should show validation error (email required message from l10n)
      expect(find.byType(EmailCollectionDialog), findsOneWidget);
      // Dialog should still be visible (not closed)
    });

    testWidgets('Validates invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const EmailCollectionDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'not-an-email');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Dialog should still be visible (validation failed)
      expect(find.byType(EmailCollectionDialog), findsOneWidget);
    });

    testWidgets('Accepts valid email and returns it', (WidgetTester tester) async {
      String? result;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<String>(
                    context: context,
                    builder: (context) => const EmailCollectionDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Dialog should close and return the email
      expect(find.byType(EmailCollectionDialog), findsNothing);
      expect(result, 'test@example.com');
    });

    testWidgets('Returns null when cancelled', (WidgetTester tester) async {
      String? result = 'initial';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDialog<String>(
                    context: context,
                    builder: (context) => const EmailCollectionDialog(),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Tap cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog should close and return null
      expect(find.byType(EmailCollectionDialog), findsNothing);
      expect(result, isNull);
    });

    testWidgets('Pre-fills email if provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const EmailCollectionDialog(
                      initialEmail: 'prefilled@example.com',
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify email is pre-filled
      expect(find.text('prefilled@example.com'), findsOneWidget);
    });

    testWidgets('Does not pre-fill World ID fake emails', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const EmailCollectionDialog(
                      initialEmail: 'worldid_abc123@air24.app',
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Verify fake email is NOT pre-filled (field should be empty)
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('Validates common email formats', (WidgetTester tester) async {
      final validEmails = [
        'user@example.com',
        'test.user@example.co.uk',
        'user+tag@example.com',
        'user_name@example-domain.com',
      ];

      for (final email in validEmails) {
        String? result;
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await showDialog<String>(
                      context: context,
                      builder: (context) => const EmailCollectionDialog(),
                    );
                  },
                  child: const Text('Show Dialog'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Dialog'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField), email);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        expect(result, email, reason: 'Email $email should be valid');
        expect(find.byType(EmailCollectionDialog), findsNothing);
      }
    });
  });
}
