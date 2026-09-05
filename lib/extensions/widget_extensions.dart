import 'package:flutter/material.dart';

import '../spacing/app_spacing.dart';

/// Widget composition helpers.
extension WidgetX on Widget {
  /// Wraps the widget in [GestureDetector] with [onTap].
  Widget onTap(VoidCallback onTap,
          {HitTestBehavior behavior = HitTestBehavior.opaque}) =>
      GestureDetector(onTap: onTap, behavior: behavior, child: this);

  /// Wraps the widget in a [Center].
  Widget get centered => Center(child: this);

  /// Applies uniform [padding].
  Widget padded([double padding = AppSpacing.lg]) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  /// Applies symmetric padding.
  Widget pad({double horizontal = 0, double vertical = 0}) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  /// Applies [padding] only.
  Widget withPadding(EdgeInsetsGeometry padding) =>
      Padding(padding: padding, child: this);

  /// Expands the widget inside a [Flex] parent.
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Applies [flexible] sizing.
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  /// Wraps in [RepaintBoundary] to isolate repaints.
  Widget get repaint => RepaintBoundary(child: this);

  /// Wraps in a [Semantics] node with [label].
  Widget semantics({required String label, bool button = false}) =>
      Semantics(label: label, button: button, child: this);

  /// Wraps in an [AnimatedSwitcher] with [duration] and default fade.
  Widget animatedSwitcher({
    Duration duration = const Duration(milliseconds: 300),
    AnimatedSwitcherTransitionBuilder transitionBuilder =
        _defaultAnimatedSwitcherTransition,
    AnimatedSwitcherLayoutBuilder layoutBuilder =
        AnimatedSwitcher.defaultLayoutBuilder,
  }) =>
      AnimatedSwitcher(
        duration: duration,
        layoutBuilder: layoutBuilder,
        transitionBuilder: transitionBuilder,
        child: this,
      );

  /// Hides the widget entirely when [condition] is false.
  Widget visible({bool condition = true}) =>
      condition ? this : const SizedBox.shrink();

  /// Wraps the widget in a [KeyedSubtree] with [key].
  Widget keyed(Object key) =>
      KeyedSubtree(key: ValueKey<Object>(key), child: this);
}

/// Animated widget helpers.
extension WidgetAnimateX on Widget {
  /// Wraps in an [AnimatedOpacity].
  Widget fadeIn({
    double opacity = 1,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeIn,
  }) =>
      AnimatedOpacity(
        opacity: opacity,
        duration: duration,
        curve: curve,
        child: this,
      );

  /// Wraps in an [AnimatedScale].
  Widget scaleOnTap({
    double scale = 0.95,
    required VoidCallback onTap,
    Duration duration = const Duration(milliseconds: 150),
  }) =>
      GestureDetector(
        onTap: onTap,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 1, end: scale),
          duration: duration,
          curve: Curves.easeOut,
          builder: (BuildContext context, double value, Widget? child) =>
              Transform.scale(scale: value, child: child),
          child: this,
        ),
      );
}

/// Default fade transition builder used by [WidgetX.animatedSwitcher].
Widget _defaultAnimatedSwitcherTransition(
  Widget child,
  Animation<double> animation,
) =>
    FadeTransition(opacity: animation, child: child);
