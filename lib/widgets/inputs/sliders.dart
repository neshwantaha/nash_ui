import 'package:flutter/material.dart' hide Slider, RangeSlider;
import 'package:flutter/material.dart' as fl show Slider, RangeSlider;

import '../../colors/brand_colors.dart';

/// A backwards-compatible alias for [Slider].
typedef NashSlider = Slider;

/// A custom styled single-value slider with gradient track and tooltip labels.
class Slider extends StatelessWidget {
  const Slider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.showMinMaxLabels = false,
    this.prefix = '',
    this.suffix = '',
  });

  /// Current slider value.
  final double value;

  /// Value change callback.
  final ValueChanged<double>? onChanged;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of discrete divisions.
  final int? divisions;

  /// Tooltip label text.
  final String? label;

  /// Active track/thumb color.
  final Color? activeColor;

  /// Inactive track color.
  final Color? inactiveColor;

  /// Whether to display min and max text labels below the slider.
  final bool showMinMaxLabels;

  /// Prefix added to min/max labels (e.g. '$').
  final String prefix;

  /// Suffix added to min/max labels (e.g. '%', 'px').
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primary = activeColor ?? AppColors.primary;
    final Color inactive =
        inactiveColor ?? (isDark ? Colors.white12 : Colors.black12);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: primary,
            inactiveTrackColor: inactive,
            thumbColor: primary,
            overlayColor: primary.withValues(alpha: 0.15),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(),
            valueIndicatorColor: primary,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          child: fl.Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            label: label ??
                '$prefix${value.toStringAsFixed(divisions != null && divisions! > 10 ? 0 : 1)}$suffix',
            onChanged: onChanged,
          ),
        ),
        if (showMinMaxLabels)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '$prefix${min.toStringAsFixed(0)}$suffix',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black45,
                  ),
                ),
                Text(
                  '$prefix${max.toStringAsFixed(0)}$suffix',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A backwards-compatible alias for [RangeSlider].
typedef NashRangeSlider = RangeSlider;

/// A custom styled dual-thumb range slider with gradient track and tooltip labels.
class RangeSlider extends StatelessWidget {
  const RangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.labels,
    this.activeColor,
    this.inactiveColor,
    this.showMinMaxLabels = false,
    this.prefix = '',
    this.suffix = '',
  });

  /// Current range values (start and end).
  final RangeValues values;

  /// Range change callback.
  final ValueChanged<RangeValues>? onChanged;

  /// Minimum value.
  final double min;

  /// Maximum value.
  final double max;

  /// Number of discrete divisions.
  final int? divisions;

  /// Optional custom tooltip labels for start and end thumbs.
  final RangeLabels? labels;

  /// Active track/thumb color.
  final Color? activeColor;

  /// Inactive track color.
  final Color? inactiveColor;

  /// Whether to display min and max text labels below the slider.
  final bool showMinMaxLabels;

  /// Prefix added to labels (e.g. '$').
  final String prefix;

  /// Suffix added to labels (e.g. '%').
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primary = activeColor ?? AppColors.primary;
    final Color inactive =
        inactiveColor ?? (isDark ? Colors.white12 : Colors.black12);

    final RangeLabels resolvedLabels = labels ??
        RangeLabels(
          '$prefix${values.start.toStringAsFixed(0)}$suffix',
          '$prefix${values.end.toStringAsFixed(0)}$suffix',
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: primary,
            inactiveTrackColor: inactive,
            rangeThumbShape: const RoundRangeSliderThumbShape(),
            trackHeight: 6,
            rangeValueIndicatorShape:
                const RectangularRangeSliderValueIndicatorShape(),
            valueIndicatorColor: primary,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          child: fl.RangeSlider(
            values: RangeValues(
              values.start.clamp(min, max),
              values.end.clamp(min, max),
            ),
            min: min,
            max: max,
            divisions: divisions,
            labels: resolvedLabels,
            onChanged: onChanged,
          ),
        ),
        if (showMinMaxLabels)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '$prefix${min.toStringAsFixed(0)}$suffix',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black45,
                  ),
                ),
                Text(
                  '$prefix${max.toStringAsFixed(0)}$suffix',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
