import 'package:flutter/material.dart';

/// A text field that shows @mention and #hashtag suggestions.
///
/// ```dart
/// MentionField(
///   mentions: ['alice', 'bob', 'charlie'],
///   hashtags: ['flutter', 'nash_ui', 'design'],
///   onChanged: (text) => print(text),
/// )
/// ```
class MentionField extends StatefulWidget {
  const MentionField({
    super.key,
    this.mentions = const [],
    this.hashtags = const [],
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Write a message...',
    this.maxLines = 4,
    this.decoration,
  });

  final List<String> mentions;
  final List<String> hashtags;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final int maxLines;
  final InputDecoration? decoration;

  @override
  State<MentionField> createState() => _MentionFieldState();
}

class _MentionFieldState extends State<MentionField> {
  final TextEditingController _ctrl = TextEditingController();
  List<String> _suggestions = [];
  String _triggerQuery = '';
  bool _isMention = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onChanged);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged() {
    widget.onChanged?.call(_ctrl.text);
    final text = _ctrl.text;
    final pos = _ctrl.selection.baseOffset;
    if (pos < 0) return;

    final sub = text.substring(0, pos);
    final mentionMatch = RegExp(r'@(\w*)$').firstMatch(sub);
    final hashMatch = RegExp(r'#(\w*)$').firstMatch(sub);

    if (mentionMatch != null) {
      _triggerQuery = mentionMatch.group(1) ?? '';
      _isMention = true;
      setState(() {
        _suggestions = widget.mentions
            .where(
                (m) => m.toLowerCase().startsWith(_triggerQuery.toLowerCase()))
            .toList();
      });
    } else if (hashMatch != null) {
      _triggerQuery = hashMatch.group(1) ?? '';
      _isMention = false;
      setState(() {
        _suggestions = widget.hashtags
            .where(
                (h) => h.toLowerCase().startsWith(_triggerQuery.toLowerCase()))
            .toList();
      });
    } else {
      setState(() => _suggestions = []);
    }
  }

  void _applySuggestion(String suggestion) {
    final text = _ctrl.text;
    final pos = _ctrl.selection.baseOffset;
    final prefix = _isMention ? '@' : '#';
    final start = text.lastIndexOf(prefix, pos);
    if (start < 0) return;
    final newText = text.replaceRange(start, pos, '$prefix$suggestion ');
    _ctrl.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + suggestion.length + 2),
    );
    setState(() => _suggestions = []);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_suggestions.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 160),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(
                    color: theme.colorScheme.outlineVariant, width: 0.5),
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (_, i) => InkWell(
                onTap: () => _applySuggestion(_suggestions[i]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        _isMention
                            ? Icons.alternate_email_rounded
                            : Icons.tag_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _suggestions[i],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        TextField(
          controller: _ctrl,
          maxLines: widget.maxLines,
          onSubmitted: widget.onSubmitted,
          decoration: widget.decoration ??
              InputDecoration(
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
        ),
      ],
    );
  }
}
