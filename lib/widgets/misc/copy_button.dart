import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../colors/colors.dart';
import '../../radius/app_radius.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CopyButton — Copy-to-clipboard with animated feedback
// ─────────────────────────────────────────────────────────────────────────────

/// A button that copies [text] to the clipboard and briefly shows a check icon.
///
/// ```dart
/// CopyButton(text: 'flutter pub add nash_ui')
/// CopyButton(text: apiKey, tooltip: 'Copy API Key')
/// ```
class CopyButton extends StatefulWidget {
  const CopyButton({
    super.key,
    required this.text,
    this.tooltip = 'Copy',
    this.copiedTooltip = 'Copied!',
    this.iconSize = 18.0,
    this.color,
    this.copiedColor,
    this.feedbackDuration = const Duration(milliseconds: 1800),
    this.onCopied,
  });

  /// The text to copy to clipboard.
  final String text;
  final String tooltip;
  final String copiedTooltip;
  final double iconSize;
  final Color? color;
  final Color? copiedColor;
  final Duration feedbackDuration;
  final VoidCallback? onCopied;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton>
    with SingleTickerProviderStateMixin {
  bool _copied = false;
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnim = Tween<double>(begin: 1, end: 1.3)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    widget.onCopied?.call();
    setState(() => _copied = true);
    _ctrl.forward().then((_) => _ctrl.reverse());
    await Future<void>.delayed(widget.feedbackDuration);
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _copied
        ? (widget.copiedColor ?? AppColors.success)
        : (widget.color ?? scheme.onSurfaceVariant);

    return Tooltip(
      message: _copied ? widget.copiedTooltip : widget.tooltip,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              _copied ? Icons.check_rounded : Icons.copy_rounded,
              key: ValueKey(_copied),
              size: widget.iconSize,
              color: color,
            ),
          ),
          onPressed: _copy,
          style: IconButton.styleFrom(
            minimumSize: Size(widget.iconSize + 16, widget.iconSize + 16),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ShareSheet — Pure-Flutter share action sheet
// ─────────────────────────────────────────────────────────────────────────────

/// A [ShareItem] defines one action in the share sheet.
class ShareItem {
  const ShareItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
}

/// Shows a native-feeling share action sheet as a bottom modal.
///
/// ```dart
/// ShareSheet.show(
///   context,
///   title: 'Share via',
///   items: [
///     ShareItem(label: 'WhatsApp', icon: Icons.chat_rounded, onTap: () {}),
///     ShareItem(label: 'Copy Link', icon: Icons.link_rounded, onTap: () {}),
///   ],
/// );
/// ```
class ShareSheet {
  ShareSheet._();

  static Future<void> show(
    BuildContext context, {
    String title = 'Share via',
    required List<ShareItem> items,
    String? shareText,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => _ShareSheetContent(
          title: title,
          items: items,
          shareText: shareText,
        ),
      );
}

class _ShareSheetContent extends StatelessWidget {
  const _ShareSheetContent({
    required this.title,
    required this.items,
    this.shareText,
  });

  final String title;
  final List<ShareItem> items;
  final String? shareText;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (shareText != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      shareText!,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CopyButton(text: shareText!),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: items.map((item) => _ShareAction(item: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class _ShareAction extends StatelessWidget {
  const _ShareAction({required this.item});
  final ShareItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        item.onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(item.label,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
