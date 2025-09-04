// Aggregator for World ID web interop
// Uses conditional import to provide no-op stubs on non-web platforms

import 'world_id_interop_stub.dart'
    if (dart.library.html) 'world_id_interop_web.dart' as impl;

Future<bool> worldIdAvailable() => impl.worldIdAvailable();

/// Opens the Worldcoin IDKit widget. Returns the raw result map from the
/// browser wrapper or null if user cancels/closes.
Future<Map<String, dynamic>?> openWorldId({
  String? appId,
  String? action,
  String? signal,
}) => impl.openWorldId(appId: appId, action: action, signal: signal);

/// Optionally read configured app_id from HTML meta tags (web only). Returns null on non-web.
Future<String?> configuredAppId() => impl.configuredAppId();

/// Optionally read configured action from HTML meta tags (web only). Returns null on non-web.
Future<String?> configuredAction() => impl.configuredAction();
