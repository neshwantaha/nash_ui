import 'dart:math';
import 'package:flutter/material.dart';

/// An interactive spinning wheel of fortune widget with physics deceleration,
/// customizable slices, and win callbacks.
class WheelOfFortune extends StatefulWidget {
  const WheelOfFortune({
    super.key,
    required this.items,
    this.size = 280,
    this.onResult,
    this.colors = const [
      Color(0xFF6C63FF),
      Color(0xFFFF6584),
      Color(0xFF38EF7D),
      Color(0xFFF7971E),
      Color(0xFF2193B0),
      Color(0xFFFFD200),
    ],
  });

  final List<String> items;
  final double size;
  final ValueChanged<String>? onResult;
  final List<Color> colors;

  @override
  State<WheelOfFortune> createState() => WheelOfFortuneState();
}

class WheelOfFortuneState extends State<WheelOfFortune>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentAngle = 0.0;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void spin({int? targetIndex}) {
    if (_isSpinning || widget.items.isEmpty) return;

    final n = widget.items.length;
    final sliceAngle = (2 * pi) / n;
    final random = Random();
    final chosen = targetIndex ?? random.nextInt(n);

    // Calculate final rotation with multiple full spins
    final extraSpins = 5 + random.nextInt(3);
    final targetAngle =
        (extraSpins * 2 * pi) + ((n - chosen - 0.5) * sliceAngle);

    _animation = Tween<double>(
      begin: _currentAngle,
      end: _currentAngle + targetAngle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    setState(() => _isSpinning = true);

    _controller.reset();
    _controller.forward().then((_) {
      _currentAngle = (_currentAngle + targetAngle) % (2 * pi);
      setState(() => _isSpinning = false);
      widget.onResult?.call(widget.items[chosen]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: widget.size,
      height: widget.size + 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicator Arrow
          const Icon(
            Icons.arrow_drop_down,
            size: 36,
            color: Colors.amber,
          ),
          // Wheel Stack
          GestureDetector(
            onTap: spin,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      final angle =
                          _isSpinning ? _animation.value : _currentAngle;
                      return Transform.rotate(
                        angle: angle,
                        child: CustomPaint(
                          size: Size(widget.size, widget.size),
                          painter: _WheelPainter(
                            items: widget.items,
                            colors: widget.colors,
                          ),
                        ),
                      );
                    },
                  ),
                  // Center Hub
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 8),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'SPIN',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter({required this.items, required this.colors});

  final List<String> items;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final n = items.length;
    if (n == 0) return;
    final sweep = (2 * pi) / n;

    final paint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < n; i++) {
      final startAngle = (i * sweep) - (pi / 2);
      paint.color = colors[i % colors.length];

      canvas
        ..drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweep,
          true,
          paint,
        )
        ..drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweep,
          true,
          borderPaint,
        )
        ..save()
        ..translate(center.dx, center.dy)
        ..rotate(startAngle + (sweep / 2));

      final tp = TextPainter(
        text: TextSpan(
          text: items[i],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();

      tp.paint(canvas, Offset(radius * 0.45, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old) =>
      old.items != items || old.colors != colors;
}
