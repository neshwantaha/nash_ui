import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide ScrollBehavior;
import 'package:flutter/material.dart' as fl;

import '../../radius/app_radius.dart';
import '../../spacing/app_spacing.dart';

/// Platform-adaptive widget that renders differently on mobile vs desktop.
///
/// ```dart
/// AdaptiveScaffold(
///   mobileBuilder: (context) => MobileLayout(),
///   desktopBuilder: (context) => DesktopLayout(),
/// )
/// ```
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.mobileBuilder,
    required this.desktopBuilder,
    this.tabletBuilder,
    this.breakpoint = 840,
  });

  /// Builder for mobile layout (< [breakpoint]).
  final Widget Function(BuildContext context) mobileBuilder;

  /// Builder for desktop layout (>= [breakpoint]).
  final Widget Function(BuildContext context) desktopBuilder;

  /// Optional builder for tablet layout (>= 600 < [breakpoint]).
  final Widget Function(BuildContext context)? tabletBuilder;

  /// Breakpoint between mobile and desktop.
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= breakpoint) {
      return desktopBuilder(context);
    }
    if (tabletBuilder != null && width >= 600) {
      return tabletBuilder!(context);
    }
    return mobileBuilder(context);
  }
}

/// Platform-adaptive dialog that shows Cupertino on iOS and Material elsewhere.
///
/// ```dart
/// AdaptiveDialog.confirm(
///   context: context,
///   title: 'Delete?',
///   message: 'Are you sure?',
/// )
/// ```
class AdaptiveDialog {
  AdaptiveDialog._();

  /// Shows a confirmation dialog adapted to the platform.
  static Future<bool> confirm({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    if (Platform.isIOS || Platform.isMacOS) {
      return _showCupertinoConfirm(
        context,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      );
    }
    return _showMaterialConfirm(
      context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      isDestructive: isDestructive,
    );
  }

  static Future<bool> _showCupertinoConfirm(
    BuildContext context, {
    required String title,
    String? message,
    required String confirmText,
    required String cancelText,
    required bool isDestructive,
  }) async {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        ),
        title: Text(title),
        content: message != null ? Text(message) : null,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: scheme.error)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<bool> _showMaterialConfirm(
    BuildContext context, {
    required String title,
    String? message,
    required String confirmText,
    required String cancelText,
    required bool isDestructive,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: message != null ? Text(message) : null,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

/// Platform-adaptive action sheet.
///
/// Shows a bottom sheet on mobile and a popup menu on desktop.
class AdaptiveActionSheet {
  AdaptiveActionSheet._();

  /// Shows an action sheet adapted to the platform.
  static Future<int?> show({
    required BuildContext context,
    required List<String> actions,
    String? title,
    String cancelText = 'Cancel',
  }) async {
    if (Platform.isIOS || Platform.isMacOS) {
      return _showBottomSheet(
        context,
        actions: actions,
        title: title,
        cancelText: cancelText,
      );
    }
    return _showBottomSheet(
      context,
      actions: actions,
      title: title,
      cancelText: cancelText,
    );
  }

  static Future<int?> _showBottomSheet(
    BuildContext context, {
    required List<String> actions,
    String? title,
    required String cancelText,
  }) async =>
      showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (title != null)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              for (int i = 0; i < actions.length; i++)
                ListTile(
                  title: Text(actions[i]),
                  onTap: () => Navigator.of(context).pop(i),
                ),
              const Divider(height: 1),
              ListTile(
                title: Text(cancelText),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
}

/// Detects the current platform for adaptive rendering.
abstract final class Platform {
  Platform._();

  static bool get isWeb => kIsWeb;

  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isMacOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  static bool get isWindows =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  static bool get isLinux =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  static bool get isMobile => isAndroid || isIOS;

  static bool get isDesktop => isWindows || isMacOS || isLinux;

  /// Whether the current platform is a Cupertino platform.
  static bool get isCupertino => isIOS || isMacOS;
}

/// Adaptive [Switch] that renders [CupertinoSwitch] on iOS/macOS.
///
/// ```dart
/// AdaptiveSwitch(
///   value: _enabled,
///   onChanged: (v) => setState(() => _enabled = v),
/// )
/// ```
class AdaptiveSwitch extends StatelessWidget {
  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeThumbColor,
    this.thumbColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeThumbColor;
  final Color? thumbColor;

  @override
  Widget build(BuildContext context) {
    if (Platform.isCupertino) {
      return Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: activeThumbColor,
      );
    }
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: activeThumbColor,
    );
  }
}

/// Adaptive [CircularProgressIndicator] that renders [CupertinoActivityIndicator]
/// on iOS/macOS.
class AdaptiveProgress extends StatelessWidget {
  const AdaptiveProgress({
    super.key,
    this.size = 24,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color resolvedColor = color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: resolvedColor,
      ),
    );
  }
}

/// Adaptive [ScrollBehavior] for web and desktop platforms.
class AppScrollBehavior extends fl.ScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    if (Platform.isDesktop || Platform.isWeb) {
      return const BouncingScrollPhysics();
    }
    return super.getScrollPhysics(context);
  }

  @override
  Set<PointerDeviceKind> get dragDevices {
    if (Platform.isDesktop || Platform.isWeb) {
      return <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
    }
    return super.dragDevices;
  }
}
