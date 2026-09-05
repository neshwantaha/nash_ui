import 'package:flutter/material.dart' hide Draggable;
import '_draggable_helper.dart';

/// A reorderable list with drag-and-drop support.
///
/// ```dart
/// DraggableList(
///   items: items,
///   onReorder: (oldIndex, newIndex) { ... },
///   itemBuilder: (context, item, index) => ListTile(title: Text(item.name)),
/// )
/// ```
class DraggableList<T> extends StatefulWidget {
  const DraggableList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
    this.onDragStart,
    this.onDragEnd,
    this.proxyDecorator,
    this.scrollController,
    this.padding,
    this.separatorBuilder,
    this.reorderable = true,
    this.shrinkWrap = false,
    this.physics,
  });

  /// The list of items.
  final List<T> items;

  /// Builder for each item.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Callback when items are reordered.
  final void Function(int oldIndex, int newIndex) onReorder;

  /// Callback when a drag starts.
  final void Function(int index)? onDragStart;

  /// Callback when a drag ends.
  final void Function(int index)? onDragEnd;

  /// Custom proxy decorator during drag.
  final Widget Function(Widget child, int index, Animation<double> animation)?
      proxyDecorator;

  /// Optional scroll controller.
  final ScrollController? scrollController;

  /// Padding around the list.
  final EdgeInsetsGeometry? padding;

  /// Separator builder for [ListView.separated].
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Whether reordering is enabled.
  final bool reorderable;

  /// Whether the list should shrink-wrap.
  final bool shrinkWrap;

  /// Scroll physics.
  final ScrollPhysics? physics;

  @override
  State<DraggableList<T>> createState() => _DraggableListState<T>();
}

class _DraggableListState<T> extends State<DraggableList<T>> {
  late List<T> _items;

  @override
  void initState() {
    super.initState();
    _items = List<T>.from(widget.items);
  }

  @override
  void didUpdateWidget(DraggableList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _items = List<T>.from(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reorderable) {
      return ReorderableListView.builder(
        scrollController: widget.scrollController,
        padding: widget.padding as EdgeInsets?,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        proxyDecorator: widget.proxyDecorator,
        itemCount: _items.length,
        // ignore: deprecated_member_use
        onReorder: (int oldIndex, int newIndex) {
          widget.onReorder(oldIndex, newIndex);
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final T item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
        },
        itemBuilder: (BuildContext context, int index) =>
            widget.itemBuilder(context, _items[index], index),
      );
    }

    if (widget.separatorBuilder != null) {
      return ListView.separated(
        controller: widget.scrollController,
        padding: widget.padding as EdgeInsets?,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        itemCount: _items.length,
        separatorBuilder: widget.separatorBuilder!,
        itemBuilder: (BuildContext context, int index) =>
            widget.itemBuilder(context, _items[index], index),
      );
    }

    return ListView.builder(
      controller: widget.scrollController,
      padding: widget.padding as EdgeInsets?,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) =>
          widget.itemBuilder(context, _items[index], index),
    );
  }
}

/// A drop zone that accepts dragged items.
///
/// ```dart
/// DropZone(
///   onAccept: (data) { ... },
///   child: Text('Drop here'),
/// )
/// ```
class DropZone extends StatefulWidget {
  const DropZone({
    super.key,
    this.onAccept,
    this.onWillAccept,
    this.onHoverChanged,
    this.onLeave,
    required this.child,
    this.activeColor,
    this.inactiveColor,
    this.borderRadius = 12,
    this.borderWidth = 2,
  });

  /// Callback when an item is dropped.
  final void Function(dynamic data)? onAccept;

  /// Whether to accept the incoming data.
  final bool Function(dynamic data)? onWillAccept;

  /// Callback when hover state changes.
  final void Function({required bool hovering})? onHoverChanged;

  /// Callback when pointer leaves.
  final VoidCallback? onLeave;

  /// The child widget.
  final Widget child;

  /// Background color when hovering.
  final Color? activeColor;

  /// Background color when not hovering.
  final Color? inactiveColor;

  /// Border radius.
  final double borderRadius;

  /// Border width when active.
  final double borderWidth;

  @override
  State<DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<DropZone> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color active = widget.activeColor ?? scheme.primary;
    final Color inactive =
        widget.inactiveColor ?? scheme.surfaceContainerHighest;

    return DragTarget(
      onWillAcceptWithDetails: (DragTargetDetails<dynamic> details) {
        if (widget.onWillAccept != null) {
          return widget.onWillAccept!(details.data);
        }
        return true;
      },
      onAcceptWithDetails: (DragTargetDetails<dynamic> details) {
        widget.onAccept?.call(details.data);
      },
      onMove: (DragTargetDetails<dynamic> details) {
        if (!_hovering) {
          setState(() => _hovering = true);
          widget.onHoverChanged?.call(hovering: true);
        }
      },
      onLeave: (Object? data) {
        setState(() => _hovering = false);
        widget.onLeave?.call();
      },
      builder: (BuildContext context, List<dynamic> candidateData,
              List<dynamic> rejectedData) =>
          AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _hovering ? active.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: _hovering ? active : inactive,
            width: _hovering ? widget.borderWidth : 1,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

/// A draggable widget wrapper.
///
/// ```dart
/// Draggable<int>(
///   data: 42,
///   child: Chip(label: Text('Drag me')),
/// )
/// ```
/// A backwards-compatible alias for [Draggable].
typedef NashDraggable = Draggable;

class Draggable extends StatelessWidget {
  const Draggable({
    super.key,
    required this.data,
    required this.child,
    this.feedback,
    this.childWhenDragging,
    this.onDragStarted,
    this.onDragEnd,
    this.affinity,
  });

  /// The data payload.
  final dynamic data;

  /// The widget to make draggable.
  final Widget child;

  /// Custom feedback widget shown while dragging.
  final Widget? feedback;

  /// Widget shown in the original position while dragging.
  final Widget? childWhenDragging;

  /// Callback when drag starts.
  final VoidCallback? onDragStarted;

  /// Callback when drag ends.
  final void Function(DraggableDetails details)? onDragEnd;

  /// Axis affinity (horizontal/vertical/both).
  final Axis? affinity;

  @override
  Widget build(BuildContext context) => buildDraggableWidget(
        data: data as Object,
        affinity: affinity,
        onDragStarted: onDragStarted,
        onDragEnd: onDragEnd,
        feedback: feedback,
        childWhenDragging: childWhenDragging,
        child: child,
      );
}
