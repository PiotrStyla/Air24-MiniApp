// Web implementation using JS interop for Worldcoin IDKit
// Only compiled on web (dart.library.html)

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

Future<bool> worldIdAvailable() async {
  try {
    final interop = js_util.getProperty(html.window, 'WorldIdInterop');
    if (interop == null) return false;
    final available = js_util.callMethod(interop, 'available', const []);
    if (available is bool) return available;
    return available == true;
  } catch (_) {
    return false;
  }
}

Future<Map<String, dynamic>?> openWorldId({
  String? appId,
  String? action,
  String? signal,
}) async {
  final interop = js_util.getProperty(html.window, 'WorldIdInterop');
  if (interop == null) return null;
  final cfg = <String, dynamic>{
    if (appId != null && appId.isNotEmpty) 'app_id': appId,
    if (action != null && action.isNotEmpty) 'action': action,
    if (signal != null && signal.isNotEmpty) 'signal': signal,
  };
  try {
    final promise = js_util.callMethod(interop, 'open', [js_util.jsify(cfg)]);
    final result = await js_util.promiseToFuture(promise);
    if (result is String) {
      final parsed = jsonDecode(result);
      if (parsed is Map) {
        return parsed.cast<String, dynamic>();
      }
    }
  } catch (_) {
    // swallow and return null
  }
  return null;
}

Future<String?> configuredAppId() async {
  try {
    final meta = html.document.querySelector('meta[name="worldcoin-app-id"]');
    final val = meta?.getAttribute('content')?.trim();
    if (val != null && val.isNotEmpty) return val;
  } catch (_) {}
  return null;
}

Future<String?> configuredAction() async {
  try {
    final meta = html.document.querySelector('meta[name="worldcoin-action"]');
    final val = meta?.getAttribute('content')?.trim();
    if (val != null && val.isNotEmpty) return val;
  } catch (_) {}
  return null;
}
