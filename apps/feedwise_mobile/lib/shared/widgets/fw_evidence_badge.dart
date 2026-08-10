import 'package:flutter/material.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';
import 'package:feedwise_mobile/data/models/evidence_model.dart';

class FWEvidenceBadge extends StatelessWidget {
  final EvidenceStatus status;
  final String? label;
  final bool compact;

  const FWEvidenceBadge({
    super.key,
    required this.status,
    this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        border: Border.all(color: _color.withOpacity(0.4), width: 1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(status.emoji, style: TextStyle(fontSize: compact ? 10 : 12)),
          if (label != null || !compact) ...[
            const SizedBox(width: 4),
            Text(
              label ?? status.displayName,
              style: AppTypography.labelSmall.copyWith(color: _color, fontSize: compact ? 10 : 11),
            ),
          ],
        ],
      ),
    );
  }

  Color get _color => switch (status) {
        EvidenceStatus.supported => AppColors.evidenceSupported,
        EvidenceStatus.uncertain => AppColors.evidenceUncertain,
        EvidenceStatus.missing => AppColors.evidenceMissing,
        EvidenceStatus.neutral => AppColors.evidenceNeutral,
      };
}

class FWProgressBar extends StatelessWidget {
  final double value;
  final Color? color;
  final Color? trackColor;
  final double height;
  final bool showLabel;
  final String? label;
  final bool animate;

  const FWProgressBar({
    super.key,
    required this.value,
    this.color,
    this.trackColor,
    this.height = 6,
    this.showLabel = false,
    this.label,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = color ?? AppColors.primary500;
    final track = trackColor ?? (isDark ? AppColors.borderDark : AppColors.borderLight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && label != null) ...[
          Text(label!, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryDark)),
          const SizedBox(height: 4),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: height,
            backgroundColor: track,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 2),
          Text(
            '${(value * 100).toInt()}%',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiaryDark),
          ),
        ],
      ],
    );
  }
}

class FWBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;

  const FWBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary500;
    final fg = textColor ?? Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(label, style: AppTypography.labelSmall.copyWith(color: fg)),
    );
  }
}
