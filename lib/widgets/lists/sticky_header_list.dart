import 'package:flutter/material.dart';

/// A sticky-header list builder.
///
/// Groups items under floating sticky headers while scrolling.
///
/// ```dart
/// StickyHeaderList(
///   sections: [
///     StickySection(
///       header: Text('A'),
///       children: [ListTile(title: Text('Apple'))],
///     ),
///     StickySection(
///       header: Text('B'),
///       children: [ListTile(title: Text('Banana'))],
///     ),
///   ],
/// )
/// ```
class StickySection {
  const StickySection({
    required this.header,
    required this.children,
  });

  final Widget header;
  final List<Widget> children;
}

class StickyHeaderList extends StatefulWidget {
  const StickyHeaderList({
    super.key,
    required this.sections,
    this.headerDecoration,
    this.headerPadding,
    this.shrinkWrap = false,
    this.physics,
    this.controller,
  });

  final List<StickySection> sections;
  final BoxDecoration? headerDecoration;
  final EdgeInsetsGeometry? headerPadding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  @override
  State<StickyHeaderList> createState() => _StickyHeaderListState();
}

class _StickyHeaderListState extends State<StickyHeaderList> {
  final ScrollController _fallback = ScrollController();

  ScrollController get _ctrl => widget.controller ?? _fallback;

  // Map from section index → global offset
  final Map<int, double> _offsets = {};

  int get _currentSection {
    final offset = _ctrl.hasClients ? _ctrl.offset : 0.0;
    int active = 0;
    for (final entry in _offsets.entries) {
      if (entry.value <= offset + 1) {
        active = entry.key;
      }
    }
    return active;
  }

  @override
  void dispose() {
    if (widget.controller == null) _fallback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        setState(() {});
        return false;
      },
      child: Stack(
        children: [
          ListView.builder(
            controller: _ctrl,
            shrinkWrap: widget.shrinkWrap,
            physics: widget.physics,
            itemCount: widget.sections.length,
            itemBuilder: (context, i) {
              final sec = widget.sections[i];
              return _SectionWidget(
                section: sec,
                index: i,
                headerDecoration: widget.headerDecoration ??
                    BoxDecoration(
                      color: theme.colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.outline.withAlpha(50),
                        ),
                      ),
                    ),
                headerPadding: widget.headerPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                onBuild: (offset) => _offsets[i] = offset,
              );
            },
          ),
          // Floating sticky header
          if (_ctrl.hasClients)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: widget.headerPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: widget.headerDecoration ??
                    BoxDecoration(
                      color: theme.colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.outline.withAlpha(50),
                        ),
                      ),
                    ),
                child: widget.sections[_currentSection].header,
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionWidget extends StatefulWidget {
  const _SectionWidget({
    required this.section,
    required this.index,
    required this.headerDecoration,
    required this.headerPadding,
    required this.onBuild,
  });

  final StickySection section;
  final int index;
  final BoxDecoration headerDecoration;
  final EdgeInsetsGeometry headerPadding;
  final void Function(double offset) onBuild;

  @override
  State<_SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<_SectionWidget> {
  final _key = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final pos = box.localToGlobal(Offset.zero);
    widget.onBuild(pos.dy);
  }

  @override
  Widget build(BuildContext context) => Column(
        key: _key,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: widget.headerPadding,
            decoration: widget.headerDecoration,
            child: widget.section.header,
          ),
          ...widget.section.children,
        ],
      );
}
