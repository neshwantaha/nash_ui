import 'package:flutter/material.dart';

/// A floating action button that rotates and toggles between Light, Dark, and System theme modes.
class ThemeSwitcherFab extends StatefulWidget {
  const ThemeSwitcherFab({
    super.key,
    required this.currentMode,
    required this.onChanged,
    this.heroTag = 'theme_switcher_fab',
  });

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;
  final Object heroTag;

  @override
  State<ThemeSwitcherFab> createState() => _ThemeSwitcherFabState();
}

class _ThemeSwitcherFabState extends State<ThemeSwitcherFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    _controller.forward(from: 0.0);
    final next = widget.currentMode == ThemeMode.light
        ? ThemeMode.dark
        : widget.currentMode == ThemeMode.dark
            ? ThemeMode.system
            : ThemeMode.light;
    widget.onChanged(next);
  }

  IconData get _icon {
    switch (widget.currentMode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      heroTag: widget.heroTag,
      onPressed: _toggle,
      backgroundColor: theme.colorScheme.primaryContainer,
      foregroundColor: theme.colorScheme.onPrimaryContainer,
      child: RotationTransition(
        turns: Tween<double>(begin: 0.0, end: 0.5).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
        ),
        child: Icon(_icon),
      ),
    );
  }
}
