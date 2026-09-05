import 'package:flutter/material.dart';

/// An interactive voice note player with playback speed toggle,
/// seekable waveform visualization, and play/pause controls.
class VoiceNotePlayer extends StatefulWidget {
  const VoiceNotePlayer({
    super.key,
    this.duration = const Duration(seconds: 42),
    this.amplitudes = const [
      0.2,
      0.4,
      0.7,
      0.9,
      0.5,
      0.8,
      0.3,
      0.6,
      0.9,
      0.4,
      0.7,
      0.3,
      0.8,
      0.5,
      0.2,
      0.6,
      0.9,
      0.4,
      0.7,
      0.5,
    ],
    this.activeColor,
    this.inactiveColor,
    this.onPlayStateChanged,
    this.avatarUrl,
  });

  final Duration duration;
  final List<double> amplitudes;
  final Color? activeColor;
  final Color? inactiveColor;
  final ValueChanged<bool>? onPlayStateChanged;
  final String? avatarUrl;

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _speed = 1.0;
  bool _isPlaying = false;

  static const List<double> _speeds = [1.0, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() => setState(() {}));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isPlaying = false);
        _controller.reset();
        widget.onPlayStateChanged?.call(false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _controller.forward();
    } else {
      _controller.stop();
    }
    widget.onPlayStateChanged?.call(_isPlaying);
  }

  void _cycleSpeed() {
    final nextIndex = (_speeds.indexOf(_speed) + 1) % _speeds.length;
    setState(() {
      _speed = _speeds[nextIndex];
      _controller.duration = Duration(
        milliseconds: (widget.duration.inMilliseconds / _speed).round(),
      );
      if (_isPlaying) {
        _controller.forward();
      }
    });
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = widget.activeColor ?? theme.colorScheme.primary;
    final inactive = widget.inactiveColor ?? theme.colorScheme.outlineVariant;
    final currentPos = widget.duration * _controller.value;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: theme.colorScheme.outlineVariant.withAlpha(60)),
      ),
      child: Row(
        children: [
          // Play / Pause FAB
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: active,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: theme.colorScheme.onPrimary,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Waveform bars
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barCount = widget.amplitudes.length;
                const barWidth = 3.0;

                return GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    final fraction =
                        (details.localPosition.dx / constraints.maxWidth)
                            .clamp(0.0, 1.0);
                    _controller.value = fraction;
                  },
                  onTapDown: (details) {
                    final fraction =
                        (details.localPosition.dx / constraints.maxWidth)
                            .clamp(0.0, 1.0);
                    _controller.value = fraction;
                  },
                  child: Container(
                    height: 36,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(barCount, (i) {
                        final barProgress = i / barCount;
                        final isPlayed = _controller.value >= barProgress;
                        final barHeight =
                            (widget.amplitudes[i] * 28).clamp(6.0, 32.0);

                        return Container(
                          width: barWidth,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: isPlayed ? active : inactive,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),

          // Duration & Speed controls
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDuration(currentPos),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: _cycleSpeed,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: active.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_speed.toStringAsFixed(_speed.truncateToDouble() == _speed ? 0 : 1)}x',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: active,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
