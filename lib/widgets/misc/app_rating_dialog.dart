import 'package:flutter/material.dart';

/// A modern "Rate Us" app rating prompt dialog with interactive stars and feedback.
class AppRatingDialog extends StatefulWidget {
  const AppRatingDialog({
    super.key,
    this.title = 'Enjoying Nash UI?',
    this.subtitle = 'Tap a star to rate your experience on the store.',
    this.submitLabel = 'Submit Rating',
    this.cancelLabel = 'Maybe Later',
    this.onSubmit,
    this.starColor = Colors.amber,
  });

  final String title;
  final String subtitle;
  final String submitLabel;
  final String cancelLabel;
  final ValueChanged<int>? onSubmit;
  final Color starColor;

  @override
  State<AppRatingDialog> createState() => _AppRatingDialogState();
}

class _AppRatingDialogState extends State<AppRatingDialog> {
  int _selectedStars = 5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.starColor.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.star_rounded, size: 40, color: widget.starColor),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.subtitle,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Star row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  onPressed: () => setState(() => _selectedStars = starIndex),
                  icon: Icon(
                    starIndex <= _selectedStars
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: widget.starColor,
                    size: 36,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(widget.cancelLabel),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop(_selectedStars);
                      widget.onSubmit?.call(_selectedStars);
                    },
                    child: Text(widget.submitLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
