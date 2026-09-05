import 'package:flutter/widgets.dart';

/// Animation duration tokens.
abstract final class AppDuration {
  AppDuration._();

  /// 100ms — micro interactions, focus states.
  static const Duration micro = Duration(milliseconds: 100);

  /// 150ms — fast transitions.
  static const Duration fast = Duration(milliseconds: 150);

  /// 250ms — standard element transitions.
  static const Duration normal = Duration(milliseconds: 250);

  /// 400ms — deliberate, page transitions.
  static const Duration slow = Duration(milliseconds: 400);

  /// 600ms — hero and showcase transitions.
  static const Duration verySlow = Duration(milliseconds: 600);
}

/// Animation curve tokens.
abstract final class AppCurves {
  AppCurves._();

  /// Standard Material motion curve.
  static const Curve standard = Curves.easeInOutCubic;

  /// Ease-out for entrances.
  static const Curve easeOut = Curves.easeOutCubic;

  /// Ease-in for exits.
  static const Curve easeIn = Curves.easeInCubic;

  /// Springy bounce used for playful emphasis.
  static const Curve bounceOut = Curves.easeOutBack;

  /// Smooth linear motion.
  static const Curve linear = Curves.linear;

  /// Deceleration curve for sheets.
  static const Curve decelerate = Curves.decelerate;
}
