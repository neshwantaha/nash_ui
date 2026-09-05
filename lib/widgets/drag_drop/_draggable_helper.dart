import 'package:flutter/material.dart';

Widget buildDraggableWidget<T extends Object>({
  required T data,
  required Widget child,
  Widget? feedback,
  Widget? childWhenDragging,
  VoidCallback? onDragStarted,
  void Function(DraggableDetails details)? onDragEnd,
  Axis? affinity,
}) =>
    Draggable<T>(
      data: data,
      affinity: affinity,
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd,
      feedback: feedback ??
          Material(
            elevation: 8,
            color: Colors.transparent,
            child: child,
          ),
      childWhenDragging: childWhenDragging ?? const SizedBox.shrink(),
      child: child,
    );
