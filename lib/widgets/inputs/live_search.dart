import 'dart:async';
import 'package:flutter/material.dart';
import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LiveSearch — Debounced async search with overlay results
// ─────────────────────────────────────────────────────────────────────────────

/// A search input with built-in debounce, loading state, and results overlay.
///
/// ```dart
/// LiveSearch<User>(
///   hint: 'Search users…',
///   onSearch: (query) => api.searchUsers(query),
///   itemBuilder: (ctx, user) => ListTile(title: Text(user.name)),
/// )
/// ```
class LiveSearch<T> extends StatefulWidget {
  const LiveSearch({
    super.key,
    required this.onSearch,
    required this.itemBuilder,
    this.hint = 'Search…',
    this.label,
    this.debounceDelay = const Duration(milliseconds: 400),
    this.minChars = 1,
    this.maxResults = 8,
    this.onSelected,
    this.emptyText = 'No results found',
    this.icon = Icons.search_rounded,
  });

  /// Async function that returns results for the given query.
  final Future<List<T>> Function(String query) onSearch;

  /// Builds each result item in the overlay.
  final Widget Function(BuildContext context, T item) itemBuilder;

  final String hint;
  final String? label;

  /// How long to wait after the user stops typing before searching.
  final Duration debounceDelay;

  /// Minimum characters before triggering a search.
  final int minChars;

  /// Maximum number of results shown in the overlay.
  final int maxResults;

  /// Called when a result item is tapped.
  final void Function(T item)? onSelected;

  final String emptyText;
  final IconData icon;

  @override
  State<LiveSearch<T>> createState() => _LiveSearchState<T>();
}

class _LiveSearchState<T> extends State<LiveSearch<T>> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();

  Timer? _debounce;
  List<T> _results = [];
  bool _isLoading = false;
  String _lastQuery = '';
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _hideOverlay();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    if (query.length < widget.minChars) {
      _hideOverlay();
      return;
    }
    if (query == _lastQuery) return;
    _lastQuery = query;
    _debounce = Timer(widget.debounceDelay, () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() => _isLoading = true);
    _showOverlayEntry();
    try {
      final results = await widget.onSearch(query);
      if (!mounted) return;
      _results = results.take(widget.maxResults).toList();
    } catch (_) {
      _results = [];
    } finally {
      if (mounted) setState(() => _isLoading = false);
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _showOverlayEntry() {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (_) => _SearchOverlay<T>(
        link: _layerLink,
        results: _results,
        isLoading: _isLoading,
        emptyText: widget.emptyText,
        itemBuilder: widget.itemBuilder,
        onSelected: (item) {
          widget.onSelected?.call(item);
          _hideOverlay();
          _controller.clear();
          _focusNode.unfocus();
        },
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: Icon(widget.icon),
          suffixIcon: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        _controller.clear();
                        _hideOverlay();
                      },
                    )
                  : null,
          filled: true,
          fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            borderSide:
                BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            borderSide:
                BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            borderSide: BorderSide(color: scheme.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 4,
          ),
        ),
      ),
    );
  }
}

class _SearchOverlay<T> extends StatelessWidget {
  const _SearchOverlay({
    required this.link,
    required this.results,
    required this.isLoading,
    required this.emptyText,
    required this.itemBuilder,
    required this.onSelected,
  });

  final LayerLink link;
  final List<T> results;
  final bool isLoading;
  final String emptyText;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T) onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      width: 0,
      child: CompositedTransformFollower(
        link: link,
        showWhenUnlinked: false,
        offset: const Offset(0, 56),
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 320),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(
                color: scheme.outline.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: isLoading && results.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : results.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          emptyText,
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        itemCount: results.length,
                        itemBuilder: (ctx, i) => InkWell(
                          onTap: () => onSelected(results[i]),
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          child: itemBuilder(ctx, results[i]),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
