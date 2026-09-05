import 'dart:async';

import 'package:flutter/material.dart';

/// A countdown timer widget.
///
/// ```dart
/// CountDownTimer(
///   duration: Duration(minutes: 5),
///   onFinished: () => print('Time is up!'),
/// )
/// ```
class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    super.key,
    required this.duration,
    this.onFinished,
    this.onTick,
    this.style,
    this.autoStart = true,
    this.format = CountDownFormat.hms,
  });

  final Duration duration;
  final VoidCallback? onFinished;
  final void Function(Duration remaining)? onTick;
  final TextStyle? style;
  final bool autoStart;
  final CountDownFormat format;

  @override
  State<CountDownTimer> createState() => CountDownTimerState();
}

enum CountDownFormat { hms, ms, s }

class CountDownTimerState extends State<CountDownTimer> {
  late Duration _remaining;
  Timer? _timer;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    if (widget.autoStart) start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void start() {
    if (_running) return;
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 0) {
        _timer?.cancel();
        _running = false;
        widget.onFinished?.call();
        setState(() {});
        return;
      }
      setState(() => _remaining -= const Duration(seconds: 1));
      widget.onTick?.call(_remaining);
    });
  }

  void pause() {
    _timer?.cancel();
    _running = false;
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      _remaining = widget.duration;
      _running = false;
    });
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    switch (widget.format) {
      case CountDownFormat.hms:
        return '$h:$m:$s';
      case CountDownFormat.ms:
        return '$m:$s';
      case CountDownFormat.s:
        return '${d.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) => Text(
        _format(_remaining),
        style: widget.style ??
            Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontFamily: 'monospace'),
      );
}

// ---------------------------------------------------------------------------

/// A stopwatch widget that counts up.
///
/// ```dart
/// final _sw = GlobalKey<StopWatchState>();
///
/// StopWatch(key: _sw)
/// _sw.currentState?.start();
/// ```
class StopWatch extends StatefulWidget {
  const StopWatch({
    super.key,
    this.style,
    this.autoStart = false,
    this.format = CountDownFormat.hms,
    this.onTick,
  });

  final TextStyle? style;
  final bool autoStart;
  final CountDownFormat format;
  final void Function(Duration elapsed)? onTick;

  @override
  State<StopWatch> createState() => StopWatchState();
}

class StopWatchState extends State<StopWatch> {
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void start() {
    if (_running) return;
    _running = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed += const Duration(seconds: 1));
      widget.onTick?.call(_elapsed);
    });
  }

  void pause() {
    _timer?.cancel();
    _running = false;
  }

  void reset() {
    _timer?.cancel();
    setState(() {
      _elapsed = Duration.zero;
      _running = false;
    });
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    switch (widget.format) {
      case CountDownFormat.hms:
        return '$h:$m:$s';
      case CountDownFormat.ms:
        return '$m:$s';
      case CountDownFormat.s:
        return '${d.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) => Text(
        _format(_elapsed),
        style: widget.style ??
            Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontFamily: 'monospace'),
      );
}
