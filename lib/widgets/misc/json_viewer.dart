import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An interactive, collapsible JSON viewer with syntax highlighting and copy-to-clipboard.
class JsonViewer extends StatefulWidget {
  const JsonViewer({
    super.key,
    required this.json,
    this.initialExpanded = true,
    this.maxHeight = 350,
  });

  /// Accepts a JSON String or Map/List dynamic.
  final dynamic json;
  final bool initialExpanded;
  final double maxHeight;

  @override
  State<JsonViewer> createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
  dynamic _parsed;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _parseJson();
  }

  @override
  void didUpdateWidget(covariant JsonViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.json != widget.json) {
      _parseJson();
    }
  }

  void _parseJson() {
    if (widget.json is String) {
      try {
        _parsed = jsonDecode(widget.json as String);
      } catch (_) {
        _parsed = widget.json;
      }
    } else {
      _parsed = widget.json;
    }
  }

  void _copy() {
    final str = widget.json is String
        ? widget.json as String
        : const JsonEncoder.withIndent('  ').convert(_parsed);
    Clipboard.setData(ClipboardData(text: str));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                  bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.data_object_rounded,
                        size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'JSON Data',
                      style: theme.textTheme.labelMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _copy,
                  icon: Icon(_copied ? Icons.check : Icons.copy_rounded,
                      size: 14),
                  label: Text(_copied ? 'Copied' : 'Copy',
                      style: const TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
          // Collapsible JSON Tree
          Container(
            constraints: BoxConstraints(maxHeight: widget.maxHeight),
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildNode(_parsed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode(dynamic value, {int indent = 0}) {
    if (value is Map) {
      return _buildMap(Map<String, dynamic>.from(value), indent: indent);
    } else if (value is List) {
      return _buildList(value.cast<dynamic>(), indent: indent);
    } else {
      return _buildPrimitive(value);
    }
  }

  Widget _buildMap(Map<String, dynamic> map, {int indent = 0}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: map.entries.map((entry) {
          final isComplex = entry.value is Map || entry.value is List;
          return Padding(
            padding: EdgeInsets.only(left: indent * 16.0, top: 2, bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${entry.key}": ',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                if (!isComplex)
                  _buildPrimitive(entry.value)
                else
                  _buildNode(entry.value, indent: 1),
              ],
            ),
          );
        }).toList(),
      );

  Widget _buildList(List<dynamic> list, {int indent = 0}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list
            .map((item) => Padding(
                  padding:
                      EdgeInsets.only(left: indent * 16.0, top: 2, bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('- ',
                          style: TextStyle(
                              fontFamily: 'monospace', color: Colors.grey)),
                      _buildNode(item, indent: 1),
                    ],
                  ),
                ))
            .toList(),
      );

  Widget _buildPrimitive(dynamic val) {
    Color valColor = Colors.grey;
    if (val is num) {
      valColor = const Color(0xFF26A69A);
    } else if (val is bool) {
      valColor = const Color(0xFFFF9800);
    } else if (val is String) {
      valColor = const Color(0xFF42A5F5);
    }

    final displayStr = val is String ? '"$val"' : '$val';

    return Text(
      displayStr,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        color: valColor,
      ),
    );
  }
}
