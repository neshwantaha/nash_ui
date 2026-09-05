import 'package:flutter/material.dart';

import 'duration.dart';

/// A [Hero] wrapper with sensible defaults for [child] and [tag].
class HeroWidget extends StatelessWidget {
  const HeroWidget({
    super.key,
    required this.tag,
    required this.child,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.placeholderBuilder,
    this.transitionOnUserGestures = false,
    this.duration = AppDuration.slow,
  });

  /// Hero tag.
  final Object tag;

  /// The hero child.
  final Widget child;

  /// Rect tween between flight endpoints.
  final CreateRectTween? createRectTween;

  /// Custom flight builder.
  final HeroFlightShuttleBuilder? flightShuttleBuilder;

  /// Placeholder shown at the destination before flight.
  final HeroPlaceholderBuilder? placeholderBuilder;

  /// Whether hero animations occur during gesture navigation.
  final bool transitionOnUserGestures;

  /// Flight duration.
  final Duration duration;

  @override
  Widget build(BuildContext context) => Hero(
        tag: tag,
        createRectTween: createRectTween,
        flightShuttleBuilder: flightShuttleBuilder,
        placeholderBuilder: placeholderBuilder,
        transitionOnUserGestures: transitionOnUserGestures,
        child: child,
      );
}
