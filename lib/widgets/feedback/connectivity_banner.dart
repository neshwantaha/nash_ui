import 'dart:async';
import 'package:flutter/material.dart';
import '../../colors/colors.dart';
import 'connectivity_check_stub.dart'
    if (dart.library.io) 'connectivity_check_io.dart'
    if (dart.library.js_interop) 'connectivity_check_web.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ConnectivityBanner — Auto offline/online detection banner
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps its [child] and shows an animated top/bottom banner when the device
/// goes offline. Automatically hides when connectivity is restored.
///
/// Works on all platforms including Web (no `dart:io` dependency).
///
/// ```dart
/// ConnectivityBanner(
///   child: Scaffold(body: MyPage()),
/// )
/// ```
class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({
    super.key,
    required this.child,
    this.position = ConnectivityBannerPosition.top,
    this.offlineMessage = 'You are offline',
    this.onlineMessage = 'Back online!',
    this.checkInterval = const Duration(seconds: 5),
    this.lookupHost = 'google.com',
  });

  /// The main app widget to wrap.
  final Widget child;

  /// Where to show the banner.
  final ConnectivityBannerPosition position;

  /// Message shown when offline.
  final String offlineMessage;

  /// Message shown when connection is restored (briefly).
  final String onlineMessage;

  /// How often to check connectivity.
  final Duration checkInterval;

  /// Host to perform DNS lookup against (non-web) or HEAD request (web).
  final String lookupHost;

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

/// Position of the connectivity banner.
enum ConnectivityBannerPosition { top, bottom }

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  bool _isOffline = false;
  bool _showRestoredMessage = false;
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    final isTop = widget.position == ConnectivityBannerPosition.top;
    _slideAnim = Tween<Offset>(
      begin: Offset(0, isTop ? -1 : 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _timer = Timer.periodic(widget.checkInterval, (_) => _checkConnectivity());
    _checkConnectivity();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    bool isConnected;
    try {
      isConnected = await checkConnectivity(widget.lookupHost);
    } catch (_) {
      isConnected = false;
    }

    if (!mounted) return;

    if (!isConnected && !_isOffline) {
      setState(() => _isOffline = true);
      _controller.forward();
    } else if (isConnected && _isOffline) {
      setState(() {
        _isOffline = false;
        _showRestoredMessage = true;
      });
      await Future<void>.delayed(const Duration(seconds: 2));
      if (mounted) {
        await _controller.reverse();
        setState(() => _showRestoredMessage = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTop = widget.position == ConnectivityBannerPosition.top;

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: isTop ? 0 : null,
          bottom: isTop ? null : 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _slideAnim,
            child: _ConnectivityBannerBar(
              showRestored: _showRestoredMessage,
              offlineMessage: widget.offlineMessage,
              onlineMessage: widget.onlineMessage,
            ),
          ),
        ),
      ],
    );
  }
}

class _ConnectivityBannerBar extends StatelessWidget {
  const _ConnectivityBannerBar({
    required this.showRestored,
    required this.offlineMessage,
    required this.onlineMessage,
  });

  final bool showRestored;
  final String offlineMessage;
  final String onlineMessage;

  @override
  Widget build(BuildContext context) {
    final color = showRestored ? AppColors.success : const Color(0xFF1E293B);
    final icon = showRestored ? Icons.wifi_rounded : Icons.wifi_off_rounded;
    final message = showRestored ? onlineMessage : offlineMessage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SafeArea(
        bottom: false,
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
