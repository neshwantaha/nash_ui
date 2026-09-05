import 'package:flutter/material.dart';

import '../spacing/app_spacing.dart';

/// A responsive grid built on a maximum cross-axis extent.
///
/// Children automatically reflow into more columns as the screen widens.
class Grid extends StatelessWidget {
  const Grid({
    super.key,
    required this.children,
    this.maxCrossAxisExtent = 260,
    this.childAspectRatio = 1,
    this.crossAxisSpacing = AppSpacing.md,
    this.mainAxisSpacing = AppSpacing.md,
    this.padding,
    this.shrinkWrap = false,
    this.primary,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.blank,
  });

  /// Items to display.
  final List<Widget> children;

  /// Maximum item width before a new column is added.
  final double maxCrossAxisExtent;

  /// Item width / height ratio.
  final double childAspectRatio;

  /// Horizontal spacing between columns.
  final double crossAxisSpacing;

  /// Vertical spacing between rows.
  final double mainAxisSpacing;

  /// Grid padding.
  final EdgeInsetsGeometry? padding;

  /// Whether the grid sizes itself to its children.
  final bool shrinkWrap;

  /// Whether the primary scroll axis is the grid's.
  final bool? primary;

  /// Scroll controller.
  final ScrollController? scrollController;

  /// Scroll direction.
  final Axis scrollDirection;

  /// Widget shown while the grid is empty.
  final Widget? blank;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items =
        children.isEmpty && blank != null ? <Widget>[blank!] : children;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      padding: padding,
      shrinkWrap: shrinkWrap,
      primary: primary,
      controller: scrollController,
      scrollDirection: scrollDirection,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) => items[index],
    );
  }
}

/// A simple vertical list with design-system defaults.
class AppListView extends StatelessWidget {
  const AppListView({
    super.key,
    required this.children,
    this.padding,
    this.separator,
    this.shrinkWrap = false,
    this.physics,
  });

  /// List items.
  final List<Widget> children;

  /// List padding.
  final EdgeInsetsGeometry? padding;

  /// Optional separator between items.
  final Widget? separator;

  /// Whether the list sizes to its children.
  final bool shrinkWrap;

  /// Scroll physics.
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0 && separator != null) items.add(separator!);
      items.add(children[i]);
    }
    return ListView(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      children: items,
    );
  }
}
