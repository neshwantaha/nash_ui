import 'dart:async';

import 'package:flutter/material.dart';

/// The current state of a [MorphButton].
enum MorphButtonState { idle, loading, success, error }

/// A button that morphs from a text label → spinning loader → ✓ / ✗ symbol.
///
/// ```dart
/// MorphButton(
///   label: 'Submit',
///   onPressed: () async {
///     await Future.delayed(const Duration(seconds: 2));
///     return true; // true = success, false = error
///   },
/// )
/// ```
class MorphButton extends StatefulWidget {
  const MorphButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.successColor = const Color(0xFF22C55E),
    this.errorColor = const Color(0xFFEF4444),
    this.height = 52,
    this.minWidth = 180,
    this.borderRadius = 28,
    this.resetDuration = const Duration(seconds: 2),
    this.textStyle,
    this.icon,
  });

  /// Label shown in the idle state.
  final String label;

  /// Async callback; return `true` for success, `false` / throw for error.
  final Future<bool> Function() onPressed;

  /// Primary button color (defaults to [ColorScheme.primary]).
  final Color? color;

  /// Color shown when state is [MorphButtonState.success].
  final Color successColor;

  /// Color shown when state is [MorphButtonState.error].
  final Color errorColor;

  final double height;
  final double minWidth;
  final double borderRadius;

  /// How long to show the result icon before resetting to idle.
  final Duration resetDuration;

  final TextStyle? textStyle;

  /// Optional leading icon in idle state.
  final IconData? icon;

  @override
  State<MorphButton> createState() => _MorphButtonState();
}

class _MorphButtonState extends State<MorphButton>
    with SingleTickerProviderStateMixin {
  MorphButtonState _state = MorphButtonState.idle;
  late AnimationController _ctrl;

  double _idleWidth = 0;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_state != MorphButtonState.idle) return;
    setState(() => _state = MorphButtonState.loading);
    _ctrl.forward();

    bool success;
    try {
      success = await widget.onPressed();
    } catch (_) {
      success = false;
    }

    if (!mounted) return;
    setState(() =>
        _state = success ? MorphButtonState.success : MorphButtonState.error);

    _resetTimer = Timer(widget.resetDuration, () {
      if (!mounted) return;
      _ctrl.reverse().then((_) {
        if (mounted) setState(() => _state = MorphButtonState.idle);
      });
    });
  }

  Color _bgColor(BuildContext context) => switch (_state) {
        MorphButtonState.loading =>
          (widget.color ?? Theme.of(context).colorScheme.primary)
              .withValues(alpha: 0.85),
        MorphButtonState.success => widget.successColor,
        MorphButtonState.error => widget.errorColor,
        _ => widget.color ?? Theme.of(context).colorScheme.primary,
      };

  @override
  Widget build(BuildContext context) {
    final isCollapsed = _state == MorphButtonState.loading ||
        _state == MorphButtonState.success ||
        _state == MorphButtonState.error;

    return LayoutBuilder(
      builder: (context, _) => GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          height: widget.height,
          width: isCollapsed
              ? widget.height
              : _idleWidth == 0
                  ? widget.minWidth
                  : _idleWidth,
          decoration: BoxDecoration(
            color: _bgColor(context),
            borderRadius: BorderRadius.circular(
                isCollapsed ? widget.height / 2 : widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: _bgColor(context).withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Center(
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) => switch (_state) {
        MorphButtonState.loading => SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        MorphButtonState.success =>
          const Icon(Icons.check_rounded, color: Colors.white, size: 26),
        MorphButtonState.error =>
          const Icon(Icons.close_rounded, color: Colors.white, size: 26),
        _ => MeasureSize(
            onChange: (size) {
              if (_idleWidth != size.width) {
                setState(() => _idleWidth = size.width);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 18),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: (widget.textStyle ??
                              const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600))
                          .copyWith(
                              color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
      };
}

/// Helper to measure a widget's rendered size.
class MeasureSize extends StatefulWidget {
  const MeasureSize({super.key, required this.child, required this.onChange});
  final Widget child;
  final void Function(Size size) onChange;
  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  final _key = GlobalKey();
  Size? _old;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _notify());
  }

  void _notify() {
    final ctx = _key.currentContext;
    if (ctx == null) return;
    final size = (ctx.findRenderObject() as RenderBox).size;
    if (size != _old) {
      _old = size;
      widget.onChange(size);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notify());
    return SizedBox(key: _key, child: widget.child);
  }
}
