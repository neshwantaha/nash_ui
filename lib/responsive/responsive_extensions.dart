import 'package:flutter/material.dart';

import 'breakpoint.dart';
import 'responsive_layout.dart';
import 'screen_type.dart';

/// Responsive context extensions.
///
/// ```dart
/// context.width            // screen width in dp
/// context.isPhone          // true when width < 600
/// context.screenType       // AppScreenType.phone
/// ```
extension ContextResponsiveX on BuildContext {
  /// Full screen width in logical pixels.
  double get width => MediaQuery.sizeOf(this).width;

  /// Full screen height in logical pixels.
  double get height => MediaQuery.sizeOf(this).height;

  /// True when the screen width is below the phone breakpoint.
  bool get isPhone => width < AppBreakpoint.phone;

  /// True when the screen width is in the tablet range.
  bool get isTablet =>
      width >= AppBreakpoint.phone && width < AppBreakpoint.tablet;

  /// True when the screen width is at or above the tablet breakpoint.
  bool get isDesktop => width >= AppBreakpoint.tablet;

  /// True when the screen is taller than it is wide.
  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;

  /// True when the screen is wider than it is tall.
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// Current orientation.
  Orientation get orientation => MediaQuery.orientationOf(this);

  /// Classified screen type ([AppScreenType.phone], [AppScreenType.tablet] or
  /// [AppScreenType.desktop]).
  AppScreenType get screenType => AppResponsive.screenTypeOf(this);

  /// The active [AppResponsiveState] if one is present, otherwise `null`.
  AppResponsiveState? get responsive => AppResponsiveState.maybeOf(this);

  /// Top padding including status bar / safe area.
  double get safeTop => MediaQuery.paddingOf(this).top;

  /// Bottom padding including system navigation / safe area.
  double get safeBottom => MediaQuery.paddingOf(this).bottom;

  /// The `Theme.of(this)` instance.
  ThemeData get theme => Theme.of(this);
}

/// Responsive number extensions.
///
/// ```dart
/// SizedBox(width: 10.w)          // scaled width
/// EdgeInsets.all(16.r)           // scaled radius
/// SizedBox(height: 20.h)         // scaled height
/// ```
extension NumResponsiveX on num {
  /// Scaled width value (`value * widthFactor`).
  double get w => toDouble() * AppResponsiveState.globalWidthFactor;

  /// Scaled height value (`value * heightFactor`).
  double get h => toDouble() * AppResponsiveState.globalHeightFactor;

  /// Scaled radius value (uses width factor).
  double get r => toDouble() * AppResponsiveState.globalWidthFactor;

  /// Scaled vertical value (uses height factor).
  double get v => toDouble() * AppResponsiveState.globalHeightFactor;

  /// A [SizedBox] with scaled width.
  SizedBox get spaceW => SizedBox(width: w);

  /// A [SizedBox] with scaled height.
  SizedBox get spaceH => SizedBox(height: h);
}
