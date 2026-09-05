import 'package:flutter/material.dart';

/// A realistic flight boarding pass / event ticket card widget with cutout notches,
/// dashed perforation divider, and barcode footer.
class BoardingPassCard extends StatelessWidget {
  const BoardingPassCard({
    super.key,
    required this.originCode,
    required this.originCity,
    required this.destinationCode,
    required this.destinationCity,
    required this.passengerName,
    required this.flightNumber,
    required this.gate,
    required this.seat,
    required this.departureTime,
    this.boardingTime,
    this.backgroundColor,
    this.accentColor,
    this.onTap,
  });

  final String originCode;
  final String originCity;
  final String destinationCode;
  final String destinationCity;
  final String passengerName;
  final String flightNumber;
  final String gate;
  final String seat;
  final String departureTime;
  final String? boardingTime;
  final Color? backgroundColor;
  final Color? accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surface;
    final accent = accentColor ?? theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Flight route
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: accent.withAlpha(20),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        originCode,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: accent,
                        ),
                      ),
                      Text(originCity, style: theme.textTheme.bodySmall),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.flight_takeoff, color: accent, size: 24),
                      const SizedBox(height: 4),
                      Text(flightNumber, style: theme.textTheme.labelSmall),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        destinationCode,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: accent,
                        ),
                      ),
                      Text(destinationCity, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),

            // Middle section: Passenger & Flight Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCol('PASSENGER', passengerName, theme),
                      _buildInfoCol('TIME', departureTime, theme),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCol('GATE', gate, theme),
                      _buildInfoCol('SEAT', seat, theme),
                      if (boardingTime != null)
                        _buildInfoCol('BOARDING', boardingTime!, theme),
                    ],
                  ),
                ],
              ),
            ),

            // Perforated Divider
            Row(
              children: [
                Container(
                  width: 14,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(14)),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final count = (constraints.maxWidth / 8).floor();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          count,
                          (_) => Container(
                            width: 4,
                            height: 1.5,
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: 14,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(14)),
                  ),
                ),
              ],
            ),

            // Barcode Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(35, (i) {
                  final isThick = (i * 7) % 3 == 0;
                  return Container(
                    width: isThick ? 3.0 : 1.5,
                    height: 32,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    color: theme.colorScheme.onSurface.withAlpha(180),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCol(String label, String value, ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(120),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
