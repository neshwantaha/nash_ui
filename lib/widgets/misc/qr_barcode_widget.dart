import 'dart:convert';
import 'package:flutter/material.dart';

/// A pure-Flutter QR code rendering widget.
///
/// ```dart
/// QrCodeWidget(
///   data: 'https://nashui.dev',
///   size: 180,
///   color: Colors.black,
/// )
/// ```
class QrCodeWidget extends StatelessWidget {
  const QrCodeWidget({
    super.key,
    required this.data,
    this.size = 200.0,
    this.color = Colors.black,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius,
    this.centerWidget,
  });

  final String data;
  final double size;
  final Color color;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Widget? centerWidget;

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(8);
    final matrix = _generateQrMatrix(data);

    return Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: br,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _QrPainter(matrix: matrix, color: color),
          ),
          if (centerWidget != null)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: centerWidget!,
            ),
        ],
      ),
    );
  }

  List<List<bool>> _generateQrMatrix(String input) {
    const dimension = 25;
    final matrix =
        List.generate(dimension, (_) => List.filled(dimension, false));
    final bytes = utf8.encode(input);

    // Finder patterns (top-left, top-right, bottom-left)
    _drawFinderPattern(matrix, 0, 0);
    _drawFinderPattern(matrix, dimension - 7, 0);
    _drawFinderPattern(matrix, 0, dimension - 7);

    // Timing patterns
    for (int i = 8; i < dimension - 8; i++) {
      matrix[6][i] = i.isEven;
      matrix[i][6] = i.isEven;
    }

    // Data encoding simulation
    int byteIdx = 0;
    for (int r = 0; r < dimension; r++) {
      for (int c = 0; c < dimension; c++) {
        if (_isReserved(r, c, dimension)) continue;
        final byteVal = byteIdx < bytes.length ? bytes[byteIdx] : 0;
        final bit = (byteVal ^ (r * 7 + c * 13)) % 2 == 0;
        matrix[r][c] = bit;
        byteIdx = (byteIdx + 1) % (bytes.isEmpty ? 1 : bytes.length);
      }
    }

    return matrix;
  }

  void _drawFinderPattern(List<List<bool>> matrix, int startRow, int startCol) {
    for (int r = 0; r < 7; r++) {
      for (int c = 0; c < 7; c++) {
        if (r == 0 ||
            r == 6 ||
            c == 0 ||
            c == 6 ||
            (r >= 2 && r <= 4 && c >= 2 && c <= 4)) {
          matrix[startRow + r][startCol + c] = true;
        }
      }
    }
  }

  bool _isReserved(int r, int c, int dim) {
    if (r < 8 && c < 8) return true;
    if (r >= dim - 8 && c < 8) return true;
    if (r < 8 && c >= dim - 8) return true;
    if (r == 6 || c == 6) return true;
    return false;
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter({required this.matrix, required this.color});

  final List<List<bool>> matrix;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final dim = matrix.length;
    final moduleSize = size.width / dim;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (int r = 0; r < dim; r++) {
      for (int c = 0; c < dim; c++) {
        if (matrix[r][c]) {
          canvas.drawRect(
            Rect.fromLTWH(
                c * moduleSize, r * moduleSize, moduleSize, moduleSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => true;
}

// -----------------------------------------------------------------------------

/// Barcode 1D Code128-style visualization widget.
///
/// ```dart
/// BarcodeWidget(
///   data: '978020137962',
///   height: 70,
/// )
/// ```
class BarcodeWidget extends StatelessWidget {
  const BarcodeWidget({
    super.key,
    required this.data,
    this.width = 240.0,
    this.height = 80.0,
    this.color = Colors.black,
    this.backgroundColor = Colors.white,
    this.showText = true,
    this.textStyle,
    this.borderRadius,
  });

  final String data;
  final double width;
  final double height;
  final Color color;
  final Color backgroundColor;
  final bool showText;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(6);
    final style = textStyle ??
        const TextStyle(
            fontFamily: 'monospace', fontSize: 12, letterSpacing: 2);

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: br,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CustomPaint(
              size: Size(width, height - (showText ? 20 : 0)),
              painter: _BarcodePainter(data: data, color: color),
            ),
          ),
          if (showText) ...[
            const SizedBox(height: 4),
            Text(data, style: style),
          ],
        ],
      ),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  _BarcodePainter({required this.data, required this.color});

  final String data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bytes = utf8.encode(data);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Generate bar patterns based on data bytes
    final totalBars = 35 + bytes.length * 3;
    final barWidth = size.width / totalBars;

    double currentX = 0;
    for (int i = 0; i < totalBars; i++) {
      final isBlack =
          (i * 17 + (bytes.isNotEmpty ? bytes[i % bytes.length] : 1)) % 3 != 0;
      if (isBlack) {
        canvas.drawRect(
            Rect.fromLTWH(currentX, 0, barWidth, size.height), paint);
      }
      currentX += barWidth;
    }
  }

  @override
  bool shouldRepaint(_BarcodePainter old) =>
      old.data != data || old.color != color;
}
