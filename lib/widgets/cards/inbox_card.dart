import 'package:flutter/material.dart';

/// A message inbox card with sender avatar, preview, unread indicator,
/// timestamp, and swipe-to-archive support.
///
/// ```dart
/// InboxCard(
///   senderName: 'Sarah Lee',
///   preview: 'Hey, did you see the new design?',
///   timestamp: '11:20 AM',
///   isUnread: true,
///   onTap: () {},
/// )
/// ```
class InboxCard extends StatefulWidget {
  const InboxCard({
    super.key,
    required this.senderName,
    required this.preview,
    required this.timestamp,
    this.avatarUrl,
    this.avatarInitials,
    this.avatarColor,
    this.isUnread = false,
    this.unreadCount = 0,
    this.isPinned = false,
    this.onTap,
    this.onArchive,
    this.onDelete,
    this.subject,
  });

  final String senderName;
  final String preview;
  final String timestamp;
  final String? avatarUrl;
  final String? avatarInitials;
  final Color? avatarColor;
  final bool isUnread;
  final int unreadCount;
  final bool isPinned;
  final VoidCallback? onTap;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;
  final String? subject;

  @override
  State<InboxCard> createState() => _InboxCardState();
}

class _InboxCardState extends State<InboxCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = widget.avatarInitials ??
        widget.senderName
            .split(' ')
            .take(2)
            .map((w) => w.isNotEmpty ? w[0] : '')
            .join();
    final avatarColor =
        widget.avatarColor ?? theme.colorScheme.primaryContainer;

    return Dismissible(
      key: ValueKey(widget.senderName + widget.timestamp),
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.archive_outlined, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          widget.onArchive?.call();
        } else {
          widget.onDelete?.call();
        }
      },
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          color: widget.isUnread
              ? theme.colorScheme.primary.withAlpha(10)
              : theme.colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: avatarColor,
                backgroundImage: widget.avatarUrl != null
                    ? NetworkImage(widget.avatarUrl!)
                    : null,
                child: widget.avatarUrl == null
                    ? Text(
                        initials,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (widget.isPinned) ...[
                              const Icon(Icons.push_pin_rounded,
                                  size: 14, color: Colors.orange),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              widget.senderName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: widget.isUnread
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.timestamp,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: widget.isUnread
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                widget.isUnread ? FontWeight.bold : null,
                          ),
                        ),
                      ],
                    ),
                    if (widget.subject != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subject!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (widget.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.unreadCount > 99
                                  ? '99+'
                                  : '${widget.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
