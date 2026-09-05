import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

/// Animation helpers built on top of Flutter's animation primitives.
abstract final class AnimationUtils {
  AnimationUtils._();

  /// Wraps [parent] with a [CurvedAnimation].
  static Animation<double> curved(
    Animation<double> parent,
    Curve curve, {
    Curve? reverseCurve,
  }) =>
      CurvedAnimation(parent: parent, curve: curve, reverseCurve: reverseCurve);

  /// Builds an interval animation: [begin]–[end] are 0–1 points along [parent].
  static Animation<double> interval(
    Animation<double> parent,
    double begin,
    double end, {
    Curve curve = Curves.easeInOut,
  }) =>
      CurveTween(curve: Interval(begin, end, curve: curve)).animate(parent);

  /// A [Tween] between [begin] and [end].
  static Tween<double> between(double begin, double end) =>
      Tween<double>(begin: begin, end: end);

  /// The reverse of [parent]'s controller progress (1 - value).
  static double inverse(double value) => 1 - value;

  /// Returns [duration] scaled by a factor (useful for staggered layouts).
  static Duration scaled(Duration duration, double factor) =>
      Duration(milliseconds: (duration.inMilliseconds * factor).round());

  /// A staggered delay for item [index] in a list of [count] items.
  static Duration stagger(
    int index, {
    Duration step = const Duration(milliseconds: 60),
  }) =>
      Duration(milliseconds: index * step.inMilliseconds);
}
