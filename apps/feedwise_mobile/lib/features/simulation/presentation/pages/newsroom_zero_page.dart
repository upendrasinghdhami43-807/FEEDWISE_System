import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/data/models/scenario_model.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';
import 'package:feedwise_mobile/shared/widgets/fw_decision_button.dart';

class NewsroomZeroPage extends StatefulWidget {
  const NewsroomZeroPage({super.key});

  @override
  State<NewsroomZeroPage> createState() => _NewsroomZeroPageState();
}

class _NewsroomZeroPageState extends State<NewsroomZeroPage> {
  int _stage = 0; // 0=briefing, 1=review, 2=decide, 3=result
  Decision? _selected;

  static const _story = (
    title: 'BREAKING: Viral video claims "Mayor resigns amid corruption scandal"',
    source: 'Anonymous tip via social media',
    body: 'A video circulating on social media purports to show the Mayor of the city admitting to corruption. The video has 500K views. Three other sources have shared it. We have 10 minutes to decide whether to publish.',
    indicators: [
      '⚠️ Source: Anonymous — unverified',
      '🔴 Video has no timestamps or metadata',
      '⚠️ Mayor\'s office has not responded yet',
      '🔴 No secondary source confirmation',
      '✅ Video quality appears unedited',
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1117),
        title: Row(children: [
          const Text('📰', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text('NEWSROOM ZERO', style: AppTypography.brandWordmark.copyWith(fontSize: 14, color: AppColors.textPrimaryDark)),
        ]),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
      ),
      body: _buildStage(),
    );
  }

  Widget _buildStage() {
    return switch (_stage) {
      0 => _BriefingStage(story: _story, onStart: () => setState(() => _stage = 1)),
      1 => _ReviewStage(story: _story, onDecide: () => setState(() => _stage = 2)),
      2 => _DecideStage(
          selected: _selected,
          onSelect: (d) => setState(() => _selected = d),
          onPublish: () => setState(() => _stage = 3),
        ),
      _ => _ResultStage(decision: _selected ?? Decision.ignore, onDone: () => context.pop()),
    };
  }
}

class _BriefingStage extends StatelessWidget {
  final dynamic story;
  final VoidCallback onStart;
  const _BriefingStage({required this.story, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: AppColors.secondary500.withOpacity(0.2), borderRadius: BorderRadius.circular(AppRadius.full)),
            child: Text('⏱️ BREAKING NEWS — 10 MINUTES TO DECIDE', style: AppTypography.labelSmall.copyWith(color: AppColors.secondary400)),
          ),
          const SizedBox(height: 16),
          Text('You\'re the Editor', style: AppTypography.displaySmall.copyWith(color: AppColors.textPrimaryDark)),
          const SizedBox(height: 8),
          Text('A story just hit your desk. Read it carefully before deciding whether to publish, verify, hold, or reject.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark, height: 1.5)),
          const SizedBox(height: 20),
          FWCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('INCOMING STORY', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryDark, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Text(story.title, style: AppTypography.titleLarge.copyWith(color: AppColors.textPrimaryDark)),
                const SizedBox(height: 4),
                Text('Source: ${story.source}', style: AppTypography.bodySmall.copyWith(color: AppColors.evidenceUncertain)),
              ],
            ),
          ),
          const Spacer(),
          FWButton(label: 'Read Full Story →', isFullWidth: true, size: FWButtonSize.large, onPressed: onStart),
        ],
      ),
    );
  }
}

class _ReviewStage extends StatelessWidget {
  final dynamic story;
  final VoidCallback onDecide;
  const _ReviewStage({required this.story, required this.onDecide});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(story.title, style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
          const SizedBox(height: 12),
          Text(story.body, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark, height: 1.6)),
          const SizedBox(height: 20),
          Text('SOURCE INDICATORS', style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiaryDark, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          ...story.indicators.map<Widget>((indicator) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(indicator, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
          )),
          const SizedBox(height: 24),
          FWButton(label: 'Make Editorial Decision →', isFullWidth: true, size: FWButtonSize.large, onPressed: onDecide),
        ],
      ),
    );
  }
}

class _DecideStage extends StatelessWidget {
  final Decision? selected;
  final ValueChanged<Decision> onSelect;
  final VoidCallback onPublish;
  const _DecideStage({required this.selected, required this.onSelect, required this.onPublish});

  @override
  Widget build(BuildContext context) {
    final options = [
      (Decision.share, 'PUBLISH NOW', 'Push to homepage immediately'),
      (Decision.verify, 'SEND TO VERIFY', 'Route to fact-check desk first'),
      (Decision.ignore, 'HOLD STORY', 'Wait for more information'),
      (Decision.report, 'REJECT', 'Do not publish at all'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Editorial Decision', style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryDark)),
          const SizedBox(height: 6),
          Text('As editor, what do you do with this story?',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
          const SizedBox(height: 20),
          ...options.map((o) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => onSelect(o.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: selected == o.$1 ? AppColors.primary500.withOpacity(0.1) : AppColors.surfaceCardDark,
                  border: Border.all(color: selected == o.$1 ? AppColors.primary500 : AppColors.borderDark, width: selected == o.$1 ? 2 : 1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o.$2, style: AppTypography.titleMedium.copyWith(
                            color: selected == o.$1 ? AppColors.primary400 : AppColors.textPrimaryDark,
                          )),
                          Text(o.$3, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                        ],
                      ),
                    ),
                    if (selected == o.$1) const Icon(Icons.check_circle, color: AppColors.primary500, size: 20),
                  ],
                ),
              ),
            ),
          )),
          const SizedBox(height: 16),
          if (selected != null)
            FWButton(label: 'Confirm Decision →', isFullWidth: true, size: FWButtonSize.large, onPressed: onPublish),
        ],
      ),
    );
  }
}

class _ResultStage extends StatelessWidget {
  final Decision decision;
  final VoidCallback onDone;
  const _ResultStage({required this.decision, required this.onDone});

  @override
  Widget build(BuildContext context) {
    final isCorrect = decision == Decision.verify || decision == Decision.ignore;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isCorrect ? '✅' : '❌', style: const TextStyle(fontSize: 64))
              .animate().scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          Text(isCorrect ? 'Good Editorial Judgment!' : 'The Story Was Unverified',
              style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimaryDark), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            isCorrect
                ? 'You correctly chose to verify or hold the story. The video turned out to be AI-generated. By not publishing immediately, you protected your newsroom\'s credibility.'
                : 'The video was later confirmed to be AI-generated. Publishing unverified content damages newsroom credibility and spreads misinformation.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FWButton(label: 'Back to Play', isFullWidth: true, onPressed: onDone),
        ],
      ),
    );
  }
}
