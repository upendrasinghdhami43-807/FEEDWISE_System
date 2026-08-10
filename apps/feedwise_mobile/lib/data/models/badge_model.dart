import 'package:equatable/equatable.dart';

enum BadgeCategory {
  investigation('Investigation'),
  decision('Decision'),
  streak('Streak'),
  skill('Skill'),
  special('Special');

  final String displayName;
  const BadgeCategory(this.displayName);
}

class BadgeModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final BadgeCategory category;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int xpReward;
  final String? requirement;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
    this.xpReward = 50,
    this.requirement,
  });

  @override
  List<Object?> get props => [id, title, category, isUnlocked];
}

class DecisionRecord extends Equatable {
  final String id;
  final String userId;
  final String scenarioId;
  final String decision;
  final bool wasCorrect;
  final int xpEarned;
  final int credibilityDelta;
  final DateTime decidedAt;

  const DecisionRecord({
    required this.id,
    required this.userId,
    required this.scenarioId,
    required this.decision,
    required this.wasCorrect,
    required this.xpEarned,
    required this.credibilityDelta,
    required this.decidedAt,
  });

  @override
  List<Object?> get props => [id, userId, scenarioId, decidedAt];
}
