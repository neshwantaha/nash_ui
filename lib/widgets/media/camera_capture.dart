import 'package:flutter/material.dart';

/// A simulated camera capture widget providing a stylised viewfinder UI
/// with capture button, flash toggle, and camera switch controls.
/// Uses the Flutter widget tree only (no camera plugin required).
class CameraCapture extends StatefulWidget {
  const CameraCapture({
    super.key,
    this.onCapture,
    this.onSwitchCamera,
    this.onFlashToggle,
    this.shutterColor,
    this.showGrid = true,
    this.child,
  });

  /// Called when the shutter button is pressed.
  final VoidCallback? onCapture;
  final VoidCallback? onSwitchCamera;
  final ValueChanged<FlashMode>? onFlashToggle;
  final Color? shutterColor;
  final bool showGrid;

  /// Provide your own preview widget (e.g. from camera plugin).
  final Widget? child;

  @override
  State<CameraCapture> createState() => _CameraCaptureState();
}

enum FlashMode { off, auto, on, torch }

class _CameraCaptureState extends State<CameraCapture>
    with SingleTickerProviderStateMixin {
  FlashMode _flashMode = FlashMode.auto;
  bool _frontCamera = false;
  late AnimationController _shutterController;
  late Animation<double> _shutterScale;

  @override
  void initState() {
    super.initState();
    _shutterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _shutterScale = Tween<double>(begin: 1, end: 0.88).animate(
      CurvedAnimation(parent: _shutterController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shutterController.dispose();
    super.dispose();
  }

  IconData get _flashIcon => switch (_flashMode) {
        FlashMode.off => Icons.flash_off,
        FlashMode.auto => Icons.flash_auto,
        FlashMode.on => Icons.flash_on,
        FlashMode.torch => Icons.highlight,
      };

  void _cycleFlash() {
    setState(() {
      _flashMode =
          FlashMode.values[(_flashMode.index + 1) % FlashMode.values.length];
    });
    widget.onFlashToggle?.call(_flashMode);
  }

  Future<void> _onShutter() async {
    widget.onCapture?.call();
    await _shutterController.forward();
    if (mounted) {
      await _shutterController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shutter = widget.shutterColor ?? Colors.white;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Preview area
          widget.child ??
              Container(
                color: Colors.black87,
                child: const Center(
                  child:
                      Icon(Icons.camera_alt, color: Colors.white38, size: 72),
                ),
              ),

          // Grid overlay
          if (widget.showGrid) const CustomPaint(painter: _GridPainter()),

          // Top controls bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _cycleFlash,
                    icon: Icon(_flashIcon, color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('PHOTO',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          // Bottom controls bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Last photo preview placeholder
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white54, width: 1.5),
                    ),
                    child: const Icon(Icons.photo, color: Colors.white60),
                  ),

                  // Shutter button
                  GestureDetector(
                    key: const ValueKey('camera_shutter_button'),
                    onTap: _onShutter,
                    child: ScaleTransition(
                      scale: _shutterScale,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: shutter, width: 3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: shutter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Switch camera
                  IconButton(
                    onPressed: () {
                      setState(() => _frontCamera = !_frontCamera);
                      widget.onSwitchCamera?.call();
                    },
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) =>
                          RotationTransition(turns: anim, child: child),
                      child: Icon(
                        _frontCamera ? Icons.camera_front : Icons.camera_rear,
                        key: ValueKey(_frontCamera),
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Corner viewfinder brackets
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _ViewfinderPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(30)
      ..strokeWidth = 0.5;
    canvas
      ..drawLine(
          Offset(size.width / 3, 0), Offset(size.width / 3, size.height), paint)
      ..drawLine(Offset(size.width * 2 / 3, 0),
          Offset(size.width * 2 / 3, size.height), paint)
      ..drawLine(Offset(0, size.height / 3),
          Offset(size.width, size.height / 3), paint)
      ..drawLine(Offset(0, size.height * 2 / 3),
          Offset(size.width, size.height * 2 / 3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ViewfinderPainter extends CustomPainter {
  const _ViewfinderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    const len = 24.0;
    const margin = 40.0;
    final corners = [
      // top-left
      [
        const Offset(margin, margin + len),
        const Offset(margin, margin),
        const Offset(margin + len, margin)
      ],
      // top-right
      [
        Offset(size.width - margin - len, margin),
        Offset(size.width - margin, margin),
        Offset(size.width - margin, margin + len)
      ],
      // bottom-left
      [
        Offset(margin, size.height - margin - len),
        Offset(margin, size.height - margin),
        Offset(margin + len, size.height - margin)
      ],
      // bottom-right
      [
        Offset(size.width - margin - len, size.height - margin),
        Offset(size.width - margin, size.height - margin),
        Offset(size.width - margin, size.height - margin - len)
      ],
    ];
    for (final c in corners) {
      final path = Path()
        ..moveTo(c[0].dx, c[0].dy)
        ..lineTo(c[1].dx, c[1].dy)
        ..lineTo(c[2].dx, c[2].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
