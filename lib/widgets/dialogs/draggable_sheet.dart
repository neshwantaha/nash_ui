import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';
import '../../shadows/shadow.dart';

/// Shows a draggable bottom sheet with multiple snap points.
Future<T?> showDraggableSheet<T>({
  required BuildContext context,
  required Widget Function(
          BuildContext context, ScrollController scrollController)
      builder,
  double initialChildSize = 0.5,
  double minChildSize = 0.25,
  double maxChildSize = 0.95,
  List<double> snapSizes = const <double>[0.25, 0.5, 0.95],
  bool isDismissible = true,
}) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (BuildContext context) => DraggableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        snapSizes: snapSizes,
        builder: builder,
      ),
    );

/// A draggable bottom sheet with multiple snap points and fluid drag physics.
class DraggableSheet extends StatelessWidget {
  const DraggableSheet({
    super.key,
    required this.builder,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 0.95,
    this.snapSizes = const <double>[0.25, 0.5, 0.95],
    this.borderRadius = AppRadius.extraLarge,
  });

  /// Builder providing the [ScrollController] that enables synchronized dragging.
  final Widget Function(BuildContext context, ScrollController scrollController)
      builder;

  /// Initial height fraction of the screen.
  final double initialChildSize;

  /// Minimum height fraction.
  final double minChildSize;

  /// Maximum expanded fraction.
  final double maxChildSize;

  /// Snap point fractions.
  final List<double> snapSizes;

  /// Top corners radius.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      snap: true,
      snapSizes: snapSizes,
      builder: (BuildContext context, ScrollController scrollController) =>
          Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161626) : Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(borderRadius)),
          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.08),
            ),
          ),
          boxShadow: AppShadow.floating,
        ),
        child: Column(
          children: <Widget>[
            // Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Sheet Content
            Expanded(
              child: builder(context, scrollController),
            ),
          ],
        ),
      ),
    );
  }
}
