import 'package:flutter/material.dart';

/// An interactive onboarding overlay that highlights target widgets with
/// a spotlight effect and step-by-step tooltips.
class OnboardingOverlay extends StatefulWidget {
  const OnboardingOverlay({
    super.key,
    required this.steps,
    required this.child,
    this.onFinish,
    this.spotlightColor,
    this.tooltipColor,
    this.barrierColor,
  });

  final List<OnboardingStep> steps;
  final Widget child;
  final VoidCallback? onFinish;
  final Color? spotlightColor;
  final Color? tooltipColor;
  final Color? barrierColor;

  @override
  State<OnboardingOverlay> createState() => _OnboardingOverlayState();
}

class OnboardingStep {
  const OnboardingStep({
    required this.title,
    required this.description,
    required this.targetKey,
    this.tooltipDirection = TooltipDirection.bottom,
  });

  final String title;
  final String description;
  final GlobalKey targetKey;
  final TooltipDirection tooltipDirection;
}

enum TooltipDirection { top, bottom, left, right }

class _OnboardingOverlayState extends State<OnboardingOverlay>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  bool _active = true;
  OverlayEntry? _entry;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    WidgetsBinding.instance.addPostFrameCallback((_) => _show());
  }

  @override
  void dispose() {
    _controller.dispose();
    _entry?.remove();
    super.dispose();
  }

  Rect? _getTargetRect() {
    final ctx = widget.steps[_currentStep].targetKey.currentContext;
    if (ctx == null) return null;
    final rb = ctx.findRenderObject() as RenderBox?;
    if (rb == null) return null;
    final pos = rb.localToGlobal(Offset.zero);
    return pos & rb.size;
  }

  void _show() {
    if (!mounted || !_active) return;
    final target = _getTargetRect();
    if (target == null) return;
    final step = widget.steps[_currentStep];

    _entry?.remove();
    _entry = OverlayEntry(builder: (ctx) => _buildOverlay(ctx, target, step));
    Overlay.of(context).insert(_entry!);
    _controller.forward(from: 0);
  }

  void _next() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep++);
      _show();
    } else {
      _dismiss();
      widget.onFinish?.call();
    }
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      _entry?.remove();
      _entry = null;
      setState(() => _active = false);
    });
  }

  Widget _buildOverlay(BuildContext ctx, Rect target, OnboardingStep step) {
    final theme = Theme.of(ctx);
    final barrier = widget.barrierColor ?? Colors.black.withAlpha(160);
    final tooltipBg = widget.tooltipColor ?? theme.colorScheme.surface;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Stack(
        children: [
          // Dark overlay with spotlight hole
          Positioned.fill(
            child: CustomPaint(
              painter: _SpotlightPainter(rect: target, color: barrier),
            ),
          ),
          // Tooltip card
          Positioned(
            top: step.tooltipDirection == TooltipDirection.bottom
                ? target.bottom + 12
                : step.tooltipDirection == TooltipDirection.top
                    ? target.top - 140
                    : target.top,
            left: (target.left + target.width / 2 - 140)
                .clamp(12, double.infinity),
            child: SizedBox(
              width: 280,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: tooltipBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            step.title,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            '${_currentStep + 1}/${widget.steps.length}',
                            style: theme.textTheme.labelSmall?.copyWith(
                                color:
                                    theme.colorScheme.onSurface.withAlpha(120)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(step.description, style: theme.textTheme.bodySmall),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          TextButton(
                              onPressed: _dismiss, child: const Text('Skip')),
                          const Spacer(),
                          FilledButton(
                            onPressed: _next,
                            child: Text(_currentStep == widget.steps.length - 1
                                ? 'Done'
                                : 'Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({required this.rect, required this.color});
  final Rect rect;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final fullRect = Offset.zero & size;
    const padding = 8.0;
    final spotRect = rect.inflate(padding);
    final rrect = RRect.fromRectAndRadius(spotRect, const Radius.circular(12));

    final path = Path()
      ..addRect(fullRect)
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;

    canvas
      ..drawPath(path, Paint()..color = color)
      ..drawRRect(
        rrect,
        Paint()
          ..color = Colors.white.withAlpha(60)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter old) => old.rect != rect;
}
