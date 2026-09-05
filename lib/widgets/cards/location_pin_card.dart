import 'package:flutter/material.dart';

/// A card displaying a geographic location with address, coordinates, and actions.
class LocationPinCard extends StatelessWidget {
  const LocationPinCard({
    super.key,
    required this.title,
    required this.address,
    this.latitude,
    this.longitude,
    this.distance,
    this.onGetDirections,
    this.onShare,
    this.pinColor,
    this.actionLabel = 'Get Directions',
  });

  final String title;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? distance;
  final VoidCallback? onGetDirections;
  final VoidCallback? onShare;
  final Color? pinColor;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = pinColor ?? theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accent.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.location_on_rounded, color: accent, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (distance != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              distance!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (latitude != null && longitude != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (onGetDirections != null || onShare != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                if (onGetDirections != null)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onGetDirections,
                      icon: const Icon(Icons.directions_rounded, size: 18),
                      label: Text(actionLabel),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                if (onShare != null) ...[
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_outlined, size: 18),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
