import 'dart:async';
import 'package:flutter/material.dart';

/// Preset animation effects for [AnimatedTextKit].
enum AnimatedTextEffect {
  typewriter,
  fade,
  scale,
  wavy,
}

/// A versatile animated text display supporting Typewriter, Fade, Scale,
/// and Wavy character-by-character animations.
class AnimatedTextKit extends StatefulWidget {
  const AnimatedTextKit({
    super.key,
    required this.texts,
    this.effect = AnimatedTextEffect.typewriter,
    this.textStyle,
    this.duration = const Duration(milliseconds: 80),
    this.pause = const Duration(seconds: 2),
    this.repeat = true,
    this.onFinished,
  });

  final List<String> texts;
  final AnimatedTextEffect effect;
  final TextStyle? textStyle;
  final Duration duration;
  final Duration pause;
  final bool repeat;
  final VoidCallback? onFinished;

  @override
  State<AnimatedTextKit> createState() => _AnimatedTextKitState();
}

class _AnimatedTextKitState extends State<AnimatedTextKit>
    with SingleTickerProviderStateMixin {
  int _textIndex = 0;
  int _charIndex = 0;
  Timer? _timer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _startAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (widget.texts.isEmpty) return;

    if (widget.effect == AnimatedTextEffect.typewriter) {
      _charIndex = 0;
      _timer = Timer.periodic(widget.duration, (t) {
        final currentText = widget.texts[_textIndex];
        if (_charIndex < currentText.length) {
          setState(() => _charIndex++);
        } else {
          t.cancel();
          _timer = Timer(widget.pause, _nextText);
        }
      });
    } else {
      _fadeController.forward().then((_) {
        _timer = Timer(widget.pause, () {
          _fadeController.reverse().then((_) => _nextText());
        });
      });
    }
  }

  void _nextText() {
    if (!mounted) return;
    if (_textIndex < widget.texts.length - 1) {
      setState(() => _textIndex++);
      _startAnimation();
    } else if (widget.repeat) {
      setState(() => _textIndex = 0);
      _startAnimation();
    } else {
      widget.onFinished?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.textStyle ?? theme.textTheme.titleMedium;
    final currentText = widget.texts.isNotEmpty ? widget.texts[_textIndex] : '';

    if (widget.effect == AnimatedTextEffect.typewriter) {
      return Text(
        currentText.substring(0, _charIndex.clamp(0, currentText.length)),
        style: style,
      );
    }

    if (widget.effect == AnimatedTextEffect.scale) {
      return ScaleTransition(
        scale: _fadeAnimation,
        child: Text(currentText, style: style),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(currentText, style: style),
    );
  }
}
