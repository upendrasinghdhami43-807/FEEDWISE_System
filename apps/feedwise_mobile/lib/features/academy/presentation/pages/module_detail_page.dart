import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/theme.dart';
import '../../../data/models/lesson_model.dart';
import '../../../shared/widgets/fw_card.dart';
import '../../../shared/widgets/fw_button.dart';

class ModuleDetailPage extends StatelessWidget {
  final String moduleId;
  const ModuleDetailPage({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text('Module', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FWCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🔎 Source Verification', style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimaryDark)),
                  const SizedBox(height: 8),
                  Text('Learn to evaluate where information comes from and how to verify sources before sharing.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.play_circle_outline, size: 16, color: AppColors.primary400),
                      const SizedBox(width: 4),
                      Text('8 lessons', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryDark)),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16, color: AppColors.textTertiaryDark),
                      const SizedBox(width: 4),
                      Text('~25 min', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('LESSONS', style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiaryDark, letterSpacing: 1.5)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => FWCard(
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: i < 3 ? AppColors.primary500.withOpacity(0.2) : AppColors.borderDark,
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: i < 3
                            ? const Icon(Icons.check, size: 14, color: AppColors.primary400)
                            : Text('${i + 1}', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryDark))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Lesson ${i + 1}: Source Basics', style: AppTypography.titleSmall.copyWith(
                          color: i < 3 ? AppColors.textSecondaryDark : AppColors.textPrimaryDark,
                        )),
                      ),
                      if (i < 3)
                        const Icon(Icons.check_circle, size: 16, color: AppColors.evidenceSupported),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
