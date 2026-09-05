import 'package:flutter/material.dart';
import 'breakpoint.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ResponsiveGrid — Responsive column grid system
// ─────────────────────────────────────────────────────────────────────────────

/// A responsive column grid that automatically adjusts the number of columns based
/// on the current screen width.
///
/// ```dart
/// ResponsiveGrid(
///   mobile: 1,
///   tablet: 2,
///   desktop: 4,
///   spacing: 16,
///   children: [Card1(), Card2(), Card3(), Card4()],
/// )
/// ```
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobile = 1,
    this.tablet = 2,
    this.desktop = 3,
    this.wideDesktop,
    this.spacing = 16.0,
    this.runSpacing,
    this.padding,
  });

  /// Children to arrange in the grid.
  final List<Widget> children;

  /// Number of columns on mobile (<600px).
  final int mobile;

  /// Number of columns on tablet (600–1024px).
  final int tablet;

  /// Number of columns on desktop (>1024px).
  final int desktop;

  /// Number of columns on wide desktop (>1440px, defaults to [desktop]).
  final int? wideDesktop;

  /// Horizontal spacing between columns.
  final double spacing;

  /// Vertical spacing between rows (defaults to [spacing]).
  final double? runSpacing;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cols = _columnCount(width);
    final vSpacing = runSpacing ?? spacing;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalSpacing = spacing * (cols - 1);
          final itemWidth = (constraints.maxWidth - totalSpacing) / cols;

          final rows = <List<Widget>>[];
          for (int i = 0; i < children.length; i += cols) {
            rows.add(children.sublist(i, (i + cols).clamp(0, children.length)));
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int r = 0; r < rows.length; r++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int c = 0; c < cols; c++) ...[
                      SizedBox(
                        width: itemWidth,
                        child: c < rows[r].length
                            ? rows[r][c]
                            : const SizedBox.shrink(),
                      ),
                      if (c < cols - 1) SizedBox(width: spacing),
                    ],
                  ],
                ),
                if (r < rows.length - 1) SizedBox(height: vSpacing),
              ],
            ],
          );
        },
      ),
    );
  }

  int _columnCount(double width) {
    if (width >= 1440) return wideDesktop ?? desktop;
    if (width >= AppBreakpoint.tablet) return desktop;
    if (width >= AppBreakpoint.phone) return tablet;
    return mobile;
  }
}
