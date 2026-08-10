import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/shared/widgets/fw_card.dart';
import 'package:feedwise_mobile/shared/widgets/fw_button.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('Community', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coming soon banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1640), Color(0xFF242736)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.primary500.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text('🌍', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('Community Mode', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
                  const SizedBox(height: 8),
                  Text('Submit your own scenarios, review community content, and collaborate with learners worldwide.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark, height: 1.5),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text('Coming in Phase 6', style: AppTypography.labelMedium.copyWith(color: AppColors.primary400)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text('COMING FEATURES', style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiaryDark, letterSpacing: 1.5)),
            const SizedBox(height: 12),

            ...[
              ('📝', 'Submit Scenarios', 'Create and submit your own scenarios for review'),
              ('🔍', 'Review Queue', 'Help verify community-submitted content'),
              ('🤝', 'Responsible Corrections', 'Politely correct misinformation with sources'),
              ('🏆', 'Community Leaderboard', 'See top contributors in your region'),
            ].map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FWCard(
                child: Row(
                  children: [
                    Text(item.$1, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.$2, style: AppTypography.titleSmall.copyWith(color: AppColors.textPrimaryDark)),
                          Text(item.$3, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
