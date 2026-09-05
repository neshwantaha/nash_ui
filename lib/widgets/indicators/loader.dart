import 'package:flutter/material.dart';

import '../../spacing/app_spacing.dart';
import '../../typography/font_weight.dart';

/// Loader style selector.
enum LoaderStyle {
  /// Circular spinner.
  circular,

  /// Three bouncing dots.
  dots,

  /// Pulsing box.
  pulse,
}

/// A flexible loading indicator with multiple styles.
class Loader extends StatelessWidget {
  const Loader({
    super.key,
    this.style = LoaderStyle.circular,
    this.color,
    this.size = 32,
    this.strokeWidth = 3,
    this.label,
    this.labelColor,
    this.centered = false,
  });

  /// Loader style.
  final LoaderStyle style;

  /// Loader color.
  final Color? color;

  /// Loader size.
  final double size;

  /// Spinner stroke width.
  final double strokeWidth;

  /// Optional label below the loader.
  final String? label;

  /// Label color.
  final Color? labelColor;

  /// Whether to center the loader in its parent.
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color accent = color ?? scheme.primary;

    final Widget indicator = switch (style) {
      LoaderStyle.circular => SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: accent,
            strokeWidth: strokeWidth,
          ),
        ),
      LoaderStyle.dots => _DotsLoader(color: accent, size: size),
      LoaderStyle.pulse => _PulseLoader(color: accent, size: size),
    };

    final Widget column = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        indicator,
        if (label != null) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          Text(
            label!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: labelColor ?? scheme.onSurfaceVariant,
                  fontWeight: AppFontWeight.medium,
                ),
          ),
        ],
      ],
    );

    if (!centered) return column;
    return Center(child: column);
  }
}

class _DotsLoader extends StatefulWidget {
  const _DotsLoader({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double dotSize = widget.size * 0.22;
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < 3; i++) ...<Widget>[
            _dot(i, dotSize),
            if (i < 2) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _dot(int index, double dotSize) {
    final double phase = (_controller.value - index * 0.16) % 1.0;
    final double scale = phase < 0.5
        ? 0.6 + 0.8 * (phase / 0.5)
        : 1.4 - 0.8 * ((phase - 0.5) / 0.5);
    return Opacity(
      opacity: 0.4 + 0.6 * (1 - (scale - 1).abs().clamp(0, 1)),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: dotSize,
          height: dotSize,
          decoration:
              BoxDecoration(color: widget.color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _PulseLoader extends StatefulWidget {
  const _PulseLoader({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  State<_PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<_PulseLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) => ScaleTransition(
          scale: Tween<double>(begin: 0.7, end: 1.1).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
          child: Opacity(
            opacity: 0.4 + 0.6 * _controller.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.size * 0.3),
              ),
            ),
          ),
        ),
      );
}
