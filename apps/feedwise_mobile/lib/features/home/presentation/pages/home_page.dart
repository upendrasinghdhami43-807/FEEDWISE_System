import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/data/models/user_model.dart';
import 'package:feedwise_mobile/data/models/skill_model.dart';
import 'package:feedwise_mobile/logic/providers/auth/auth_provider.dart';
import 'package:feedwise_mobile/logic/providers/investigation/investigation_provider.dart';
import 'package:feedwise_mobile/logic/providers/feed/feed_provider.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';
import 'package:feedwise_mobile/shared/widgets/fw_skill_radar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final skillsAsync = ref.watch(skillsProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('FEEDWISE', style: AppTypography.brandWordmark.copyWith(
          color: AppColors.primary500,
          letterSpacing: 3,
          fontSize: 18,
        )),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/me/notifications'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(currentUserProvider),
        color: AppColors.primary500,
        child: userAsync.when(
          data: (user) => _HomeContent(user: user, skillsAsync: skillsAsync),
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary500)),
          error: (_, __) => _HomeContent(user: _demoUser, skillsAsync: skillsAsync),
        ),
      ),
    );
  }

  static final _demoUser = UserModel(
    id: 'demo', authId: 'demo', email: 'demo@fw.app', name: 'Arjun',
    xp: 450, level: 3, currentStreak: 5, bestStreak: 12,
    createdAt: DateTime(2026, 1, 1),
  );
}

class _HomeContent extends ConsumerWidget {
  final UserModel user;
  final AsyncValue<SkillsModel> skillsAsync;
  const _HomeContent({required this.user, required this.skillsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          _GreetingSection(user: user).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // XP Progress
          _XPCard(user: user).animate().fadeIn(delay: 50.ms, duration: 300.ms),

          const SizedBox(height: 16),

          // Streak + Stats Row
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Streak', value: '🔥 ${user.currentStreak}', subtitle: 'days')),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(label: 'Level', value: '⚡ ${user.level}', subtitle: user.levelTitle)),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(label: 'XP', value: '✨ ${user.xp}', subtitle: 'earned')),
            ],
          ).animate().fadeIn(delay: 100.ms, duration: 300.ms),

          const SizedBox(height: 20),

          // Daily Challenge
          _DailyChallengeCard(onTap: () => context.go('/explore')).animate().fadeIn(delay: 150.ms, duration: 300.ms),

          const SizedBox(height: 16),

          // Featured Scenario
          _FeaturedScenarioCard(onTap: () => context.go('/explore')).animate().fadeIn(delay: 200.ms, duration: 300.ms),

          const SizedBox(height: 20),

          // Quick Actions
          Text('QUICK ACCESS', style: AppTypography.labelMedium.copyWith(
            color: AppColors.textTertiaryDark,
            letterSpacing: 1.5,
          )),

          const SizedBox(height: 12),

          _QuickActionsGrid(context: context).animate().fadeIn(delay: 250.ms, duration: 300.ms),

          const SizedBox(height: 20),

          // Skill Snapshot
          skillsAsync.when(
            data: (skills) => _SkillSnapshot(skills: skills).animate().fadeIn(delay: 300.ms, duration: 300.ms),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  final UserModel user;
  const _GreetingSection({required this.user});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$_greeting, ${user.name.split(' ').first} 👋',
                  style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryDark)),
              const SizedBox(height: 2),
              Text('Continue your MIL journey',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(user.name[0].toUpperCase(),
                style: AppTypography.titleLarge.copyWith(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

class _XPCard extends StatelessWidget {
  final UserModel user;
  const _XPCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(user.levelTitle, style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryDark)),
              Text('Level ${user.level}', style: AppTypography.labelMedium.copyWith(color: AppColors.primary500)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: user.levelProgress,
              minHeight: 8,
              backgroundColor: AppColors.borderDark,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary500),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${user.xp} XP', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
              Text('${user.xpForNextLevel} XP to Level ${user.level + 1}',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  const _StatCard({required this.label, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(value, style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark)),
          const SizedBox(height: 2),
          Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _DailyChallengeCard extends StatelessWidget {
  final VoidCallback onTap;
  const _DailyChallengeCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.coolGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('🧠', style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Daily Challenge', style: AppTypography.titleSmall.copyWith(color: AppColors.tertiary400)),
                const SizedBox(height: 2),
                Text('"Would you share this?"',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryDark)),
                const SizedBox(height: 2),
                Text('Source Verification · ~3 min', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiaryDark),
        ],
      ),
    );
  }
}

class _FeaturedScenarioCard extends StatelessWidget {
  final VoidCallback onTap;
  const _FeaturedScenarioCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FWGradientCard(
      gradient: AppColors.heroGradient,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text('🔥 TRENDING', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('AI Earthquake Prediction', style: AppTypography.headlineSmall.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text('Scientists claim AI predicts earthquakes 48 hrs early. Can you spot the missing evidence?',
              style: AppTypography.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8))),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text('Investigate →', style: AppTypography.labelMedium.copyWith(color: AppColors.primary600)),
              ),
              const SizedBox(width: 10),
              Text('AI Content · Intermediate', style: AppTypography.bodySmall.copyWith(color: Colors.white.withOpacity(0.7))),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final BuildContext context;
  const _QuickActionsGrid({required this.context});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(emoji: '📱', label: 'Feed', onTap: () => context.go('/explore')),
      _QuickAction(emoji: '🎮', label: 'Play', onTap: () => context.go('/play')),
      _QuickAction(emoji: '📚', label: 'Academy', onTap: () => context.go('/academy')),
      _QuickAction(emoji: '🏅', label: 'Badges', onTap: () => context.push('/me/achievements')),
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: actions.map((a) => _QuickActionTile(action: a)).toList(),
    );
  }
}

class _QuickAction {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.emoji, required this.label, required this.onTap});
}

class _QuickActionTile extends StatelessWidget {
  final _QuickAction action;
  const _QuickActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: FWCard(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(action.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(action.label, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondaryDark), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _SkillSnapshot extends StatelessWidget {
  final SkillsModel skills;
  const _SkillSnapshot({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SKILL SNAPSHOT', style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiaryDark, letterSpacing: 1.5)),
            TextButton(onPressed: () => context.push('/me/progress'), child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 12),
        FWCard(
          child: Center(
            child: FWSkillRadar(skills: skills, size: 220),
          ),
        ),
      ],
    );
  }
}
