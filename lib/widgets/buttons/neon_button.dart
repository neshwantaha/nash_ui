import 'package:flutter/material.dart';

/// A neon glow button with animated pulse and color bleed effect.
///
/// ```dart
/// NeonButton(
///   label: 'Sign In',
///   color: Colors.cyanAccent,
///   onPressed: () {},
/// )
/// ```
class NeonButton extends StatefulWidget {
  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.icon,
    this.width,
    this.height = 52,
    this.borderRadius,
    this.textStyle,
    this.pulseAnimation = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;
  final double? width;
  final double height;
  final double? borderRadius;
  final TextStyle? textStyle;
  final bool pulseAnimation;

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    if (widget.pulseAnimation) {
      _pulseCtrl.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final neonColor = widget.color ?? Theme.of(context).colorScheme.primary;
    final br = widget.borderRadius ?? widget.height / 2;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) => GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(br),
              color: Colors.transparent,
              border: Border.all(color: neonColor, width: 1.8),
              boxShadow: [
                BoxShadow(
                  color: neonColor.withAlpha((80 * _pulse.value).round()),
                  blurRadius: 18 * _pulse.value,
                  spreadRadius: 2 * _pulse.value,
                ),
                BoxShadow(
                  color: neonColor.withAlpha((30 * _pulse.value).round()),
                  blurRadius: 40 * _pulse.value,
                  spreadRadius: 4 * _pulse.value,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(br),
              child: Material(
                color: neonColor.withAlpha(20),
                child: InkWell(
                  splashColor: neonColor.withAlpha(60),
                  onTap: widget.onPressed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: neonColor, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: widget.textStyle ??
                            TextStyle(
                              color: neonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: neonColor,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
