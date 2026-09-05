import 'package:flutter/material.dart';

/// A vertical flex layout with design-system spacing defaults.
class AppColumn extends StatelessWidget {
  const AppColumn({
    super.key,
    this.children = const <Widget>[],
    this.gap = 0,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
  });

  /// Children placed vertically.
  final List<Widget> children;

  /// Uniform gap between children.
  final double gap;

  /// Padding around the column.
  final EdgeInsetsGeometry? padding;

  /// Vertical alignment.
  final MainAxisAlignment mainAxisAlignment;

  /// Horizontal alignment.
  final CrossAxisAlignment crossAxisAlignment;

  /// How the column occupies available space.
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    final List<Widget> spaced = _intersperse(children, gap);
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: spaced,
      ),
    );
  }

  List<Widget> _intersperse(List<Widget> items, double gap) {
    if (gap <= 0 || items.isEmpty) return items;
    final List<Widget> result = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (i > 0) result.add(SizedBox(height: gap));
      result.add(items[i]);
    }
    return result;
  }
}

/// A horizontal flex layout with design-system spacing defaults.
class AppRow extends StatelessWidget {
  const AppRow({
    super.key,
    this.children = const <Widget>[],
    this.gap = 0,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  /// Children placed horizontally.
  final List<Widget> children;

  /// Uniform gap between children.
  final double gap;

  /// Padding around the row.
  final EdgeInsetsGeometry? padding;

  /// Horizontal alignment.
  final MainAxisAlignment mainAxisAlignment;

  /// Vertical alignment.
  final CrossAxisAlignment crossAxisAlignment;

  /// How the row occupies available space.
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    final List<Widget> spaced = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0 && gap > 0) spaced.add(SizedBox(width: gap));
      spaced.add(children[i]);
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: spaced,
      ),
    );
  }
}

/// A [AppWrap] with design-system spacing defaults.
class AppWrap extends StatelessWidget {
  const AppWrap({
    super.key,
    this.children = const <Widget>[],
    this.spacing = 8,
    this.runSpacing = 8,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.direction = Axis.horizontal,
  });

  /// Items to wrap.
  final List<Widget> children;

  /// Spacing between items on the main axis.
  final double spacing;

  /// Spacing between wrapped runs.
  final double runSpacing;

  /// Main-axis alignment.
  final WrapAlignment alignment;

  /// Run alignment.
  final WrapAlignment runAlignment;

  /// Cross-axis alignment.
  final WrapCrossAlignment crossAxisAlignment;

  /// Wrap direction.
  final Axis direction;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        alignment: alignment,
        runAlignment: runAlignment,
        crossAxisAlignment: crossAxisAlignment,
        direction: direction,
        children: children,
      );
}
