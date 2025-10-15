// Stubbed MiniKit interop for non-web platforms

Future<bool> minikitInstalled() async => false;

Future<Map<String, dynamic>?> walletAuth(String nonce) async => null;

Future<String?> getWalletAddress() async => null;
