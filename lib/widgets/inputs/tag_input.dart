import 'package:flutter/material.dart';

/// An interactive tag input field where users can add and remove chips/tags.
///
/// ```dart
/// TagInput(
///   tags: selectedTags,
///   onChanged: (newTags) => setState(() => selectedTags = newTags),
///   hintText: 'Add a tag...',
/// )
/// ```
class TagInput extends StatefulWidget {
  const TagInput({
    super.key,
    required this.tags,
    required this.onChanged,
    this.hintText = 'Add tag...',
    this.maxTags,
    this.tagColor,
    this.tagTextColor,
    this.borderRadius = 8,
    this.allowDuplicates = false,
  });

  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  final String hintText;
  final int? maxTags;
  final Color? tagColor;
  final Color? tagTextColor;
  final double borderRadius;
  final bool allowDuplicates;

  @override
  State<TagInput> createState() => _TagInputState();
}

class _TagInputState extends State<TagInput> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;
    if (widget.maxTags != null && widget.tags.length >= widget.maxTags!) return;
    if (!widget.allowDuplicates && widget.tags.contains(text)) {
      _ctrl.clear();
      return;
    }

    final updated = List<String>.from(widget.tags)..add(text);
    widget.onChanged(updated);
    _ctrl.clear();
  }

  void _removeTag(int index) {
    final updated = List<String>.from(widget.tags)..removeAt(index);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tagBg = widget.tagColor ?? theme.colorScheme.primaryContainer;
    final tagFg = widget.tagTextColor ?? theme.colorScheme.onPrimaryContainer;

    final canAdd =
        widget.maxTags == null || widget.tags.length < widget.maxTags!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...List.generate(widget.tags.length, (i) {
            final tag = widget.tags[i];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: tagBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tag,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: tagFg,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _removeTag(i),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: tagFg.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (canAdd)
            SizedBox(
              width: 120,
              child: TextField(
                controller: _ctrl,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: widget.tags.isEmpty ? widget.hintText : '',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                ),
                style: const TextStyle(fontSize: 14),
                onSubmitted: _addTag,
              ),
            ),
        ],
      ),
    );
  }
}
