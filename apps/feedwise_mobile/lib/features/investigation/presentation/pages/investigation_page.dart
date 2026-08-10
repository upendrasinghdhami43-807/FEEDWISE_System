import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/data/models/evidence_model.dart';
import 'package:feedwise_mobile/data/models/scenario_model.dart';
import 'package:feedwise_mobile/logic/providers/investigation/investigation_provider.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';
import 'package:feedwise_mobile/shared/widgets/fw_evidence_badge.dart';

class InvestigationPage extends ConsumerWidget {
  final String scenarioId;
  const InvestigationPage({super.key, required this.scenarioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(investigationProvider(scenarioId));

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.surfaceDark,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary500)),
      );
    }

    final scenario = state.scenario;
    if (scenario == null) {
      return Scaffold(
        backgroundColor: AppColors.surfaceDark,
        body: Center(child: Text('Scenario not found', style: AppTypography.bodyLarge)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text('TrustLens™', style: AppTypography.labelMedium.copyWith(color: Colors.white)),
            ),
          ],
        ),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post summary
            _PostSummaryCard(scenario: scenario).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 16),

            // Evidence overall status
            _OverallStatusBanner(evidenceSet: scenario.evidence).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 16),

            // Evidence panels
            Text('EVIDENCE REVIEW', style: AppTypography.labelMedium.copyWith(
              color: AppColors.textTertiaryDark,
              letterSpacing: 1.5,
            )),
            const SizedBox(height: 8),

            ...scenario.evidence.byCategory.asMap().entries.map((entry) =>
              _EvidenceItemCard(item: entry.value)
                .animate()
                .fadeIn(delay: (150 + entry.key * 60).ms, duration: 250.ms)
                .slideX(begin: 0.05, end: 0),
            ),

            const SizedBox(height: 20),

            // AI Insight (non-authoritative)
            _AIInsightCard(scenario: scenario).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 24),

            // CTA
            FWButton(
              label: 'Make Your Decision →',
              isFullWidth: true,
              size: FWButtonSize.large,
              onPressed: () => context.push('/explore/$scenarioId/decide'),
            ).animate().fadeIn(delay: 400.ms),
          ],
        ),
      ),
    );
  }
}

class _PostSummaryCard extends StatelessWidget {
  final ScenarioModel scenario;
  const _PostSummaryCard({required this.scenario});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Text(scenario.category.emoji + ' ' + scenario.category.displayName,
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondaryDark)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _difficultyColor(scenario.difficulty).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(scenario.difficulty.displayName,
                    style: AppTypography.labelSmall.copyWith(color: _difficultyColor(scenario.difficulty))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(scenario.content.headline,
              style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimaryDark, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('via ', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
              Text(scenario.content.sourceName,
                  style: AppTypography.titleSmall.copyWith(color: AppColors.textSecondaryDark)),
              const Spacer(),
              Text(scenario.content.timeAgo,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
            ],
          ),
        ],
      ),
    );
  }

  Color _difficultyColor(DifficultyLevel d) => switch (d) {
        DifficultyLevel.beginner => AppColors.evidenceSupported,
        DifficultyLevel.easy => AppColors.tertiary400,
        DifficultyLevel.intermediate => AppColors.evidenceUncertain,
        DifficultyLevel.advanced => AppColors.secondary400,
        DifficultyLevel.expert => AppColors.evidenceMissing,
      };
}

class _OverallStatusBanner extends StatelessWidget {
  final EvidenceSet evidenceSet;
  const _OverallStatusBanner({required this.evidenceSet});

  @override
  Widget build(BuildContext context) {
    final status = evidenceSet.overallStatus;
    final color = switch (status) {
      EvidenceStatus.supported => AppColors.evidenceSupported,
      EvidenceStatus.uncertain => AppColors.evidenceUncertain,
      EvidenceStatus.missing => AppColors.evidenceMissing,
      EvidenceStatus.neutral => AppColors.evidenceNeutral,
    };

    final message = switch (status) {
      EvidenceStatus.supported => 'Evidence appears solid. Multiple indicators check out.',
      EvidenceStatus.uncertain => '⚠️ NEEDS VERIFICATION — Several indicators are missing or unclear.',
      EvidenceStatus.missing => '🔴 SIGNIFICANT GAPS — Key evidence markers are missing.',
      EvidenceStatus.neutral => 'Assessment is inconclusive.',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: AppTypography.bodyMedium.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}

class _EvidenceItemCard extends StatefulWidget {
  final EvidenceItem item;
  const _EvidenceItemCard({required this.item});

  @override
  State<_EvidenceItemCard> createState() => _EvidenceItemCardState();
}

class _EvidenceItemCardState extends State<_EvidenceItemCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: FWCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FWEvidenceBadge(status: item.status, compact: true),
                  const SizedBox(width: 8),
                  Text(item.category.displayName,
                      style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryDark)),
                  const Spacer(),
                  Text(item.label, style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
                  const SizedBox(width: 4),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more, size: 16, color: AppColors.textTertiaryDark),
                ],
              ),
              const SizedBox(height: 6),
              Text(item.value,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
              if (_expanded) ...[
                const SizedBox(height: 8),
                const Divider(color: AppColors.borderDark, height: 1),
                const SizedBox(height: 8),
                Text(item.explanation,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark, height: 1.5)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AIInsightCard extends StatelessWidget {
  final ScenarioModel scenario;
  const _AIInsightCard({required this.scenario});

  @override
  Widget build(BuildContext context) {
    return FWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.skillAI.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text('🤖 AI ASSISTANT', style: AppTypography.labelSmall.copyWith(color: AppColors.skillAI)),
              ),
              const SizedBox(width: 6),
              Text('(Non-authoritative)', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '"Based on the evidence markers, this content has several indicators associated with unverified claims: missing primary source, unnamed author, and emotional framing language. Make your own judgment using the evidence above."',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryDark,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
