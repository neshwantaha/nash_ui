import 'package:flutter/material.dart';

import 'duration.dart';

/// Supported page transition styles.
enum TransitionType {
  /// Fade only.
  fade,

  /// Slide up from the bottom (Android default feel).
  slideUp,

  /// Slide in from the right.
  slideRight,

  /// Slide in from the left.
  slideLeft,

  /// Scale from 0.92.
  scale,

  /// Fade + slight slide up (shared-axis-like).
  sharedAxis,
}

/// A [PageRouteBuilder] with configurable transitions.
///
/// ```dart
/// Navigator.of(context).push(
///   PageRoute(page: const ProfileScreen(), type: TransitionType.slideUp),
/// );
/// ```
class PageRoute<T> extends PageRouteBuilder<T> {
  PageRoute({
    required Widget page,
    this.type = TransitionType.sharedAxis,
    Duration duration = AppDuration.slow,
    Curve curve = AppCurves.standard,
    this.reverseDuration = AppDuration.slow,
    super.fullscreenDialog = false,
  }) : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              page,
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) =>
              TransitionSwitcher(
            animation: animation,
            type: type,
            curve: curve,
            child: child,
          ),
        );

  /// Transition style.
  final TransitionType type;

  /// Reverse transition duration.
  final Duration reverseDuration;
}

/// Applies an [TransitionType] transition to [child] driven by [animation].
class TransitionSwitcher extends StatelessWidget {
  const TransitionSwitcher({
    super.key,
    required this.animation,
    required this.child,
    this.type = TransitionType.sharedAxis,
    this.curve = AppCurves.standard,
  });

  /// The driving animation (0..1).
  final Animation<double> animation;

  /// The transitioning child.
  final Widget child;

  /// Transition style.
  final TransitionType type;

  /// Transition curve.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final CurvedAnimation curved =
        CurvedAnimation(parent: animation, curve: curve);
    final Widget faded = FadeTransition(opacity: curved, child: child);

    switch (type) {
      case TransitionType.fade:
        return faded;
      case TransitionType.slideUp:
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
                  .animate(curved),
          child: faded,
        );
      case TransitionType.slideRight:
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
                  .animate(curved),
          child: faded,
        );
      case TransitionType.slideLeft:
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(-0.08, 0), end: Offset.zero)
                  .animate(curved),
          child: faded,
        );
      case TransitionType.scale:
        return ScaleTransition(scale: curved, child: faded);
      case TransitionType.sharedAxis:
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
                  .animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
    }
  }
}
