import 'package:flutter/material.dart';

/// A rich chat bubble widget supporting text messages, timestamps,
/// read receipts, emoji reactions, and reply-to previews.
class ChatBubble extends StatefulWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.isSent = true,
    this.timestamp,
    this.status = MessageStatus.sent,
    this.senderName,
    this.avatarWidget,
    this.replyTo,
    this.reactions = const [],
    this.onReact,
    this.onReply,
    this.bubbleColor,
    this.textColor,
  });

  final String message;
  final bool isSent;
  final String? timestamp;
  final MessageStatus status;
  final String? senderName;
  final Widget? avatarWidget;
  final String? replyTo;
  final List<ChatReaction> reactions;
  final VoidCallback? onReact;
  final VoidCallback? onReply;
  final Color? bubbleColor;
  final Color? textColor;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

enum MessageStatus { sending, sent, delivered, read }

class ChatReaction {
  const ChatReaction({required this.emoji, required this.count});
  final String emoji;
  final int count;
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
    _slideAnim = Tween<Offset>(
      begin: Offset(widget.isSent ? 1 : -1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStatus() => switch (widget.status) {
        MessageStatus.sending => const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
        MessageStatus.sent =>
          const Icon(Icons.check, size: 14, color: Colors.white70),
        MessageStatus.delivered =>
          const Icon(Icons.done_all, size: 14, color: Colors.white70),
        MessageStatus.read =>
          const Icon(Icons.done_all, size: 14, color: Colors.blue),
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSent = widget.isSent;

    final bubbleColor = widget.bubbleColor ??
        (isSent
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest);
    final textColor = widget.textColor ??
        (isSent ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface);

    return SlideTransition(
      position: _slideAnim,
      child: Align(
        alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isSent && widget.avatarWidget != null) ...[
              widget.avatarWidget!,
              const SizedBox(width: 8),
            ],
            GestureDetector(
              onLongPress: widget.onReact,
              onDoubleTap: widget.onReply,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                  crossAxisAlignment: isSent
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (widget.senderName != null && !isSent)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 2),
                        child: Text(
                          widget.senderName!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(isSent ? 18 : 4),
                              bottomRight: Radius.circular(isSent ? 4 : 18),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.replyTo != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(30),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border(
                                      left: BorderSide(
                                        color: theme.colorScheme.secondary,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    widget.replyTo!,
                                    style: TextStyle(
                                      color: textColor.withAlpha(160),
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              Text(
                                widget.message,
                                style:
                                    TextStyle(color: textColor, fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.timestamp != null)
                                    Text(
                                      widget.timestamp!,
                                      style: TextStyle(
                                        color: textColor.withAlpha(140),
                                        fontSize: 11,
                                      ),
                                    ),
                                  if (isSent) ...[
                                    const SizedBox(width: 4),
                                    _buildStatus(),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Reactions
                        if (widget.reactions.isNotEmpty)
                          Positioned(
                            bottom: -14,
                            right: isSent ? 4 : null,
                            left: isSent ? null : 4,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: widget.reactions
                                  .map((ChatReaction r) => Container(
                                        margin: const EdgeInsets.only(right: 2),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surface,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: theme
                                                .colorScheme.outlineVariant,
                                            width: 0.5,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          '${r.emoji} ${r.count}',
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
