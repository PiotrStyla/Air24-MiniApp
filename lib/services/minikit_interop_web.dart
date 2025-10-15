import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

Future<bool> minikitInstalled() async {
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

Future<Map<String, dynamic>?> walletAuth(String nonce) async {
  final interop = js_util.getProperty(html.window, 'MiniKitInterop');
  if (interop == null) return null;
  try {
    final promise = js_util.callMethod(interop, 'walletAuth', [nonce]);
    final result = await js_util.promiseToFuture(promise);
    if (result is String) {
      try {
        final parsed = jsonDecode(result);
        if (parsed is Map) return parsed.cast<String, dynamic>();
      } catch (_) {}
    } else if (result is Map) {
      return (result as Map).cast<String, dynamic>();
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
