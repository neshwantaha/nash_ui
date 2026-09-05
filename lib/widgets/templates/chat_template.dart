import '../../nash_ui.dart';

/// A single chat message.
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.time,
    this.isMine = false,
    this.sender,
    this.avatarUrl,
    this.isRead = false,
  });

  /// Message body.
  final String text;

  /// Message timestamp.
  final DateTime time;

  /// Whether the message was sent by the current user.
  final bool isMine;

  /// Sender name (shown for incoming messages).
  final String? sender;

  /// Sender avatar URL.
  final String? avatarUrl;

  /// Read receipt for outgoing messages.
  final bool isRead;
}

/// A complete chat screen template.
///
/// Shows a scrollable conversation with styled message bubbles, a date divider
/// and a composer that appends outgoing bubbles and calls [onSend].
///
/// ```dart
/// ChatTemplate(
///   title: 'Sarah',
///   messages: <ChatMessage>[
///     ChatMessage(text: 'Hey!', time: DateTime.now(), isMine: false),
///   ],
///   onSend: (String text) {},
/// )
/// ```
class ChatTemplate extends StatefulWidget {
  const ChatTemplate({
    super.key,
    required this.title,
    this.messages = const <ChatMessage>[],
    this.subtitle,
    this.onSend,
    this.onBack,
    this.onAttachment,
    this.avatarUrl,
    this.composerHint = 'Type a message…',
    this.bubbleColor,
  });

  /// Conversation title.
  final String title;

  /// Subtitle (e.g. "online").
  final String? subtitle;

  /// Initial messages.
  final List<ChatMessage> messages;

  /// Called with the typed text when the send button is pressed.
  final ValueChanged<String>? onSend;

  /// Back button callback.
  final VoidCallback? onBack;

  /// Attachment button callback.
  final VoidCallback? onAttachment;

  /// Contact avatar URL.
  final String? avatarUrl;

  /// Composer placeholder text.
  final String composerHint;

  /// Color of incoming bubbles.
  final Color? bubbleColor;

  @override
  State<ChatTemplate> createState() => _ChatTemplateState();
}

class _ChatTemplateState extends State<ChatTemplate> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final List<ChatMessage> _messages =
      List<ChatMessage>.of(widget.messages);

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        time: DateTime.now(),
        isMine: true,
      ));
    });
    _controller.clear();
    widget.onSend?.call(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: onBackLeading(),
        title: Row(
          children: <Widget>[
            Avatar(url: widget.avatarUrl, initials: widget.title, radius: 18),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: textTheme.labelSmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final ChatMessage message = _messages[index];
                final bool showDivider = index == 0 ||
                    AppDateUtils.formatDate(_messages[index - 1].time) !=
                        AppDateUtils.formatDate(message.time);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (showDivider)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              AppDateUtils.formatDate(message.time),
                              style: textTheme.labelSmall
                                  ?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                          ),
                        ),
                      ),
                    _MessageBubble(
                      message: message,
                      bubbleColor: widget.bubbleColor,
                    ),
                  ],
                );
              },
            ),
          ),
          _Composer(
            controller: _controller,
            hint: widget.composerHint,
            onAttachment: widget.onAttachment,
            onSend: _send,
          ),
        ],
      ),
    );
  }

  Widget? onBackLeading() {
    if (widget.onBack == null) return null;
    return IconButton(
      onPressed: widget.onBack,
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, this.bubbleColor});

  final ChatMessage message;
  final Color? bubbleColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool mine = message.isMine;

    final Widget bubble = Container(
      constraints: const BoxConstraints(maxWidth: 280),
      margin: EdgeInsets.only(
        left: mine ? AppSpacing.lg : 0,
        right: mine ? 0 : AppSpacing.lg,
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
      decoration: BoxDecoration(
        gradient: mine ? AppGradients.brand : null,
        color: mine ? null : (bubbleColor ?? scheme.surfaceContainerHighest),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppRadius.large),
          topRight: const Radius.circular(AppRadius.large),
          bottomLeft: Radius.circular(mine ? AppRadius.large : 4),
          bottomRight: Radius.circular(mine ? 4 : AppRadius.large),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            message.text,
            style: textTheme.bodyMedium?.copyWith(
              color: mine ? Colors.white : scheme.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppDateUtils.formatTime(message.time),
                style: textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color: mine
                      ? Colors.white.withValues(alpha: 0.8)
                      : scheme.onSurfaceVariant,
                ),
              ),
              if (mine) ...<Widget>[
                const SizedBox(width: 4),
                Icon(
                  message.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                  size: 14,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ],
            ],
          ),
        ],
      ),
    );

    if (mine || message.avatarUrl == null) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: Avatar(
              url: message.avatarUrl,
              initials: message.sender ?? 'U',
              radius: 14,
            ),
          ),
          bubble,
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.hint,
    required this.onSend,
    this.onAttachment,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback? onAttachment;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm, AppSpacing.xs, AppSpacing.sm, AppSpacing.sm),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(
            top:
                BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: <Widget>[
            if (onAttachment != null)
              IconButton(
                onPressed: onAttachment,
                icon: const Icon(Icons.add_circle_outline_rounded),
                tooltip: 'Attach',
              ),
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: hint,
                  filled: true,
                  fillColor: scheme.surfaceContainerHighest,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            IconButton.filled(
              onPressed: onSend,
              icon: const Icon(Icons.send_rounded),
              color: Colors.white,
              tooltip: 'Send',
              style: IconButton.styleFrom(
                backgroundColor: scheme.primary,
                disabledBackgroundColor: scheme.primary.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
