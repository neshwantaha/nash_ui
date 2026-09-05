import 'dart:async';
import 'package:web/web.dart' as web;

/// Returns true if the device has internet connectivity (Web/Wasm).
Future<bool> checkConnectivity(String host) async {
  try {
    return web.window.navigator.onLine;
  } catch (_) {
    return true;
  }
}
