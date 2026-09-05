import 'dart:async';
import 'package:flutter/material.dart';

/// A lightweight in-app diagnostics overlay showing FPS, screen size, and device orientation.
class DebugOverlay extends StatefulWidget {
  const DebugOverlay({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  int _fps = 60;
  int _frameCount = 0;
  Timer? _timer;
  DateTime _lastTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final now = DateTime.now();
        final elapsed = now.difference(_lastTime).inMilliseconds;
        if (elapsed > 0 && mounted) {
          setState(() {
            _fps = ((_frameCount * 1000) / elapsed).round().clamp(1, 120);
            _frameCount = 0;
            _lastTime = now;
          });
        }
      });
      WidgetsBinding.instance.addPersistentFrameCallback((_) {
        _frameCount++;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final media = MediaQuery.of(context);
    final size = media.size;

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: media.padding.top + 8,
          right: 12,
          child: IgnorePointer(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(180),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24, width: 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _fps >= 50
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_fps FPS | ${size.width.toInt()}x${size.height.toInt()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
