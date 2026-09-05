import 'package:flutter/material.dart' hide Card;

import '../../icons/app_icons.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';
import '../media/avatar.dart';
import 'card.dart';

/// A product card with image, title, price and actions.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    this.imageUrl,
    this.oldPrice,
    this.discount,
    this.rating,
    this.onTap,
    this.onAddToCart,
    this.onFavorite,
    this.favorite = false,
    this.subtitle,
  });

  /// Product name.
  final String title;

  /// Current price.
  final String price;

  /// Product image URL.
  final String? imageUrl;

  /// Strike-through original price.
  final String? oldPrice;

  /// Discount badge text (e.g. `-20%`).
  final String? discount;

  /// Rating value (0–5).
  final double? rating;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Add-to-cart callback.
  final VoidCallback? onAddToCart;

  /// Favorite toggle callback.
  final VoidCallback? onFavorite;

  /// Whether the product is favorited.
  final bool favorite;

  /// Optional subtitle.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Card(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.25,
                child: imageUrl == null
                    ? Container(
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          AppIcons.photo,
                          size: 40,
                          color: scheme.onSurfaceVariant,
                        ),
                      )
                    : Image.network(imageUrl!, fit: BoxFit.cover),
              ),
              if (discount != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.error,
                      borderRadius: BorderRadius.circular(AppRadius.circular),
                    ),
                    child: Text(
                      discount!,
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: scheme.surface.withValues(alpha: 0.85),
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: Icon(
                      favorite ? AppIcons.favoriteFilled : AppIcons.favorite,
                      size: 20,
                      color: favorite ? scheme.error : scheme.onSurfaceVariant,
                    ),
                    onPressed: onFavorite,
                    iconSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
                const SizedBox(height: 6),
                if (rating != null)
                  Row(
                    children: <Widget>[
                      const Icon(AppIcons.star,
                          size: 16, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        rating!.toStringAsFixed(1),
                        style: textTheme.labelMedium
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          price,
                          style: textTheme.titleLarge?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (oldPrice != null) ...<Widget>[
                          const SizedBox(width: 6),
                          Text(
                            oldPrice!,
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    IconButton.filledTonal(
                      onPressed: onAddToCart,
                      icon: const Icon(AppIcons.add, size: 20),
                      tooltip: 'Add to cart',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A user profile card with avatar, name and actions.
class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.name,
    this.avatarUrl,
    this.subtitle,
    this.onTap,
    this.onMessage,
    this.onCall,
    this.trailing,
    this.initial,
  });

  /// User name.
  final String name;

  /// Avatar image URL.
  final String? avatarUrl;

  /// Subtitle (e.g. role, company).
  final String? subtitle;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Message action.
  final VoidCallback? onMessage;

  /// Call action.
  final VoidCallback? onCall;

  /// Custom trailing widget.
  final Widget? trailing;

  /// Initials fallback.
  final String? initial;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Card(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Avatar(
              url: avatarUrl, initials: initial ?? _initials(name), radius: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else ...<Widget>[
            if (onMessage != null) ...[
              IconButton(
                onPressed: onMessage,
                icon: const Icon(AppIcons.send, size: 20),
              ),
            ],
            if (onCall != null) ...[
              IconButton(
                onPressed: onCall,
                icon: const Icon(AppIcons.call, size: 20),
              ),
            ],
          ],
        ],
      ),
    );
  }

  static String _initials(String name) {
    final List<String> parts =
        name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
