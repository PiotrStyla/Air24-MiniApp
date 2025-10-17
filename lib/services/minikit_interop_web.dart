import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

Future<bool> minikitInstalled() async {
  Future<bool> _check() async {
    try {
      final interop = js_util.getProperty(html.window, 'MiniKitInterop');
      if (interop == null) return false;
      final installed = js_util.callMethod(interop, 'isInstalled', const []);
      if (installed is bool) return installed;
      return installed == true;
    } catch (_) {
      return false;
    }
  }

  // Initial check
  if (await _check()) return true;

  // Short retry window to accommodate host-provided MiniKit attaching late
  await Future.delayed(const Duration(milliseconds: 200));
  if (await _check()) return true;

  await Future.delayed(const Duration(milliseconds: 300));
  return await _check();
}

Future<Map<String, dynamic>?> walletAuth(String nonce) async {
  final interop = js_util.getProperty(html.window, 'MiniKitInterop');
  if (interop == null) return null;
  try {
    final promise = js_util.callMethod(interop, 'walletAuth', [nonce]);
    final result = await js_util.promiseToFuture(promise);
    if (result is String) {
      try {
        final parsed = jsonDecode(result);
        if (parsed is Map) return Map<String, dynamic>.from(parsed);
      } catch (_) {}
    } else if (result is Map) {
      return Map<String, dynamic>.from(result);
    }
  } catch (_) {}
  return null;
}

Future<String?> getWalletAddress() async {
  try {
    final interop = js_util.getProperty(html.window, 'MiniKitInterop');
    if (interop == null) return null;
    final addr = js_util.callMethod(interop, 'getWalletAddress', const []);
    if (addr == null) return null;
    return addr.toString();
  } catch (_) {
    return null;
  }
}
