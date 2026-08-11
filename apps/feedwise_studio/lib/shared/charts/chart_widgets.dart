import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

// ─── Skill Bar Chart (Horizontal) ────────────────────────────────────────────

class SkillBarChart extends StatelessWidget {
  final List<({String name, double value, Color color})> skills;
  final double height;
  final bool showValues;

  const SkillBarChart({
    super.key,
    required this.skills,
    this.height = 200,
    this.showValues = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: skills.map((skill) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  skill.name,
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (showValues)
                  Text(
                    '${skill.value.round()}%',
                    style: TextStyle(
                      color: skill.color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: skill.value / 100),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  color: skill.color,
                  backgroundColor: AppColors.surfaceElevatedDark,
                ),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}

// ─── Engagement Line Chart ────────────────────────────────────────────────────

class EngagementLineChart extends StatelessWidget {
  final List<({String label, double value})> data;
  final Color? lineColor;
  final double height;

  const EngagementLineChart({
    super.key,
    required this.data,
    this.lineColor,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final color = lineColor ?? AppColors.primary500;
    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue / 4,
            getDrawingHorizontalLine: (value) => const FlLine(
              color: AppColors.borderDark,
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= data.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[idx].label,
                      style: const TextStyle(
                        color: AppColors.textTertiaryDark,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    value.round().toString(),
                    style: const TextStyle(
                      color: AppColors.textTertiaryDark,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
            topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (i) => FlSpot(i.toDouble(), data[i].value),
              ),
              isCurved: true,
              color: color,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                  radius: 4,
                  color: color,
                  strokeWidth: 2,
                  strokeColor: AppColors.surfaceCardDark,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.2),
                    color.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.surfaceElevatedDark,
              tooltipBorder: const BorderSide(color: AppColors.borderDark),
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) =>
                LineTooltipItem(
                  spot.y.round().toString(),
                  TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Multi-Line Skill Trend Chart ─────────────────────────────────────────────

class SkillTrendChart extends StatelessWidget {
  final List<({String name, List<double> values, Color color})> series;
  final List<String> labels;
  final double height;

  const SkillTrendChart({
    super.key,
    required this.series,
    required this.labels,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) => const FlLine(
                  color: AppColors.borderDark,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(labels[idx], style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 10)),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 36,
                    interval: 20,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toInt()}',
                      style: const TextStyle(color: AppColors.textTertiaryDark, fontSize: 10),
                    ),
                  ),
                ),
                topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minY: 0,
              maxY: 100,
              lineBarsData: series.map((s) => LineChartBarData(
                spots: List.generate(s.values.length, (i) => FlSpot(i.toDouble(), s.values[i])),
                isCurved: true,
                color: s.color,
                barWidth: 2,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              )).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: series.map((s) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 16, height: 3, decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 6),
              Text(s.name, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11)),
            ],
          )).toList(),
        ),
      ],
    );
  }
}
