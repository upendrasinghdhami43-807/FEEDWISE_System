import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/data/models/scenario_model.dart';
import 'package:feedwise_mobile/logic/providers/feed/feed_provider.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';
import 'package:feedwise_mobile/shared/widgets/fw_shimmer.dart';
import 'package:feedwise_mobile/shared/widgets/fw_badge.dart';

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);
    final filter = ref.watch(feedFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('Explore', style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryDark)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          _FeedFilterBar(selected: filter),
          const SizedBox(height: 4),

          // Feed list
          Expanded(
            child: feedAsync.when(
              data: (items) => items.isEmpty
                  ? _EmptyFeed()
                  : ListView.builder(
                      itemCount: items.length,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemBuilder: (context, i) => ContentCard(
                        item: items[i],
                        onInvestigate: () => context.push('/explore/${items[i].scenarioId}/investigate'),
                        onShare: () => context.push('/explore/${items[i].scenarioId}/decide?preselect=share'),
                        onReport: () => context.push('/explore/${items[i].scenarioId}/decide?preselect=report'),
                      ).animate().fadeIn(delay: (i * 40).ms, duration: 250.ms),
                    ),
              loading: () => const FeedSkeleton(),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 48, color: AppColors.textTertiaryDark),
                    const SizedBox(height: 12),
                    Text('Could not load feed', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
                    const SizedBox(height: 16),
                    FWButton(label: 'Retry', onPressed: () => ref.invalidate(feedProvider), variant: FWButtonVariant.outline),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedFilterBar extends ConsumerWidget {
  final String selected;
  const _FeedFilterBar({required this.selected});

  static const _filters = ['All', 'Trending', 'AI', 'Deepfakes', 'Clickbait', 'Nepal'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final filter = _filters[i];
          final isSelected = selected == filter;
          return GestureDetector(
            onTap: () => ref.read(feedFilterProvider.notifier).state = filter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary500 : AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: isSelected ? AppColors.primary500 : AppColors.borderDark,
                ),
              ),
              child: Text(
                filter,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textSecondaryDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  final ContentItemModel item;
  final VoidCallback onInvestigate;
  final VoidCallback onShare;
  final VoidCallback onReport;

  const ContentCard({
    super.key,
    required this.item,
    required this.onInvestigate,
    required this.onShare,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: FWCard(
        onTap: onInvestigate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trending badge
            if (item.isTrending)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FWBadge(
                  label: '🔥 TRENDING',
                  color: AppColors.secondary500,
                ),
              ),

            // Source header
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary500.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item.sourceName[0].toUpperCase(),
                      style: AppTypography.titleSmall.copyWith(color: AppColors.primary500),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.sourceName, style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
                      Text(item.timeAgo, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, size: 18, color: AppColors.textTertiaryDark),
              ],
            ),

            const SizedBox(height: 10),

            // Headline
            Text(
              item.headline,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            if (item.body != null) ...[
              const SizedBox(height: 6),
              Text(
                item.body!,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            // Tags
            if (item.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                children: item.tags
                    .take(3)
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevatedDark,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(color: AppColors.borderDark),
                          ),
                          child: Text('#$t', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryDark)),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 12),

            // Engagement stats
            Row(
              children: [
                _EngStat(icon: Icons.thumb_up_outlined, value: item.formattedLikes),
                const SizedBox(width: 16),
                _EngStat(icon: Icons.chat_bubble_outline, value: item.formattedComments),
                const SizedBox(width: 16),
                _EngStat(icon: Icons.share_outlined, value: item.formattedShares),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(color: AppColors.borderDark, height: 1),
            const SizedBox(height: 12),

            // Primary CTA
            FWButton(
              label: '🔍 Investigate',
              isFullWidth: true,
              onPressed: onInvestigate,
            ),

            const SizedBox(height: 8),

            // Secondary actions
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.share_outlined, size: 16),
                    label: Text('Share', style: AppTypography.labelSmall),
                    onPressed: onShare,
                    style: TextButton.styleFrom(foregroundColor: AppColors.decisionShare),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.flag_outlined, size: 16),
                    label: Text('Report', style: AppTypography.labelSmall),
                    onPressed: onReport,
                    style: TextButton.styleFrom(foregroundColor: AppColors.decisionReport),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.bookmark_outline, size: 16),
                    label: Text('Save', style: AppTypography.labelSmall),
                    onPressed: () {},
                    style: TextButton.styleFrom(foregroundColor: AppColors.textTertiaryDark),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EngStat extends StatelessWidget {
  final IconData icon;
  final String value;
  const _EngStat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiaryDark),
        const SizedBox(width: 4),
        Text(value, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
      ],
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📭', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text('No content to show', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
          const SizedBox(height: 8),
          Text('Try a different filter', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
        ],
      ),
    );
  }
}
