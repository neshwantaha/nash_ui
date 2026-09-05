import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Celebration confetti burst / shower overlay widget.
///
/// ```dart
/// final _confettiKey = GlobalKey<ConfettiWidgetState>();
///
/// ConfettiWidget(
///   key: _confettiKey,
///   child: MySuccessScreen(),
/// )
///
/// // Trigger burst
/// _confettiKey.currentState?.play();
/// ```
class ConfettiWidget extends StatefulWidget {
  const ConfettiWidget({
    super.key,
    this.child,
    this.particleCount = 60,
    this.colors = const [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.amber,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ],
    this.duration = const Duration(seconds: 3),
    this.autoPlay = false,
  });

  final Widget? child;
  final int particleCount;
  final List<Color> colors;
  final Duration duration;
  final bool autoPlay;

  @override
  State<ConfettiWidget> createState() => ConfettiWidgetState();
}

class ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}));

    if (widget.autoPlay) {
      play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Triggers the confetti celebration particles.
  void play() {
    _generateParticles();
    _controller
      ..reset()
      ..forward();
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(
        _Particle(
          x: 0.5 + (_random.nextDouble() - 0.5) * 0.4,
          y: 0.2,
          vx: (_random.nextDouble() - 0.5) * 2.5,
          vy: -_random.nextDouble() * 3.5 - 1.0,
          color: widget.colors[_random.nextInt(widget.colors.length)],
          size: _random.nextDouble() * 8 + 4,
          rotation: _random.nextDouble() * 2 * math.pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.2,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          if (widget.child != null) widget.child!,
          if (_controller.isAnimating)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ConfettiPainter(
                    particles: _particles,
                    progress: _controller.value,
                  ),
                ),
              ),
            ),
        ],
      );
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });

  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double size;
  double rotation;
  double rotationSpeed;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});

  final List<_Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final gravity = 6.0 * progress;

    for (final p in particles) {
      final currentX = (p.x * size.width) + (p.vx * 100 * progress);
      final currentY = (p.y * size.height) +
          (p.vy * 80 * progress) +
          (0.5 * gravity * progress * size.height);
      final currentRot = p.rotation + p.rotationSpeed * progress * 50;

      final paint = Paint()
        ..color =
            p.color.withAlpha((255 * (1.0 - progress)).clamp(0, 255).toInt())
        ..style = PaintingStyle.fill;

      canvas
        ..save()
        ..translate(currentX, currentY)
        ..rotate(currentRot)
        ..drawRect(
          Rect.fromCenter(
              center: Offset.zero, width: p.size, height: p.size * 0.6),
          paint,
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => true;
}
