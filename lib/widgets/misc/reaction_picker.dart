import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An emoji reaction picker popup.
///
/// ```dart
/// ReactionPicker(
///   onReact: (emoji) => print('Reacted: $emoji'),
/// )
/// ```
class ReactionPicker extends StatefulWidget {
  const ReactionPicker({
    super.key,
    required this.onReact,
    this.emojis = const ['❤️', '👍', '😂', '😮', '😢', '😡'],
    this.child,
  });

  final ValueChanged<String> onReact;
  final List<String> emojis;
  final Widget? child;

  @override
  State<ReactionPicker> createState() => _ReactionPickerState();
}

class _ReactionPickerState extends State<ReactionPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  bool _visible = false;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _show() {
    HapticFeedback.lightImpact();
    setState(() => _visible = true);
    _ctrl.forward();
  }

  void _hide() {
    _ctrl
        .reverse()
        .then((_) => mounted ? setState(() => _visible = false) : null);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: _show,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_visible)
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(30),
                          blurRadius: 12,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.emojis.length, (i) {
                      final hovered = _hoveredIndex == i;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          widget.onReact(widget.emojis[i]);
                          _hide();
                        },
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = i),
                          onExit: (_) => setState(() => _hoveredIndex = null),
                          child: AnimatedScale(
                            scale: hovered ? 1.5 : 1.0,
                            duration: const Duration(milliseconds: 150),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                widget.emojis[i],
                                style: const TextStyle(fontSize: 26),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            widget.child ?? const SizedBox.shrink(),
          ],
        ),
      );
}
