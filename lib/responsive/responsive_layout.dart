import 'package:flutter/widgets.dart';

import 'breakpoint.dart';
import 'screen_type.dart';

/// Root widget of the responsive system.
///
/// Wraps your application (usually above `MaterialApp`) so that responsive
/// number extensions such as `10.w`, `20.h`, `16.r` and `5.v` scale against
/// the reference [designWidth]/[designHeight]. It also exposes the current
/// [screenType] via [AppResponsive.of].
///
/// ```dart
/// AppResponsive(
///   designWidth: 390,
///   designHeight: 844,
///   child: const MyApp(),
/// )
/// ```
class AppResponsive extends StatefulWidget {
  const AppResponsive({
    super.key,
    required this.child,
    this.designWidth = 390,
    this.designHeight = 844,
  });

  /// The widget tree that receives responsive context.
  final Widget child;

  /// The reference design width used to compute the width factor.
  final double designWidth;

  /// The reference design height used to compute the height factor.
  final double designHeight;

  /// Reads the active [AppScreenType] from an ancestor [AppResponsive] widget.
  ///
  /// Falls back to [AppScreenType.phone] when none is found.
  static AppScreenType screenTypeOf(BuildContext context) {
    final AppResponsiveState? state =
        context.findAncestorStateOfType<AppResponsiveState>();
    return state?.screenType ?? AppScreenType.phone;
  }

  @override
  State<AppResponsive> createState() => AppResponsiveState();
}

/// Mutable state holder for [AppResponsive].
class AppResponsiveState extends State<AppResponsive> {
  AppResponsiveState();

  static AppResponsiveState? _active;
  double _widthFactor = 1;
  double _heightFactor = 1;
  AppScreenType _screenType = AppScreenType.phone;

  /// Global width factor used by the `num.w` / `num.r` extensions.
  static double get globalWidthFactor => _active?._widthFactor ?? 1;

  /// Global height factor used by the `num.h` / `num.v` extensions.
  static double get globalHeightFactor => _active?._heightFactor ?? 1;

  /// Active screen type computed from the current constraints.
  AppScreenType get screenType => _screenType;

  /// Current width scale factor (screen width / design width).
  double get widthFactor => _widthFactor;

  /// Current height scale factor (screen height / design height).
  double get heightFactor => _heightFactor;

  /// Finds the nearest [AppResponsiveState] ancestor, if any.
  static AppResponsiveState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<AppResponsiveState>();

  @override
  void dispose() {
    if (_active == this) {
      _active = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _active = this;
    final Size size = MediaQuery.sizeOf(context);
    _widthFactor = size.width / widget.designWidth;
    _heightFactor = size.height / widget.designHeight;
    _screenType = screenTypeFor(size.width);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width =
            constraints.maxWidth.isFinite ? constraints.maxWidth : size.width;
        _widthFactor = width / widget.designWidth;
        _screenType = screenTypeFor(width);
        return widget.child;
      },
    );
  }
}

/// Classifies a [width] into an [AppScreenType].
AppScreenType screenTypeFor(double width) {
  if (width < AppBreakpoint.phone) return AppScreenType.phone;
  if (width < AppBreakpoint.tablet) return AppScreenType.tablet;
  return AppScreenType.desktop;
}
