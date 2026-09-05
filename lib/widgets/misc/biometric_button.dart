import 'package:flutter/material.dart';

/// An animated biometric authentication button that cycles through
/// idle, scanning, and success/fail states.
class BiometricButton extends StatefulWidget {
  const BiometricButton({
    super.key,
    this.type = BiometricButtonType.fingerprint,
    this.onAuthenticate,
    this.size = 80,
    this.color,
    this.label = 'Touch to Authenticate',
    this.successLabel = 'Authenticated',
    this.failureLabel = 'Try Again',
  });

  final BiometricButtonType type;
  final Future<bool> Function()? onAuthenticate;
  final double size;
  final Color? color;
  final String label;
  final String successLabel;
  final String failureLabel;

  @override
  State<BiometricButton> createState() => _BiometricButtonState();
}

enum BiometricButtonType { fingerprint, face }

enum _AuthState { idle, scanning, success, failure }

class _BiometricButtonState extends State<BiometricButton>
    with SingleTickerProviderStateMixin {
  _AuthState _state = _AuthState.idle;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (_state == _AuthState.scanning) return;
    setState(() => _state = _AuthState.scanning);
    _pulseController.stop();

    final success = await widget.onAuthenticate?.call() ?? true;
    if (!mounted) return;
    setState(() => _state = success ? _AuthState.success : _AuthState.failure);

    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _state = _AuthState.idle);
    _pulseController.repeat(reverse: true);
  }

  Color _getColor(BuildContext context) {
    final theme = Theme.of(context);
    return switch (_state) {
      _AuthState.idle => widget.color ?? theme.colorScheme.primary,
      _AuthState.scanning => theme.colorScheme.secondary,
      _AuthState.success => Colors.green,
      _AuthState.failure => theme.colorScheme.error,
    };
  }

  String get _label => switch (_state) {
        _AuthState.idle => widget.label,
        _AuthState.scanning => 'Scanning…',
        _AuthState.success => widget.successLabel,
        _AuthState.failure => widget.failureLabel,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor(context);
    final icon = widget.type == BiometricButtonType.face
        ? Icons.face_unlock_outlined
        : Icons.fingerprint;

    return GestureDetector(
      onTap: _onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, child) {
              final scale = _state == _AuthState.idle ? _pulseAnim.value : 1.0;
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withAlpha(20),
                border: Border.all(color: color, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(80),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: _state == _AuthState.scanning
                  ? Padding(
                      padding: EdgeInsets.all(widget.size * 0.25),
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: color),
                    )
                  : Icon(
                      _state == _AuthState.success
                          ? Icons.check_circle_outline
                          : _state == _AuthState.failure
                              ? Icons.error_outline
                              : icon,
                      size: widget.size * 0.5,
                      color: color,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              _label,
              key: ValueKey(_state),
              style: theme.textTheme.bodySmall?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
