import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/mock/mock_data.dart';
import '../../core/models/scenario_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_button.dart';
import '../../shared/widgets/fw_card.dart';
import '../../shared/widgets/fw_stat_card.dart';
import '../../shared/charts/chart_widgets.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final analytics = MockData.analytics;
    final scenarios = MockData.scenarios;
    final publishedCount = scenarios.where((s) => s.status == ScenarioStatus.published).length;
    final draftCount    = scenarios.where((s) => s.status == ScenarioStatus.draft).length;
    final reviewCount   = scenarios.where((s) => s.status == ScenarioStatus.inReview).length;

    return AdminLayout(
      title: 'Dashboard',
      actions: [
        FWButton(
          label: 'New Scenario',
          icon: Icons.add_rounded,
          onPressed: () => context.go('/scenarios/new'),
          size: FWButtonSize.small,
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─ Welcome banner
            _WelcomeBanner(userName: user?.name ?? 'Admin'),
            const SizedBox(height: 24),

            // ─ KPI cards
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 48) / 4;
                final isNarrow = constraints.maxWidth < 700;
                if (isNarrow) {
                  return Column(
                    children: [
                      Row(children: [
                        Expanded(child: FWStatCard(value: '${analytics.engagement.activeUsers}', label: 'Active Users', icon: Icons.people_outline, iconColor: AppColors.primary400, delta: '+12%')),
                        const SizedBox(width: 16),
                        Expanded(child: FWStatCard(value: '${analytics.engagement.scenariosCompleted}', label: 'Scenarios Done', icon: Icons.check_circle_outline, iconColor: AppColors.success, delta: '+8%')),
                      ]),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: FWStatCard(value: '${analytics.engagement.completionRate.round()}%', label: 'Completion Rate', icon: Icons.trending_up, iconColor: AppColors.tertiary400, delta: '+5%')),
                        const SizedBox(width: 16),
                        Expanded(child: FWStatCard(value: '$publishedCount', label: 'Published Scenarios', icon: Icons.article_outlined, iconColor: AppColors.warning, delta: '+2')),
                      ]),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: FWStatCard(value: '${analytics.engagement.activeUsers}', label: 'Active Users', icon: Icons.people_outline, iconColor: AppColors.primary400, delta: '+12%')),
                    const SizedBox(width: 16),
                    Expanded(child: FWStatCard(value: '${analytics.engagement.scenariosCompleted}', label: 'Scenarios Done', icon: Icons.check_circle_outline, iconColor: AppColors.success, delta: '+8%')),
                    const SizedBox(width: 16),
                    Expanded(child: FWStatCard(value: '${analytics.engagement.completionRate.round()}%', label: 'Completion Rate', icon: Icons.trending_up, iconColor: AppColors.tertiary400, delta: '+5%')),
                    const SizedBox(width: 16),
                    Expanded(child: FWStatCard(value: '$publishedCount', label: 'Published Scenarios', icon: Icons.article_outlined, iconColor: AppColors.warning, delta: '+2')),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // ─ Main content row
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return Column(children: [
                    _EngagementChart(data: analytics.weeklyEngagement.map((d) => (label: d.label, value: d.value)).toList()),
                    const SizedBox(height: 20),
                    _ScenarioPipeline(published: publishedCount, review: reviewCount, draft: draftCount, scenarios: scenarios),
                  ]);
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _EngagementChart(data: analytics.weeklyEngagement.map((d) => (label: d.label, value: d.value)).toList()),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: _ScenarioPipeline(published: publishedCount, review: reviewCount, draft: draftCount, scenarios: scenarios),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // ─ Recent scenarios + skill gaps
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return Column(children: [
                    _RecentScenariosCard(scenarios: scenarios.take(5).toList()),
                    const SizedBox(height: 20),
                    _SkillGapsCard(analytics: analytics),
                  ]);
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _RecentScenariosCard(scenarios: scenarios.take(5).toList())),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: _SkillGapsCard(analytics: analytics)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  final String userName;
  const _WelcomeBanner({required this.userName});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = now.hour < 12 ? 'Good morning' : now.hour < 17 ? 'Good afternoon' : 'Good evening';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$greeting, ${userName.split(' ').first} 👋', style: AppTypography.headlineMedium(AppColors.textPrimaryDark)),
              const SizedBox(height: 4),
              Text('Here\'s what\'s happening on FeedWise today.', style: AppTypography.bodyMedium(AppColors.textSecondaryDark)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceCardDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondaryDark),
              const SizedBox(width: 8),
              Text(
                '${_monthName(DateTime.now().month)} ${DateTime.now().day}, ${DateTime.now().year}',
                style: AppTypography.labelMedium(AppColors.textSecondaryDark),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _monthName(int month) => ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][month-1];
}

class _EngagementChart extends StatelessWidget {
  final List<({String label, double value})> data;
  const _EngagementChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FWSectionHeader(
            title: 'Weekly Engagement',
            subtitle: 'Active users this week',
            action: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: const Text('This Week', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 20),
          EngagementLineChart(data: data, height: 200),
        ],
      ),
    );
  }
}

class _ScenarioPipeline extends StatelessWidget {
  final int published, review, draft;
  final List<ScenarioModel> scenarios;
  const _ScenarioPipeline({required this.published, required this.review, required this.draft, required this.scenarios});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FWSectionHeader(title: 'Scenario Pipeline', subtitle: 'Content review status'),
          const SizedBox(height: 20),
          _PipelineItem(label: 'Published', count: published, color: AppColors.statusPublished, icon: Icons.check_circle_outline),
          const SizedBox(height: 12),
          _PipelineItem(label: 'In Review',  count: review,    color: AppColors.statusReview,    icon: Icons.rate_review_outlined),
          const SizedBox(height: 12),
          _PipelineItem(label: 'Draft',      count: draft,     color: AppColors.statusDraft,     icon: Icons.edit_outlined),
          const SizedBox(height: 24),
          // Funnel bar
          Column(
            children: [
              _PipelineBar(label: 'Published', value: published / (published + review + draft), color: AppColors.statusPublished),
              const SizedBox(height: 8),
              _PipelineBar(label: 'Review',    value: review / (published + review + draft),    color: AppColors.statusReview),
              const SizedBox(height: 8),
              _PipelineBar(label: 'Draft',     value: draft / (published + review + draft),     color: AppColors.statusDraft),
            ],
          ),
        ],
      ),
    );
  }
}

class _PipelineItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  const _PipelineItem({required this.label, required this.count, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Text(label, style: AppTypography.bodyMedium(AppColors.textSecondaryDark)),
        const Spacer(),
        Text('$count', style: AppTypography.titleLarge(color)),
      ],
    );
  }
}

class _PipelineBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _PipelineBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label, style: AppTypography.labelSmall(AppColors.textTertiaryDark))),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value.isNaN ? 0 : value,
              minHeight: 6,
              color: color,
              backgroundColor: AppColors.surfaceElevatedDark,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(value * 100).round()}%', style: AppTypography.labelSmall(color)),
      ],
    );
  }
}

class _RecentScenariosCard extends StatelessWidget {
  final List<ScenarioModel> scenarios;
  const _RecentScenariosCard({required this.scenarios});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FWSectionHeader(
            title: 'Recent Scenarios',
            subtitle: 'Latest content updates',
            action: TextButton(
              onPressed: () => context.go('/scenarios'),
              child: const Text('View all →', style: TextStyle(color: AppColors.primary400, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 16),
          ...scenarios.map((s) => _ScenarioRow(scenario: s)),
        ],
      ),
    );
  }
}

class _ScenarioRow extends StatelessWidget {
  final ScenarioModel scenario;
  const _ScenarioRow({required this.scenario});

  @override
  Widget build(BuildContext context) {
    final statusColor = scenario.status.color;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: scenario.category.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Text(scenario.category.emoji, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scenario.title, style: AppTypography.titleSmall(AppColors.textPrimaryDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(scenario.id, style: AppTypography.labelSmall(AppColors.textTertiaryDark)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(scenario.status.label, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _SkillGapsCard extends StatelessWidget {
  final dynamic analytics;
  const _SkillGapsCard({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final skills = [
      (name: 'Source Verification', value: 84.0, color: AppColors.primary500),
      (name: 'Evidence Evaluation', value: 78.0, color: AppColors.info),
      (name: 'AI Literacy',         value: 61.0, color: AppColors.tertiary400),
      (name: 'Bias Detection',      value: 75.0, color: AppColors.warning),
      (name: 'Digital Safety',      value: 88.0, color: AppColors.success),
    ];

    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FWSectionHeader(title: 'Platform Skill Levels', subtitle: 'Average across all students'),
          const SizedBox(height: 20),
          SkillBarChart(skills: skills),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AI Literacy (61%) needs attention. Consider adding more AI scenarios.',
                    style: AppTypography.bodySmall(AppColors.warning),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
