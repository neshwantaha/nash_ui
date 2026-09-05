import 'package:flutter/material.dart';

import '../../radius/app_radius.dart';

/// Supported third-party authentication providers for [SocialButton].
enum SocialProvider {
  google,
  apple,
  github,
  microsoft,
  x,
  facebook,
  discord,
}

/// A ready-to-use social authentication button styled according to brand guidelines.
///
/// ```dart
/// SocialButton(
///   provider: SocialProvider.google,
///   onPressed: () => signInWithGoogle(),
/// )
/// ```
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.customLabel,
    this.height = 48.0,
    this.width,
    this.expanded = true,
    this.radius = AppRadius.medium,
    this.outlined = false,
  });

  /// The social provider.
  final SocialProvider provider;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// Custom button label (defaults to 'Continue with [Provider]').
  final String? customLabel;

  /// Button height.
  final double height;

  /// Fixed width (ignored when [expanded] is true).
  final double? width;

  /// Whether the button fills parent width.
  final bool expanded;

  /// Corner radius.
  final double radius;

  /// Whether to render in outlined mode instead of filled brand color.
  final bool outlined;

  String get _defaultLabel {
    switch (provider) {
      case SocialProvider.google:
        return 'Continue with Google';
      case SocialProvider.apple:
        return 'Continue with Apple';
      case SocialProvider.github:
        return 'Continue with GitHub';
      case SocialProvider.microsoft:
        return 'Continue with Microsoft';
      case SocialProvider.x:
        return 'Continue with X';
      case SocialProvider.facebook:
        return 'Continue with Facebook';
      case SocialProvider.discord:
        return 'Continue with Discord';
    }
  }

  IconData get _icon {
    switch (provider) {
      case SocialProvider.google:
        return Icons.g_mobiledata_rounded;
      case SocialProvider.apple:
        return Icons.apple_rounded;
      case SocialProvider.github:
        return Icons.code_rounded;
      case SocialProvider.microsoft:
        return Icons.window_rounded;
      case SocialProvider.x:
        return Icons.close_rounded;
      case SocialProvider.facebook:
        return Icons.facebook_rounded;
      case SocialProvider.discord:
        return Icons.discord_rounded;
    }
  }

  Color _brandColor(bool isDark) {
    switch (provider) {
      case SocialProvider.google:
        return isDark ? const Color(0xFF1F1F1F) : Colors.white;
      case SocialProvider.apple:
        return isDark ? Colors.white : Colors.black;
      case SocialProvider.github:
        return isDark ? const Color(0xFF24292E) : const Color(0xFF24292E);
      case SocialProvider.microsoft:
        return const Color(0xFF2F2F2F);
      case SocialProvider.x:
        return Colors.black;
      case SocialProvider.facebook:
        return const Color(0xFF1877F2);
      case SocialProvider.discord:
        return const Color(0xFF5865F2);
    }
  }

  Color _textColor(bool isDark) {
    if (outlined) return isDark ? Colors.white : Colors.black87;
    switch (provider) {
      case SocialProvider.google:
        return isDark ? Colors.white : Colors.black87;
      case SocialProvider.apple:
        return isDark ? Colors.black : Colors.white;
      case SocialProvider.github:
      case SocialProvider.microsoft:
      case SocialProvider.x:
      case SocialProvider.facebook:
      case SocialProvider.discord:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = outlined ? Colors.transparent : _brandColor(isDark);
    final fg = _textColor(isDark);
    final isGoogle = provider == SocialProvider.google;

    return Container(
      height: height,
      width: expanded ? double.infinity : width,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: outlined
              ? (isDark ? Colors.white24 : Colors.black26)
              : (isGoogle
                  ? (isDark ? Colors.white12 : Colors.black12)
                  : Colors.transparent),
        ),
        boxShadow: !outlined && !isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_icon, size: 22, color: fg),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    customLabel ?? _defaultLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: fg,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
