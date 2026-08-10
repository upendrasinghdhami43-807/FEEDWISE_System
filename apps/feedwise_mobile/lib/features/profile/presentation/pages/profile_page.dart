import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/theme.dart';
import '../../../logic/providers/auth/auth_provider.dart';
import '../../../logic/providers/investigation/investigation_provider.dart';
import '../../../shared/widgets/fw_card.dart';
import '../../../shared/widgets/fw_button.dart';
import '../../../shared/widgets/fw_skill_radar.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final skillsAsync = ref.watch(skillsProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: userAsync.when(
        data: (user) => CustomScrollView(
          slivers: [
            // Header sliver
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: AppColors.surfaceDark,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A1640), AppColors.surfaceDark],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: AppColors.heroGradient,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary400, width: 2),
                            ),
                            child: Center(
                              child: Text(user.name[0].toUpperCase(),
                                  style: AppTypography.headlineLarge.copyWith(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(user.name, style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
                          Text('${user.levelTitle} · Level ${user.level}',
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.primary400)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => context.push('/me/settings')),
                const SizedBox(width: 4),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Stats row
                  Row(
                    children: [
                      Expanded(child: _ProfileStat(label: 'XP', value: '${user.xp}', emoji: '✨')),
                      const SizedBox(width: 10),
                      Expanded(child: _ProfileStat(label: 'Streak', value: '${user.currentStreak}d', emoji: '🔥')),
                      const SizedBox(width: 10),
                      Expanded(child: _ProfileStat(label: 'Badges', value: '4', emoji: '🏅')),
                    ],
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 20),

                  // Skill radar
                  skillsAsync.when(
                    data: (skills) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('MIL SKILL PROFILE', style: AppTypography.labelMedium.copyWith(
                              color: AppColors.textTertiaryDark,
                              letterSpacing: 1.5,
                            )),
                            TextButton(onPressed: () => context.push('/me/progress'), child: const Text('Details')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FWCard(
                          child: Center(child: FWSkillRadar(skills: skills, size: 220)),
                        ),
                      ],
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ).animate().fadeIn(delay: 50.ms),

                  const SizedBox(height: 20),

                  // Menu items
                  Text('ACCOUNT', style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiaryDark, letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  ..._menuItems(context, ref).map((item) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _MenuTile(item: item),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary500)),
        error: (_, __) => const Center(child: Text('Error')),
      ),
    );
  }

  List<_MenuItem> _menuItems(BuildContext context, WidgetRef ref) => [
    _MenuItem(icon: Icons.emoji_events_outlined, label: 'Achievements & Badges', onTap: () => context.push('/me/achievements')),
    _MenuItem(icon: Icons.show_chart, label: 'Progress & History', onTap: () => context.push('/me/progress')),
    _MenuItem(icon: Icons.school_outlined, label: 'Academy Progress', onTap: () => context.go('/academy')),
    _MenuItem(icon: Icons.group_outlined, label: 'Community', onTap: () => context.push('/me/community')),
    _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () => context.push('/me/notifications')),
    _MenuItem(icon: Icons.settings_outlined, label: 'Settings', onTap: () => context.push('/me/settings')),
    _MenuItem(icon: Icons.logout, label: 'Sign Out', isDestructive: true,
        onTap: () => ref.read(authControllerProvider.notifier).signOut().then((_) => context.go('/login'))),
  ];
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  const _ProfileStat({required this.label, required this.value, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark)),
          Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.isDestructive = false});
}

class _MenuTile extends StatelessWidget {
  final _MenuItem item;
  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      onTap: item.onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(item.icon, size: 20, color: item.isDestructive ? AppColors.evidenceMissing : AppColors.textSecondaryDark),
          const SizedBox(width: 12),
          Expanded(child: Text(item.label, style: AppTypography.titleSmall.copyWith(
            color: item.isDestructive ? AppColors.evidenceMissing : AppColors.textPrimaryDark,
          ))),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiaryDark),
        ],
      ),
    );
  }
}
