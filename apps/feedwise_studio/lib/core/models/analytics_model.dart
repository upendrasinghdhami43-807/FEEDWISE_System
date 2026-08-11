// ─── Analytics Models ─────────────────────────────────────────────────────────

class EngagementMetrics {
  final int activeUsers;
  final int scenariosCompleted;
  final double avgPerUser;
  final double completionRate;

  const EngagementMetrics({
    required this.activeUsers,
    required this.scenariosCompleted,
    required this.avgPerUser,
    required this.completionRate,
  });
}

class ChartDataPoint {
  final String label;
  final double value;
  final DateTime? date;

  const ChartDataPoint({
    required this.label,
    required this.value,
    this.date,
  });
}

class SkillTrendData {
  final String skillName;
  final List<ChartDataPoint> points;
  final double currentAvg;
  final double delta; // change from last period

  const SkillTrendData({
    required this.skillName,
    required this.points,
    required this.currentAvg,
    required this.delta,
  });
}

class ScenarioPerformanceData {
  final String scenarioId;
  final String title;
  final double correctPercent;
  final double avgTimeSeconds;
  final int completions;

  const ScenarioPerformanceData({
    required this.scenarioId,
    required this.title,
    required this.correctPercent,
    required this.avgTimeSeconds,
    required this.completions,
  });

  String get avgTimeFormatted {
    final mins = avgTimeSeconds ~/ 60;
    final secs = (avgTimeSeconds % 60).toInt();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }
}

class AnalyticsDashboard {
  final EngagementMetrics engagement;
  final List<SkillTrendData> skillTrends;
  final List<ScenarioPerformanceData> scenarioPerformance;
  final List<ChartDataPoint> weeklyEngagement;
  final String weakestSkillName;
  final String recommendation;

  const AnalyticsDashboard({
    required this.engagement,
    required this.skillTrends,
    required this.scenarioPerformance,
    required this.weeklyEngagement,
    required this.weakestSkillName,
    required this.recommendation,
  });
}

class ModerationItem {
  final String id;
  final String title;
  final String submitterName;
  final String submitterEmail;
  final String category;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime submittedAt;
  final String? reviewNote;

  const ModerationItem({
    required this.id,
    required this.title,
    required this.submitterName,
    required this.submitterEmail,
    required this.category,
    required this.status,
    required this.submittedAt,
    this.reviewNote,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(submittedAt);
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
