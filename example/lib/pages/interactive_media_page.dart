import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class InteractiveMediaPage extends StatelessWidget {
  const InteractiveMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Media & Audio',
      icon: Icons.play_circle_outline_rounded,
      sections: [
        // ── Voice Note Player ──────────────────────────────────────────
        ShowcaseSection(
          title: 'VoiceNotePlayer',
          children: const [
            Text(
              'Interactive voice message player with speed multiplier (1x/1.5x/2x) and seekable waveform.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 12),
            VoiceNotePlayer(
              duration: Duration(seconds: 35),
              amplitudes: [
                0.3,
                0.6,
                0.9,
                0.4,
                0.8,
                0.5,
                0.2,
                0.7,
                0.9,
                0.6,
                0.8,
                0.4,
                0.3,
                0.7,
                0.9,
                0.5,
                0.8,
                0.3,
                0.6,
                0.4,
              ],
            ),
          ],
        ),

        // ── Equalizer Visualizer ───────────────────────────────────────
        ShowcaseSection(
          title: 'EqualizerWidget',
          children: const [
            Text(
              'Animated frequency bands audio visualizer.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                EqualizerWidget(
                    bandCount: 8, height: 40, barWidth: 5, spacing: 4),
                SizedBox(width: 24),
                EqualizerWidget(
                    bandCount: 12,
                    height: 32,
                    barWidth: 3,
                    spacing: 2,
                    color: Colors.amber),
              ],
            ),
          ],
        ),

        // ── Audio Waveform ─────────────────────────────────────────────
        ShowcaseSection(
          title: 'AudioWaveform',
          children: const [
            Text(
              'Static or active audio waveform amplitude display.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 12),
            AudioWaveform(
              amplitudes: [
                0.2,
                0.5,
                0.8,
                0.3,
                0.9,
                0.6,
                0.4,
                0.7,
                0.9,
                0.5,
                0.3,
                0.8
              ],
              progress: 0.55,
            ),
          ],
        ),

        // ── Before / After Image Comparison ────────────────────────────
        ShowcaseSection(
          title: 'BeforeAfterImage',
          children: [
            const Text(
              'Interactive split-slider before & after comparison.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: BeforeAfterImage(
                before: Container(
                  color: Colors.blueGrey,
                  child: const Center(
                    child: Text('BEFORE (Original)',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                after: Container(
                  color: Colors.deepPurple,
                  child: const Center(
                    child: Text('AFTER (Enhanced)',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),

        // ── Magnifier Lens ─────────────────────────────────────────────
        ShowcaseSection(
          title: 'MagnifierLens',
          children: [
            const Text(
              'Drag or touch over content to inspect with a magnifying glass lens.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            MagnifierLens(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(40),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber),
                ),
                child: const Column(
                  children: [
                    Text(
                        '🔍 Touch and drag here to magnify this fine text details & patterns!',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                        'Nash UI Design System v2.7.0 — Material 3 High Performance Library',
                        style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
