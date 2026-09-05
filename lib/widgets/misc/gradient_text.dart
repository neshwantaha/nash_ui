import 'package:flutter/material.dart';

/// A text widget rendered with a moving gradient shader.
///
/// ```dart
/// GradientText(
///   'Nash UI',
///   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
///   gradient: LinearGradient(colors: [Colors.purple, Colors.cyan]),
/// )
/// ```
class GradientText extends StatefulWidget {
  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient,
    this.animate = true,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final Gradient? gradient;
  final bool animate;
  final TextAlign? textAlign;

  @override
  State<GradientText> createState() => _GradientTextState();
}

class _GradientTextState extends State<GradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.animate) {
      _ctrl.repeat();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.gradient ??
        const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF48CAE4), Color(0xFFFF6584)],
        );

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final shift = _ctrl.value;
        final shiftedGradient = LinearGradient(
          colors: gradient.colors,
          begin: Alignment(-1 + 2 * shift, 0),
          end: Alignment(1 + 2 * shift, 0),
        );
        return ShaderMask(
          shaderCallback: shiftedGradient.createShader,
          blendMode: BlendMode.srcIn,
          child: Text(
            widget.text,
            style: widget.style ??
                const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            textAlign: widget.textAlign,
          ),
        );
      },
    );
  }
}
