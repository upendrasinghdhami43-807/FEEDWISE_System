import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/data/models/scenario_model.dart';
import 'package:feedwise_mobile/logic/providers/feed/feed_provider.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';

class ConsequencePage extends ConsumerWidget {
  final String scenarioId;
  final String decision;

  const ConsequencePage({
    super.key,
    required this.scenarioId,
    required this.decision,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenarioAsync = ref.watch(scenarioByIdProvider(scenarioId));

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: scenarioAsync.when(
        data: (scenario) {
          if (scenario == null) return const Center(child: Text('Not found'));
          final decision = Decision.values.firstWhere(
            (d) => d.name == this.decision,
            orElse: () => Decision.ignore,
          );
          final consequence = scenario.getConsequence(decision);
          final isCorrect = scenario.isCorrectDecision(decision);
          return _ConsequenceContent(
            scenario: scenario,
            consequence: consequence,
            decision: decision,
            isCorrect: isCorrect,
            onLearn: () => context.push('/explore/$scenarioId/lesson'),
            onNext: () => context.go('/explore'),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary500)),
        error: (_, __) => const Center(child: Text('Error')),
      ),
    );
  }
}

class _ConsequenceContent extends StatelessWidget {
  final ScenarioModel scenario;
  final dynamic consequence;
  final Decision decision;
  final bool isCorrect;
  final VoidCallback onLearn;
  final VoidCallback onNext;

  const _ConsequenceContent({
    required this.scenario,
    required this.consequence,
    required this.decision,
    required this.isCorrect,
    required this.onLearn,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = isCorrect ? AppColors.evidenceSupported : AppColors.evidenceMissing;
    final headerGradient = isCorrect
        ? const LinearGradient(colors: [Color(0xFF16A34A), Color(0xFF22C55E)], begin: Alignment.topLeft, end: Alignment.bottomRight)
        : const LinearGradient(colors: [Color(0xFFB91C1C), Color(0xFFEF4444)], begin: Alignment.topLeft, end: Alignment.bottomRight);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header result
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              decoration: BoxDecoration(gradient: headerGradient),
              child: Column(
                children: [
                  Text(isCorrect ? '✅' : '❌', style: const TextStyle(fontSize: 56))
                      .animate().scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 12),

                  Text(
                    isCorrect ? 'Good Call!' : 'What Happened?',
                    style: AppTypography.displaySmall.copyWith(color: Colors.white),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 8),

                  Text(
                    'You chose to ${decision.displayName.toLowerCase()}',
                    style: AppTypography.bodyLarge.copyWith(color: Colors.white.withOpacity(0.85)),
                  ).animate().fadeIn(delay: 300.ms),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Impact numbers
                  if (consequence.reach > 0) ...[
                    Text('IMPACT', style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textTertiaryDark,
                      letterSpacing: 1.5,
                    )),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _ImpactStat(label: 'Reached', value: consequence.formattedReach, color: AppColors.evidenceMissing)),
                        const SizedBox(width: 10),
                        Expanded(child: _ImpactStat(label: 'Shared On', value: '${consequence.furtherShares}', color: AppColors.secondary400)),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Credibility delta
                  FWCard(
                    child: Row(
                      children: [
                        Text('Credibility', style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimaryDark)),
                        const Spacer(),
                        Text(
                          consequence.credibilityDelta >= 0 ? '+${consequence.credibilityDelta}' : '${consequence.credibilityDelta}',
                          style: AppTypography.headlineSmall.copyWith(
                            color: consequence.credibilityDelta >= 0 ? AppColors.evidenceSupported : AppColors.evidenceMissing,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Explanation
                  FWCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('WHAT HAPPENED', style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textTertiaryDark,
                          letterSpacing: 1.5,
                        )),
                        const SizedBox(height: 8),
                        Text(consequence.explanation,
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark, height: 1.5)),
                      ],
                    ),
                  ),

                  // Missed clues
                  if (consequence.missedClues.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    FWCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('WHAT YOU MIGHT HAVE MISSED', style: AppTypography.labelMedium.copyWith(
                            color: AppColors.evidenceUncertain,
                            letterSpacing: 1.5,
                          )),
                          const SizedBox(height: 10),
                          ...consequence.missedClues.map((clue) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: AppColors.evidenceUncertain)),
                                Expanded(child: Text(clue, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark))),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // CTAs
                  FWButton(
                    label: '📚 Learn Why',
                    isFullWidth: true,
                    size: FWButtonSize.large,
                    onPressed: onLearn,
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 12),

                  FWButton(
                    label: 'Next Scenario →',
                    variant: FWButtonVariant.outline,
                    isFullWidth: true,
                    onPressed: onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ImpactStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Column(
        children: [
          Text(value, style: AppTypography.headlineMedium.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
        ],
      ),
    );
  }
}
