import 'package:flutter/material.dart';

/// A single option in a [PollWidget].
class PollOption {
  const PollOption({
    required this.label,
    required this.votes,
    this.color,
  });

  final String label;
  final int votes;
  final Color? color;
}

/// An animated social-style poll widget.
///
/// ```dart
/// PollWidget(
///   question: 'Favorite framework?',
///   options: [
///     PollOption(label: 'Flutter', votes: 482),
///     PollOption(label: 'React Native', votes: 201),
///     PollOption(label: 'Swift UI', votes: 130),
///   ],
/// )
/// ```
class PollWidget extends StatefulWidget {
  const PollWidget({
    super.key,
    required this.question,
    required this.options,
    this.onVote,
    this.totalLabel,
    this.allowRevote = false,
    this.closedAt,
  });

  final String question;
  final List<PollOption> options;
  final ValueChanged<int>? onVote;
  final String? totalLabel;
  final bool allowRevote;
  final String? closedAt;

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget>
    with SingleTickerProviderStateMixin {
  int? _voted;
  late AnimationController _barCtrl;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  void _vote(int index) {
    if (_voted != null && !widget.allowRevote) return;
    setState(() => _voted = index);
    _barCtrl.forward(from: 0);
    widget.onVote?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalVotes = widget.options.fold<int>(0, (s, o) => s + o.votes);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          ...List.generate(widget.options.length, (i) {
            final opt = widget.options[i];
            final fraction = totalVotes == 0 ? 0.0 : opt.votes / totalVotes;
            final isVoted = _voted == i;
            final showResults = _voted != null;
            final barColor = opt.color ??
                (isVoted
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondaryContainer);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => _vote(i),
                child: AnimatedBuilder(
                  animation: _barCtrl,
                  builder: (_, __) {
                    final animated =
                        showResults ? fraction * _barCtrl.value : 0.0;
                    return Stack(
                      children: [
                        // Background
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isVoted
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                              width: isVoted ? 1.5 : 1,
                            ),
                          ),
                        ),
                        // Fill
                        FractionallySizedBox(
                          widthFactor: animated,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: barColor.withAlpha(40),
                            ),
                          ),
                        ),
                        // Label + percentage
                        Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (isVoted)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: Icon(
                                        Icons.check_circle_rounded,
                                        size: 16,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  Text(opt.label,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight:
                                            isVoted ? FontWeight.bold : null,
                                      )),
                                ],
                              ),
                              if (showResults)
                                Text(
                                  '${(fraction * 100).round()}%',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.totalLabel ??
                    '$totalVotes vote${totalVotes == 1 ? '' : 's'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (widget.closedAt != null)
                Text(
                  'Closes ${widget.closedAt}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
