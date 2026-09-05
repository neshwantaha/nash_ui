import 'package:flutter/material.dart';

/// A multi-stop gradient color picker widget.
/// Allows users to add, remove, and reorder gradient stops interactively.
class GradientPicker extends StatefulWidget {
  const GradientPicker({
    super.key,
    this.initialColors = const [Color(0xFF6C63FF), Color(0xFFFF6584)],
    this.onChanged,
    this.height = 48,
    this.borderRadius,
  });

  final List<Color> initialColors;
  final ValueChanged<LinearGradient>? onChanged;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<GradientPicker> createState() => _GradientPickerState();
}

class _GradientPickerState extends State<GradientPicker> {
  late List<Color> _colors;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _colors = List.from(widget.initialColors);
  }

  LinearGradient get _gradient => LinearGradient(colors: _colors);

  void _notify() => widget.onChanged?.call(_gradient);

  void _addStop() {
    if (_colors.length >= 6) return;
    final mid = Color.lerp(_colors.last, Colors.white, 0.5) ?? Colors.white;
    setState(() => _colors.add(mid));
    _notify();
  }

  void _removeStop(int index) {
    if (_colors.length <= 2) return;
    setState(() {
      _colors.removeAt(index);
      if (_selectedIndex >= _colors.length) _selectedIndex = _colors.length - 1;
    });
    _notify();
  }

  void _changeColor(int index, Color color) {
    setState(() => _colors[index] = color);
    _notify();
  }

  static const List<Color> _palette = [
    Color(0xFF6C63FF),
    Color(0xFFFF6584),
    Color(0xFF43E97B),
    Color(0xFFF7971E),
    Color(0xFF2193B0),
    Color(0xFFFF512F),
    Color(0xFFA18CD1),
    Color(0xFFFDA085),
    Color(0xFF11998E),
    Color(0xFFFC5C7D),
    Color(0xFF6A3093),
    Color(0xFF1A1A2E),
    Colors.white,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final br = widget.borderRadius ?? BorderRadius.circular(16);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient preview bar
        ClipRRect(
          borderRadius: br,
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              gradient: _gradient,
              borderRadius: br,
              boxShadow: [
                BoxShadow(
                    color: _colors.first.withAlpha(80),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Stop buttons
        Row(
          children: [
            ...List.generate(_colors.length, (i) {
              final selected = i == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                onLongPress: () => _removeStop(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  width: selected ? 36 : 28,
                  height: selected ? 36 : 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _colors[i],
                    border: Border.all(
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      width: selected ? 3 : 1.5,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                                color: _colors[i].withAlpha(120), blurRadius: 8)
                          ]
                        : null,
                  ),
                ),
              );
            }),
            if (_colors.length < 6)
              GestureDetector(
                onTap: _addStop,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: theme.colorScheme.outline, width: 1.5),
                  ),
                  child: Icon(Icons.add,
                      size: 16, color: theme.colorScheme.onSurface),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Color palette for selected stop
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _palette
              .map((Color c) => GestureDetector(
                    onTap: () => _changeColor(_selectedIndex, c),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c,
                        border: Border.all(
                          color: _colors[_selectedIndex] == c
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withAlpha(80),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
