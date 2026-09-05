import 'package:flutter/material.dart';

/// A visual distance bar connecting two points with travel mode, ETA, and progress.
class DistanceBar extends StatelessWidget {
  const DistanceBar({
    super.key,
    required this.origin,
    required this.destination,
    required this.distanceText,
    required this.durationText,
    this.progress = 0.5,
    this.travelMode = Icons.directions_car_rounded,
    this.accentColor,
  });

  final String origin;
  final String destination;
  final String distanceText;
  final String durationText;
  final double progress; // 0.0 to 1.0
  final IconData travelMode;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.trip_origin_rounded, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text(
                    origin,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(travelMode, size: 14, color: color),
                    const SizedBox(width: 4),
                    Text(
                      durationText,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    destination,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.location_on_rounded,
                      size: 16, color: Colors.redAccent),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress track
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final indicatorX = (w - 24) * progress.clamp(0.0, 1.0);

              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Base track
                  Container(
                    height: 6,
                    width: w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  // Completed portion
                  Container(
                    height: 6,
                    width: indicatorX + 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  // Floating vehicle indicator
                  Positioned(
                    left: indicatorX,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withAlpha(80),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(travelMode, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              distanceText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
