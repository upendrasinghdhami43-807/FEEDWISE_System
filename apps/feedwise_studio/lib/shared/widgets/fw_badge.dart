import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

// ─── Status Badge ─────────────────────────────────────────────────────────────

class FWBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? backgroundColor;
  final IconData? icon;
  final FWBadgeSize size;

  const FWBadge({
    super.key,
    required this.label,
    required this.color,
    this.backgroundColor,
    this.icon,
    this.size = FWBadgeSize.medium,
  });

  factory FWBadge.draft({FWBadgeSize size = FWBadgeSize.medium}) => FWBadge(
    label: 'Draft',
    color: AppColors.statusDraft,
    backgroundColor: AppColors.statusDraft.withValues(alpha: 0.12),
    icon: Icons.edit_outlined,
    size: size,
  );

  factory FWBadge.review({FWBadgeSize size = FWBadgeSize.medium}) => FWBadge(
    label: 'In Review',
    color: AppColors.statusReview,
    backgroundColor: AppColors.statusReview.withValues(alpha: 0.12),
    icon: Icons.rate_review_outlined,
    size: size,
  );

  factory FWBadge.published({FWBadgeSize size = FWBadgeSize.medium}) => FWBadge(
    label: 'Published',
    color: AppColors.statusPublished,
    backgroundColor: AppColors.statusPublished.withValues(alpha: 0.12),
    icon: Icons.check_circle_outline,
    size: size,
  );

  factory FWBadge.archived({FWBadgeSize size = FWBadgeSize.medium}) => FWBadge(
    label: 'Archived',
    color: AppColors.statusArchived,
    backgroundColor: AppColors.statusArchived.withValues(alpha: 0.12),
    icon: Icons.archive_outlined,
    size: size,
  );

  factory FWBadge.factChecked({FWBadgeSize size = FWBadgeSize.medium}) => FWBadge(
    label: 'Fact Checked',
    color: AppColors.info,
    backgroundColor: AppColors.info.withValues(alpha: 0.12),
    icon: Icons.fact_check_outlined,
    size: size,
  );

  factory FWBadge.milReviewed({FWBadgeSize size = FWBadgeSize.medium}) => FWBadge(
    label: 'MIL Reviewed',
    color: AppColors.primary400,
    backgroundColor: AppColors.primary500.withValues(alpha: 0.12),
    icon: Icons.school_outlined,
    size: size,
  );

  @override
  Widget build(BuildContext context) {
    final isSmall = size == FWBadgeSize.small;
    return Container(
      padding: isSmall
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 3)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 10 : 12, color: color),
            SizedBox(width: isSmall ? 4 : 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: isSmall ? 10 : 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

enum FWBadgeSize { small, medium }

// ─── Role Badge ───────────────────────────────────────────────────────────────

class FWRoleBadge extends StatelessWidget {
  final String role;

  const FWRoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (role.toLowerCase()) {
      'admin'     => (AppColors.secondary400, Icons.admin_panel_settings),
      'teacher'   => (AppColors.primary400, Icons.school),
      'moderator' => (AppColors.warning, Icons.security),
      _           => (AppColors.textSecondaryDark, Icons.person_outline),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            role[0].toUpperCase() + role.substring(1),
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ─── Difficulty Badge ─────────────────────────────────────────────────────────

class FWDifficultyBadge extends StatelessWidget {
  final int level; // 1-5
  final String? label;

  const FWDifficultyBadge({super.key, required this.level, this.label});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.evidenceSupported,
      AppColors.tertiary400,
      AppColors.warning,
      AppColors.secondary400,
      AppColors.evidenceMissing,
    ];
    final color = colors[(level - 1).clamp(0, 4)];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) => Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < level ? color : AppColors.borderDark,
          ),
        )),
        if (label != null) ...[
          const SizedBox(width: 6),
          Text(label!, style: AppTypography.labelSmall(AppColors.textSecondaryDark)),
        ],
      ],
    );
  }
}
