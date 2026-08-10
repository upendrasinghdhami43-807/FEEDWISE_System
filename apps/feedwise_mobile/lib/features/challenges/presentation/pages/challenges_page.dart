import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/data/models/scenario_model.dart';
import 'package:feedwise_mobile/logic/providers/feed/feed_provider.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';

class ChallengesPage extends ConsumerWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenariosAsync = ref.watch(allScenariosProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('Play', style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryDark)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Newsroom Zero Hero
            _NewsroomHeroCard(onTap: () => context.push('/play/newsroom')).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 20),

            // Daily Challenge
            _DailyChallengeSection(onTap: () => context.go('/explore')).animate().fadeIn(delay: 50.ms),

            const SizedBox(height: 20),

            // Scenario Packs
            Text('SCENARIO PACKS', style: AppTypography.labelMedium.copyWith(
              color: AppColors.textTertiaryDark,
              letterSpacing: 1.5,
            )),
            const SizedBox(height: 12),

            scenariosAsync.when(
              data: (scenarios) => _ScenarioPackGrid(scenarios: scenarios),
              loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(color: AppColors.primary500))),
              error: (_, __) => const Text('Error loading packs'),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 20),

            // Streak
            _StreakCard().animate().fadeIn(delay: 150.ms),
          ],
        ),
      ),
    );
  }
}

class _NewsroomHeroCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NewsroomHeroCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F1117), Color(0xFF1A1D27)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.primary500.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(color: AppColors.primary500.withOpacity(0.1), blurRadius: 20, spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary500.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: AppColors.primary500.withOpacity(0.5)),
                  ),
                  child: Text('FEATURED MODE', style: AppTypography.labelSmall.copyWith(color: AppColors.primary400, letterSpacing: 1)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text('📰', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text('Newsroom Zero', style: AppTypography.headlineMedium.copyWith(color: Colors.white)),
            const SizedBox(height: 6),
            Text('You\'re the editor. Breaking news is coming in fast. Verify before you publish.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark, height: 1.5)),
            const SizedBox(height: 16),
            FWButton(
              label: 'Enter Newsroom →',
              size: FWButtonSize.small,
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyChallengeSection extends StatelessWidget {
  final VoidCallback onTap;
  const _DailyChallengeSection({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.warmGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(child: Text('⚡', style: TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DAILY CHALLENGE', style: AppTypography.labelSmall.copyWith(
                  color: AppColors.secondary400,
                  letterSpacing: 1.5,
                )),
                const SizedBox(height: 3),
                Text('Source Verification Sprint', style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryDark)),
                const SizedBox(height: 2),
                Text('3 scenarios · ~5 min', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary400.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text('+150 XP', style: AppTypography.labelSmall.copyWith(color: AppColors.secondary400)),
          ),
        ],
      ),
    );
  }
}

class _ScenarioPackGrid extends StatelessWidget {
  final List<ScenarioModel> scenarios;
  const _ScenarioPackGrid({required this.scenarios});

  static const _packs = [
    _Pack('🤖', 'AI & Deepfakes', ScenarioCategory.aiGeneratedContent, [AppColors.primary600, AppColors.primary400]),
    _Pack('🎣', 'Clickbait', ScenarioCategory.clickbait, [Color(0xFFDB2C2C), Color(0xFFFF6B6B)]),
    _Pack('🖼️', 'Misleading Context', ScenarioCategory.misleadingContext, [Color(0xFF0D9488), Color(0xFF2DD4BF)]),
    _Pack('📊', 'Statistics', ScenarioCategory.statManipulation, [Color(0xFFD97706), Color(0xFFF59E0B)]),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _packs.length,
      itemBuilder: (_, i) => _PackCard(pack: _packs[i], scenarios: scenarios),
    );
  }
}

class _Pack {
  final String emoji;
  final String name;
  final ScenarioCategory category;
  final List<Color> gradient;
  const _Pack(this.emoji, this.name, this.category, this.gradient);
}

class _PackCard extends StatelessWidget {
  final _Pack pack;
  final List<ScenarioModel> scenarios;
  const _PackCard({required this.pack, required this.scenarios});

  @override
  Widget build(BuildContext context) {
    final count = scenarios.where((s) => s.category == pack.category).length;

    return GestureDetector(
      onTap: () => context.go('/explore'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [pack.gradient[0].withOpacity(0.15), pack.gradient[1].withOpacity(0.08)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: pack.gradient[0].withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(pack.emoji, style: const TextStyle(fontSize: 28)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pack.name, style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark), maxLines: 2),
                const SizedBox(height: 2),
                Text('$count scenarios', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('5 Day Streak!', style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark)),
                Text('Keep going — come back tomorrow to maintain your streak',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
