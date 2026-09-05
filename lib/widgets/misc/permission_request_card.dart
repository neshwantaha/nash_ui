import 'package:flutter/material.dart';

/// A card prompting the user to grant a specific device permission (Camera, Location, Notifications, etc.).
class PermissionRequestCard extends StatelessWidget {
  const PermissionRequestCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onRequest,
    this.isGranted = false,
    this.grantButtonLabel = 'Allow Access',
    this.grantedLabel = 'Granted',
    this.iconColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onRequest;
  final bool isGranted;
  final String grantButtonLabel;
  final String grantedLabel;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = iconColor ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isGranted
                ? Colors.green.withAlpha(80)
                : theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isGranted ? Colors.green : accent).withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isGranted ? Icons.check_circle_rounded : icon,
              color: isGranted ? Colors.green : accent,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 10),
                if (!isGranted)
                  FilledButton.tonal(
                    onPressed: onRequest,
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(grantButtonLabel),
                  )
                else
                  Row(
                    children: [
                      const Icon(Icons.check, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        grantedLabel,
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
