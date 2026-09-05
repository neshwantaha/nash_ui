import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ErrorBoundary — Widget-level error catching
// ─────────────────────────────────────────────────────────────────────────────

/// Catches Flutter widget build errors and shows a styled fallback UI.
///
/// In debug mode, shows the full error details.
/// In release mode, shows a friendly message.
///
/// ```dart
/// ErrorBoundary(
///   child: MyRiskyWidget(),
///   onError: (error, stack) => logger.e(error),
/// )
/// ```
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
    this.onError,
    this.title = 'Something went wrong',
    this.subtitle = 'An unexpected error occurred. Please try again.',
  });

  /// The widget to monitor.
  final Widget child;

  /// Custom fallback widget. If null, the default styled error card is shown.
  final Widget? fallback;

  /// Called when an error is caught.
  final void Function(Object error, StackTrace stack)? onError;

  final String title;
  final String subtitle;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallback ??
          _DefaultErrorView(
            title: widget.title,
            subtitle: widget.subtitle,
            error: _error,
            onRetry: () => setState(() {
              _error = null;
            }),
          );
    }

    return _ErrorCatcher(
      child: widget.child,
      onError: (error, stack) {
        widget.onError?.call(error, stack);
        setState(() {
          _error = error;
        });
      },
    );
  }
}

class _ErrorCatcher extends StatelessWidget {
  const _ErrorCatcher({required this.child, required this.onError});
  final Widget child;
  final void Function(Object, StackTrace) onError;

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (details) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onError(details.exception, details.stack ?? StackTrace.current);
      });
      return const SizedBox.shrink();
    };
    return child;
  }
}

class _DefaultErrorView extends StatelessWidget {
  const _DefaultErrorView({
    required this.title,
    required this.subtitle,
    required this.onRetry,
    this.error,
  });

  final String title;
  final String subtitle;
  final VoidCallback onRetry;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E0A0A) : const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, color: scheme.error, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: scheme.error,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.6),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          if (error != null && _isDebug()) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                error.toString(),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: Colors.red,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  bool _isDebug() {
    bool debug = false;
    assert(() {
      debug = true;
      return true;
    }());
    return debug;
  }
}
