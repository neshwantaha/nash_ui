import 'package:flutter/material.dart';

/// A multi-segment progress bar styled like Instagram / Snapchat stories.
///
/// Each segment can be in one of three states:
/// - **done** — fully filled
/// - **active** — animating fill from 0 → 1
/// - **pending** — empty
///
/// ```dart
/// SegmentedProgressBar(
///   segmentCount: 5,
///   currentIndex: 2,
///   progress: 0.4,          // 40% through segment 2
///   duration: Duration(seconds: 5),
///   onComplete: () => setState(() => currentIndex++),
/// )
/// ```
class SegmentedProgressBar extends StatefulWidget {
  const SegmentedProgressBar({
    super.key,
    required this.segmentCount,
    required this.currentIndex,
    this.progress,
    this.duration = const Duration(seconds: 5),
    this.onComplete,
    this.height = 3,
    this.spacing = 4,
    this.activeColor,
    this.pendingColor,
    this.autoPlay = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(2)),
  });

  /// Total number of segments.
  final int segmentCount;

  /// Index of the currently active segment (0-based).
  final int currentIndex;

  /// Manual progress override for the active segment (0.0–1.0).
  /// When null and [autoPlay] is true, the segment auto-fills over [duration].
  final double? progress;

  /// Duration of the auto-fill animation for the active segment.
  final Duration duration;

  /// Called when the active segment finishes.
  final VoidCallback? onComplete;

  /// Height of each segment bar.
  final double height;

  /// Gap between segments.
  final double spacing;

  /// Color of filled / active segments. Defaults to white.
  final Color? activeColor;

  /// Color of unfilled segments. Defaults to white with 40% opacity.
  final Color? pendingColor;

  /// When true the active segment automatically fills over [duration].
  final bool autoPlay;

  /// Border radius of each segment.
  final BorderRadius borderRadius;

  @override
  State<SegmentedProgressBar> createState() => _SegmentedProgressBarState();
}

class _SegmentedProgressBarState extends State<SegmentedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    if (widget.autoPlay && widget.progress == null) {
      _ctrl
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed) widget.onComplete?.call();
        })
        ..forward();
    } else if (widget.progress != null) {
      _ctrl.value = widget.progress!.clamp(0, 1);
    }
  }

  @override
  void didUpdateWidget(SegmentedProgressBar old) {
    super.didUpdateWidget(old);
    if (widget.progress != null) {
      _ctrl.value = widget.progress!.clamp(0, 1);
    }
    if (old.currentIndex != widget.currentIndex && widget.autoPlay) {
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.activeColor ?? Colors.white;
    final pending = widget.pendingColor ?? Colors.white.withValues(alpha: 0.4);

    return Row(
      children: List.generate(widget.segmentCount, (i) {
        final isDone = i < widget.currentIndex;
        final isActive = i == widget.currentIndex;

        Widget bar;
        if (isDone) {
          bar = _Segment(
            progress: 1,
            activeColor: active,
            pendingColor: pending,
            height: widget.height,
            borderRadius: widget.borderRadius,
          );
        } else if (isActive) {
          bar = AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => _Segment(
              progress: widget.progress ?? _ctrl.value,
              activeColor: active,
              pendingColor: pending,
              height: widget.height,
              borderRadius: widget.borderRadius,
            ),
          );
        } else {
          bar = _Segment(
            progress: 0,
            activeColor: active,
            pendingColor: pending,
            height: widget.height,
            borderRadius: widget.borderRadius,
          );
        }

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : widget.spacing),
            child: bar,
          ),
        );
      }),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.progress,
    required this.activeColor,
    required this.pendingColor,
    required this.height,
    required this.borderRadius,
  });

  final double progress;
  final Color activeColor;
  final Color pendingColor;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            SizedBox(
              height: height,
              child: LinearProgressIndicator(
                value: 0,
                backgroundColor: pendingColor,
                color: pendingColor,
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0, 1),
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: borderRadius,
                ),
              ),
            ),
          ],
        ),
      );
}
