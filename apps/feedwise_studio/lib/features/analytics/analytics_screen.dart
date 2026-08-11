import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/mock/mock_data.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_button.dart';
import '../../shared/widgets/fw_card.dart';
import '../../shared/widgets/fw_stat_card.dart';
import '../../shared/charts/chart_widgets.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  String _period = 'This Week';
  final _periods = ['Today', 'This Week', 'This Month', 'All Time'];

  @override
  Widget build(BuildContext context) {
    final analytics = MockData.analytics;
    return AdminLayout(
      title: 'Analytics',
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            children: _periods.map((p) => GestureDetector(
              onTap: () => setState(() => _period = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: _period == p ? AppColors.primary500.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  p,
                  style: TextStyle(
                    color: _period == p ? AppColors.primary400 : AppColors.textTertiaryDark,
                    fontSize: 12,
                    fontWeight: _period == p ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
        const SizedBox(width: 8),
        FWButton(
          label: 'Export CSV',
          icon: Icons.download_outlined,
          variant: FWButtonVariant.ghost,
          onPressed: () {},
          size: FWButtonSize.small,
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─ KPI row
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return Column(children: [
                    Row(children: [
                      Expanded(child: FWStatCard(value: '${analytics.engagement.activeUsers}', label: 'Active Users', icon: Icons.people_outline, iconColor: AppColors.primary400, delta: '+12%')),
                      const SizedBox(width: 12),
                      Expanded(child: FWStatCard(value: '${analytics.engagement.scenariosCompleted}', label: 'Completions', icon: Icons.check_circle_outline, iconColor: AppColors.success, delta: '+8%')),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: FWStatCard(value: '${analytics.engagement.avgPerUser.toStringAsFixed(1)}', label: 'Avg/User', icon: Icons.person_outline, iconColor: AppColors.tertiary400, delta: '+0.5')),
                      const SizedBox(width: 12),
                      Expanded(child: FWStatCard(value: '${analytics.engagement.completionRate.round()}%', label: 'Completion Rate', icon: Icons.trending_up, iconColor: AppColors.warning, delta: '+5%')),
                    ]),
                  ]);
                }
                return Row(
                  children: [
                    Expanded(child: FWStatCard(value: '${analytics.engagement.activeUsers}', label: 'Active Users', icon: Icons.people_outline, iconColor: AppColors.primary400, delta: '+12%')),
                    const SizedBox(width: 16),
                    Expanded(child: FWStatCard(value: '${analytics.engagement.scenariosCompleted}', label: 'Completions', icon: Icons.check_circle_outline, iconColor: AppColors.success, delta: '+8%')),
                    const SizedBox(width: 16),
                    Expanded(child: FWStatCard(value: '${analytics.engagement.avgPerUser.toStringAsFixed(1)}', label: 'Avg/User', icon: Icons.person_outline, iconColor: AppColors.tertiary400, delta: '+0.5')),
                    const SizedBox(width: 16),
                    Expanded(child: FWStatCard(value: '${analytics.engagement.completionRate.round()}%', label: 'Completion Rate', icon: Icons.trending_up, iconColor: AppColors.warning, delta: '+5%')),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // ─ Skill trends chart
            FWCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FWSectionHeader(title: 'Skill Score Trends', subtitle: 'Average skill improvements over time'),
                  const SizedBox(height: 24),
                  SkillTrendChart(
                    height: 240,
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    series: analytics.skillTrends.map((t) => (
                      name: t.skillName,
                      values: t.points.map((p) => p.value).toList(),
                      color: _skillColor(t.skillName),
                    )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return Column(children: [
                    _ScenarioPerformanceTable(analytics: analytics),
                    const SizedBox(height: 20),
                    _SkillGapPanel(analytics: analytics),
                  ]);
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _ScenarioPerformanceTable(analytics: analytics)),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: _SkillGapPanel(analytics: analytics)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _skillColor(String name) {
    if (name.contains('Source'))    return AppColors.primary500;
    if (name.contains('Evidence'))  return AppColors.info;
    if (name.contains('AI'))        return AppColors.tertiary400;
    if (name.contains('Bias'))      return AppColors.warning;
    return AppColors.success;
  }
}

class _ScenarioPerformanceTable extends StatelessWidget {
  final dynamic analytics;
  const _ScenarioPerformanceTable({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: const FWSectionHeader(title: 'Scenario Performance', subtitle: 'Effectiveness by scenario'),
          ),
          const Divider(height: 1, color: AppColors.borderDark),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text('Scenario', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(child: Text('Correct %', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(child: Text('Avg Time', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12, fontWeight: FontWeight.w600))),
                Expanded(child: Text('Completions', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderDark),
          ...analytics.scenarioPerformance.map((data) => _PerformanceRow(data: data)),
        ],
      ),
    );
  }
}

class _PerformanceRow extends StatelessWidget {
  final dynamic data;
  const _PerformanceRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final correct = data.correctPercent as double;
    final color = correct >= 70 ? AppColors.success : correct >= 50 ? AppColors.warning : AppColors.error;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(data.title as String, style: AppTypography.bodySmall(AppColors.textPrimaryDark), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${correct.round()}%', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              Expanded(child: Text(data.avgTimeFormatted as String, style: AppTypography.bodySmall(AppColors.textSecondaryDark))),
              Expanded(child: Text('${data.completions}', style: AppTypography.bodySmall(AppColors.textSecondaryDark))),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.borderDark),
      ],
    );
  }
}

class _SkillGapPanel extends StatelessWidget {
  final dynamic analytics;
  const _SkillGapPanel({required this.analytics});

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
          const FWSectionHeader(title: 'Skill Gap Analysis', subtitle: 'Platform-wide averages'),
          const SizedBox(height: 20),
          SkillBarChart(skills: skills),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.warning.withOpacity(0.08), AppColors.secondary400.withOpacity(0.04)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 16),
                    const SizedBox(width: 8),
                    Text('Recommendation', style: AppTypography.labelMedium(AppColors.warning)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  analytics.recommendation as String,
                  style: AppTypography.bodySmall(AppColors.textSecondaryDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
