import 'dart:async';

import 'package:flutter/foundation.dart';

/// Log severity levels.
enum LogLevel {
  /// Verbose debug messages.
  debug,

  /// Informational messages.
  info,

  /// Warnings that should be noticed.
  warning,

  /// Errors that should be fixed.
  error,

  /// Fatal issues that stop execution.
  critical,
}

/// A lightweight, dependency-free logger with level filtering.
///
/// ```dart
/// Logger.enabled = true;
/// Logger.level = LogLevel.debug;
/// Logger.d('Building profile screen');
/// Logger.e('Failed to load', error);
/// ```
abstract final class Logger {
  Logger._();

  /// Global on/off switch.
  static bool enabled = true;

  /// Minimum level that will be printed.
  static LogLevel level = LogLevel.debug;

  /// Optional external sink (e.g. sentry). Receives formatted lines.
  static void Function(String line)? sink;

  /// Logs a debug message.
  static void d(String message, [Object? error, StackTrace? stack]) =>
      _log(LogLevel.debug, message, error, stack);

  /// Logs an info message.
  static void i(String message, [Object? error, StackTrace? stack]) =>
      _log(LogLevel.info, message, error, stack);

  /// Logs a warning.
  static void w(String message, [Object? error, StackTrace? stack]) =>
      _log(LogLevel.warning, message, error, stack);

  /// Logs an error.
  static void e(String message, [Object? error, StackTrace? stack]) =>
      _log(LogLevel.error, message, error, stack);

  /// Logs a critical message.
  static void c(String message, [Object? error, StackTrace? stack]) =>
      _log(LogLevel.critical, message, error, stack);

  static void _log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stack,
  ]) {
    if (!enabled || level.index < Logger.level.index) return;
    final String line = _format(level, message);
    // ignore: avoid_print
    print(line);
    sink?.call(line);
    if (error != null) {
      final String errorLine = '$line\n  ${error.toString()}';
      // ignore: avoid_print
      print(errorLine);
      if (stack != null) {
        // ignore: avoid_print
        print('$errorLine\n  $stack');
      }
    }
  }

  static String _format(LogLevel level, String message) {
    final String tag = level.name.toUpperCase().padRight(8);
    final String time =
        '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}';
    return '$time [$tag] $message';
  }
}

/// A tiny debouncer helper for throttling rapid calls.
class Debouncer {
  Debouncer(this.delay);

  /// Delay between calls.
  final Duration delay;

  Timer? _timer;

  /// Schedules [action], cancelling any pending invocation.
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels any pending invocation.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
