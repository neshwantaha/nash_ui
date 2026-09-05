import '../../nash_ui.dart';

/// A single social post inside a [SocialTemplate].
class SocialPost {
  const SocialPost({
    required this.author,
    required this.time,
    this.text,
    this.imageUrl,
    this.avatarUrl,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.liked = false,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  /// Author name.
  final String author;

  /// Relative time label.
  final String time;

  /// Post body text.
  final String? text;

  /// Post image URL.
  final String? imageUrl;

  /// Author avatar URL.
  final String? avatarUrl;

  /// Like count.
  final int likes;

  /// Comment count.
  final int comments;

  /// Share count.
  final int shares;

  /// Whether the current user liked the post.
  final bool liked;

  /// Like callback.
  final VoidCallback? onLike;

  /// Comment callback.
  final VoidCallback? onComment;

  /// Share callback.
  final VoidCallback? onShare;
}

/// A complete social-feed template.
///
/// Renders a story row followed by a list of [SocialPost]s.
class SocialTemplate extends StatelessWidget {
  const SocialTemplate({
    super.key,
    required this.posts,
    this.title = 'Feed',
    this.stories = const <String>[],
    this.currentUserName = 'You',
    this.onNewStory,
    this.onNotification,
    this.onWritePost,
    this.appBar,
    this.header,
  });

  /// Posts to display.
  final List<SocialPost> posts;

  /// App bar title.
  final String title;

  /// Story authors.
  final List<String> stories;

  /// Name of the current user (own story).
  final String currentUserName;

  /// Add-story callback.
  final VoidCallback? onNewStory;

  /// Notification callback.
  final VoidCallback? onNotification;

  /// Compose callback (floating action button).
  final VoidCallback? onWritePost;

  /// Custom app bar.
  final PreferredSizeWidget? appBar;

  /// Custom widget shown below the app bar.
  final Widget? header;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBar ??
            AppBar(
              title: title,
              actions: <Widget>[
                if (onNotification != null)
                  IconButton(
                    onPressed: onNotification,
                    icon: const Icon(Icons.notifications_none_rounded),
                    tooltip: 'Notifications',
                  ),
              ],
            ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          children: <Widget>[
            if (header != null)
              header!
            else ...<Widget>[
              SizedBox(
                height: 108,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: <Widget>[
                    _StoryItem(
                      name: currentUserName,
                      own: true,
                      onTap: onNewStory,
                    ),
                    for (final String story in stories) ...<Widget>[
                      const SizedBox(width: AppSpacing.md),
                      _StoryItem(name: story),
                    ],
                  ],
                ),
              ),
            ],
            for (final SocialPost post in posts) _PostCard(post: post),
          ],
        ),
        floatingActionButton: onWritePost == null
            ? null
            : FloatingActionButton.extended(
                onPressed: onWritePost,
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Post'),
              ),
      );
}

class _StoryItem extends StatelessWidget {
  const _StoryItem({required this.name, this.own = false, this.onTap});

  final String name;
  final bool own;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: own ? null : AppGradients.brand,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 29,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: own
                  ? Icon(Icons.add_rounded,
                      color: Theme.of(context).colorScheme.primary)
                  : Padding(
                      padding: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 72,
            child: Text(
              own ? 'Your story' : name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final SocialPost post;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Avatar(url: post.avatarUrl, initials: post.author),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      post.author,
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      post.time,
                      style: textTheme.labelSmall
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz_rounded, size: 20),
              ),
            ],
          ),
          if (post.text != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(post.text!,
                style: textTheme.bodyMedium?.copyWith(height: 1.4)),
          ],
          if (post.imageUrl != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(post.imageUrl!, fit: BoxFit.cover),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              _Action(
                icon: post.liked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: post.liked ? scheme.error : scheme.onSurfaceVariant,
                label: '${post.likes}',
                onTap: post.onLike,
              ),
              const SizedBox(width: AppSpacing.md),
              _Action(
                icon: Icons.chat_bubble_outline_rounded,
                color: scheme.onSurfaceVariant,
                label: '${post.comments}',
                onTap: post.onComment,
              ),
              const SizedBox(width: AppSpacing.md),
              _Action(
                icon: Icons.reply_rounded,
                color: scheme.onSurfaceVariant,
                label: '${post.shares}',
                onTap: post.onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.color,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: color),
              ),
            ],
          ),
        ),
      );
}
