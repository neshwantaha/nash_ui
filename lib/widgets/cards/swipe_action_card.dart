import 'package:flutter/material.dart';

/// A card that reveals hidden actions when swiped left or right.
///
/// ```dart
/// SwipeActionCard(
///   child: ListTile(title: Text('Item')),
///   leftActions: [
///     SwipeAction(
///       icon: Icons.archive,
///       label: 'Archive',
///       color: Colors.green,
///       onTap: () {},
///     ),
///   ],
///   rightActions: [
///     SwipeAction(
///       icon: Icons.delete,
///       label: 'Delete',
///       color: Colors.red,
///       onTap: () {},
///     ),
///   ],
/// )
/// ```
class SwipeAction {
  const SwipeAction({
    required this.icon,
    this.label,
    required this.color,
    required this.onTap,
    this.foregroundColor = Colors.white,
  });

  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback onTap;
  final Color foregroundColor;
}

class SwipeActionCard extends StatefulWidget {
  const SwipeActionCard({
    super.key,
    required this.child,
    this.leftActions = const [],
    this.rightActions = const [],
    this.actionWidth = 72.0,
    this.borderRadius,
    this.elevation = 1,
    this.margin,
  });

  final Widget child;
  final List<SwipeAction> leftActions;
  final List<SwipeAction> rightActions;
  final double actionWidth;
  final BorderRadius? borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? margin;

  @override
  State<SwipeActionCard> createState() => _SwipeActionCardState();
}

class _SwipeActionCardState extends State<SwipeActionCard> {
  double _dragStart = 0;
  double _offset = 0;

  double get _maxLeft => widget.leftActions.length * widget.actionWidth;
  double get _maxRight => widget.rightActions.length * widget.actionWidth;

  void _snap(double target) {
    setState(() => _offset = target);
  }

  @override
  Widget build(BuildContext context) {
    final br = widget.borderRadius ?? BorderRadius.circular(12);
    return Padding(
      padding: widget.margin ?? const EdgeInsets.symmetric(vertical: 4),
      child: ClipRRect(
        borderRadius: br,
        child: GestureDetector(
          onHorizontalDragStart: (d) => _dragStart = d.localPosition.dx,
          onHorizontalDragUpdate: (d) {
            final delta = d.localPosition.dx - _dragStart;
            _dragStart = d.localPosition.dx;
            setState(() {
              _offset = (_offset + delta).clamp(-_maxRight, _maxLeft);
            });
          },
          onHorizontalDragEnd: (_) {
            if (_offset > _maxLeft / 2) {
              _snap(_maxLeft);
            } else if (_offset < -_maxRight / 2) {
              _snap(-_maxRight);
            } else {
              _snap(0);
            }
          },
          child: Stack(
            children: [
              // Left actions background
              if (widget.leftActions.isNotEmpty)
                Positioned.fill(
                  child: Row(
                    children: widget.leftActions
                        .map((a) => GestureDetector(
                              onTap: () {
                                _snap(0);
                                a.onTap();
                              },
                              child: Container(
                                width: widget.actionWidth,
                                color: a.color,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(a.icon, color: a.foregroundColor),
                                    if (a.label != null)
                                      Text(a.label!,
                                          style: TextStyle(
                                              color: a.foregroundColor,
                                              fontSize: 11)),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),

              // Right actions background
              if (widget.rightActions.isNotEmpty)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.rightActions
                          .map((a) => GestureDetector(
                                onTap: () {
                                  _snap(0);
                                  a.onTap();
                                },
                                child: Container(
                                  width: widget.actionWidth,
                                  color: a.color,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(a.icon, color: a.foregroundColor),
                                      if (a.label != null)
                                        Text(a.label!,
                                            style: TextStyle(
                                                color: a.foregroundColor,
                                                fontSize: 11)),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),

              // Foreground sliding card
              Transform.translate(
                offset: Offset(_offset, 0),
                child: Material(
                  elevation: widget.elevation,
                  borderRadius: br,
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
