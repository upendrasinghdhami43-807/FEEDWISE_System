import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/providers/teacher_provider.dart';
import '../../core/models/user_model.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_avatar.dart';
import '../../shared/widgets/fw_button.dart';
import '../../shared/widgets/fw_card.dart';
import '../../shared/widgets/fw_stat_card.dart';

class StudentDetailScreen extends ConsumerWidget {
  final String studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(selectedStudentProvider);

    if (student == null) {
      return AdminLayout(
        title: 'Student Detail',
        child: const Center(child: Text('Student not found', style: TextStyle(color: AppColors.textSecondaryDark))),
      );
    }

    final skills = [
      (name: 'Source Verification', value: student.skills.sourceVerification, color: AppColors.primary500),
      (name: 'Evidence Evaluation', value: student.skills.evidenceEvaluation, color: AppColors.info),
      (name: 'AI Literacy',         value: student.skills.aiLiteracy,         color: AppColors.tertiary400),
      (name: 'Bias Detection',      value: student.skills.biasDetection,      color: AppColors.warning),
      (name: 'Digital Safety',      value: student.skills.digitalSafety,      color: AppColors.success),
    ];

    return AdminLayout(
      title: 'Student Profile',
      actions: [
        FWButton(
          label: 'Assign Challenge',
          icon: Icons.add_task,
          variant: FWButtonVariant.secondary,
          onPressed: () {},
          size: FWButtonSize.small,
        ),
        const SizedBox(width: 8),
        FWButton(
          label: 'Message',
          icon: Icons.message_outlined,
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
            // ─ Profile header
            FWCard(
              child: Row(
                children: [
                  FWAvatar(name: student.name, size: 72),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student.name, style: AppTypography.headlineMedium(AppColors.textPrimaryDark)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _InfoChip(icon: Icons.class_outlined, label: student.className),
                            const SizedBox(width: 12),
                            _InfoChip(icon: Icons.grade_outlined, label: 'Grade ${student.gradeLevel}'),
                            const SizedBox(width: 12),
                            _InfoChip(icon: Icons.email_outlined, label: student.email),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _MILLevel(level: student.milLevel),
                            const SizedBox(width: 12),
                            _StatusLabel(status: student.statusLabel),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Streak
                  Column(
                    children: [
                      const Icon(Icons.local_fire_department, color: AppColors.secondary400, size: 32),
                      const SizedBox(height: 4),
                      Text('${student.streak}', style: const TextStyle(color: AppColors.secondary400, fontSize: 24, fontWeight: FontWeight.w800)),
                      const Text('day streak', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─ Stats row
            Row(
              children: [
                Expanded(child: FWMiniStatCard(value: '${student.completedChallenges}', label: 'Challenges', color: AppColors.primary400)),
                const SizedBox(width: 12),
                Expanded(child: FWMiniStatCard(value: '${student.averageScore.round()}%', label: 'Avg Score', color: student.averageScore >= 80 ? AppColors.success : AppColors.warning)),
                const SizedBox(width: 12),
                Expanded(child: FWMiniStatCard(value: '${student.badgeCount}', label: 'Badges', color: AppColors.tertiary400)),
                const SizedBox(width: 12),
                Expanded(child: FWMiniStatCard(value: '${student.xp}', label: 'XP', color: AppColors.primary400)),
              ],
            ),
            const SizedBox(height: 20),

            // ─ Skills + decisions
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700) {
                  return Column(children: [
                    _SkillsCard(skills: skills),
                    const SizedBox(height: 20),
                    _DecisionsCard(decisions: student.recentDecisions),
                  ]);
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _SkillsCard(skills: skills)),
                    const SizedBox(width: 20),
                    Expanded(flex: 3, child: _DecisionsCard(decisions: student.recentDecisions)),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // ─ Assignments
            _AssignmentsCard(assignments: student.assignments),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: AppColors.textTertiaryDark),
      const SizedBox(width: 5),
      Text(label, style: AppTypography.bodySmall(AppColors.textSecondaryDark)),
    ],
  );
}

class _MILLevel extends StatelessWidget {
  final int level;
  const _MILLevel({required this.level});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: AppColors.heroGradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text('MIL Level $level', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
  );
}

class _StatusLabel extends StatelessWidget {
  final String status;
  const _StatusLabel({required this.status});

  Color get _color {
    if (status == 'High Performer') return AppColors.success;
    if (status == 'Needs Support') return AppColors.error;
    return AppColors.warning;
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: _color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _color.withOpacity(0.3)),
    ),
    child: Text(status, style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}

class _SkillsCard extends StatelessWidget {
  final List<({String name, double value, Color color})> skills;
  const _SkillsCard({required this.skills});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FWSectionHeader(title: 'MIL Skills', subtitle: 'Current skill scores'),
          const SizedBox(height: 20),
          ...skills.map((skill) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(skill.name, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Text('${skill.value.round()}%', style: TextStyle(color: skill.color, fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: skill.value / 100),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOut,
                  builder: (context, v, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: v,
                      minHeight: 8,
                      color: skill.color,
                      backgroundColor: AppColors.surfaceElevatedDark,
                    ),
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

class _DecisionsCard extends StatelessWidget {
  final List<dynamic> decisions;
  const _DecisionsCard({required this.decisions});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: FWSectionHeader(title: 'Recent Decisions', subtitle: 'Latest scenario interactions'),
          ),
          const Divider(height: 1, color: AppColors.borderDark),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(children: const [
              Expanded(flex: 3, child: Text('Scenario', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
              Expanded(child: Text('Action', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
              Expanded(child: Text('Result', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
              Expanded(child: Text('When', style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 11, fontWeight: FontWeight.w600))),
            ]),
          ),
          const Divider(height: 1, color: AppColors.borderDark),

          if (decisions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No decisions yet', style: TextStyle(color: AppColors.textTertiaryDark))),
            )
          else
            ...decisions.map((d) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(d.scenarioTitle as String, style: AppTypography.bodySmall(AppColors.textPrimaryDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        child: Text(d.action as String, style: AppTypography.bodySmall(AppColors.textSecondaryDark)),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              (d.isCorrect as bool) ? Icons.check_circle : Icons.cancel,
                              size: 14,
                              color: (d.isCorrect as bool) ? AppColors.success : AppColors.error,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              (d.isCorrect as bool) ? 'Correct' : 'Incorrect',
                              style: TextStyle(
                                color: (d.isCorrect as bool) ? AppColors.success : AppColors.error,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Text(d.timeAgo as String, style: AppTypography.labelSmall(AppColors.textTertiaryDark))),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.borderDark),
              ],
            )),
        ],
      ),
    );
  }
}

class _AssignmentsCard extends StatelessWidget {
  final List<dynamic> assignments;
  const _AssignmentsCard({required this.assignments});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FWSectionHeader(title: 'Assigned Challenges', subtitle: 'Active assignments for this student'),
          const SizedBox(height: 16),
          if (assignments.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, color: AppColors.textTertiaryDark, size: 20),
                  SizedBox(width: 10),
                  Text('No assignments yet', style: TextStyle(color: AppColors.textSecondaryDark)),
                ],
              ),
            )
          else
            ...assignments.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(a.challengeTitle as String, style: AppTypography.titleSmall(AppColors.textPrimaryDark))),
                        if (a.isCompleted as bool)
                          const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('${a.completedScenarios}/${a.totalScenarios} completed', style: AppTypography.bodySmall(AppColors.textSecondaryDark)),
                        const Spacer(),
                        if (a.dueDate != null)
                          Text(
                            'Due ${(a.dueDate as DateTime).day}/${(a.dueDate as DateTime).month}',
                            style: AppTypography.labelSmall(AppColors.textTertiaryDark),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: a.progress as double,
                        minHeight: 6,
                        color: (a.isCompleted as bool) ? AppColors.success : AppColors.primary500,
                        backgroundColor: AppColors.surfaceCardDark,
                      ),
                    ),
                  ],
                ),
              ),
            )),
        ],
      ),
    );
  }
}
