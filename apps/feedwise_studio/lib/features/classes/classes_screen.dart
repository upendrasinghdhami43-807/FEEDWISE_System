import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../core/providers/teacher_provider.dart';
import '../../shared/layouts/admin_layout.dart';
import '../../shared/widgets/fw_card.dart';
import '../../shared/widgets/fw_button.dart';

class ClassesScreen extends ConsumerWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ref.watch(teacherClassesProvider);

    return AdminLayout(
      title: 'Classes',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${classes.length} Classes',
              style: AppTypography.headlineSmall(AppColors.textPrimaryDark),
            ),
            const SizedBox(height: 16),
            ...classes.map((cls) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FWCard(
                hoverable: true,
                onTap: () {
                  ref.read(selectedClassIdProvider.notifier).state = cls.id;
                  context.go('/teacher');
                },
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.heroGradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${cls.gradeLevel}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cls.name, style: AppTypography.headlineSmall(AppColors.textPrimaryDark)),
                          const SizedBox(height: 4),
                          Text(
                            '${cls.studentCount} students · Grade ${cls.gradeLevel}',
                            style: AppTypography.bodySmall(AppColors.textSecondaryDark),
                          ),
                        ],
                      ),
                    ),
                    FWButton(
                      label: 'View Class',
                      icon: Icons.arrow_forward,
                      variant: FWButtonVariant.secondary,
                      onPressed: () {
                        ref.read(selectedClassIdProvider.notifier).state = cls.id;
                        context.go('/teacher');
                      },
                      size: FWButtonSize.small,
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
