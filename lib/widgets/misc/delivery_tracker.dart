import 'package:flutter/material.dart';

/// A single step in order delivery tracking.
class DeliveryStep {
  const DeliveryStep({
    required this.title,
    required this.subtitle,
    required this.time,
    this.isCompleted = false,
    this.isCurrent = false,
    this.icon,
  });

  final String title;
  final String subtitle;
  final String time;
  final bool isCompleted;
  final bool isCurrent;
  final IconData? icon;
}

/// A multi-step delivery tracker with animated pulse on the active step.
class DeliveryTracker extends StatelessWidget {
  const DeliveryTracker({
    super.key,
    required this.steps,
    this.activeColor,
    this.completedColor,
    this.estimatedArrival,
    this.trackingNumber,
  });

  final List<DeliveryStep> steps;
  final Color? activeColor;
  final Color? completedColor;
  final String? estimatedArrival;
  final String? trackingNumber;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final done = completedColor ?? Colors.green;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (estimatedArrival != null || trackingNumber != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (estimatedArrival != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Delivery',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                      Text(
                        estimatedArrival!,
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: active),
                      ),
                    ],
                  ),
                if (trackingNumber != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#$trackingNumber',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
          ],
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            final isLast = index == steps.length - 1;

            Color nodeColor;
            Widget nodeIcon;

            if (step.isCompleted) {
              nodeColor = done;
              nodeIcon = const Icon(Icons.check, size: 14, color: Colors.white);
            } else if (step.isCurrent) {
              nodeColor = active;
              nodeIcon = Icon(step.icon ?? Icons.local_shipping_rounded,
                  size: 14, color: Colors.white);
            } else {
              nodeColor = theme.colorScheme.outlineVariant;
              nodeIcon = Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      shape: BoxShape.circle));
            }

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline Node + Line
                  Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: nodeColor,
                          shape: BoxShape.circle,
                          boxShadow: step.isCurrent
                              ? [
                                  BoxShadow(
                                    color: active.withAlpha(80),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: nodeIcon,
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: step.isCompleted
                                ? done
                                : theme.colorScheme.outlineVariant,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // Step info
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                step.title,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: step.isCurrent || step.isCompleted
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: step.isCurrent
                                      ? active
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                step.time,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            step.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
