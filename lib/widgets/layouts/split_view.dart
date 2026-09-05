import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';

/// Orientation for [SplitView].
enum SplitViewOrientation {
  horizontal,
  vertical,
}

/// A resizable two-panel split view widget with a draggable divider.
class SplitView extends StatefulWidget {
  const SplitView({
    super.key,
    required this.firstChild,
    required this.secondChild,
    this.initialRatio = 0.5,
    this.minRatio = 0.15,
    this.maxRatio = 0.85,
    this.orientation = SplitViewOrientation.horizontal,
    this.dividerThickness = 6.0,
    this.dividerColor,
    this.onRatioChanged,
  });

  /// First panel content (left or top).
  final Widget firstChild;

  /// Second panel content (right or bottom).
  final Widget secondChild;

  /// Initial split ratio from 0.0 to 1.0.
  final double initialRatio;

  /// Minimum allowed ratio.
  final double minRatio;

  /// Maximum allowed ratio.
  final double maxRatio;

  /// Horizontal (left/right) or vertical (top/bottom) split.
  final SplitViewOrientation orientation;

  /// Divider grip thickness in pixels.
  final double dividerThickness;

  /// Custom divider color.
  final Color? dividerColor;

  /// Callback when the ratio is adjusted.
  final ValueChanged<double>? onRatioChanged;

  @override
  State<SplitView> createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  late double _ratio;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _ratio = widget.initialRatio.clamp(widget.minRatio, widget.maxRatio);
  }

  void _updateRatio(double delta, double totalSize) {
    if (totalSize <= 0) return;
    setState(() {
      _ratio = (_ratio + (delta / totalSize))
          .clamp(widget.minRatio, widget.maxRatio);
    });
    widget.onRatioChanged?.call(_ratio);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHorizontal = widget.orientation == SplitViewOrientation.horizontal;

    final defaultDividerColor = _isDragging
        ? AppColors.primary
        : (isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.1));

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSize = isHorizontal
            ? constraints.maxWidth - widget.dividerThickness
            : constraints.maxHeight - widget.dividerThickness;

        final firstSize = totalSize * _ratio;
        final secondSize = totalSize * (1.0 - _ratio);

        final divider = MouseRegion(
          cursor: isHorizontal
              ? SystemMouseCursors.resizeColumn
              : SystemMouseCursors.resizeRow,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart:
                isHorizontal ? (_) => setState(() => _isDragging = true) : null,
            onHorizontalDragEnd: isHorizontal
                ? (_) => setState(() => _isDragging = false)
                : null,
            onHorizontalDragUpdate: isHorizontal
                ? (d) => _updateRatio(d.delta.dx, totalSize)
                : null,
            onVerticalDragStart: !isHorizontal
                ? (_) => setState(() => _isDragging = true)
                : null,
            onVerticalDragEnd: !isHorizontal
                ? (_) => setState(() => _isDragging = false)
                : null,
            onVerticalDragUpdate: !isHorizontal
                ? (d) => _updateRatio(d.delta.dy, totalSize)
                : null,
            child: Container(
              width: isHorizontal ? widget.dividerThickness : double.infinity,
              height: isHorizontal ? double.infinity : widget.dividerThickness,
              color: widget.dividerColor ?? defaultDividerColor,
              child: Center(
                child: Container(
                  width: isHorizontal ? 2 : 24,
                  height: isHorizontal ? 24 : 2,
                  decoration: BoxDecoration(
                    color: _isDragging
                        ? Colors.white
                        : (isDark ? Colors.white38 : Colors.black38),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),
          ),
        );

        if (isHorizontal) {
          return Row(
            children: [
              SizedBox(width: firstSize, child: widget.firstChild),
              divider,
              SizedBox(width: secondSize, child: widget.secondChild),
            ],
          );
        } else {
          return Column(
            children: [
              SizedBox(height: firstSize, child: widget.firstChild),
              divider,
              SizedBox(height: secondSize, child: widget.secondChild),
            ],
          );
        }
      },
    );
  }
}
