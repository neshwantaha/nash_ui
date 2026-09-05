import 'package:flutter/material.dart';

/// A smooth animated numeric counter widget supporting prefix, suffix,
/// decimal places, and curved number transitions.
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 1200),
    this.curve = Curves.easeOutCubic,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.decimalPlaces = 0,
    this.formatter,
  });

  final num value;
  final Duration duration;
  final Curve curve;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final int decimalPlaces;
  final String Function(num)? formatter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = style ??
        theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, val, _) {
        final formattedNumber = formatter != null
            ? formatter!(val)
            : decimalPlaces > 0
                ? val.toStringAsFixed(decimalPlaces)
                : val.round().toString();

        return Text(
          '$prefix$formattedNumber$suffix',
          style: textStyle,
        );
      },
    );
  }
}
