import 'package:flutter/material.dart';

import '../../animation/duration.dart';
import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';

/// A professional pagination widget with page buttons, ellipsis, and navigation controls.
class Pagination extends StatelessWidget {
  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.siblingCount = 1,
    this.showEdges = true,
    this.activeColor,
    this.itemSize = 36,
  });

  /// The active 1-indexed page number.
  final int currentPage;

  /// Total number of pages (must be >= 1).
  final int totalPages;

  /// Callback when a page button is tapped.
  final ValueChanged<int> onPageChanged;

  /// Number of sibling page buttons on each side of active page.
  final int siblingCount;

  /// Whether to show First / Last buttons.
  final bool showEdges;

  /// Custom active button color.
  final Color? activeColor;

  /// Size of each page button (width and height).
  final double itemSize;

  List<dynamic> _buildPageRange() {
    final List<dynamic> pages = [];
    final int start = (currentPage - siblingCount).clamp(1, totalPages);
    final int end = (currentPage + siblingCount).clamp(1, totalPages);

    if (start > 1) {
      pages.add(1);
      if (start > 2) pages.add('…');
    }

    for (int i = start; i <= end; i++) {
      pages.add(i);
    }

    if (end < totalPages) {
      if (end < totalPages - 1) pages.add('…');
      pages.add(totalPages);
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    final primary = activeColor ?? scheme.primary;
    final pageRange = _buildPageRange();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous Button
        _PageButton(
          size: itemSize,
          isDark: isDark,
          enabled: currentPage > 1,
          onTap: () => onPageChanged(currentPage - 1),
          child: const Icon(Icons.chevron_left_rounded, size: 18),
        ),
        const SizedBox(width: 6),

        // Page numbers
        for (final item in pageRange) ...[
          if (item is int)
            _PageButton(
              size: itemSize,
              isDark: isDark,
              isSelected: item == currentPage,
              activeColor: primary,
              onTap: () => onPageChanged(item),
              child: Text(
                '$item',
                style: TextStyle(
                  fontWeight:
                      item == currentPage ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                  color: item == currentPage
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            )
          else
            SizedBox(
              width: itemSize * 0.7,
              height: itemSize,
              child: Center(
                child: Text(
                  '…',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 4),
        ],

        const SizedBox(width: 2),
        // Next Button
        _PageButton(
          size: itemSize,
          isDark: isDark,
          enabled: currentPage < totalPages,
          onTap: () => onPageChanged(currentPage + 1),
          child: const Icon(Icons.chevron_right_rounded, size: 18),
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.size,
    required this.isDark,
    required this.child,
    this.isSelected = false,
    this.enabled = true,
    this.activeColor,
    this.onTap,
  });

  final double size;
  final bool isDark;
  final Widget child;
  final bool isSelected;
  final bool enabled;
  final Color? activeColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected
        ? (activeColor ?? AppColors.primary)
        : (isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04));

    final border = isSelected
        ? Border.all(color: activeColor ?? AppColors.primary)
        : Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.08),
          );

    return AnimatedContainer(
      duration: AppDuration.fast,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: enabled ? bg : bg.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Center(
            child: Opacity(
              opacity: enabled ? 1.0 : 0.35,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
