import 'package:flutter/material.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/data/models/scenario_model.dart';

class FWDecisionButton extends StatelessWidget {
  final Decision decision;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isDisabled;

  const FWDecisionButton({
    super.key,
    required this.decision,
    required this.onTap,
    this.isSelected = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _decisionColor;
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : AppColors.surfaceCardDark,
            border: Border.all(
              color: isSelected ? color : AppColors.borderDark,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Center(
                  child: Text(decision.emoji, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      decision.displayName,
                      style: AppTypography.titleMedium.copyWith(
                        color: isSelected ? color : AppColors.textPrimaryDark,
                      ),
                    ),
                    Text(
                      _decisionDescription,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiaryDark),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Color get _decisionColor => switch (decision) {
        Decision.share => AppColors.decisionShare,
        Decision.verify => AppColors.decisionVerify,
        Decision.report => AppColors.decisionReport,
        Decision.ignore => AppColors.decisionIgnore,
      };

  String get _decisionDescription => switch (decision) {
        Decision.share => 'Share this content with your network',
        Decision.verify => 'Flag for verification before sharing',
        Decision.report => 'Report as harmful or false content',
        Decision.ignore => 'Scroll past without engaging',
      };
}
