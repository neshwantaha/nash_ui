import 'package:flutter/material.dart';

/// A gap (empty space) that auto-detects its parent axis.
///
/// Inside a [Column] it becomes a vertical gap; inside a [Row] a horizontal
/// gap; anywhere else it falls back to a square [SizedBox].
///
/// ```dart
/// Column(children: [
///   Text('Title'),
///   Gap(16),        // SizedBox(height: 16) automatically
///   Text('Body'),
/// ])
///
/// Row(children: [
///   Icon(Icons.star),
///   Gap(8),         // SizedBox(width: 8) automatically
///   Text('Stars'),
/// ])
/// ```
class Gap extends StatelessWidget {
  /// Creates a gap of [size] logical pixels (auto axis-detection).
  const Gap(this._size, {super.key})
      : _width = null,
        _height = null,
        _expand = false;

  /// A vertical gap of [size] (explicit).
  const Gap.vertical(double size, {super.key})
      : _size = size,
        _width = null,
        _height = size,
        _expand = false;

  /// A horizontal gap of [size] (explicit).
  const Gap.horizontal(double size, {super.key})
      : _size = size,
        _width = size,
        _height = null,
        _expand = false;

  /// An expanding gap equivalent to [Spacer].
  const Gap.expand({super.key})
      : _size = 0,
        _width = null,
        _height = null,
        _expand = true;

  final double _size;
  final double? _width;
  final double? _height;
  final bool _expand;

  @override
  Widget build(BuildContext context) {
    if (_expand) return const Expanded(child: SizedBox.shrink());

    // If explicit width/height provided, use directly.
    if (_width != null || _height != null) {
      return SizedBox(width: _width, height: _height);
    }

    // Auto-detect parent Flex axis.
    final Flex? flex = context.findAncestorWidgetOfExactType<Flex>();
    if (flex != null) {
      return flex.direction == Axis.horizontal
          ? SizedBox(width: _size)
          : SizedBox(height: _size);
    }

    // Fallback: square
    return SizedBox(width: _size, height: _size);
  }
}

/// Backwards-compatible alias for [Gap].
typedef AppGap = Gap;

/// A themed horizontal or vertical divider.
class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.height = 1,
    this.thickness,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    this.vertical = false,
    this.dashed = false,
  });

  /// Height of the divider box.
  final double height;

  /// Stroke thickness.
  final double? thickness;

  /// Leading padding.
  final double indent;

  /// Trailing padding.
  final double endIndent;

  /// Divider color.
  final Color? color;

  /// When true, renders a vertical divider.
  final bool vertical;

  /// When true, renders a dashed line via [CustomPaint].
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final Color resolvedColor = color ??
        Theme.of(context).dividerTheme.color ??
        Theme.of(context).colorScheme.outlineVariant;
    if (vertical) {
      return VerticalDivider(
        width: height,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: resolvedColor,
      );
    }
    if (dashed) {
      return SizedBox(
        height: height,
        child: CustomPaint(
            painter:
                _DashPainter(color: resolvedColor, thickness: thickness ?? 1)),
      );
    }
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: resolvedColor,
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter({required this.color, required this.thickness});

  final Color color;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = thickness;
    const double dash = 6;
    const double gap = 4;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
          Offset(x, size.height / 2), Offset(x + dash, size.height / 2), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.thickness != thickness;
}
