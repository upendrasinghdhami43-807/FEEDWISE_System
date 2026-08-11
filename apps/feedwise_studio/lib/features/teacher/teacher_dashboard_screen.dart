import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/teacher_provider.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_button.dart';
import '../../shared/widgets/fw_card.dart';
import '../../shared/widgets/fw_stat_card.dart';
import '../../shared/widgets/fw_avatar.dart';
import '../../shared/charts/chart_widgets.dart';

class TeacherDashboardScreen extends ConsumerWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final classStats = ref.watch(selectedClassStatsProvider);
    final classes = ref.watch(teacherClassesProvider);
    final selectedClassId = ref.watch(selectedClassIdProvider);
    final selectedClass = classes.firstWhere((c) => c.id == selectedClassId, orElse: () => classes.first);

    final skills = [
      (name: 'Source Verification', value: classStats.averageSkills.sourceVerification, color: AppColors.primary500),
      (name: 'Evidence Evaluation', value: classStats.averageSkills.evidenceEvaluation, color: AppColors.info),
      (name: 'AI Literacy',         value: classStats.averageSkills.aiLiteracy,         color: AppColors.tertiary400),
      (name: 'Bias Detection',      value: classStats.averageSkills.biasDetection,      color: AppColors.warning),
      (name: 'Digital Safety',      value: classStats.averageSkills.digitalSafety,      color: AppColors.success),
    ];

    return AdminLayout(
      title: 'Teacher Dashboard',
      actions: [
        FWButton(
          label: 'Assign Challenge',
          icon: Icons.add_task,
          onPressed: () => _showAssignDialog(context),
          size: FWButtonSize.small,
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─ Welcome
            _WelcomeRow(
              userName: user?.name ?? 'Teacher',
              classes: classes.map((c) => c.name).toList(),
              selectedClass: selectedClass.name,
              onClassChanged: (name) {
                final cls = classes.firstWhere((c) => c.name == name);
                ref.read(selectedClassIdProvider.notifier).state = cls.id;
              },
            ),
            const SizedBox(height: 24),

            // ─ KPI row
            Row(
              children: [
                Expanded(child: FWStatCard(value: '${classStats.studentCount}', label: 'Students', icon: Icons.people_outline, iconColor: AppColors.primary400)),
                const SizedBox(width: 14),
                Expanded(child: FWStatCard(value: '${classStats.completedChallenges}', label: 'Completions', icon: Icons.check_circle_outline, iconColor: AppColors.success, delta: '+22%')),
                const SizedBox(width: 14),
                Expanded(child: FWStatCard(value: '${classStats.averageScore.round()}%', label: 'Avg Score', icon: Icons.bar_chart, iconColor: AppColors.tertiary400, delta: '+4%')),
              ],
            ),
            const SizedBox(height: 24),

            // ─ Main content
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return Column(children: [
                    _SkillGapCard(skills: skills, classStats: classStats),
                    const SizedBox(height: 20),
                    _ActivityCard(activity: classStats.recentActivity),
                  ]);
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _SkillGapCard(skills: skills, classStats: classStats)),
                    const SizedBox(width: 20),
                    Expanded(flex: 2, child: _ActivityCard(activity: classStats.recentActivity)),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // ─ Students overview
            _StudentsOverviewCard(),
          ],
        ),
      ),
    );
  }

  void _showAssignDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _AssignChallengeDialog(),
    );
  }
}

class _WelcomeRow extends StatelessWidget {
  final String userName;
  final List<String> classes;
  final String selectedClass;
  final ValueChanged<String> onClassChanged;

  const _WelcomeRow({
    required this.userName,
    required this.classes,
    required this.selectedClass,
    required this.onClassChanged,
  });

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
              Text('Viewing your class performance overview.', style: AppTypography.bodyMedium(AppColors.textSecondaryDark)),
            ],
          ),
        ),
        // Class selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceCardDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            children: [
              const Icon(Icons.class_outlined, size: 16, color: AppColors.textSecondaryDark),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: selectedClass,
                underline: const SizedBox(),
                dropdownColor: AppColors.surfaceElevatedDark,
                style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, fontWeight: FontWeight.w600),
                items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) { if (v != null) onClassChanged(v); },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkillGapCard extends StatelessWidget {
  final List<({String name, double value, Color color})> skills;
  final dynamic classStats;
  const _SkillGapCard({required this.skills, required this.classStats});

  @override
  Widget build(BuildContext context) {
    // Find weakest
    final weakest = skills.reduce((a, b) => a.value < b.value ? a : b);

    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FWSectionHeader(title: 'Class Skill Gaps', subtitle: 'Average skill scores for this class'),
          const SizedBox(height: 20),
          SkillBarChart(skills: skills),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Weakest skill: ${weakest.name} (${weakest.value.round()}%). Consider assigning targeted AI Literacy challenges.',
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

class _ActivityCard extends StatelessWidget {
  final List<dynamic> activity;
  const _ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FWSectionHeader(
            title: 'Recent Activity',
            subtitle: 'Student actions in the last 24 hours',
            action: TextButton(
              onPressed: () {},
              child: const Text('View all →', style: TextStyle(color: AppColors.primary400, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 16),
          if (activity.isEmpty)
            const Center(child: Text('No recent activity', style: TextStyle(color: AppColors.textTertiaryDark)))
          else
            ...activity.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8, height: 8,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.isPositive ? AppColors.success : AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: item.studentName, style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, fontWeight: FontWeight.w600)),
                              TextSpan(text: ' ${item.action} ', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
                              TextSpan(text: item.scenarioTitle, style: const TextStyle(color: AppColors.primary400, fontSize: 13, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        Text(item.timeAgo, style: AppTypography.labelSmall(AppColors.textTertiaryDark)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}

class _StudentsOverviewCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(selectedClassStudentsProvider);

    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FWSectionHeader(
            title: 'Students Overview',
            subtitle: '${students.length} students in this class',
            action: TextButton(
              onPressed: () => context.go('/students'),
              child: const Text('View all →', style: TextStyle(color: AppColors.primary400, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 16),
          ...students.take(5).map((student) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                FWAvatar(name: student.name, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.name, style: AppTypography.titleSmall(AppColors.textPrimaryDark)),
                      Text('Lv.${student.milLevel} · ${student.completedChallenges} challenges', style: AppTypography.labelSmall(AppColors.textTertiaryDark)),
                    ],
                  ),
                ),
                // Score bar
                SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${student.averageScore.round()}%',
                        style: TextStyle(
                          color: student.averageScore >= 80 ? AppColors.success : student.averageScore < 60 ? AppColors.error : AppColors.warning,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: student.averageScore / 100,
                          minHeight: 5,
                          color: student.averageScore >= 80 ? AppColors.success : student.averageScore < 60 ? AppColors.error : AppColors.warning,
                          backgroundColor: AppColors.surfaceElevatedDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _statusColor(student.statusLabel).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(student.statusLabel, style: TextStyle(color: _statusColor(student.statusLabel), fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == 'High Performer') return AppColors.success;
    if (status == 'Needs Support') return AppColors.error;
    return AppColors.warning;
  }
}

// ─── Assign Challenge Dialog ──────────────────────────────────────────────────

class _AssignChallengeDialog extends StatefulWidget {
  const _AssignChallengeDialog();

  @override
  State<_AssignChallengeDialog> createState() => _AssignChallengeDialogState();
}

class _AssignChallengeDialogState extends State<_AssignChallengeDialog> {
  String _challenge = 'AI & Deepfakes Bundle';
  String _target    = 'Grade 10A (All)';
  bool _isLoading   = false;

  final _challenges = ['AI & Deepfakes Bundle', 'Source Verification Basics', 'Political Misinformation', 'Scam Detection', 'Bias & Context'];
  final _targets    = ['Grade 10A (All)', 'Grade 10B (All)', 'Grade 11A (All)', 'Struggling students only'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceCardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 440,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_task, color: AppColors.primary400, size: 24),
                  const SizedBox(width: 12),
                  Text('Assign Challenge', style: AppTypography.headlineSmall(AppColors.textPrimaryDark)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textTertiaryDark),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _DialogDropdown(label: 'Challenge', value: _challenge, items: _challenges, onChanged: (v) => setState(() => _challenge = v)),
              const SizedBox(height: 16),
              _DialogDropdown(label: 'Assign to', value: _target, items: _targets, onChanged: (v) => setState(() => _target = v)),
              const SizedBox(height: 16),
              // Due date
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondaryDark),
                    const SizedBox(width: 12),
                    const Text('Due date: ', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13)),
                    Text(
                      '${DateTime.now().add(const Duration(days: 7)).day}/${DateTime.now().add(const Duration(days: 7)).month}/${DateTime.now().add(const Duration(days: 7)).year}',
                      style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    const Text('Change', style: TextStyle(color: AppColors.primary400, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FWButton(
                      label: 'Assign Now',
                      icon: Icons.send_outlined,
                      onPressed: () async {
                        setState(() => _isLoading = true);
                        await Future.delayed(const Duration(milliseconds: 800));
                        if (context.mounted) Navigator.pop(context);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Challenge assigned successfully!'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ));
                        }
                      },
                      isLoading: _isLoading,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogDropdown extends StatelessWidget {
  final String label, value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const _DialogDropdown({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: AppColors.surfaceElevatedDark,
            style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14),
            items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
            onChanged: (v) { if (v != null) onChanged(v); },
          ),
        ),
      ],
    );
  }
}
