import 'package:flutter/material.dart';

/// A single action in a [SpeedDial].
class SpeedDialItem {
  const SpeedDialItem({
    required this.icon,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final String? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback onTap;
  final String? tooltip;
}

/// An animated, expandable FAB (Speed Dial / FabMenu).
///
/// ```dart
/// SpeedDial(
///   icon: Icons.add,
///   closeIcon: Icons.close,
///   items: [
///     SpeedDialItem(icon: Icons.share, label: 'Share', onTap: () {}),
///     SpeedDialItem(icon: Icons.edit, label: 'Edit', onTap: () {}),
///   ],
/// )
/// ```
class SpeedDial extends StatefulWidget {
  const SpeedDial({
    super.key,
    this.icon = Icons.add,
    this.closeIcon = Icons.close,
    required this.items,
    this.backgroundColor,
    this.foregroundColor,
    this.spacing = 8.0,
    this.overlayColor,
    this.overlayOpacity = 0.4,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  final IconData icon;
  final IconData closeIcon;
  final List<SpeedDialItem> items;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double spacing;
  final Color? overlayColor;
  final double overlayOpacity;
  final Duration animationDuration;

  @override
  State<SpeedDial> createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _expand;

  bool _open = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _ctrl.forward() : _ctrl.reverse();
  }

  void _close() {
    setState(() => _open = false);
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Sub-items (reverse so first item is closest to FAB)
        ...List.generate(widget.items.length, (i) {
          final item = widget.items[widget.items.length - 1 - i];
          return AnimatedBuilder(
            animation: _expand,
            builder: (_, __) => FadeTransition(
              opacity: _expand,
              child: SizeTransition(
                sizeFactor: _expand,
                // ignore: deprecated_member_use
                axisAlignment: -1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: widget.spacing),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.label != null)
                        GestureDetector(
                          onTap: () {
                            _close();
                            item.onTap();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(item.label!,
                                style: theme.textTheme.bodySmall),
                          ),
                        ),
                      FloatingActionButton.small(
                        heroTag: 'speed_dial_item_$i',
                        backgroundColor: item.backgroundColor ??
                            theme.colorScheme.secondaryContainer,
                        foregroundColor: item.foregroundColor ??
                            theme.colorScheme.onSecondaryContainer,
                        tooltip: item.tooltip,
                        onPressed: () {
                          _close();
                          item.onTap();
                        },
                        child: Icon(item.icon),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),

        // Main FAB
        FloatingActionButton(
          heroTag: 'speed_dial_main',
          backgroundColor: widget.backgroundColor ?? theme.colorScheme.primary,
          foregroundColor:
              widget.foregroundColor ?? theme.colorScheme.onPrimary,
          onPressed: _toggle,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _expand,
          ),
        ),
      ],
    );
  }
}
