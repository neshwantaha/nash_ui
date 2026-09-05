import 'package:flutter/material.dart';

/// A node in the treemap hierarchy.
class TreeMapNode {
  const TreeMapNode({
    required this.label,
    required this.value,
    this.color,
    this.children = const [],
  });

  final String label;
  final double value;
  final Color? color;
  final List<TreeMapNode> children;
}

/// A treemap chart displaying hierarchical data as nested rectangles.
///
/// ```dart
/// TreeMapChart(
///   nodes: [
///     TreeMapNode(label: 'Flutter', value: 45, color: Colors.blue),
///     TreeMapNode(label: 'React', value: 30, color: Colors.cyan),
///     TreeMapNode(label: 'Swift', value: 25, color: Colors.orange),
///   ],
/// )
/// ```
class TreeMapChart extends StatelessWidget {
  const TreeMapChart({
    super.key,
    required this.nodes,
    this.height = 240,
    this.gap = 2.0,
    this.borderRadius = 6.0,
    this.showLabels = true,
  });

  final List<TreeMapNode> nodes;
  final double height;
  final double gap;
  final double borderRadius;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = nodes.fold<double>(0, (s, n) => s + n.value);

    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;
        final tiles =
            _squarify(nodes, total, Rect.fromLTWH(0, 0, width, height), gap);

        return SizedBox(
          height: height,
          child: Stack(
            children: tiles.map((t) {
              final color = t.node.color ??
                  theme.colorScheme.primary
                      .withAlpha(100 + (t.node.value / total * 155).round());
              return Positioned(
                left: t.rect.left,
                top: t.rect.top,
                width: t.rect.width,
                height: t.rect.height,
                child: Container(
                  margin: EdgeInsets.all(gap / 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: showLabels
                      ? Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.node.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (t.rect.height > 30)
                                Text(
                                  t.node.value.toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9,
                                  ),
                                ),
                            ],
                          ),
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _Tile {
  _Tile(this.node, this.rect);
  final TreeMapNode node;
  final Rect rect;
}

List<_Tile> _squarify(
    List<TreeMapNode> nodes, double total, Rect bounds, double gap) {
  if (nodes.isEmpty) return [];
  final sorted = [...nodes]..sort((a, b) => b.value.compareTo(a.value));
  final tiles = <_Tile>[];

  double left = bounds.left;
  double top = bounds.top;
  double remainWidth = bounds.width;
  double remainHeight = bounds.height;

  for (int i = 0; i < sorted.length; i++) {
    final fraction = sorted[i].value / total;
    double w, h;
    if (remainWidth >= remainHeight) {
      w = remainWidth * fraction;
      h = remainHeight;
      tiles.add(_Tile(sorted[i], Rect.fromLTWH(left, top, w, h)));
      left += w;
      remainWidth -= w;
    } else {
      w = remainWidth;
      h = remainHeight * fraction;
      tiles.add(_Tile(sorted[i], Rect.fromLTWH(left, top, w, h)));
      top += h;
      remainHeight -= h;
    }
  }
  return tiles;
}
