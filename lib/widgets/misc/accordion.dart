import 'package:flutter/material.dart';

/// A single accordion panel.
class AccordionItem {
  const AccordionItem({
    required this.header,
    required this.body,
    this.initiallyExpanded = false,
  });

  final Widget header;
  final Widget body;
  final bool initiallyExpanded;
}

/// A list of expandable accordion (collapsible) panels.
///
/// ```dart
/// Accordion(
///   items: [
///     AccordionItem(
///       header: Text('What is nash_ui?'),
///       body: Text('A comprehensive Flutter design system.'),
///     ),
///     AccordionItem(
///       header: Text('Is it free?'),
///       body: Text('Yes, MIT licensed.'),
///       initiallyExpanded: true,
///     ),
///   ],
/// )
/// ```
class Accordion extends StatefulWidget {
  const Accordion({
    super.key,
    required this.items,
    this.allowMultipleOpen = false,
    this.dividerColor,
    this.elevation = 0,
    this.iconColor,
    this.expandedIconColor,
  });

  final List<AccordionItem> items;

  /// When true, multiple panels can be expanded simultaneously.
  final bool allowMultipleOpen;
  final Color? dividerColor;
  final double elevation;
  final Color? iconColor;
  final Color? expandedIconColor;

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  late final List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.items.map((e) => e.initiallyExpanded).toList();
  }

  void _toggle(int index) {
    setState(() {
      if (widget.allowMultipleOpen) {
        _expanded[index] = !_expanded[index];
      } else {
        for (int i = 0; i < _expanded.length; i++) {
          _expanded[i] = i == index ? !_expanded[i] : false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: List.generate(widget.items.length, (i) {
        final item = widget.items[i];
        final isOpen = _expanded[i];
        return Card(
          elevation: widget.elevation,
          margin: const EdgeInsets.symmetric(vertical: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: widget.dividerColor ??
                  theme.colorScheme.outline.withAlpha(70),
            ),
          ),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(8),
                  bottom: isOpen ? Radius.zero : const Radius.circular(8),
                ),
                onTap: () => _toggle(i),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(child: item.header),
                      AnimatedRotation(
                        turns: isOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: isOpen
                              ? (widget.expandedIconColor ??
                                  theme.colorScheme.primary)
                              : (widget.iconColor ??
                                  theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: isOpen
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: item.body,
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
