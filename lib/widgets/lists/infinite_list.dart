import 'package:flutter/material.dart';
import '../loading/shimmer.dart';

// ─────────────────────────────────────────────────────────────────────────────
// InfiniteList — Paginated list with auto-load-more
// ─────────────────────────────────────────────────────────────────────────────

/// A ListView that calls [onLoadMore] when the user scrolls near the bottom.
/// Shows shimmer skeletons while loading additional items.
///
/// ```dart
/// InfiniteList(
///   itemCount: items.length,
///   itemBuilder: (ctx, i) => ListTile(title: Text(items[i])),
///   hasMore: hasMore,
///   isLoading: isLoadingMore,
///   onLoadMore: () => fetchNextPage(),
/// )
/// ```
class InfiniteList extends StatefulWidget {
  const InfiniteList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onLoadMore,
    this.hasMore = true,
    this.isLoading = false,
    this.loadMoreThreshold = 200.0,
    this.shimmerCount = 3,
    this.padding,
    this.separator,
    this.scrollController,
    this.physics,
    this.shrinkWrap = false,
    this.emptyWidget,
  });

  /// Number of already-loaded items.
  final int itemCount;

  /// Builds each item.
  final IndexedWidgetBuilder itemBuilder;

  /// Called when the user scrolls near the bottom and [hasMore] is true.
  final VoidCallback onLoadMore;

  /// Whether there are more pages to fetch.
  final bool hasMore;

  /// Whether the next page is currently being fetched.
  final bool isLoading;

  /// How many pixels from the bottom to trigger [onLoadMore].
  final double loadMoreThreshold;

  /// Number of shimmer skeleton cards shown while loading more.
  final int shimmerCount;

  final EdgeInsets? padding;
  final Widget? separator;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  /// Widget shown when [itemCount] is 0 and not loading.
  final Widget? emptyWidget;

  @override
  State<InfiniteList> createState() => _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.hasMore || widget.isLoading) return;
    final max = _controller.position.maxScrollExtent;
    final pos = _controller.position.pixels;
    if (pos >= max - widget.loadMoreThreshold) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0 && !widget.isLoading) {
      return widget.emptyWidget ?? const SizedBox.shrink();
    }

    final totalCount = widget.itemCount + (widget.isLoading ? 1 : 0);

    return ListView.separated(
      controller: _controller,
      padding: widget.padding,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      itemCount: totalCount,
      separatorBuilder: (_, __) =>
          widget.separator ?? const SizedBox(height: 8),
      itemBuilder: (ctx, i) {
        if (i >= widget.itemCount) {
          return ShimmerList(
            itemCount: widget.shimmerCount,
          );
        }
        return widget.itemBuilder(ctx, i);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RefreshList — Pull-to-refresh + infinite scroll combined
// ─────────────────────────────────────────────────────────────────────────────

/// Combines pull-to-refresh and infinite scroll in a single widget.
///
/// ```dart
/// RefreshList(
///   itemCount: items.length,
///   itemBuilder: (ctx, i) => MyCard(items[i]),
///   hasMore: hasNextPage,
///   isLoading: isLoadingMore,
///   onRefresh: () => fetchFromStart(),
///   onLoadMore: () => fetchNextPage(),
/// )
/// ```
class RefreshList extends StatelessWidget {
  const RefreshList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    this.hasMore = true,
    this.isLoading = false,
    this.shimmerCount = 3,
    this.padding,
    this.separator,
    this.emptyWidget,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool isLoading;
  final int shimmerCount;
  final EdgeInsets? padding;
  final Widget? separator;
  final Widget? emptyWidget;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: onRefresh,
        color: Theme.of(context).colorScheme.primary,
        child: InfiniteList(
          itemCount: itemCount,
          itemBuilder: itemBuilder,
          onLoadMore: onLoadMore,
          hasMore: hasMore,
          isLoading: isLoading,
          shimmerCount: shimmerCount,
          padding: padding,
          separator: separator,
          emptyWidget: emptyWidget,
          physics: const AlwaysScrollableScrollPhysics(),
        ),
      );
}
