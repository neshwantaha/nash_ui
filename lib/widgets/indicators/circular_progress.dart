import 'package:flutter/material.dart';

/// A circular progress indicator with value, percent and gradient support.
class CircularProgress extends StatelessWidget {
  const CircularProgress({
    super.key,
    this.value,
    this.size = 72,
    this.strokeWidth = 6,
    this.color,
    this.backgroundColor,
    this.gradient,
    this.showPercent = true,
    this.percentTextStyle,
    this.label,
    this.labelStyle,
    this.animate = true,
    this.duration = const Duration(milliseconds: 800),
  });

  /// Progress value (0–1); null renders an indeterminate spinner.
  final double? value;

  /// Widget size.
  final double size;

  /// Stroke width.
  final double strokeWidth;

  /// Progress color.
  final Color? color;

  /// Track background color.
  final Color? backgroundColor;

  /// Progress gradient (overrides [color]).
  final Gradient? gradient;

  /// Whether to show the perceTage in the center.
  final bool showPercent;

  /// Percent text style.
  final TextStyle? percentTextStyle;

  /// Optional label under the percent.
  final String? label;

  /// Label text style.
  final TextStyle? labelStyle;

  /// Whether to animate value changes.
  final bool animate;

  /// Animation duration.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color resolved = color ?? scheme.primary;
    final double? p = value?.clamp(0, 1);
    final AlignmentGeometry? gBegin =
        gradient is LinearGradient ? (gradient as LinearGradient).begin : null;
    final AlignmentGeometry? gEnd =
        gradient is LinearGradient ? (gradient as LinearGradient).end : null;

    Widget bar = TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: p ?? 0),
      duration: animate ? duration : Duration.zero,
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double v, Widget? child) =>
          CircularProgressIndicator(
        value: value == null ? null : v,
        strokeWidth: strokeWidth,
        backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(
          gradient != null ? Colors.white : resolved,
        ),
      ),
    );

    if (gradient != null) {
      bar = ShaderMask(
        shaderCallback: (Rect bounds) => LinearGradient(
          colors: gradient!.colors,
          begin: gBegin ?? Alignment.centerLeft,
          end: gEnd ?? Alignment.centerRight,
        ).createShader(bounds),
        child: bar,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(width: size, height: size, child: bar),
          if (showPercent && p != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${(p * 100).round()}%',
                  style: percentTextStyle ??
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                ),
                if (label != null)
                  Text(
                    label!,
                    style: labelStyle ??
                        Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
