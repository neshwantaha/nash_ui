import 'package:flutter/material.dart' hide SegmentedButton;
import 'package:flutter/material.dart' as fl show SegmentedButton;

import '../../radius/app_radius.dart';

/// A segmented button control.
class SegmentedButton<T> extends StatelessWidget {
  const SegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.multiSelect = false,
    this.size = SegmentSize.medium,
    this.showSelectedIcon = true,
    this.enabled = true,
  });

  /// Available segments.
  final List<Segment<T>> segments;

  /// Selected value(s).
  final Set<T> selected;

  /// Called when the selection changes.
  final ValueChanged<Set<T>>? onChanged;

  /// Whether multiple segments can be selected.
  final bool multiSelect;

  /// Visual size.
  final SegmentSize size;

  /// Whether to show the check icon on the selected segment.
  final bool showSelectedIcon;

  /// Whether the control is interactive.
  final bool enabled;

  ButtonSegment<T> toSegment(Segment<T> s) => ButtonSegment<T>(
        value: s.value,
        icon: s.icon == null ? null : Icon(s.icon, size: 18),
        label: Text(s.label),
        tooltip: s.tooltip,
        enabled: s.enabled,
      );

  @override
  Widget build(BuildContext context) {
    if (multiSelect) {
      return fl.SegmentedButton<T>(
        segments: segments.map(toSegment).toList(),
        selected: selected,
        onSelectionChanged:
            enabled ? (Set<T> value) => onChanged?.call(value) : null,
        multiSelectionEnabled: true,
        showSelectedIcon: showSelectedIcon,
        style: _style(context),
      );
    }
    return fl.SegmentedButton<T>(
      segments: segments.map(toSegment).toList(),
      selected: selected,
      onSelectionChanged:
          enabled ? (Set<T> value) => onChanged?.call(value) : null,
      showSelectedIcon: showSelectedIcon,
      style: _style(context),
    );
  }

  ButtonStyle? _style(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double padding = switch (size) {
      SegmentSize.small => 8.0,
      SegmentSize.medium => 12.0,
      SegmentSize.large => 16.0,
    };
    return ButtonStyle(
      visualDensity:
          VisualDensity(vertical: size == SegmentSize.small ? -2 : 0),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: padding),
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? scheme.primary
            : scheme.onSurfaceVariant,
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? scheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
      ),
      side: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? BorderSide(color: scheme.primary.withValues(alpha: 0.4))
            : BorderSide(color: scheme.outlineVariant),
      ),
      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium)),
      ),
    );
  }
}

/// A single segmented control option.
class Segment<T> {
  const Segment({
    required this.value,
    required this.label,
    this.icon,
    this.tooltip,
    this.enabled = true,
  });

  /// Segment value.
  final T value;

  /// Segment label.
  final String label;

  /// Optional icon.
  final IconData? icon;

  /// Tooltip text.
  final String? tooltip;

  /// Whether this segment is enabled.
  final bool enabled;
}

/// Visual sizes for [SegmentedButton].
enum SegmentSize {
  /// Compact.
  small,

  /// Default.
  medium,

  /// Large / touch-friendly.
  large,
}
