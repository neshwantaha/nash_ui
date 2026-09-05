import 'package:flutter/material.dart';

/// A draggable/reorderable dashboard widget arranged in a configurable grid.
/// Each tile can be dragged to a different position.
class DraggableDashboard extends StatefulWidget {
  const DraggableDashboard({
    super.key,
    required this.items,
    this.crossAxisCount = 2,
    this.spacing = 12,
    this.onReorder,
  });

  final List<DashboardItem> items;
  final int crossAxisCount;
  final double spacing;
  final ValueChanged<List<DashboardItem>>? onReorder;

  @override
  State<DraggableDashboard> createState() => _DraggableDashboardState();
}

class DashboardItem {
  const DashboardItem({
    required this.id,
    required this.child,
    this.crossAxisCellCount = 1,
    this.mainAxisCellCount = 1,
  });

  final String id;
  final Widget child;
  final int crossAxisCellCount;
  final int mainAxisCellCount;
}

class _DraggableDashboardState extends State<DraggableDashboard> {
  late List<DashboardItem> _items;
  int? _hoverIndex;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  void _onAccept(int from, int to) {
    setState(() {
      final item = _items.removeAt(from);
      _items.insert(to, item);
      _hoverIndex = null;
    });
    widget.onReorder?.call(_items);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.spacing,
        crossAxisSpacing: widget.spacing,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final isHover = _hoverIndex == index;

        return DragTarget<int>(
          onWillAcceptWithDetails: (details) {
            setState(() => _hoverIndex = index);
            return details.data != index;
          },
          onLeave: (_) => setState(() => _hoverIndex = null),
          onAcceptWithDetails: (details) => _onAccept(details.data, index),
          builder: (_, candidates, __) => LongPressDraggable<int>(
            data: index,
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: 140,
                height: 140,
                child: Opacity(
                  opacity: 0.85,
                  child: _DashboardTile(item: item, theme: theme),
                ),
              ),
            ),
            childWhenDragging: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withAlpha(40),
                ),
              ),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: isHover
                    ? Border.all(color: theme.colorScheme.primary, width: 2)
                    : null,
                boxShadow: isHover
                    ? [
                        BoxShadow(
                            color: theme.colorScheme.primary.withAlpha(60),
                            blurRadius: 12)
                      ]
                    : null,
              ),
              child: _DashboardTile(item: item, theme: theme),
            ),
          ),
        );
      },
    );
  }
}

class _DashboardTile extends StatelessWidget {
  const _DashboardTile({required this.item, required this.theme});
  final DashboardItem item;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: item.child,
      );
}
