import 'user_model.dart';

// ─── Class Model ─────────────────────────────────────────────────────────────

class ClassModel {
  final String id;
  final String name;
  final String teacherId;
  final int gradeLevel;
  final List<String> studentIds;
  final DateTime createdAt;

  const ClassModel({
    required this.id,
    required this.name,
    required this.teacherId,
    required this.gradeLevel,
    this.studentIds = const [],
    required this.createdAt,
  });

  int get studentCount => studentIds.length;
}

// ─── Student Model ─────────────────────────────────────────────────────────────

class StudentModel {
  final String id;
  final String name;
  final String email;
  final String classId;
  final String className;
  final int gradeLevel;
  final int milLevel;
  final int xp;
  final double averageScore; // 0-100
  final int completedChallenges;
  final int badgeCount;
  final int streak;
  final DateTime? lastActive;
  final DateTime joinedAt;
  final SkillsModel skills;
  final List<DecisionRecord> recentDecisions;
  final List<AssignmentRecord> assignments;

  const StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.classId,
    required this.className,
    required this.gradeLevel,
    this.milLevel = 1,
    this.xp = 0,
    this.averageScore = 0,
    this.completedChallenges = 0,
    this.badgeCount = 0,
    this.streak = 0,
    this.lastActive,
    required this.joinedAt,
    required this.skills,
    this.recentDecisions = const [],
    this.assignments = const [],
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get statusLabel {
    if (averageScore >= 80) return 'High Performer';
    if (averageScore < 50)  return 'Needs Support';
    return 'On Track';
  }
}

// ─── Decision Record ──────────────────────────────────────────────────────────

class DecisionRecord {
  final String scenarioId;
  final String scenarioTitle;
  final String action; // Share, Verify, Report, Ignore
  final bool isCorrect;
  final DateTime timestamp;

  const DecisionRecord({
    required this.scenarioId,
    required this.scenarioTitle,
    required this.action,
    required this.isCorrect,
    required this.timestamp,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)  return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ─── Assignment Record ────────────────────────────────────────────────────────

class AssignmentRecord {
  final String id;
  final String challengeId;
  final String challengeTitle;
  final String classId;
  final DateTime? dueDate;
  final int totalScenarios;
  final int completedScenarios;

  const AssignmentRecord({
    required this.id,
    required this.challengeId,
    required this.challengeTitle,
    required this.classId,
    this.dueDate,
    required this.totalScenarios,
    this.completedScenarios = 0,
  });

  double get progress => totalScenarios > 0 ? completedScenarios / totalScenarios : 0;
  bool get isCompleted => completedScenarios >= totalScenarios;
}

// ─── Class Stats ──────────────────────────────────────────────────────────────

class ClassStats {
  final int studentCount;
  final int completedChallenges;
  final double averageScore;
  final SkillsModel averageSkills;
  final List<ActivityItem> recentActivity;

  const ClassStats({
    required this.studentCount,
    required this.completedChallenges,
    required this.averageScore,
    required this.averageSkills,
    this.recentActivity = const [],
  });
}

// ─── Activity Item ────────────────────────────────────────────────────────────

class ActivityItem {
  final String studentName;
  final String action;
  final String scenarioTitle;
  final DateTime timestamp;
  final bool isPositive;

  const ActivityItem({
    required this.studentName,
    required this.action,
    required this.scenarioTitle,
    required this.timestamp,
    this.isPositive = true,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)  return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
