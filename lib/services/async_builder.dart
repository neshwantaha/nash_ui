import 'package:flutter/material.dart';

import '../animation/fade.dart';
import '../widgets/loading/loading_widgets.dart';
import '../widgets/ux/ux_states.dart';

/// An enum describing the state of an [AsyncBuilder].
enum AsyncStatus {
  /// The future is still running.
  loading,

  /// The future completed successfully.
  done,

  /// The future threw an error.
  error,
}

/// Builds loading, error and success UI from a `Future`.
///
/// ```dart
/// AsyncBuilder<String>(
///   future: fetchProfile(),
///   onDone: (BuildContext context, String value) => Text(value),
///   onError: (BuildContext context, Object error) =>
///       ErrorState(onRetry: () => setState(() {})),
/// )
/// ```
class AsyncBuilder<T> extends StatefulWidget {
  const AsyncBuilder({
    super.key,
    this.future,
    this.initialValue,
    this.loading,
    this.onLoading,
    this.onError,
    this.onDone,
    this.retryOnError = true,
  });

  /// The future to await. Re-run by calling [retry].
  final Future<T>? Function()? future;

  /// Value shown until the first future completes.
  final T? initialValue;

  /// Placeholder widget shown while loading.
  final Widget? loading;

  /// Builds the loading UI (used when [loading] is null).
  final Widget Function(BuildContext context)? onLoading;

  /// Builds the error UI.
  final Widget Function(BuildContext context, Object error, StackTrace? stack)?
      onError;

  /// Builds the success UI.
  final Widget Function(BuildContext context, T value)? onDone;

  /// Whether to expose a retry callback that re-runs [future].
  final bool retryOnError;

  @override
  State<AsyncBuilder<T>> createState() => _AsyncBuilderState<T>();
}

class _AsyncBuilderState<T> extends State<AsyncBuilder<T>> {
  AsyncStatus _status = AsyncStatus.loading;
  T? _value;
  Object? _error;
  StackTrace? _stack;

  @override
  void initState() {
    super.initState();
    _run();
  }

  @override
  void didUpdateWidget(AsyncBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.future != widget.future) _run();
  }

  Future<void> _run() async {
    setState(() {
      _status = AsyncStatus.loading;
    });
    try {
      final T? result = await widget.future?.call();
      if (!mounted) return;
      setState(() {
        _value = result;
        _status = AsyncStatus.done;
      });
    } catch (error, stack) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _stack = stack;
        _status = AsyncStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case AsyncStatus.loading:
        return widget.loading ??
            widget.onLoading?.call(context) ??
            const LoadingScreen();
      case AsyncStatus.error:
        if (widget.onError != null) {
          return widget.onError!(context, _error!, _stack);
        }
        return ErrorState(
          onRetry: widget.retryOnError ? _run : null,
        );
      case AsyncStatus.done:
        final T value = _value ?? widget.initialValue as T;
        if (widget.onDone == null) {
          return const SizedBox.shrink();
        }
        return FadeAnimation(child: widget.onDone!(context, value));
    }
  }
}
