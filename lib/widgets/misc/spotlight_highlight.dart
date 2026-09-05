import 'package:flutter/material.dart';

/// Highlights a specific widget on screen with a spotlight/darkened backdrop.
///
/// Useful for feature onboarding, tutorials, and guided tours.
///
/// ```dart
/// SpotlightHighlight(
///   isVisible: showTip,
///   message: 'Tap here to add a new item',
///   child: FloatingActionButton(onPressed: _add, child: Icon(Icons.add)),
/// )
/// ```
class SpotlightHighlight extends StatefulWidget {
  const SpotlightHighlight({
    super.key,
    required this.child,
    required this.isVisible,
    this.message,
    this.barrierColor = const Color(0xCC000000),
    this.spotlightRadius = 80,
    this.spotlightShape = BoxShape.circle,
    this.borderColor,
    this.onDismiss,
    this.messagePadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.messageStyle,
  });

  /// The widget to highlight.
  final Widget child;

  /// Whether the spotlight is active.
  final bool isVisible;

  /// Optional caption shown below or above the spotlight.
  final String? message;

  /// Dark overlay color.
  final Color barrierColor;

  /// Radius of the circular spotlight.
  final double spotlightRadius;

  /// Shape of the spotlight cutout.
  final BoxShape spotlightShape;

  /// Optional glowing border around the spotlight.
  final Color? borderColor;

  /// Called when the user taps outside the spotlight.
  final VoidCallback? onDismiss;

  final EdgeInsets messagePadding;
  final TextStyle? messageStyle;

  @override
  State<SpotlightHighlight> createState() => _SpotlightHighlightState();
}

class _SpotlightHighlightState extends State<SpotlightHighlight>
    with SingleTickerProviderStateMixin {
  final _key = GlobalKey();
  late AnimationController _ctrl;
  late Animation<double> _fade;
  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    if (widget.isVisible) _show();
  }

  @override
  void didUpdateWidget(SpotlightHighlight old) {
    super.didUpdateWidget(old);
    if (widget.isVisible && !old.isVisible) {
      _show();
    } else if (!widget.isVisible && old.isVisible) {
      _hide();
    }
  }

  Rect _getTargetRect() {
    final ctx = _key.currentContext;
    if (ctx == null) return Rect.zero;
    final box = ctx.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    return pos & box.size;
  }

  void _show() {
    _entry = OverlayEntry(builder: (_) => _buildOverlay());
    Overlay.of(context).insert(_entry!);
    _ctrl.forward();
  }

  void _hide() {
    _ctrl.reverse().then((_) {
      _entry?.remove();
      _entry = null;
    });
  }

  @override
  void dispose() {
    _entry?.remove();
    _ctrl.dispose();
    super.dispose();
  }

  Widget _buildOverlay() {
    final rect = _getTargetRect();
    final center = rect.center;
    final r = widget.spotlightRadius;

    return FadeTransition(
      opacity: _fade,
      child: GestureDetector(
        onTap: widget.onDismiss,
        child: Stack(
          children: [
            // Dark backdrop with hole
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _SpotlightPainter(
                center: center,
                radius: r,
                color: widget.barrierColor,
                borderColor: widget.borderColor,
              ),
            ),
            // Message bubble
            if (widget.message != null)
              Positioned(
                left: 16,
                right: 16,
                top: center.dy + r + 20,
                child: Center(
                  child: Container(
                    padding: widget.messagePadding,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                        )
                      ],
                    ),
                    child: Text(
                      widget.message!,
                      textAlign: TextAlign.center,
                      style: widget.messageStyle ??
                          const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1F2937),
                              fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: _key, child: widget.child);
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({
    required this.center,
    required this.radius,
    required this.color,
    this.borderColor,
  });

  final Offset center;
  final double radius;
  final Color color;
  final Color? borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);

    if (borderColor != null) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = borderColor!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) =>
      old.center != center || old.radius != radius;
}
