import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/theme.dart';
import '../../../data/models/scenario_model.dart';
import '../../../logic/providers/investigation/investigation_provider.dart';
import '../../../logic/providers/feed/feed_provider.dart';
import '../../../shared/widgets/fw_card.dart';
import '../../../shared/widgets/fw_button.dart';
import '../../../shared/widgets/fw_decision_button.dart';

class DecisionPage extends ConsumerStatefulWidget {
  final String scenarioId;
  const DecisionPage({super.key, required this.scenarioId});

  @override
  ConsumerState<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends ConsumerState<DecisionPage> {
  Decision? _selected;

  @override
  Widget build(BuildContext context) {
    final scenarioAsync = ref.watch(scenarioByIdProvider(widget.scenarioId));

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('Your Decision', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: scenarioAsync.when(
        data: (scenario) => scenario == null
            ? const Center(child: Text('Not found'))
            : _DecisionContent(
                scenario: scenario,
                selected: _selected,
                onSelect: (d) => setState(() => _selected = d),
                onConfirm: () => context.push(
                    '/explore/${widget.scenarioId}/consequence?decision=${_selected!.name}'),
              ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary500)),
        error: (_, __) => const Center(child: Text('Error loading scenario')),
      ),
    );
  }
}

class _DecisionContent extends StatelessWidget {
  final ScenarioModel scenario;
  final Decision? selected;
  final ValueChanged<Decision> onSelect;
  final VoidCallback onConfirm;

  const _DecisionContent({
    required this.scenario,
    required this.selected,
    required this.onSelect,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Claim
          FWCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('THE CLAIM', style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textTertiaryDark,
                  letterSpacing: 1.5,
                )),
                const SizedBox(height: 8),
                Text(
                  scenario.content.headline,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text('via ${scenario.content.sourceName}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          Text('WHAT DO YOU DO?', style: AppTypography.labelMedium.copyWith(
            color: AppColors.textTertiaryDark,
            letterSpacing: 1.5,
          )).animate().fadeIn(delay: 50.ms),

          const SizedBox(height: 12),

          ...Decision.values.asMap().entries.map((entry) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FWDecisionButton(
                decision: entry.value,
                isSelected: selected == entry.value,
                onTap: () => onSelect(entry.value),
              ),
            ).animate().fadeIn(delay: (100 + entry.key * 60).ms, duration: 250.ms)
              .slideX(begin: 0.05, end: 0),
          ),

          const SizedBox(height: 20),

          if (selected != null)
            FWButton(
              label: 'Confirm — ${selected!.displayName}',
              isFullWidth: true,
              size: FWButtonSize.large,
              onPressed: onConfirm,
            ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.95, 0.95)),

          if (selected == null)
            Center(
              child: Text(
                'Select an action above to continue',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiaryDark),
              ),
            ),
        ],
      ),
    );
  }
}
