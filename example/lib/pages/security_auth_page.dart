import 'package:nash_ui/nash_ui.dart';
import 'showcase_page.dart';

class SecurityAuthPage extends StatefulWidget {
  const SecurityAuthPage({super.key});

  @override
  State<SecurityAuthPage> createState() => _SecurityAuthPageState();
}

class _SecurityAuthPageState extends State<SecurityAuthPage> {
  String _pin = '';
  String _enteredCode = '';
  String _lastPattern = '';

  @override
  Widget build(BuildContext context) {
    return ShowcasePage(
      title: 'Security & Auth',
      icon: Icons.security_rounded,
      sections: [
        // ── Biometric Auth Button ──────────────────────────────────────
        ShowcaseSection(
          title: 'BiometricButton',
          children: [
            const Text(
              'Animated fingerprint/face biometric verification button with pulse and states.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: BiometricButton(
                onAuthenticate: () async {
                  await Future<void>.delayed(const Duration(seconds: 1));
                  return true;
                },
              ),
            ),
          ],
        ),

        // ── OTP Pin Field ──────────────────────────────────────────────
        ShowcaseSection(
          title: 'OtpPinField',
          children: [
            const Text(
              'Modern 4 to 6 digit verification field with auto-advance and paste support.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: OtpPinField(
                length: 6,
                onCompleted: (val) => setState(() => _pin = val),
              ),
            ),
            if (_pin.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                    child: Text('Entered PIN: $_pin',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green))),
              ),
          ],
        ),

        // ── Security Pin Keypad ────────────────────────────────────────
        ShowcaseSection(
          title: 'SecurityPinKeyboard',
          children: [
            const Text(
              'On-screen secure PIN keypad with optional scrambled numbers order.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      _enteredCode.isEmpty
                          ? 'Enter Secure PIN'
                          : '• ' * _enteredCode.length,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                    ),
                    const SizedBox(height: 16),
                    SecurityPinKeyboard(
                      onKeyTap: (digit) {
                        if (_enteredCode.length < 6) {
                          setState(() => _enteredCode += digit);
                        }
                      },
                      onDelete: () {
                        if (_enteredCode.isNotEmpty) {
                          setState(() => _enteredCode = _enteredCode.substring(
                              0, _enteredCode.length - 1));
                        }
                      },
                      onBiometricTap: () {
                        setState(() => _enteredCode = '999999');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Pattern Lock Screen ────────────────────────────────────────
        ShowcaseSection(
          title: 'PatternLock',
          children: [
            const Text(
              '9-dot gesture pattern lock for Android/iOS security patterns.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: PatternLock(
                dimension: 240,
                onComplete: (points) {
                  setState(() => _lastPattern = points.join(' ➔ '));
                },
              ),
            ),
            if (_lastPattern.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                    child: Text('Pattern: $_lastPattern',
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600))),
              ),
          ],
        ),
      ],
    );
  }
}
