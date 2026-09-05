import 'package:flutter/widgets.dart';

/// Reduced motion support for the design system.
///
/// Detects system-level reduced motion preferences and provides utilities
/// to disable or minimize animations when requested.
///
/// ```dart
/// if (ReducedMotion.of(context)) {
///   // Skip animation
///   return child;
/// }
/// ```
abstract final class ReducedMotion {
  ReducedMotion._();

  /// Whether the system or app requests reduced motion.
  static bool of(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  /// Returns a [Duration] that respects reduced motion.
  ///
  /// When reduced motion is enabled, returns [Duration.zero] or a minimal
  /// duration. Otherwise returns the given [duration].
  static Duration duration(BuildContext context, Duration duration) =>
      of(context) ? Duration.zero : duration;

  /// Returns an animation duration that respects reduced motion.
  static Duration animationDuration(BuildContext context,
          {Duration? fallback}) =>
      of(context)
          ? const Duration(milliseconds: 1)
          : (fallback ?? const Duration(milliseconds: 300));

  /// Wraps a child with conditional animation.
  ///
  /// When reduced motion is active, returns [child] without animation.
  static Widget wrap({
    required BuildContext context,
    required Widget child,
    required Widget animatedChild,
  }) =>
      of(context) ? child : animatedChild;

  /// Returns a curve that respects reduced motion.
  ///
  /// When reduced motion is active, returns [Curves.linear] (instant).
  static Curve curve(BuildContext context,
          {Curve fallback = Curves.easeInOut}) =>
      of(context) ? Curves.linear : fallback;
}

/// A widget that conditionally applies animation based on reduced motion.
///
/// ```dart
/// ReducedMotionWrapper(
///   child: MyContent(),
///   animatedChild: MyAnimatedContent(),
/// )
/// ```
class ReducedMotionWrapper extends StatelessWidget {
  const ReducedMotionWrapper({
    super.key,
    required this.child,
    required this.animatedChild,
  });

  /// Non-animated version of the child.
  final Widget child;

  /// Animated version of the child.
  final Widget animatedChild;

  @override
  Widget build(BuildContext context) => ReducedMotion.wrap(
        context: context,
        child: child,
        animatedChild: animatedChild,
      );
}

/// Extension on BuildContext for reduced motion checks.
extension ReducedMotionX on BuildContext {
  /// Whether the system requests reduced motion.
  bool get prefersReducedMotion => ReducedMotion.of(this);
}
