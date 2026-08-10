import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/theme.dart';
import '../../../data/models/skill_model.dart';
import '../../../logic/providers/feed/feed_provider.dart';
import '../../../shared/widgets/fw_card.dart';
import '../../../shared/widgets/fw_button.dart';

class LessonPage extends ConsumerWidget {
  final String scenarioId;
  const LessonPage({super.key, required this.scenarioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenarioAsync = ref.watch(scenarioByIdProvider(scenarioId));

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: scenarioAsync.when(
        data: (scenario) {
          if (scenario == null) return const Center(child: Text('Not found'));
          final lesson = scenario.lesson;
          return _LessonContent(
            lesson: lesson,
            onDone: () => context.go('/explore'),
            onContinueAcademy: () => context.go('/academy'),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary500)),
        error: (_, __) => const Center(child: Text('Error')),
      ),
    );
  }
}

class _LessonContent extends StatelessWidget {
  final dynamic lesson;
  final VoidCallback onDone;
  final VoidCallback onContinueAcademy;

  const _LessonContent({required this.lesson, required this.onDone, required this.onContinueAcademy});

  @override
  Widget build(BuildContext context) {
    final skill = lesson.primarySkill as Skill;
    final skillColor = _skillColor(skill);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Skill unlock header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [skillColor.withOpacity(0.8), skillColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Text(skill.emoji, style: const TextStyle(fontSize: 64))
                      .animate()
                      .scale(begin: const Offset(0.3, 0.3), duration: 700.ms, curve: Curves.elasticOut)
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .shimmer(duration: 1500.ms, delay: 800.ms),

                  const SizedBox(height: 12),

                  Text('SKILL UNLOCKED', style: AppTypography.labelLarge.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 2,
                  )).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 6),

                  Text(skill.displayName, style: AppTypography.displaySmall.copyWith(color: Colors.white))
                      .animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text('+10 ${skill.displayName} XP',
                        style: AppTypography.labelMedium.copyWith(color: Colors.white)),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lesson title
                  Text(lesson.title, style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryDark))
                      .animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 12),

                  // Explanation
                  Text(lesson.explanation,
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondaryDark, height: 1.6))
                      .animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: 20),

                  // Tips
                  Text('KEY TIPS', style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textTertiaryDark,
                    letterSpacing: 1.5,
                  )),

                  const SizedBox(height: 10),

                  ...lesson.tips.asMap().entries.map((entry) =>
                    _TipCard(tip: entry.value as String, index: entry.key, color: skillColor)
                        .animate()
                        .fadeIn(delay: (200 + entry.key * 80).ms, duration: 250.ms)
                        .slideX(begin: 0.05, end: 0),
                  ),

                  const SizedBox(height: 20),

                  // Key Takeaway
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: skillColor.withOpacity(0.1),
                      border: Border.all(color: skillColor.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('💡 KEY TAKEAWAY', style: AppTypography.labelMedium.copyWith(
                          color: skillColor,
                          letterSpacing: 1,
                        )),
                        const SizedBox(height: 8),
                        Text(lesson.keyTakeaway,
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark, height: 1.5)),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 28),

                  FWButton(
                    label: 'Continue →',
                    isFullWidth: true,
                    size: FWButtonSize.large,
                    onPressed: onDone,
                  ).animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: 10),

                  FWButton(
                    label: 'Explore Academy',
                    variant: FWButtonVariant.ghost,
                    isFullWidth: true,
                    icon: Icons.school_outlined,
                    onPressed: onContinueAcademy,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _skillColor(Skill skill) => switch (skill) {
        Skill.sourceVerification => AppColors.skillSource,
        Skill.evidenceEvaluation => AppColors.skillEvidence,
        Skill.aiLiteracy => AppColors.skillAI,
        Skill.biasDetection => AppColors.skillBias,
        Skill.digitalSafety => AppColors.skillSafety,
      };
}

class _TipCard extends StatelessWidget {
  final String tip;
  final int index;
  final Color color;
  const _TipCard({required this.tip, required this.index, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('${index + 1}',
                  style: AppTypography.labelSmall.copyWith(color: color, fontSize: 10)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(tip, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
