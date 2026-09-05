import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A long-press contextual menu that appears near the pressed position.
///
/// Wrap any widget with [AppContextMenu] to give it a right-click / long-press
/// popover with a list of labelled action items.
///
/// ```dart
/// AppContextMenu(
///   items: [
///     ContextMenuItem(label: 'Edit', icon: Icons.edit, onTap: () {}),
///     ContextMenuItem(label: 'Delete', icon: Icons.delete, isDestructive: true, onTap: () {}),
///   ],
///   child: ListTile(title: Text('Long-press me')),
/// )
/// ```
class AppContextMenu extends StatelessWidget {
  const AppContextMenu({
    super.key,
    required this.child,
    required this.items,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.width = 200,
  });

  /// The widget to wrap.
  final Widget child;

  /// Menu items to show.
  final List<ContextMenuItem> items;

  /// Border radius of the menu card.
  final BorderRadius borderRadius;

  /// Width of the popup menu card.
  final double width;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (d) {},
        onLongPressStart: (d) => _show(context, d.globalPosition),
        child: child,
      );

  void _show(BuildContext context, Offset position) {
    HapticFeedback.mediumImpact();
    final screen = MediaQuery.sizeOf(context);

    // Position menu to the right of the touch, flip if near edge
    double dx = position.dx + 8;
    double dy = position.dy;
    if (dx + width > screen.width) dx = position.dx - width - 8;
    if (dy + items.length * 48.0 > screen.height) {
      dy = screen.height - items.length * 48.0 - 16;
    }

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => Stack(
        children: [
          Positioned(
            left: dx,
            top: dy,
            child: _ContextMenuCard(
              items: items,
              borderRadius: borderRadius,
              width: width,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single item in an [AppContextMenu].
class ContextMenuItem {
  const ContextMenuItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isDestructive;
}

class _ContextMenuCard extends StatefulWidget {
  const _ContextMenuCard({
    required this.items,
    required this.borderRadius,
    required this.width,
  });

  final List<ContextMenuItem> items;
  final BorderRadius borderRadius;
  final double width;

  @override
  State<_ContextMenuCard> createState() => _ContextMenuCardState();
}

class _ContextMenuCardState extends State<_ContextMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(_ctrl);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScaleTransition(
      scale: _scale,
      alignment: Alignment.topLeft,
      child: FadeTransition(
        opacity: _fade,
        child: Material(
          borderRadius: widget.borderRadius,
          elevation: 8,
          shadowColor: Colors.black38,
          color: theme.colorScheme.surface,
          child: SizedBox(
            width: widget.width,
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items.asMap().entries.map((e) {
                  final i = e.key;
                  final item = e.value;
                  final color = item.isDestructive
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (i > 0) Divider(height: 1, color: theme.dividerColor),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          item.onTap();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              if (item.icon != null) ...[
                                Icon(item.icon, size: 18, color: color),
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(color: color),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
