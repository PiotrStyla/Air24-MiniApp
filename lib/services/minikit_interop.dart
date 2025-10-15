// Aggregator for MiniKit interop; provides no-ops off web

import 'minikit_interop_stub.dart'
    if (dart.library.html) 'minikit_interop_web.dart' as impl;

Future<bool> minikitInstalled() => impl.minikitInstalled();

Future<Map<String, dynamic>?> walletAuth(String nonce) => impl.walletAuth(nonce);

Future<String?> getWalletAddress() => impl.getWalletAddress();
