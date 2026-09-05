import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';
import '../../gradients/brand_gradients.dart';
import '../../radius/app_radius.dart';

/// An interactive slide-to-confirm / slide-to-act button.
///
/// Commonly used for sensitive actions like checkout, order confirmation,
/// unlocking, and irreversible operations.
///
/// ```dart
/// SlideButton(
///   label: 'Slide to confirm order',
///   completedLabel: 'Order Confirmed!',
///   onCompleted: () async {
///     await processOrder();
///   },
/// )
/// ```
class SlideButton extends StatefulWidget {
  const SlideButton({
    super.key,
    required this.onCompleted,
    this.label = 'Slide to confirm',
    this.completedLabel = 'Completed',
    this.height = 56.0,
    this.radius = AppRadius.circular,
    this.sliderColor,
    this.sliderGradient,
    this.backgroundColor,
    this.icon = Icons.arrow_forward_rounded,
    this.completedIcon = Icons.check_rounded,
    this.autoReset = true,
    this.resetDuration = const Duration(seconds: 2),
  });

  /// Called when the user drags the slider to the end.
  final Future<void> Function() onCompleted;

  /// Label shown when idle.
  final String label;

  /// Label shown after completion.
  final String completedLabel;

  /// Total height of the slider track.
  final double height;

  /// Corner radius.
  final double radius;

  /// Drag handle background color.
  final Color? sliderColor;

  /// Drag handle gradient.
  final Gradient? sliderGradient;

  /// Track background color.
  final Color? backgroundColor;

  /// Drag handle icon.
  final IconData icon;

  /// Success icon after completion.
  final IconData completedIcon;

  /// Whether to automatically slide back to start after completion.
  final bool autoReset;

  /// Duration before auto-resetting.
  final Duration resetDuration;

  @override
  State<SlideButton> createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  bool _isCompleted = false;
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, double maxDrag) {
    if (_isCompleted || _isLoading) return;
    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
    });
  }

  Future<void> _onDragEnd(DragEndDetails details, double maxDrag) async {
    if (_isCompleted || _isLoading) return;

    if (_dragPosition >= maxDrag * 0.85) {
      // Complete the slide
      _anim = Tween<double>(begin: _dragPosition, end: maxDrag).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut),
      )..addListener(() => setState(() => _dragPosition = _anim.value));
      await _animController.forward(from: 0);

      setState(() {
        _isLoading = true;
        _isCompleted = true;
      });

      await widget.onCompleted();

      if (mounted) setState(() => _isLoading = false);

      if (widget.autoReset && mounted) {
        await Future<void>.delayed(widget.resetDuration);
        if (mounted) _reset(maxDrag);
      }
    } else {
      // Snap back to 0
      _anim = Tween<double>(begin: _dragPosition, end: 0.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
      )..addListener(() => setState(() => _dragPosition = _anim.value));
      _animController.forward(from: 0);
    }
  }

  void _reset(double maxDrag) {
    _anim = Tween<double>(begin: _dragPosition, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    )..addListener(() => setState(() => _dragPosition = _anim.value));
    _animController.forward(from: 0).then((_) {
      if (mounted) {
        setState(() {
          _isCompleted = false;
          _dragPosition = 0.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = widget.sliderColor ?? AppColors.primary;
    final bg = widget.backgroundColor ??
        (isDark ? const Color(0xFF161626) : const Color(0xFFEBEBF5));
    final handleSize = widget.height - 8;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - handleSize - 8;
        final progress =
            maxDrag > 0 ? (_dragPosition / maxDrag).clamp(0.0, 1.0) : 0.0;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Progress Fill
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: _dragPosition + handleSize + 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: _isCompleted
                        ? AppColors.emerald.withValues(alpha: 0.2)
                        : primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(widget.radius),
                  ),
                ),
              ),

              // Center Label
              Center(
                child: Opacity(
                  opacity: (1.0 - progress * 1.5).clamp(0.0, 1.0),
                  child: Text(
                    _isCompleted ? widget.completedLabel : widget.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white60 : Colors.black54,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              // Handle
              Positioned(
                left: _dragPosition + 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) => _onDragUpdate(d, maxDrag),
                  onHorizontalDragEnd: (d) => _onDragEnd(d, maxDrag),
                  child: Container(
                    width: handleSize,
                    height: handleSize,
                    decoration: BoxDecoration(
                      gradient: _isCompleted
                          ? null
                          : (widget.sliderGradient ?? AppGradients.primary),
                      color: _isCompleted ? AppColors.emerald : primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isCompleted ? AppColors.emerald : primary)
                              .withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              _isCompleted ? widget.completedIcon : widget.icon,
                              color: Colors.white,
                              size: 22,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
