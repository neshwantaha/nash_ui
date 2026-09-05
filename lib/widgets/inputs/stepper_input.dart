import 'package:flutter/material.dart';

/// A numeric stepper input with increment / decrement buttons.
///
/// Supports integer and double values, min/max clamping, long-press
/// acceleration, and optional label.
///
/// ```dart
/// StepperInput(
///   value: _count,
///   min: 0,
///   max: 99,
///   onChanged: (v) => setState(() => _count = v),
/// )
/// ```
class StepperInput extends StatefulWidget {
  const StepperInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.step = 1,
    this.label,
    this.buttonSize = 36,
    this.textStyle,
    this.activeColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
    this.longPressRepeatDelay = const Duration(milliseconds: 80),
  });

  /// Current numeric value.
  final num value;

  /// Called with the new value after increment or decrement.
  final ValueChanged<num> onChanged;

  /// Minimum allowed value.
  final num min;

  /// Maximum allowed value.
  final num max;

  /// Amount to add / subtract per tap.
  final num step;

  /// Optional label shown below the control.
  final String? label;

  /// Size of the +/- icon buttons.
  final double buttonSize;

  /// Style for the value text.
  final TextStyle? textStyle;

  /// Accent color for buttons and borders.
  final Color? activeColor;

  /// Border radius of the container.
  final BorderRadius borderRadius;

  /// Padding around the row.
  final EdgeInsetsGeometry padding;

  /// Interval between repeated increments during long press.
  final Duration longPressRepeatDelay;

  @override
  State<StepperInput> createState() => _StepperInputState();
}

class _StepperInputState extends State<StepperInput> {
  void _increment() {
    final next = widget.value + widget.step;
    if (next <= widget.max) widget.onChanged(next);
  }

  void _decrement() {
    final next = widget.value - widget.step;
    if (next >= widget.min) widget.onChanged(next);
  }

  Widget _button({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    final color = widget.activeColor ?? Theme.of(context).colorScheme.primary;
    return _LongPressButton(
      onTap: enabled ? onTap : null,
      repeatDelay: widget.longPressRepeatDelay,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.buttonSize,
        height: widget.buttonSize,
        decoration: BoxDecoration(
          color: enabled ? color.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: widget.borderRadius,
        ),
        child: Icon(
          icon,
          size: widget.buttonSize * 0.55,
          color: enabled ? color : color.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canDecrement = widget.value > widget.min;
    final canIncrement = widget.value < widget.max;
    final theme = Theme.of(context);

    final control = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        border: Border.all(
          color: (widget.activeColor ?? theme.colorScheme.primary)
              .withValues(alpha: 0.3),
        ),
        borderRadius: widget.borderRadius,
        color: theme.colorScheme.surfaceContainerLowest,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button(
            icon: Icons.remove,
            onTap: _decrement,
            enabled: canDecrement,
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Text(
              _formatValue(widget.value),
              key: ValueKey(widget.value),
              style: widget.textStyle ??
                  theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
            ),
          ),
          const SizedBox(width: 8),
          _button(
            icon: Icons.add,
            onTap: _increment,
            enabled: canIncrement,
          ),
        ],
      ),
    );

    if (widget.label == null) return control;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        control,
        const SizedBox(height: 4),
        Text(
          widget.label!,
          style: theme.textTheme.labelSmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  String _formatValue(num v) {
    if (v is int) return v.toString();
    if (v == v.truncate()) return v.truncate().toString();
    return v.toStringAsFixed(1);
  }
}

/// Internal widget that handles long-press repeated callbacks.
class _LongPressButton extends StatefulWidget {
  const _LongPressButton({
    required this.child,
    required this.onTap,
    required this.repeatDelay,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Duration repeatDelay;

  @override
  State<_LongPressButton> createState() => _LongPressButtonState();
}

class _LongPressButtonState extends State<_LongPressButton> {
  bool _pressing = false;

  void _startRepeat() async {
    _pressing = true;
    while (_pressing && mounted && widget.onTap != null) {
      widget.onTap!();
      await Future<void>.delayed(widget.repeatDelay);
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.onTap,
        onLongPressStart: (_) => _startRepeat(),
        onLongPressEnd: (_) => _pressing = false,
        child: widget.child,
      );
}
