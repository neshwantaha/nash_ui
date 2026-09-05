import 'package:flutter/material.dart';

import '../../animation/duration.dart';
import '../../colors/brand_colors.dart';
import '../../radius/app_radius.dart';

/// A single node in a [TreeView].
class TreeNode<T> {
  TreeNode({
    required this.label,
    this.value,
    this.icon,
    this.children = const [],
    this.isExpanded = false,
    this.trailing,
  });

  /// Node title label.
  final String label;

  /// Optional generic payload value.
  final T? value;

  /// Leading icon.
  final IconData? icon;

  /// Nested child nodes.
  final List<TreeNode<T>> children;

  /// Whether this node is currently expanded.
  bool isExpanded;

  /// Optional trailing widget (e.g. badge, count, action button).
  final Widget? trailing;

  /// Whether this node has nested children.
  bool get hasChildren => children.isNotEmpty;
}

/// An expandable tree view widget for displaying hierarchical data structures.
class TreeView<T> extends StatefulWidget {
  const TreeView({
    super.key,
    required this.nodes,
    this.onNodeSelected,
    this.indent = 20.0,
    this.selectedNode,
    this.showGuidelines = true,
  });

  /// Root tree nodes.
  final List<TreeNode<T>> nodes;

  /// Callback when any node is tapped.
  final ValueChanged<TreeNode<T>>? onNodeSelected;

  /// Indentation per depth level in logical pixels.
  final double indent;

  /// Currently selected node.
  final TreeNode<T>? selectedNode;

  /// Whether to render vertical guide lines on nested levels.
  final bool showGuidelines;

  @override
  State<TreeView<T>> createState() => _TreeViewState<T>();
}

class _TreeViewState<T> extends State<TreeView<T>> {
  TreeNode<T>? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedNode;
  }

  void _toggleExpand(TreeNode<T> node) {
    setState(() {
      node.isExpanded = !node.isExpanded;
    });
  }

  void _selectNode(TreeNode<T> node) {
    setState(() => _selected = node);
    widget.onNodeSelected?.call(node);
  }

  Widget _buildNode(
      TreeNode<T> node, int depth, bool isDark, ColorScheme scheme) {
    final isSelected = _selected == node;
    final hasChildren = node.hasChildren;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: depth * widget.indent),
          child: Material(
            color: isSelected
                ? (isDark
                    ? scheme.primary.withValues(alpha: 0.18)
                    : scheme.primary.withValues(alpha: 0.08))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: InkWell(
              onTap: () {
                if (hasChildren) _toggleExpand(node);
                _selectNode(node);
              },
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    // Expand/Collapse arrow
                    if (hasChildren)
                      AnimatedRotation(
                        turns: node.isExpanded ? 0.25 : 0.0,
                        duration: AppDuration.fast,
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      )
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 6),

                    // Icon
                    Icon(
                      node.icon ??
                          (hasChildren
                              ? (node.isExpanded
                                  ? Icons.folder_open_rounded
                                  : Icons.folder_rounded)
                              : Icons.insert_drive_file_rounded),
                      size: 18,
                      color: isSelected
                          ? scheme.primary
                          : (hasChildren
                              ? (isDark ? AppColors.amber : AppColors.amber)
                              : (isDark ? Colors.white60 : Colors.black54)),
                    ),
                    const SizedBox(width: 8),

                    // Label
                    Expanded(
                      child: Text(
                        node.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : (hasChildren
                                  ? FontWeight.w600
                                  : FontWeight.w400),
                          color: isSelected
                              ? scheme.primary
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),

                    if (node.trailing != null) node.trailing!,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Recursive Children
        if (hasChildren && node.isExpanded)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: node.children
                .map((child) => _buildNode(child, depth + 1, isDark, scheme))
                .toList(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: widget.nodes
          .map((node) => _buildNode(node, 0, isDark, scheme))
          .toList(),
    );
  }
}
