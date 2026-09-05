import 'package:flutter/material.dart';

/// An animated status bar indicating internet connectivity changes.
class NetworkStatusBar extends StatelessWidget {
  const NetworkStatusBar({
    super.key,
    required this.isOnline,
    this.onlineText = 'Back online',
    this.offlineText = 'No internet connection',
    this.autoHideOnline = true,
  });

  final bool isOnline;
  final String onlineText;
  final String offlineText;
  final bool autoHideOnline;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: (!isOnline || !autoHideOnline) ? 32.0 : 0.0,
        color: isOnline ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
        child: (!isOnline || !autoHideOnline)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isOnline ? onlineText : offlineText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      );
}
