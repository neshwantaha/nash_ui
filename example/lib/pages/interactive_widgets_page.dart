import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class InteractiveWidgetsPage extends StatefulWidget {
  const InteractiveWidgetsPage({super.key});

  @override
  State<InteractiveWidgetsPage> createState() => _InteractiveWidgetsPageState();
}

class _InteractiveWidgetsPageState extends State<InteractiveWidgetsPage> {
  final GlobalKey<ConfettiWidgetState> _confettiKey =
      GlobalKey<ConfettiWidgetState>();
  final GlobalKey<WheelOfFortuneState> _wheelKey =
      GlobalKey<WheelOfFortuneState>();
  double _liquidValue = 0.72;
  String _wheelResult = '';

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      key: _confettiKey,
      child: ShowcasePage(
        title: 'Interactive Widgets',
        icon: Icons.celebration_rounded,
        sections: [
          // ── Wheel Of Fortune & Confetti ──────────────────────────────
          ShowcaseSection(
            title: 'WheelOfFortune & ConfettiWidget',
            children: [
              const Text(
                'Spin the fortune wheel with physics easing and trigger celebration confetti particles.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Center(
                child: WheelOfFortune(
                  key: _wheelKey,
                  size: 240,
                  items: const [
                    'iPhone 16',
                    '100\$ Gift',
                    'Try Again',
                    'Free Coffee',
                    'Gold Pass',
                    'AirPods Pro'
                  ],
                  onResult: (res) {
                    setState(() => _wheelResult = res);
                    _confettiKey.currentState?.play();
                  },
                ),
              ),
              if (_wheelResult.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Text(
                      '🎉 Winner: $_wheelResult',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Center(
                child: FilledButton.icon(
                  onPressed: () => _confettiKey.currentState?.play(),
                  icon: const Icon(Icons.celebration),
                  label: const Text('Burst Confetti'),
                ),
              ),
            ],
          ),

          // ── Animated Text Kit ────────────────────────────────────────
          ShowcaseSection(
            title: 'AnimatedTextKit (Dynamic Typing)',
            children: const [
              Text(
                'Character by character typewriter and fade animations.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              AnimatedTextKit(
                texts: [
                  '🚀 Modern Flutter Design System',
                  '✨ 100+ Production Ready Components',
                  '⚡ Zero Warning & Blazing Fast',
                  '🎨 Beautiful Material 3 Theming',
                ],
                textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ],
          ),

          // ── Animated Counter ─────────────────────────────────────────
          ShowcaseSection(
            title: 'AnimatedCounter',
            children: const [
              Text(
                'Smooth easing numeric count up animations.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedCounter(
                      value: 12500,
                      prefix: '\$',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                  AnimatedCounter(
                      value: 98.6,
                      suffix: '%',
                      decimalPlaces: 1,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                  AnimatedCounter(
                      value: 450,
                      suffix: ' ms',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange)),
                ],
              ),
            ],
          ),

          // ── Liquid Wave Progress Bar ─────────────────────────────────
          ShowcaseSection(
            title: 'LiquidProgressBar',
            children: [
              const Text(
                'Animated sine wave fluid progress indicator.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              LiquidProgressBar(value: _liquidValue, height: 48),
              const SizedBox(height: 12),
              Slider(
                value: _liquidValue,
                min: 0.0,
                max: 1.0,
                divisions: 100,
                label: '${(_liquidValue * 100).round()}%',
                showMinMaxLabels: true,
                suffix: '%',
                onChanged: (v) => setState(() => _liquidValue = v),
              ),
            ],
          ),

          // ── Chat Bubble ──────────────────────────────────────────────
          ShowcaseSection(
            title: 'ChatBubble (Rich Messaging)',
            children: const [
              Text(
                'Sent and received bubbles with replies, status ticks, and emoji reactions.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              ChatBubble(
                message: 'Hey! Did you check the new nash_ui v2.7.0 update?',
                isSent: false,
                senderName: 'Sarah',
                timestamp: '11:20 AM',
                reactions: [ChatReaction(emoji: '🔥', count: 4)],
              ),
              SizedBox(height: 14),
              ChatBubble(
                message:
                    'Yes! It has VoiceNotePlayer, WheelOfFortune, and Glassmorphism!',
                isSent: true,
                replyTo: 'Did you check the new nash_ui v2.7.0 update?',
                status: MessageStatus.read,
                timestamp: '11:22 AM',
                reactions: [ChatReaction(emoji: '❤️', count: 2)],
              ),
            ],
          ),

          // ── Push Notification Card ───────────────────────────────────
          ShowcaseSection(
            title: 'PushNotificationCard',
            children: [
              const Text(
                'Rich banner with avatar, unread indicator, and action buttons.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              PushNotificationCard(
                title: 'New Flight Booking',
                body:
                    'Your flight to Dubai (SV 552) is confirmed for tomorrow.',
                timestamp: '5m ago',
                actions: [
                  PushNotificationAction(
                      label: 'View Pass', onTap: () {}, isPrimary: true),
                  PushNotificationAction(label: 'Share', onTap: () {}),
                ],
              ),
            ],
          ),

          // ── Timeline Date Picker ─────────────────────────────────────
          ShowcaseSection(
            title: 'TimelinePicker (Horizontal Calendar)',
            children: const [
              Text(
                'Horizontal scrollable days picker with weekend & today highlights.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              TimelinePicker(),
            ],
          ),

          // ── Gradient Picker ──────────────────────────────────────────
          ShowcaseSection(
            title: 'GradientPicker',
            children: const [
              Text(
                'Interactive multi-stop gradient generator.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              GradientPicker(),
            ],
          ),

          // ── QR Code & Barcode ────────────────────────────────────────
          ShowcaseSection(
            title: 'QrCodeWidget & BarcodeWidget',
            children: const [
              Text(
                'Pure Flutter generated QR Codes and 1D Barcodes.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  QrCodeWidget(
                      data: 'https://pub.dev/packages/nash_ui', size: 120),
                  BarcodeWidget(data: '978020137962', width: 140, height: 60),
                ],
              ),
            ],
          ),

          // ── Signature Pad ────────────────────────────────────────────
          ShowcaseSection(
            title: 'SignaturePad',
            children: [
              const Text(
                'Touch signature pad with clear and export callbacks.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withAlpha(60)),
                ),
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: SignaturePad(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
