import 'package:flutter/material.dart';
import '../utils/rtl_utils.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DirectionalRow — Auto-flips children order for RTL layouts
// ─────────────────────────────────────────────────────────────────────────────

/// A [Row] that automatically reverses child order in RTL locales.
///
/// This is useful for layouts where you manually arrange an icon and text
/// but want it to flip naturally for Arabic/Hebrew/Persian/Urdu UIs.
///
/// ```dart
/// DirectionalRow(
///   children: [
///     Icon(Icons.star_rounded),
///     SizedBox(width: 8),
///     Text('Featured'),
///   ],
/// )
/// // In LTR: ★ Featured
/// // In RTL: Featured ★
/// ```
class DirectionalRow extends StatelessWidget {
  const DirectionalRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing,
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  /// Optional auto-spacing between children (inserts [SizedBox] widgets).
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final isRtl = RtlHelper.isRtl(context);

    final List<Widget> items =
        spacing != null ? _withSpacing(children, spacing!) : children;

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: isRtl ? items.reversed.toList() : items,
    );
  }

  List<Widget> _withSpacing(List<Widget> widgets, double gap) {
    final result = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) result.add(SizedBox(width: gap));
    }
    return result;
  }
}
