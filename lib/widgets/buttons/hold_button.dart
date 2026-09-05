import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';

/// A button that requires the user to press and hold for a duration before triggering.
///
/// Designed to prevent accidental destructive or critical actions (e.g. account deletion,
/// data reset, emergency stop).
///
/// ```dart
/// HoldButton(
///   label: 'Hold to Delete Account',
///   color: AppColors.error,
///   duration: Duration(seconds: 2),
///   onCompleted: () => deleteAccount(),
/// )
/// ```
class HoldButton extends StatefulWidget {
  const HoldButton({
    super.key,
    required this.label,
    required this.onCompleted,
    this.completedLabel = 'Confirmed',
    this.duration = const Duration(milliseconds: 1500),
    this.color,
    this.icon = Icons.lock_outline_rounded,
    this.height = 48.0,
    this.width,
    this.expanded = false,
    this.radius = AppRadius.medium,
  });

  /// Label shown when idle.
  final String label;

  /// Label shown once hold is complete.
  final String completedLabel;

  /// Action triggered when hold reaches 100%.
  final VoidCallback onCompleted;

  /// Duration the user must hold the button.
  final Duration duration;

  /// Theme color (defaults to red/error for danger actions).
  final Color? color;

  /// Leading icon.
  final IconData? icon;

  /// Button height.
  final double height;

  /// Fixed button width.
  final double? width;

  /// When true fills parent width.
  final bool expanded;

  /// Corner radius.
  final double radius;

  @override
  State<HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isCompleted = true);
        widget.onCompleted();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (_isCompleted) return;
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    if (_isCompleted) return;
    if (_controller.status != AnimationStatus.completed) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (_isCompleted) return;
    if (_controller.status != AnimationStatus.completed) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = widget.color ?? AppColors.error;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final progress = _controller.value;

          return Container(
            height: widget.height,
            width: widget.expanded ? double.infinity : widget.width,
            constraints: BoxConstraints(minWidth: widget.width ?? 120),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B151A) : const Color(0xFFFFF1F1),
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                color: primary.withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Progress Bar Background Fill
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      color: primary.withValues(alpha: 0.25),
                    ),
                  ),
                ),

                // Button Content
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            _isCompleted
                                ? Icons.check_circle_rounded
                                : widget.icon,
                            size: 18,
                            color: primary,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          _isCompleted
                              ? widget.completedLabel
                              : (progress > 0
                                  ? '${(progress * 100).toInt()}% Hold...'
                                  : widget.label),
                          style: TextStyle(
                            color: primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
