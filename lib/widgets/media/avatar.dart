import 'package:flutter/material.dart';

import '../../colors/brand_colors.dart';
import '../../gradients/brand_gradients.dart';

/// A circular avatar with image, initials or icon fallback.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.url,
    this.initials,
    this.icon,
    this.radius = 20,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.onTap,
    this.online,
  });

  /// Avatar image URL.
  final String? url;

  /// Initials shown when there is no image.
  final String? initials;

  /// Icon shown when there is no image or initials.
  final IconData? icon;

  /// Avatar radius.
  final double radius;

  /// Background color.
  final Color? backgroundColor;

  /// Foreground color for initials/icon.
  final Color? foregroundColor;

  /// Border color.
  final Color? borderColor;

  /// Border width.
  final double? borderWidth;

  /// Tap callback.
  final VoidCallback? onTap;

  /// When set, shows an online status dot.
  final bool? online;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final double size = radius * 2;

    Widget child;
    if (url != null) {
      child = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? scheme.surfaceContainerHighest,
        backgroundImage: NetworkImage(url!),
      );
    } else if (initials != null) {
      child = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ??
            AppColors.contrastFor(scheme.primary).withValues(alpha: 0.1),
        child: Text(
          initials!.length > 2 ? initials!.substring(0, 2) : initials!,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: foregroundColor ?? scheme.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
      );
    } else {
      child = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ??
            AppGradients.brand.colors.first.withValues(alpha: 0.15),
        child: Icon(
          icon ?? Icons.person,
          size: radius * 0.9,
          color: foregroundColor ?? scheme.primary,
        ),
      );
    }

    final Widget avatar = Container(
      width: size,
      height: size,
      decoration: borderColor != null
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor!, width: borderWidth ?? 2),
            )
          : null,
      child: child,
    );

    Widget result =
        onTap == null ? avatar : GestureDetector(onTap: onTap, child: avatar);

    if (online != null) {
      result = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          result,
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: radius * 0.55,
              height: radius * 0.55,
              decoration: BoxDecoration(
                color: online! ? AppColors.success : AppColors.neutral[400],
                shape: BoxShape.circle,
                border: Border.all(color: scheme.surface, width: 2),
              ),
            ),
          ),
        ],
      );
    }
    return result;
  }
}
