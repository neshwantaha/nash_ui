import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../animation/duration.dart';
import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';
import '../../shadows/shadow.dart';
import '../../spacing/app_spacing.dart';

/// An individual action or search item in a [CommandPalette].
class CommandItem {
  const CommandItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.category = 'General',
    this.shortcut,
    this.badge,
    this.badgeColor,
    this.onSelected,
  });

  /// Action title.
  final String title;

  /// Optional subtitle or helper text.
  final String? subtitle;

  /// Leading icon.
  final IconData? icon;

  /// Group category (e.g. "Navigation", "Actions", "Settings").
  final String category;

  /// Optional keyboard shortcut label (e.g. "Ctrl+N", "⌘P").
  final String? shortcut;

  /// Optional badge text (e.g. "New", "Pro").
  final String? badge;

  /// Custom badge color.
  final Color? badgeColor;

  /// Callback executed when this item is selected.
  final VoidCallback? onSelected;
}

/// Shows a modern command palette (Spotlight / Ctrl+K search dialog).
Future<T?> showCommandPalette<T>(
  BuildContext context, {
  required List<CommandItem> items,
  String placeholder = 'Type a command or search…',
  bool barrierDismissible = true,
}) =>
    showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss Command Palette',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: AppDuration.fast,
      pageBuilder: (BuildContext context, Animation<double> anim1,
              Animation<double> anim2) =>
          CommandPalette(items: items, placeholder: placeholder),
      transitionBuilder: (BuildContext context, Animation<double> anim,
          Animation<double> secondaryAnim, Widget child) {
        final CurvedAnimation curved =
            CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );

/// A Spotlight-style command palette dialog.
class CommandPalette extends StatefulWidget {
  const CommandPalette({
    super.key,
    required this.items,
    this.placeholder = 'Type a command or search…',
  });

  final List<CommandItem> items;
  final String placeholder;

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';
  int _selectedIndex = 0;

  List<CommandItem> get _filteredItems {
    if (_query.trim().isEmpty) return widget.items;
    final String q = _query.toLowerCase();
    return widget.items
        .where((CommandItem item) =>
            item.title.toLowerCase().contains(q) ||
            (item.subtitle?.toLowerCase().contains(q) ?? false) ||
            item.category.toLowerCase().contains(q))
        .toList();
  }

  Map<String, List<CommandItem>> get _groupedItems {
    final Map<String, List<CommandItem>> map = <String, List<CommandItem>>{};
    for (final CommandItem item in _filteredItems) {
      map.putIfAbsent(item.category, () => <CommandItem>[]).add(item);
    }
    return map;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final List<CommandItem> items = _filteredItems;
    if (items.isEmpty) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % items.length;
      });
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedIndex = (_selectedIndex - 1 + items.length) % items.length;
      });
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (_selectedIndex >= 0 && _selectedIndex < items.length) {
        _selectItem(items[_selectedIndex]);
      }
    }
  }

  void _selectItem(CommandItem item) {
    Navigator.of(context).pop();
    item.onSelected?.call();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<CommandItem> filtered = _filteredItems;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: _handleKey,
          child: Container(
            width: 600,
            constraints: const BoxConstraints(maxHeight: 480),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161626) : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08),
              ),
              boxShadow: AppShadow.strong,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.large),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Search header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _focusNode,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: InputDecoration(
                              hintText: widget.placeholder,
                              hintStyle: TextStyle(
                                color: isDark ? Colors.white38 : Colors.black38,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              filled: false,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (String val) {
                              setState(() {
                                _query = val;
                                _selectedIndex = 0;
                              });
                            },
                          ),
                        ),
                        if (_query.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _query = '';
                                _selectedIndex = 0;
                              });
                            },
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'ESC',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action items list
                  Flexible(
                    child: filtered.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(AppSpacing.xxl),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.search_off_rounded,
                                    size: 40,
                                    color: isDark
                                        ? Colors.white24
                                        : Colors.black26),
                                const SizedBox(height: 12),
                                Text(
                                  'No matching commands found',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.black38,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm),
                            children: _buildGroupedWidgets(isDark, scheme),
                          ),
                  ),

                  // Bottom helper bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.02)
                          : Colors.black.withValues(alpha: 0.02),
                      border: Border(
                        top: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _KeyHint(isDark: isDark, label: '↑↓'),
                            const SizedBox(width: 4),
                            Text(
                              'Navigate',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white38 : Colors.black38,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _KeyHint(isDark: isDark, label: '↵'),
                            const SizedBox(width: 4),
                            Text(
                              'Select',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white38 : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${filtered.length} commands',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGroupedWidgets(bool isDark, ColorScheme scheme) {
    final List<Widget> widgets = <Widget>[];
    int flatIndex = 0;

    _groupedItems.forEach((String category, List<CommandItem> items) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            category.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: isDark ? Colors.white38 : Colors.black38,
            ),
          ),
        ),
      );

      for (final CommandItem item in items) {
        final int currentIndex = flatIndex;
        final bool isSelected = currentIndex == _selectedIndex;

        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Material(
              color: isSelected
                  ? (isDark
                      ? scheme.primary.withValues(alpha: 0.18)
                      : scheme.primary.withValues(alpha: 0.08))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: InkWell(
                onTap: () => _selectItem(item),
                onHover: (bool hovered) {
                  if (hovered) setState(() => _selectedIndex = currentIndex);
                },
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      if (item.icon != null) ...<Widget>[
                        Icon(
                          item.icon,
                          size: 18,
                          color: isSelected
                              ? scheme.primary
                              : (isDark ? Colors.white70 : Colors.black54),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 13,
                                color: isSelected
                                    ? scheme.primary
                                    : (isDark ? Colors.white : Colors.black87),
                              ),
                            ),
                            if (item.subtitle != null)
                              Text(
                                item.subtitle!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      isDark ? Colors.white38 : Colors.black38,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (item.badge != null) ...<Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item.badgeColor?.withValues(alpha: 0.15) ??
                                AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.badge!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: item.badgeColor ?? AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (item.shortcut != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.shortcut!,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        flatIndex++;
      }
    });

    return widgets;
  }
}

class _KeyHint extends StatelessWidget {
  const _KeyHint({required this.isDark, required this.label});
  final bool isDark;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
        ),
      );
}
