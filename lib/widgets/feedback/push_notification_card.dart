import 'package:flutter/material.dart';

/// A rich push notification card widget with icon, title, body,
/// timestamp, action buttons, and swipe-to-dismiss support.
class PushNotificationCard extends StatefulWidget {
  const PushNotificationCard({
    super.key,
    required this.title,
    required this.body,
    this.icon,
    this.iconColor,
    this.iconBackground,
    this.timestamp,
    this.actions = const [],
    this.onTap,
    this.onDismiss,
    this.isUnread = true,
    this.avatarUrl,
  });

  final String title;
  final String body;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackground;
  final String? timestamp;
  final List<PushNotificationAction> actions;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final bool isUnread;
  final String? avatarUrl;

  @override
  State<PushNotificationCard> createState() => _PushNotificationCardState();
}

class PushNotificationAction {
  const PushNotificationAction({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
}

class _PushNotificationCardState extends State<PushNotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconBg = widget.iconBackground ?? theme.colorScheme.primaryContainer;
    final iconColor = widget.iconColor ?? theme.colorScheme.onPrimaryContainer;

    return FadeTransition(
      opacity: _fadeIn,
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => widget.onDismiss?.call(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.delete_outline, color: theme.colorScheme.onError),
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isUnread
                  ? theme.colorScheme.primaryContainer.withAlpha(40)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isUnread
                    ? theme.colorScheme.primary.withAlpha(80)
                    : theme.colorScheme.outlineVariant.withAlpha(60),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon / avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: widget.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                widget.avatarUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              widget.icon ?? Icons.notifications,
                              color: iconColor,
                              size: 22,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (widget.isUnread)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.body,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(160),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.timestamp != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                widget.timestamp!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withAlpha(100),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.actions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 56),
                    child: Row(
                      children: widget.actions
                          .map((PushNotificationAction a) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: a.isPrimary
                                    ? FilledButton(
                                        onPressed: a.onTap,
                                        style: FilledButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        child: Text(a.label),
                                      )
                                    : OutlinedButton(
                                        onPressed: a.onTap,
                                        style: OutlinedButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        child: Text(a.label),
                                      ),
                              ))
                          .toList(),
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
