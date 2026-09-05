import 'package:flutter/widgets.dart';

import '../spacing/app_spacing.dart';

/// A [AppPadding] with design-system defaults.
class AppPadding extends StatelessWidget {
  const AppPadding({
    super.key,
    required this.child,
    this.all,
    this.horizontal,
    this.vertical,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.padding,
  });

  /// The padded child.
  final Widget child;

  /// Uniform padding on all sides.
  final double? all;

  /// Horizontal padding.
  final double? horizontal;

  /// Vertical padding.
  final double? vertical;

  /// Left padding.
  final double? left;

  /// Right padding.
  final double? right;

  /// Top padding.
  final double? top;

  /// Bottom padding.
  final double? bottom;

  /// Fully custom [EdgeInsetsGeometry].
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry resolved = padding ??
        EdgeInsets.only(
          left: left ?? horizontal ?? all ?? 0,
          right: right ?? horizontal ?? all ?? 0,
          top: top ?? vertical ?? all ?? 0,
          bottom: bottom ?? vertical ?? all ?? 0,
        );
    return Padding(padding: resolved, child: child);
  }
}

/// A [Container] that only adds outside margin.
class Margin extends StatelessWidget {
  const Margin({
    super.key,
    required this.child,
    this.all,
    this.horizontal,
    this.vertical,
    this.margin,
  });

  /// The child widget.
  final Widget child;

  /// Uniform margin on all sides.
  final double? all;

  /// Horizontal margin.
  final double? horizontal;

  /// Vertical margin.
  final double? vertical;

  /// Fully custom [EdgeInsetsGeometry].
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry resolved = margin ??
        EdgeInsets.symmetric(
          horizontal: horizontal ?? all ?? 0,
          vertical: vertical ?? all ?? 0,
        );
    return Container(margin: resolved, child: child);
  }
}

/// Padding sized with the [AppSpacing] scale.
class Space extends StatelessWidget {
  const Space({super.key, this.h, this.w});

  /// Standard 16dp spacer.
  const Space.lg({super.key})
      : w = null,
        h = null;

  /// Horizontal space.
  final double? w;

  /// Vertical space.
  final double? h;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: w ?? AppSpacing.lg, height: h ?? AppSpacing.lg);
}
