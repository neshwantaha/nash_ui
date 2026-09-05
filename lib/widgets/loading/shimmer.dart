import 'package:flutter/material.dart';
import '../../radius/app_radius.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer — Animated shimmer loading effect
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps any widget with a shimmer sweep animation, ideal for loading states.
///
/// ```dart
/// Shimmer(
///   child: ShimmerCard(),
/// )
/// ```
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.enabled = true,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  /// The widget to apply the shimmer effect to.
  final Widget child;

  /// Whether the shimmer effect is active. Set to false to show the real content.
  final bool enabled;

  /// Base shimmer color (defaults to surface variant).
  final Color? baseColor;

  /// Highlight sweep color (defaults to a lighter variant).
  final Color? highlightColor;

  /// Duration of one shimmer sweep.
  final Duration period;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = widget.baseColor ??
        (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0));
    final highlight = widget.highlightColor ??
        (isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC));

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          colors: [base, highlight, base],
          stops: const [0.0, 0.5, 1.0],
          transform: _SlidingGradientTransform(_animation.value),
        ).createShader(bounds),
        child: child,
      ),
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);
  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
}

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer Placeholder Presets
// ─────────────────────────────────────────────────────────────────────────────

/// A simple rectangle shimmer placeholder.
///
/// ```dart
/// Shimmer(child: ShimmerBox(width: 200, height: 20))
/// ```
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.enabled = true,
  });

  final double? width;
  final double height;
  final double? borderRadius;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.small),
      ),
    );

    return Shimmer(enabled: enabled, child: box);
  }
}

/// A card-shaped shimmer placeholder with avatar, title, and subtitle.
///
/// ```dart
/// ShimmerCard()
/// ```
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, this.enabled = true});
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    Widget box(double w, double h, {double? radius}) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius ?? AppRadius.small),
          ),
        );

    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          box(48, 48, radius: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                box(double.infinity, 14),
                const SizedBox(height: 8),
                box(160, 12),
                const SizedBox(height: 6),
                box(100, 10),
              ],
            ),
          ),
        ],
      ),
    );

    return Shimmer(enabled: enabled, child: card);
  }
}

/// A list of shimmer card placeholders.
///
/// ```dart
/// ShimmerList(itemCount: 5)
/// ```
class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.spacing = 12,
    this.enabled = true,
  });

  final int itemCount;
  final double spacing;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(
          itemCount,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: i < itemCount - 1 ? spacing : 0),
            child: ShimmerCard(enabled: enabled),
          ),
        ),
      );
}

/// A full-width banner shimmer placeholder.
class ShimmerBanner extends StatelessWidget {
  const ShimmerBanner({
    super.key,
    this.height = 160,
    this.enabled = true,
  });

  final double height;
  final bool enabled;

  @override
  Widget build(BuildContext context) => ShimmerBox(
        width: double.infinity,
        height: height,
        borderRadius: AppRadius.large,
        enabled: enabled,
      );
}
