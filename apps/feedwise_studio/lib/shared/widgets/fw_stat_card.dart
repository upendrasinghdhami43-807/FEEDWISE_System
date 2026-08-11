import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';

class FWStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? iconColor;
  final String? delta; // "+12%" or "-3%"
  final bool isPositive;
  final VoidCallback? onTap;

  const FWStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor,
    this.delta,
    this.isPositive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary400;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceCardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderDark, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon + delta row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const Spacer(),
                if (delta != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPositive
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          size: 12,
                          color: isPositive ? AppColors.success : AppColors.error,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          delta!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isPositive ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Value
            Text(
              value,
              style: AppTypography.displaySmall(AppColors.textPrimaryDark),
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              label,
              style: AppTypography.bodySmall(AppColors.textSecondaryDark),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mini Stat Card ───────────────────────────────────────────────────────────

class FWMiniStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const FWMiniStatCard({
    super.key,
    required this.value,
    required this.label,
    this.color = AppColors.primary400,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
