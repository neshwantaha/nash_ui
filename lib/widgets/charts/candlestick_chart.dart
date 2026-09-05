import 'dart:math';
import 'package:flutter/material.dart';

/// A candlestick OHLC chart for stocks and financial data.
///
/// ```dart
/// CandlestickChart(
///   candles: [
///     Candle(open: 100, high: 120, low: 90, close: 115, date: 'Mon'),
///     ...
///   ],
/// )
/// ```
class Candle {
  const Candle({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.date = '',
    this.volume,
  });

  final double open;
  final double high;
  final double low;
  final double close;
  final String date;
  final double? volume;

  bool get isBullish => close >= open;
}

class CandlestickChart extends StatelessWidget {
  const CandlestickChart({
    super.key,
    required this.candles,
    this.height = 240,
    this.bullColor,
    this.bearColor,
    this.wickWidth = 1.5,
    this.bodyWidthFactor = 0.55,
    this.showDates = true,
    this.gridLines = 5,
  });

  final List<Candle> candles;
  final double height;
  final Color? bullColor;
  final Color? bearColor;
  final double wickWidth;
  final double bodyWidthFactor;
  final bool showDates;
  final int gridLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bull = bullColor ?? const Color(0xFF26A69A);
    final bear = bearColor ?? const Color(0xFFEF5350);

    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _CandlePainter(
          candles: candles,
          bullColor: bull,
          bearColor: bear,
          wickWidth: wickWidth,
          bodyWidthFactor: bodyWidthFactor,
          gridLines: gridLines,
          gridColor: theme.colorScheme.outlineVariant.withAlpha(80),
          labelStyle: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 9,
          ),
          showDates: showDates,
        ),
      ),
    );
  }
}

class _CandlePainter extends CustomPainter {
  _CandlePainter({
    required this.candles,
    required this.bullColor,
    required this.bearColor,
    required this.wickWidth,
    required this.bodyWidthFactor,
    required this.gridLines,
    required this.gridColor,
    required this.showDates,
    this.labelStyle,
  });

  final List<Candle> candles;
  final Color bullColor;
  final Color bearColor;
  final double wickWidth;
  final double bodyWidthFactor;
  final int gridLines;
  final Color gridColor;
  final bool showDates;
  final TextStyle? labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final chartBottom = size.height - (showDates ? 18 : 0);
    final chartHeight = chartBottom;

    final allHigh = candles.map((c) => c.high).reduce(max);
    final allLow = candles.map((c) => c.low).reduce(min);
    final range = max(allHigh - allLow, 0.001);

    double toY(double v) => chartHeight - ((v - allLow) / range) * chartHeight;

    // Grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;
    for (int i = 0; i <= gridLines; i++) {
      final y = chartHeight * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final colWidth = size.width / candles.length;
    final bodyW = colWidth * bodyWidthFactor;

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final cx = colWidth * i + colWidth / 2;
      final color = c.isBullish ? bullColor : bearColor;
      final paint = Paint()..color = color;

      // Wick
      canvas.drawLine(
        Offset(cx, toY(c.high)),
        Offset(cx, toY(c.low)),
        paint..strokeWidth = wickWidth,
      );

      // Body
      final top = toY(max(c.open, c.close));
      final bottom = toY(min(c.open, c.close));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - bodyW / 2, top, bodyW, max(bottom - top, 1)),
          const Radius.circular(2),
        ),
        paint..style = PaintingStyle.fill,
      );

      // Date labels
      if (showDates &&
          c.date.isNotEmpty &&
          i % max(1, candles.length ~/ 5) == 0) {
        final tp = TextPainter(
          text: TextSpan(text: c.date, style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(cx - tp.width / 2, chartBottom + 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => true;
}
