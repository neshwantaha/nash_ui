import 'dart:async';

/// Default fallback for connectivity check (pure Dart, no platform dependencies).
Future<bool> checkConnectivity(String host) async => true;
