import 'dart:async';
import 'dart:io';

/// Returns true if the device has internet connectivity (IO/mobile/desktop).
Future<bool> checkConnectivity(String host) async {
  try {
    final result =
        await InternetAddress.lookup(host).timeout(const Duration(seconds: 4));
    return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
