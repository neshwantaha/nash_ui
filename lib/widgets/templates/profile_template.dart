import '../../nash_ui.dart';

/// A gradient profile header with avatar, name, bio and stats.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    this.name,
    this.bio,
    this.avatarUrl,
    this.avatar,
    this.stats = const <ProfileStat>[],
    this.onEdit,
    this.onFollow,
    this.followed = false,
    this.gradient = AppGradients.brand,
  });

  /// Display name.
  final String? name;

  /// Short bio / tagline.
  final String? bio;

  /// Avatar image URL.
  final String? avatarUrl;

  /// Custom avatar widget (overrides [avatarUrl]).
  final Widget? avatar;

  /// Stat chips shown below the bio.
  final List<ProfileStat> stats;

  /// Edit profile callback.
  final VoidCallback? onEdit;

  /// Follow/unfollow callback.
  final VoidCallback? onFollow;

  /// Whether the follow button is in the followed state.
  final bool followed;

  /// Header gradient.
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.large),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (onEdit != null)
                IconButton.filledTonal(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  tooltip: 'Edit profile',
                ),
            ],
          ),
          SizedBox(
            width: 96,
            height: 96,
            child: avatar ??
                Avatar(
                  url: avatarUrl,
                  initials: name ?? 'U',
                  radius: 48,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (name != null)
            Text(
              name!,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: AppFontWeight.bold,
                color: Colors.white,
              ),
            ),
          if (bio != null) ...<Widget>[
            const SizedBox(height: 2),
            Text(
              bio!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
          if (stats.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (final ProfileStat stat in stats) ...<Widget>[
                  _StatChip(label: stat.label, value: stat.value),
                  if (stat != stats.last) const SizedBox(width: AppSpacing.sm),
                ],
              ],
            ),
          ],
          if (onFollow != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            FilledButton.tonalIcon(
              onPressed: onFollow,
              icon: Icon(
                followed ? Icons.check_rounded : Icons.add_rounded,
                size: 18,
              ),
              label: Text(followed ? 'Following' : 'Follow'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: scheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: AppFontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single profile statistic.
class ProfileStat {
  const ProfileStat({required this.label, required this.value});

  /// Stat label (e.g. "Followers").
  final String label;

  /// Stat value (e.g. "1.2k").
  final String value;
}

/// A gradient dashboard header with greeting and optional action.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    this.title,
    this.subtitle,
    this.actionIcon,
    this.onAction,
    this.gradient = AppGradients.brand,
    this.avatarUrl,
    this.avatarName,
  });

  /// Heading text.
  final String? title;

  /// Supporting text.
  final String? subtitle;

  /// Header action icon.
  final IconData? actionIcon;

  /// Header action callback.
  final VoidCallback? onAction;

  /// Header gradient.
  final Gradient gradient;

  /// Optional avatar image URL.
  final String? avatarUrl;

  /// Optional avatar fallback name.
  final String? avatarName;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.large),
        ),
      ),
      child: Row(
        children: <Widget>[
          if (avatarUrl != null || avatarName != null) ...<Widget>[
            Avatar(url: avatarUrl, initials: avatarName ?? 'U', radius: 22),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (title != null)
                  Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: AppFontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actionIcon != null && onAction != null)
            IconButton(
              onPressed: onAction,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.16),
                foregroundColor: Colors.white,
              ),
              icon: Icon(actionIcon),
              tooltip: 'Action',
            ),
        ],
      ),
    );
  }
}
