import 'package:flutter_test/flutter_test.dart';

/// Tests for World ID fake email detection logic
void main() {
  group('World ID Email Detection Tests', () {
    test('Detects World ID fake emails correctly', () {
      final fakeEmails = [
        'worldid_abc123@air24.app',
        'worldid_xyz789@air24.app',
        'worldid_test@air24.app',
      ];

      for (final email in fakeEmails) {
        final isFake = email.startsWith('worldid_') && email.endsWith('@air24.app');
        expect(isFake, isTrue, reason: 'Should detect $email as fake World ID email');
      }
    });

    test('Does not detect real emails as fake', () {
      final realEmails = [
        'user@example.com',
        'test@air24.app', // Real Air24 email
        'worldid@gmail.com', // Contains 'worldid' but not the pattern
        'my_worldid_test@air24.app', // Doesn't start with 'worldid_'
      ];

      for (final email in realEmails) {
        final isFake = email.startsWith('worldid_') && email.endsWith('@air24.app');
        expect(isFake, isFalse, reason: 'Should NOT detect $email as fake World ID email');
      }
    });

    test('Email validation regex works correctly', () {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      final validEmails = [
        'user@example.com',
        'test.user@example.co.uk',
        'user+tag@example.com',
        'user_name@example-domain.com',
        'worldid_abc123@air24.app',
      ];

      final invalidEmails = [
        'not-an-email',
        '@example.com',
        'user@',
        'user@.com',
        'user @example.com',
        'user@example',
      ];

      for (final email in validEmails) {
        expect(emailRegex.hasMatch(email), isTrue, reason: '$email should be valid');
      }

      for (final email in invalidEmails) {
        expect(emailRegex.hasMatch(email), isFalse, reason: '$email should be invalid');
      }
    });
  });
}
