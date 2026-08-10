import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../app/theme/theme.dart';
import '../../data/models/skill_model.dart';

class FWSkillRadar extends StatelessWidget {
  final SkillsModel skills;
  final double size;

  const FWSkillRadar({
    super.key,
    required this.skills,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    final skillColors = [
      AppColors.skillSource,
      AppColors.skillEvidence,
      AppColors.skillAI,
      AppColors.skillBias,
      AppColors.skillSafety,
    ];

    return SizedBox(
      width: size,
      height: size,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          dataSets: [
            RadarDataSet(
              dataEntries: [
                RadarEntry(value: skills.sourceVerification),
                RadarEntry(value: skills.evidenceEvaluation),
                RadarEntry(value: skills.aiLiteracy),
                RadarEntry(value: skills.biasDetection),
                RadarEntry(value: skills.digitalSafety),
              ],
              fillColor: AppColors.primary500.withOpacity(0.15),
              borderColor: AppColors.primary500,
              borderWidth: 2,
              entryRadius: 4,
            ),
          ],
          radarBorderData: const BorderSide(color: AppColors.borderDark, width: 1),
          gridBorderData: const BorderSide(color: AppColors.borderDark, width: 0.5),
          ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
          tickBorderData: const BorderSide(color: AppColors.borderDark, width: 0.5),
          tickCount: 5,
          getTitle: (index, angle) {
            final skill = Skill.values[index];
            return RadarChartTitle(
              text: skill.emoji,
              angle: angle,
            );
          },
          titleTextStyle: AppTypography.labelMedium,
          titlePositionPercentageOffset: 0.2,
        ),
      ),
    );
  }
}

class FWSkillBar extends StatelessWidget {
  final Skill skill;
  final double value;
  final bool showLabel;

  const FWSkillBar({
    super.key,
    required this.skill,
    required this.value,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(skill.emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(skill.displayName, style: AppTypography.bodySmall),
                ],
              ),
              Text('${value.toInt()}', style: AppTypography.labelSmall.copyWith(color: _skillColor)),
            ],
          ),
        if (showLabel) const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            value: (value / 100).clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: AppColors.borderDark,
            valueColor: AlwaysStoppedAnimation<Color>(_skillColor),
          ),
        ),
      ],
    );
  }

  Color get _skillColor => switch (skill) {
        Skill.sourceVerification => AppColors.skillSource,
        Skill.evidenceEvaluation => AppColors.skillEvidence,
        Skill.aiLiteracy => AppColors.skillAI,
        Skill.biasDetection => AppColors.skillBias,
        Skill.digitalSafety => AppColors.skillSafety,
      };
}
