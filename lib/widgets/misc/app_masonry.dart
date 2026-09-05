import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A true masonry (Pinterest-style) layout that distributes items across
/// columns using a **shortest-column greedy algorithm**, allowing each child
/// to render at its **natural height**.
///
/// Unlike [GridView], no fixed main-axis extent is imposed — items can be
/// as tall or short as they need to be.
///
/// ### Basic usage (list)
/// ```dart
/// AppMasonry(
///   columnCount: 2,
///   children: cards,
/// )
/// ```
///
/// ### Builder usage (lazy)
/// ```dart
/// AppMasonry.builder(
///   itemCount: items.length,
///   columnCount: 3,
///   itemBuilder: (context, index) => ItemTile(items[index]),
/// )
/// ```
///
/// ### Adaptive columns (auto-derives column count from width)
/// ```dart
/// AppMasonry(
///   maxCrossAxisExtent: 280,
///   children: tiles,
/// )
/// ```
class AppMasonry extends StatelessWidget {
  /// Creates a masonry layout.
  ///
  /// Provide either [children] or both [itemCount] and [itemBuilder].
  const AppMasonry({
    super.key,
    this.children,
    this.itemCount,
    this.itemBuilder,
    this.columnCount,
    this.maxCrossAxisExtent = 320,
    this.spacing = 12,
    this.runSpacing = 12,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.shrinkWrap = false,
    this.reverse = false,
    this.primary,
    this.controller,
  }) : assert(
          children != null || (itemCount != null && itemBuilder != null),
          'Either children or (itemCount and itemBuilder) must be provided.',
        );

  /// Creates a masonry layout using a builder function.
  const AppMasonry.builder({
    super.key,
    required int this.itemCount,
    required IndexedWidgetBuilder this.itemBuilder,
    this.columnCount,
    this.maxCrossAxisExtent = 320,
    this.spacing = 12,
    this.runSpacing = 12,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.shrinkWrap = false,
    this.reverse = false,
    this.primary,
    this.controller,
  }) : children = null;

  // ── data ──────────────────────────────────────────────────────────────────

  /// Explicit list of children (default constructor).
  final List<Widget>? children;

  /// Total item count ([AppMasonry.builder]).
  final int? itemCount;

  /// Lazy builder ([AppMasonry.builder]).
  final IndexedWidgetBuilder? itemBuilder;

  // ── layout ────────────────────────────────────────────────────────────────

  /// Fixed column count. When null, derived from [maxCrossAxisExtent].
  final int? columnCount;

  /// Maximum column width used when [columnCount] is null.
  final double maxCrossAxisExtent;

  /// Horizontal gap between columns.
  final double spacing;

  /// Vertical gap between items in the same column.
  final double runSpacing;

  // ── scroll ────────────────────────────────────────────────────────────────

  /// Padding around the scroll content.
  final EdgeInsetsGeometry padding;

  /// Scroll physics.
  final ScrollPhysics? physics;

  /// Sizes the scroll view to its content.
  final bool shrinkWrap;

  /// Reverses scroll direction.
  final bool reverse;

  /// Whether this is the primary scroll view.
  final bool? primary;

  /// External scroll controller.
  final ScrollController? controller;

  // ── helpers ───────────────────────────────────────────────────────────────

  int _columnCount(double availableWidth) {
    if (columnCount != null) {
      if (columnCount! <= 0) {
        throw ArgumentError.value(columnCount, 'columnCount', 'must be > 0');
      }
      return columnCount!;
    }
    return math.max(1, availableWidth ~/ maxCrossAxisExtent);
  }

  List<Widget> _resolveItems(BuildContext context) {
    if (children != null) return children!;
    return List.generate(itemCount!, (i) => itemBuilder!(context, i));
  }

  /// Shortest-column greedy distribution — each item goes to the column
  /// with the fewest items currently assigned to it.
  List<List<Widget>> _distribute(List<Widget> items, int cols) {
    final columns = List.generate(cols, (_) => <Widget>[]);
    final counts = List.filled(cols, 0);
    for (final item in items) {
      int shortest = 0;
      for (int c = 1; c < cols; c++) {
        if (counts[c] < counts[shortest]) shortest = c;
      }
      columns[shortest].add(item);
      counts[shortest]++;
    }
    return columns;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final cols = _columnCount(constraints.maxWidth);
          final items = _resolveItems(context);
          final columns = _distribute(items, cols);

          final row = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int c = 0; c < cols; c++) ...[
                if (c > 0) SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < columns[c].length; i++) ...[
                        if (i > 0) SizedBox(height: runSpacing),
                        columns[c][i],
                      ],
                    ],
                  ),
                ),
              ],
            ],
          );

          return SingleChildScrollView(
            reverse: reverse,
            padding: padding,
            primary: primary,
            physics: physics,
            controller: controller,
            child: row,
          );
        },
      );
}
