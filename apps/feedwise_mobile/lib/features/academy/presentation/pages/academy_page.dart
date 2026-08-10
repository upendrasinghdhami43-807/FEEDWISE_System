import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/data/models/lesson_model.dart';
import 'package:feedwise_mobile/data/models/skill_model.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';
import 'package:feedwise_mobile/shared/widgets/fw_progress_bar.dart';

class AcademyPage extends StatelessWidget {
  const AcademyPage({super.key});

  static final _modules = [
    AcademyModule(
      id: 'mod-source',
      title: 'Source Verification',
      description: 'Learn to evaluate where information comes from.',
      skill: Skill.sourceVerification,
      emoji: '🔎',
      lessonCount: 8,
      completedCount: 3,
    ),
    AcademyModule(
      id: 'mod-evidence',
      title: 'Evidence Evaluation',
      description: 'How to analyze claims and supporting evidence.',
      skill: Skill.evidenceEvaluation,
      emoji: '📊',
      lessonCount: 6,
      completedCount: 1,
    ),
    AcademyModule(
      id: 'mod-ai',
      title: 'AI & Digital Literacy',
      description: 'Understand AI-generated content and deepfakes.',
      skill: Skill.aiLiteracy,
      emoji: '🤖',
      lessonCount: 7,
      completedCount: 0,
      isUnlocked: true,
    ),
    AcademyModule(
      id: 'mod-bias',
      title: 'Bias Detection',
      description: 'Recognize bias, framing, and manipulative language.',
      skill: Skill.biasDetection,
      emoji: '⚖️',
      lessonCount: 5,
      completedCount: 0,
    ),
    AcademyModule(
      id: 'mod-safety',
      title: 'Digital Safety',
      description: 'Protect yourself from scams, phishing, and online threats.',
      skill: Skill.digitalSafety,
      emoji: '🛡️',
      lessonCount: 6,
      completedCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('MIL Academy', style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryDark)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall progress
            _OverallProgressCard().animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 20),

            Text('MODULES', style: AppTypography.labelMedium.copyWith(
              color: AppColors.textTertiaryDark,
              letterSpacing: 1.5,
            )),
            const SizedBox(height: 10),

            ..._modules.asMap().entries.map((e) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ModuleCard(module: e.value)
                    .animate()
                    .fadeIn(delay: (50 * e.key).ms, duration: 250.ms)
                    .slideX(begin: 0.05, end: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FWGradientCard(
      gradient: AppColors.heroGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Academy Progress', style: AppTypography.titleLarge.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text('4 of 32 lessons completed', style: AppTypography.bodySmall.copyWith(color: Colors.white.withOpacity(0.7))),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: 4 / 32,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text('12.5% complete', style: AppTypography.bodySmall.copyWith(color: Colors.white.withOpacity(0.7))),
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final AcademyModule module;
  const _ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    final skillColor = _skillColor(module.skill);

    return FWCard(
      onTap: () => context.push('/academy/${module.id}'),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: skillColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Text(module.emoji, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(module.title, style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryDark)),
                const SizedBox(height: 2),
                Text(module.description,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: LinearProgressIndicator(
                          value: module.progress,
                          minHeight: 4,
                          backgroundColor: AppColors.borderDark,
                          valueColor: AlwaysStoppedAnimation<Color>(skillColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${module.completedCount}/${module.lessonCount}',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryDark)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiaryDark),
        ],
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
