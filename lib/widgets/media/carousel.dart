import 'dart:async';
import 'package:flutter/material.dart';

import '../../animation/duration.dart';
import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';

/// A modern, swipeable carousel widget with auto-play, indicators, and navigation controls.
class Carousel extends StatefulWidget {
  const Carousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 220,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.viewportFraction = 1.0,
    this.enlargeCenterPage = false,
    this.showIndicators = true,
    this.showArrows = false,
    this.indicatorColor,
    this.activeIndicatorColor,
    this.borderRadius = AppRadius.large,
    this.onPageChanged,
  });

  /// Total number of items.
  final int itemCount;

  /// Widget builder for each page.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Carousel height.
  final double height;

  /// Whether to automatically advance pages.
  final bool autoPlay;

  /// Interval between auto-advancements.
  final Duration autoPlayInterval;

  /// Fraction of viewport occupied by each item.
  final double viewportFraction;

  /// Scales up the center active item when viewportFraction < 1.0.
  final bool enlargeCenterPage;

  /// Whether to show the dot indicator at the bottom.
  final bool showIndicators;

  /// Whether to show left/right navigation arrows.
  final bool showArrows;

  /// Inactive dot color.
  final Color? indicatorColor;

  /// Active dot color.
  final Color? activeIndicatorColor;

  /// Border radius of carousel container.
  final double borderRadius;

  /// Callback when active page index changes.
  final ValueChanged<int>? onPageChanged;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
    );
    if (widget.autoPlay && widget.itemCount > 1) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.autoPlayInterval, (Timer timer) {
      if (!mounted || widget.itemCount <= 1) return;
      final int next = (_currentPage + 1) % widget.itemCount;
      _pageController.animateToPage(
        next,
        duration: AppDuration.normal,
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    widget.onPageChanged?.call(index);
  }

  void _previous() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: AppDuration.normal,
        curve: Curves.easeInOutCubic,
      );
    } else {
      _pageController.animateToPage(
        widget.itemCount - 1,
        duration: AppDuration.normal,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _next() {
    if (_currentPage < widget.itemCount - 1) {
      _pageController.nextPage(
        duration: AppDuration.normal,
        curve: Curves.easeInOutCubic,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: AppDuration.normal,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color activeColor = widget.activeIndicatorColor ?? AppColors.primary;
    final Color inactiveColor =
        widget.indicatorColor ?? (isDark ? Colors.white24 : Colors.black12);

    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // Carousel PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.itemCount,
            onPageChanged: _onPageChanged,
            itemBuilder: (BuildContext context, int index) {
              final Widget child = ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: widget.itemBuilder(context, index),
              );

              if (!widget.enlargeCenterPage) return child;

              return AnimatedBuilder(
                animation: _pageController,
                builder: (BuildContext context, Widget? _) {
                  double scale = 1.0;
                  if (_pageController.position.haveDimensions) {
                    final double page =
                        _pageController.page ?? _currentPage.toDouble();
                    scale =
                        (1 - ((page - index).abs() * 0.15)).clamp(0.85, 1.0);
                  }
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
              );
            },
          ),

          // Left Arrow
          if (widget.showArrows && widget.itemCount > 1)
            Positioned(
              left: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: _ArrowButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: _previous,
                ),
              ),
            ),

          // Right Arrow
          if (widget.showArrows && widget.itemCount > 1)
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: _ArrowButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: _next,
                ),
              ),
            ),

          // Dot Indicators
          if (widget.showIndicators && widget.itemCount > 1)
            Positioned(
              bottom: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(widget.itemCount, (int i) {
                  final bool isActive = i == _currentPage;
                  return AnimatedContainer(
                    duration: AppDuration.fast,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 22 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? activeColor : inactiveColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.black.withValues(alpha: 0.35),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      );
}
