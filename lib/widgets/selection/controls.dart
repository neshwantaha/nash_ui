import 'package:flutter/material.dart' hide Checkbox, Radio, Switch;
import 'package:flutter/material.dart' as fl show Checkbox, Radio, Switch;

import '../../radius/app_radius.dart';

/// A backwards-compatible alias for [Chip].
typedef NashChip = Chip;

/// A themed chip used for tags, filters and selected options.
class Chip extends StatelessWidget {
  const Chip({
    super.key,
    required this.label,
    this.avatar,
    this.icon,
    this.selected = false,
    this.onPressed,
    this.onDeleted,
    this.selectedColor,
    this.selectedLabelColor,
    this.backgroundColor,
    this.labelColor,
    this.borderColor,
    this.size,
    this.shape,
    this.side,
    this.padding,
  });

  /// Chip label (can be [String] or [Widget]).
  final dynamic label;

  /// Leading avatar.
  final Widget? avatar;

  /// Leading icon.
  final IconData? icon;

  /// Whether the chip is selected.
  final bool selected;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Delete callback (shows a delete icon when set).
  final VoidCallback? onDeleted;

  /// Selected background color.
  final Color? selectedColor;

  /// Selected label color.
  final Color? selectedLabelColor;

  /// Background color.
  final Color? backgroundColor;

  /// Label color.
  final Color? labelColor;

  /// Border color.
  final Color? borderColor;

  /// Chip height.
  final double? size;

  /// Custom shape border.
  final OutlinedBorder? shape;

  /// Custom border side.
  final BorderSide? side;

  /// Inner padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color resolvedSelectedColor =
        selectedColor ?? scheme.primary.withValues(alpha: 0.14);
    final Color resolvedSelectedLabel = selectedLabelColor ?? scheme.primary;

    final Widget labelWidget;
    if (label is String) {
      labelWidget = Text(
        label as String,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected
                  ? resolvedSelectedLabel
                  : (labelColor ?? scheme.onSurfaceVariant),
              fontWeight: FontWeight.w600,
            ),
      );
    } else if (label is Widget) {
      labelWidget = label as Widget;
    } else {
      labelWidget = const SizedBox.shrink();
    }

    final BorderRadius resolvedRadius =
        BorderRadius.circular(size ?? AppRadius.circular);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: resolvedRadius,
        child: Container(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: ShapeDecoration(
            color: selected
                ? resolvedSelectedColor
                : (backgroundColor ?? scheme.surfaceContainerHighest),
            shape: shape ??
                RoundedRectangleBorder(
                  borderRadius: resolvedRadius,
                  side: side ??
                      BorderSide(
                        color: selected
                            ? resolvedSelectedLabel.withValues(alpha: 0.4)
                            : (borderColor ?? scheme.outlineVariant),
                      ),
                ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (avatar != null) ...<Widget>[
                avatar!,
                const SizedBox(width: 6)
              ],
              if (icon != null) ...<Widget>[
                Icon(
                  icon,
                  size: 16,
                  color: selected
                      ? resolvedSelectedLabel
                      : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
              ],
              labelWidget,
              if (onDeleted != null) ...<Widget>[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onDeleted,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: selected
                        ? resolvedSelectedLabel
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A backwards-compatible alias for [Checkbox].
typedef NashCheckbox = Checkbox;

/// A themed checkbox row.
class Checkbox extends StatelessWidget {
  const Checkbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.semanticsLabel,
    this.enabled = true,
  });

  /// Current value.
  final bool value;

  /// Called with the next value.
  final ValueChanged<bool>? onChanged;

  /// Optional label shown beside the box.
  final String? label;

  /// Checked color.
  final Color? activeColor;

  /// Semantics label.
  final String? semanticsLabel;

  /// Whether the control is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget box = fl.Checkbox(
      value: value,
      onChanged: enabled ? (bool? v) => onChanged?.call(v ?? false) : null,
      activeColor: activeColor ?? scheme.primary,
      semanticLabel: semanticsLabel,
    );
    if (label == null) return box;
    return InkWell(
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          box,
          const SizedBox(width: 8),
          Text(label!),
        ],
      ),
    );
  }
}

/// A backwards-compatible alias for [Radio].
typedef NashRadio = Radio;

/// A themed radio row.
class Radio extends StatelessWidget {
  const Radio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.enabled = true,
  });

  /// Radio value.
  final dynamic value;

  /// Currently selected value in the group.
  final dynamic groupValue;

  /// Called with the selected value.
  final ValueChanged<dynamic>? onChanged;

  /// Optional label.
  final String? label;

  /// Selected color.
  final Color? activeColor;

  /// Whether the control is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget radio = RadioGroup<dynamic>(
      groupValue: groupValue,
      onChanged: (dynamic _) {
        if (enabled) onChanged?.call(value);
      },
      child: fl.Radio<dynamic>(
        value: value,
        activeColor: activeColor ?? scheme.primary,
      ),
    );
    if (label == null) return radio;
    return InkWell(
      onTap: enabled ? () => onChanged?.call(value) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          radio,
          const SizedBox(width: 8),
          Text(label!),
        ],
      ),
    );
  }
}

/// A backwards-compatible alias for [Switch].
typedef NashSwitch = Switch;

/// A themed switch row.
class Switch extends StatelessWidget {
  const Switch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.subtitle,
    this.enabled = true,
  });

  /// Current value.
  final bool value;

  /// Called with the next value.
  final ValueChanged<bool>? onChanged;

  /// Optional label.
  final String? label;

  /// Selected track color.
  final Color? activeColor;

  /// Optional subtitle shown under the label.
  final String? subtitle;

  /// Whether the control is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget switchWidget = fl.Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeTrackColor: activeColor ?? scheme.primary,
    );
    if (label == null && subtitle == null) return switchWidget;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: label == null ? null : Text(label!),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: switchWidget,
      onTap: enabled ? () => onChanged?.call(!value) : null,
    );
  }
}
