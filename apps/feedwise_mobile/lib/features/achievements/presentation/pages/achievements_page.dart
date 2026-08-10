import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/theme.dart';
import '../../../data/models/badge_model.dart';
import '../../../shared/widgets/fw_card.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  static final _badges = [
    BadgeModel(id: 'b1', title: 'First Investigator', description: 'Completed your first investigation', emoji: '🔍', category: BadgeCategory.investigation, isUnlocked: true, xpReward: 50),
    BadgeModel(id: 'b2', title: 'Source Checker', description: 'Verified 5 sources correctly', emoji: '✅', category: BadgeCategory.investigation, isUnlocked: true, xpReward: 75),
    BadgeModel(id: 'b3', title: 'Week Warrior', description: 'Maintained a 7-day streak', emoji: '🔥', category: BadgeCategory.streak, isUnlocked: false, xpReward: 100, requirement: '7 day streak'),
    BadgeModel(id: 'b4', title: 'AI Detective', description: 'Identified 3 AI-generated posts', emoji: '🤖', category: BadgeCategory.skill, isUnlocked: false, xpReward: 100, requirement: 'Identify 3 deepfakes'),
    BadgeModel(id: 'b5', title: 'Bias Buster', description: 'Detected bias in 5 scenarios', emoji: '⚖️', category: BadgeCategory.skill, isUnlocked: false, xpReward: 100, requirement: '5 bias detections'),
    BadgeModel(id: 'b6', title: 'MIL Champion', description: 'Reached MIL Score of 80+', emoji: '🏆', category: BadgeCategory.special, isUnlocked: false, xpReward: 250, requirement: 'MIL Score 80+'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('Achievements', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: FWCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    Text('2', style: AppTypography.headlineMedium.copyWith(color: AppColors.evidenceSupported)),
                    Text('Unlocked', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                  ]),
                  Container(width: 1, height: 40, color: AppColors.borderDark),
                  Column(children: [
                    Text('4', style: AppTypography.headlineMedium.copyWith(color: AppColors.textTertiaryDark)),
                    Text('Locked', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                  ]),
                  Container(width: 1, height: 40, color: AppColors.borderDark),
                  Column(children: [
                    Text('125', style: AppTypography.headlineMedium.copyWith(color: AppColors.xpColor)),
                    Text('XP Earned', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: _badges.length,
              itemBuilder: (_, i) => _BadgeCard(badge: _badges[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final BadgeModel badge;
  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: badge.isUnlocked ? 1.0 : 0.45,
      child: FWCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: badge.isUnlocked ? AppColors.primary500.withOpacity(0.15) : AppColors.borderDark,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text(badge.emoji, style: const TextStyle(fontSize: 28))),
                ),
                if (badge.isUnlocked)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(color: AppColors.evidenceSupported, shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(badge.title, style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(badge.description, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark), textAlign: TextAlign.center, maxLines: 2),
            if (badge.requirement != null && !badge.isUnlocked) ...[
              const SizedBox(height: 6),
              Text(badge.requirement!, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryDark), textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
