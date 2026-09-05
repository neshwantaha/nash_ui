import 'package:flutter/material.dart';

/// A modern dual-thumb RangeSlider with floating value tooltips and custom styling.
///
/// ```dart
/// AppRangeSlider(
///   values: RangeValues(20, 80),
///   min: 0,
///   max: 100,
///   onChanged: (newValues) => setState(() => values = newValues),
/// )
/// ```
class AppRangeSlider extends StatelessWidget {
  const AppRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.showLabels = true,
    this.prefix = '',
    this.suffix = '',
  });

  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showLabels;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actColor = activeColor ?? theme.colorScheme.primary;
    final inactColor =
        inactiveColor ?? theme.colorScheme.surfaceContainerHighest;

    final startLabel = '$prefix${values.start.round()}$suffix';
    final endLabel = '$prefix${values.end.round()}$suffix';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabels)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  startLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: actColor,
                  ),
                ),
                Text(
                  endLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: actColor,
                  ),
                ),
              ],
            ),
          ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: actColor,
            inactiveTrackColor: inactColor,
            trackHeight: 6,
            thumbColor: actColor,
            overlayColor: actColor.withValues(alpha: 0.15),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 8,
              elevation: 3,
            ),
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            divisions: divisions,
            labels: RangeLabels(startLabel, endLabel),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
