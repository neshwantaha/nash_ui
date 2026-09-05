import 'dart:async';

/// A utility to delay function execution until a pause in invocation occurs.
///
/// Useful for search inputs, auto-saving forms, and resize events.
///
/// ```dart
/// final Debouncer debouncer = Debouncer(duration: const Duration(milliseconds: 300));
///
/// void onSearchChanged(String query) {
///   debouncer.run(() => fetchSearchResults(query));
/// }
/// ```
class Debouncer {
  /// Creates a debouncer that waits for [duration] before executing.
  Debouncer({this.duration = const Duration(milliseconds: 300)});

  /// The delay duration.
  final Duration duration;

  Timer? _timer;

  /// Runs [action] after [duration], canceling any previously scheduled call.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Cancels the pending execution if any.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Whether an execution is currently scheduled.
  bool get isPending => _timer != null && _timer!.isActive;

  /// Disposes the debouncer.
  void dispose() => cancel();
}

/// A utility to enforce a maximum execution frequency for a function.
///
/// Useful for scroll handlers, button tap protection, and rate-limited APIs.
///
/// ```dart
/// final Throttler throttler = Throttler(duration: const Duration(milliseconds: 500));
///
/// void onButtonPressed() {
///   throttler.run(() => submitPayment());
/// }
/// ```
class Throttler {
  /// Creates a throttler that permits execution at most once every [duration].
  Throttler({this.duration = const Duration(milliseconds: 500)});

  /// The minimum interval between executions.
  final Duration duration;

  DateTime? _lastExecutionTime;
  Timer? _trailingTimer;

  /// Runs [action] if [duration] has elapsed since the last execution.
  void run(void Function() action, {bool trailing = false}) {
    final DateTime now = DateTime.now();
    if (_lastExecutionTime == null ||
        now.difference(_lastExecutionTime!) >= duration) {
      _lastExecutionTime = now;
      action();
    } else if (trailing) {
      _trailingTimer?.cancel();
      final Duration remaining = duration - now.difference(_lastExecutionTime!);
      _trailingTimer = Timer(remaining, () {
        _lastExecutionTime = DateTime.now();
        action();
      });
    }
  }

  /// Resets the throttle timer.
  void reset() {
    _lastExecutionTime = null;
    _trailingTimer?.cancel();
    _trailingTimer = null;
  }

  /// Disposes the throttler.
  void dispose() => reset();
}
