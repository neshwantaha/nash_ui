import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';
import '../../gradients/brand_gradients.dart';
import '../../radius/app_radius.dart';

/// An item inside a [SplitButton] dropdown menu.
class SplitAction {
  const SplitAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
  });

  /// Menu item label.
  final String label;

  /// Tap callback.
  final VoidCallback onTap;

  /// Optional item icon.
  final IconData? icon;

  /// Whether this action is destructive (styled red).
  final bool isDestructive;
}

/// A split action button with a primary button on the left and a dropdown menu arrow on the right.
///
/// ```dart
/// SplitButton(
///   label: 'Publish',
///   onPressed: () => publishPost(),
///   actions: [
///     SplitAction(label: 'Publish as Draft', onTap: () {}),
///     SplitAction(label: 'Schedule Publish', onTap: () {}),
///   ],
/// )
/// ```
class SplitButton extends StatelessWidget {
  const SplitButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.actions,
    this.icon,
    this.gradient,
    this.color,
    this.height = 48.0,
    this.radius = AppRadius.medium,
  });

  /// Primary button label.
  final String label;

  /// Primary button tap action.
  final VoidCallback onPressed;

  /// Dropdown menu action items.
  final List<SplitAction> actions;

  /// Optional leading icon.
  final IconData? icon;

  /// Custom gradient for the button.
  final Gradient? gradient;

  /// Solid color if gradient is not desired.
  final Color? color;

  /// Button height.
  final double height;

  /// Corner radius.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedGradient =
        color == null ? (gradient ?? AppGradients.primary) : null;
    final bg = color ?? AppColors.primary;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: resolvedGradient,
        color: resolvedGradient == null ? bg : null,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color:
                (resolvedGradient?.colors.first ?? bg).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main Action Button
            InkWell(
              onTap: onPressed,
              borderRadius:
                  BorderRadius.horizontal(left: Radius.circular(radius)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            Container(
              width: 1,
              height: height * 0.55,
              color: Colors.white.withValues(alpha: 0.3),
            ),

            // Dropdown Trigger
            PopupMenuButton<SplitAction>(
              tooltip: 'More options',
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                side: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.08),
                ),
              ),
              color: isDark ? const Color(0xFF1B1B2B) : Colors.white,
              onSelected: (action) => action.onTap(),
              itemBuilder: (context) => actions.map((action) {
                final itemColor = action.isDestructive
                    ? AppColors.error
                    : (isDark ? Colors.white : Colors.black87);
                return PopupMenuItem<SplitAction>(
                  value: action,
                  child: Row(
                    children: [
                      if (action.icon != null) ...[
                        Icon(action.icon, size: 18, color: itemColor),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        action.label,
                        style: TextStyle(
                          color: itemColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
