@TestOn('browser')
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:f35_flight_compensation/viewmodels/auth_viewmodel.dart';
import '../mock/unified_mock_auth_service.dart';

void main() {
  group('MiniKit walletAuth flow (web only)', () {
    testWidgets('Signs in using MiniKit wallet address when MiniKit is installed', (tester) async {
      // Ensure this test only runs on web/Chrome
      if (!kIsWeb) {
        // Skip on non-web platforms
        return;
      }

      // Arrange: inject a fake MiniKitInterop into window
      const walletAddress = '0xAbCDef1234567890abcd';
      final script = html.ScriptElement()
        ..type = 'text/javascript'
        ..text = '''
          window.MiniKitInterop = {
            isInstalled: function(){ return true; },
            walletAuth: async function(nonce){
              return JSON.stringify({ status: 'ok', address: '$walletAddress' });
            },
            getWalletAddress: function(){ return '$walletAddress'; }
          };
        ''';
      html.document.head!.append(script);

      // Compute expected temp email/password per AuthViewModel logic
      final worldIdHash = walletAddress.toLowerCase();
      final sanitized = worldIdHash.replaceAll(RegExp('[^a-z0-9]'), '');
      final tempPassword = (sanitized.isNotEmpty ? sanitized : 'minikitpass')
          .padRight(20, '0')
          .substring(0, 20);
      final tempEmail = 'worldid_${worldIdHash}@air24.app';

      // Seed mock auth so signInWithEmail succeeds
      final mockAuth = UnifiedMockAuthService();
      mockAuth.seedAccount(email: tempEmail, password: tempPassword, displayName: 'Wallet User', verified: true);

      final vm = AuthViewModel(mockAuth);

      // Act
      final ok = await vm.signInWithWorldID();

      // Assert
      expect(ok, isTrue);
      expect(vm.currentUser, isNotNull);
      expect(vm.currentUser!.email, equals(tempEmail));
    });
  });
}
