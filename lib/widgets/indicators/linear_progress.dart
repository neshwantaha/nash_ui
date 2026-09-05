import 'package:flutter/material.dart';

/// A linear progress bar with gradient, stripes and label.
class LinearProgress extends StatelessWidget {
  const LinearProgress({
    super.key,
    this.value,
    this.height = 8,
    this.color,
    this.backgroundColor,
    this.gradient,
    this.showLabel = false,
    this.label,
    this.rounded = true,
    this.striped = false,
    this.animate = true,
    this.duration = const Duration(milliseconds: 700),
  });

  /// Progress value (0–1); null renders an indeterminate bar.
  final double? value;

  /// Bar height.
  final double height;

  /// Bar color.
  final Color? color;

  /// Track background color.
  final Color? backgroundColor;

  /// Bar gradient (overrides [color]).
  final Gradient? gradient;

  /// Whether to show a perceTage label.
  final bool showLabel;

  /// Custom label text.
  final String? label;

  /// Rounded ends.
  final bool rounded;

  /// Striped progress effect.
  final bool striped;

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

    Widget bar;
    if (p == null) {
      bar = LinearProgressIndicator(
        minHeight: height,
        backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
        color: resolved,
      );
    } else {
      Widget inner = Container(
        width: double.infinity,
        height: height,
        color: gradient != null ? Colors.white : resolved,
      );
      if (gradient != null) {
        inner = ShaderMask(
          shaderCallback: (Rect bounds) => LinearGradient(
            colors: gradient!.colors,
            begin: gBegin ?? Alignment.centerLeft,
            end: gEnd ?? Alignment.centerRight,
          ).createShader(bounds),
          child: inner,
        );
      }
      if (striped) {
        inner = CustomPaint(
          painter: _StripePainter(stripe: Colors.white.withValues(alpha: 0.25)),
          child: inner,
        );
      }

      bar = TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: p),
        duration: animate ? duration : Duration.zero,
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double v, Widget? child) => ClipRRect(
          borderRadius: BorderRadius.circular(rounded ? 100 : 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: v,
              child: SizedBox(
                width: double.infinity,
                height: height,
                child: inner,
              ),
            ),
          ),
        ),
      );
    }

    bar = ClipRRect(
      borderRadius: BorderRadius.circular(rounded ? 100 : 0),
      child: SizedBox(height: height, child: bar),
    );

    if (!showLabel) return bar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        bar,
        const SizedBox(height: 4),
        Text(
          label ?? (p == null ? '' : '${(p * 100).round()}%'),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _StripePainter extends CustomPainter {
  const _StripePainter({required this.stripe});

  final Color stripe;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = stripe;
    const double step = 14;
    for (double x = 0; x < size.width; x += step) {
      final Path path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + step * 0.5, 0)
        ..lineTo(x - step * 0.5, size.height)
        ..lineTo(x - step, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_StripePainter oldDelegate) =>
      oldDelegate.stripe != stripe;
}
