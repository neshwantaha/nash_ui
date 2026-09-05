import 'dart:math';
import 'package:flutter/material.dart';

/// A particle data model.
class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.dx,
    required this.dy,
    required this.opacity,
    required this.color,
  });

  double x, y, radius, dx, dy, opacity;
  final Color color;
}

/// An ambient floating particles background widget.
class FloatingParticles extends StatefulWidget {
  const FloatingParticles({
    super.key,
    required this.child,
    this.particleCount = 50,
    this.colors,
    this.minRadius = 1.5,
    this.maxRadius = 4.0,
    this.speed = 0.4,
  });

  final Widget child;
  final int particleCount;
  final List<Color>? colors;
  final double minRadius;
  final double maxRadius;
  final double speed;

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<_Particle> _particles = [];
  final Random _rng = Random();
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..addListener(_update)
      ..repeat();
  }

  void _initParticles(Size size) {
    if (_particles.isNotEmpty) return;
    _size = size;
    final colors = widget.colors ??
        [Colors.white, Colors.white60, Colors.blueAccent, Colors.purpleAccent];
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_Particle(
        x: _rng.nextDouble() * size.width,
        y: _rng.nextDouble() * size.height,
        radius: widget.minRadius +
            _rng.nextDouble() * (widget.maxRadius - widget.minRadius),
        dx: (_rng.nextDouble() - 0.5) * widget.speed,
        dy: (_rng.nextDouble() - 0.5) * widget.speed,
        opacity: 0.3 + _rng.nextDouble() * 0.7,
        color: colors[_rng.nextInt(colors.length)],
      ));
    }
  }

  void _update() {
    if (_size == Size.zero) return;
    for (final p in _particles) {
      p
        ..x += p.dx
        ..y += p.dy;
      if (p.x < 0) p.x = _size.width;
      if (p.x > _size.width) p.x = 0;
      if (p.y < 0) p.y = _size.height;
      if (p.y > _size.height) p.y = 0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, constraints) {
          _initParticles(Size(constraints.maxWidth, constraints.maxHeight));
          return Stack(
            children: [
              widget.child,
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) => CustomPaint(
                      painter: _ParticlePainter(_particles),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.particles);
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withAlpha((p.opacity * 255).round())
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => true;
}
