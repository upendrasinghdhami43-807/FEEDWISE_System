import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/models/scenario_model.dart';
import '../../core/providers/scenario_provider.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_button.dart';
import '../../shared/widgets/fw_badge.dart';
import '../../shared/widgets/fw_card.dart';
import '../../shared/widgets/fw_text_field.dart';

class ScenariosListScreen extends ConsumerStatefulWidget {
  const ScenariosListScreen({super.key});

  @override
  ConsumerState<ScenariosListScreen> createState() => _ScenariosListScreenState();
}

class _ScenariosListScreenState extends ConsumerState<ScenariosListScreen> {
  final _searchCtrl = TextEditingController();
  ScenarioStatus? _filterStatus;
  ScenarioCategory? _filterCategory;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scenarios = ref.watch(scenariosProvider);
    final statusCounts = ref.watch(scenarioStatusCountsProvider);

    return AdminLayout(
      title: 'Scenarios',
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
            // ─ Pipeline status summary
            _PipelineSummary(statusCounts: statusCounts),
            const SizedBox(height: 24),

            // ─ Filters row
            Row(
              children: [
                Expanded(
                  child: FWSearchField(
                    hint: 'Search scenarios by title, ID, category...',
                    controller: _searchCtrl,
                    onChanged: (v) {
                      ref.read(scenariosProvider.notifier).search(v);
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                _FilterDropdown<ScenarioStatus?>(
                  hint: 'All Status',
                  value: _filterStatus,
                  items: [null, ...ScenarioStatus.values],
                  labelOf: (s) => s == null ? 'All Status' : s.label,
                  onChanged: (v) {
                    setState(() => _filterStatus = v);
                    ref.read(scenariosProvider.notifier).filterByStatus(v);
                  },
                ),
                const SizedBox(width: 12),
                _FilterDropdown<ScenarioCategory?>(
                  hint: 'All Categories',
                  value: _filterCategory,
                  items: [null, ...ScenarioCategory.values],
                  labelOf: (c) => c == null ? 'All Categories' : c.displayName,
                  onChanged: (v) {
                    setState(() => _filterCategory = v);
                    ref.read(scenariosProvider.notifier).filterByCategory(v);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ─ Results count
            Row(
              children: [
                Text(
                  '${scenarios.length} scenario${scenarios.length != 1 ? 's' : ''}',
                  style: AppTypography.bodySmall(AppColors.textSecondaryDark),
                ),
                if (_filterStatus != null || _searchCtrl.text.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _filterStatus = null;
                        _filterCategory = null;
                        _searchCtrl.clear();
                      });
                      ref.read(scenariosProvider.notifier).search('');
                    },
                    child: const Text('Clear filters', style: TextStyle(color: AppColors.primary400, fontSize: 12)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            // ─ Scenario cards
            if (scenarios.isEmpty)
              _EmptyState()
            else
              ...scenarios.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ScenarioCard(scenario: s),
              )),
          ],
        ),
      ),
    );
  }
}

class _PipelineSummary extends StatelessWidget {
  final Map<ScenarioStatus, int> statusCounts;
  const _PipelineSummary({required this.statusCounts});

  @override
  Widget build(BuildContext context) {
    final pipeline = [
      ScenarioStatus.draft,
      ScenarioStatus.inReview,
      ScenarioStatus.factChecked,
      ScenarioStatus.milReviewed,
      ScenarioStatus.published,
    ];

    return FWCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const Text('Pipeline:', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: pipeline.map((status) {
                  final count = statusCounts[status] ?? 0;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: status.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: status.color.withOpacity(0.25)),
                          ),
                          child: Row(
                            children: [
                              Text(status.emoji, style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 6),
                              Text(status.label, style: TextStyle(color: status.color, fontSize: 12, fontWeight: FontWeight.w500)),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: status.color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (status != ScenarioStatus.published)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.textTertiaryDark),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenarioCard extends ConsumerWidget {
  final ScenarioModel scenario;
  const _ScenarioCard({required this.scenario});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FWCard(
      hoverable: true,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: scenario.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text(scenario.category.emoji, style: const TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(scenario.id, style: AppTypography.mono(AppColors.textTertiaryDark)),
                        const SizedBox(width: 10),
                        _StatusBadge(status: scenario.status),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(scenario.title, style: AppTypography.titleMedium(AppColors.textPrimaryDark)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Actions
              Row(
                children: [
                  _ActionBtn(label: 'Edit', icon: Icons.edit_outlined, color: AppColors.primary400, onTap: () => context.go('/scenarios/${scenario.id}/edit')),
                  const SizedBox(width: 8),
                  _ActionBtn(label: 'Preview', icon: Icons.visibility_outlined, color: AppColors.textSecondaryDark, onTap: () {}),
                  if (scenario.status == ScenarioStatus.draft) ...[
                    const SizedBox(width: 8),
                    _ActionBtn(label: 'Submit', icon: Icons.send_outlined, color: AppColors.success, onTap: () {
                      ref.read(scenariosProvider.notifier).updateStatus(scenario.id, ScenarioStatus.inReview);
                    }),
                  ],
                  if (scenario.status == ScenarioStatus.inReview) ...[
                    const SizedBox(width: 8),
                    _ActionBtn(label: 'Publish', icon: Icons.publish_outlined, color: AppColors.success, onTap: () {
                      ref.read(scenariosProvider.notifier).updateStatus(scenario.id, ScenarioStatus.published);
                    }),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Meta row
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _MetaChip(icon: Icons.category_outlined, label: scenario.category.displayName, color: scenario.category.color),
              _MetaChip(icon: Icons.bar_chart_outlined, label: scenario.difficulty.label),
              _MetaChip(icon: Icons.language_outlined, label: scenario.languages.join(', ').toUpperCase()),
              _MetaChip(icon: Icons.calendar_today_outlined, label: _formatDate(scenario.updatedAt)),
            ],
          ),

          if (scenario.completions > 0) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.borderDark, height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatsChip(label: 'Completions', value: '${scenario.completions}', color: AppColors.primary400),
                const SizedBox(width: 20),
                _StatsChip(label: 'Correct Rate', value: '${scenario.correctRate.round()}%', color: scenario.correctRate >= 60 ? AppColors.success : AppColors.error),
                const SizedBox(width: 20),
                _StatsChip(label: 'Avg Time', value: _formatTime(scenario.avgTimeSeconds), color: AppColors.textSecondaryDark),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
  String _formatTime(double s) {
    final m = s ~/ 60;
    final sec = (s % 60).toInt();
    return '$m:${sec.toString().padLeft(2, '0')}';
  }
}

class _StatusBadge extends StatelessWidget {
  final ScenarioStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) => switch (status) {
    ScenarioStatus.draft       => FWBadge.draft(size: FWBadgeSize.small),
    ScenarioStatus.inReview    => FWBadge.review(size: FWBadgeSize.small),
    ScenarioStatus.factChecked => FWBadge.factChecked(size: FWBadgeSize.small),
    ScenarioStatus.milReviewed => FWBadge.milReviewed(size: FWBadgeSize.small),
    ScenarioStatus.published   => FWBadge.published(size: FWBadgeSize.small),
    ScenarioStatus.archived    => FWBadge.archived(size: FWBadgeSize.small),
  };
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _MetaChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: color ?? AppColors.textTertiaryDark),
      const SizedBox(width: 5),
      Text(label, style: TextStyle(color: color ?? AppColors.textSecondaryDark, fontSize: 12, fontWeight: FontWeight.w500)),
    ],
  );
}

class _StatsChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatsChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
      Text(label, style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 11)),
    ],
  );
}

class _ActionBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: Tooltip(
        message: widget.label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered ? widget.color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _hovered ? widget.color.withOpacity(0.3) : AppColors.borderDark),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 14, color: widget.color),
              const SizedBox(width: 5),
              Text(widget.label, style: TextStyle(color: widget.color, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    ),
  );
}

class _FilterDropdown<T> extends StatelessWidget {
  final String hint;
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  const _FilterDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: DropdownButton<T>(
        value: value,
        hint: Text(hint, style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 13)),
        underline: const SizedBox(),
        dropdownColor: AppColors.surfaceElevatedDark,
        style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textTertiaryDark, size: 18),
        items: items.map((item) => DropdownMenuItem<T>(
          value: item,
          child: Text(labelOf(item)),
        )).toList(),
        onChanged: (v) { if (v != null || T == ScenarioStatus?) onChanged(v as T); },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          const Icon(Icons.article_outlined, size: 64, color: AppColors.textTertiaryDark),
          const SizedBox(height: 16),
          Text('No scenarios found', style: AppTypography.headlineSmall(AppColors.textSecondaryDark)),
          const SizedBox(height: 8),
          Text('Try adjusting your filters or create a new scenario.', style: AppTypography.bodyMedium(AppColors.textTertiaryDark)),
        ],
      ),
    ),
  );
}
