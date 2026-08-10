import 'package:equatable/equatable.dart';
import 'skill_model.dart';

class LessonModel extends Equatable {
  final String id;
  final String scenarioId;
  final Skill primarySkill;
  final String title;
  final String explanation;
  final List<String> tips;
  final String keyTakeaway;
  final int durationSeconds;

  const LessonModel({
    required this.id,
    required this.scenarioId,
    required this.primarySkill,
    required this.title,
    required this.explanation,
    required this.tips,
    required this.keyTakeaway,
    this.durationSeconds = 60,
  });

  @override
  List<Object?> get props => [id, scenarioId, primarySkill, title];
}

class AcademyModule extends Equatable {
  final String id;
  final String title;
  final String description;
  final Skill skill;
  final String emoji;
  final int lessonCount;
  final int completedCount;
  final bool isUnlocked;

  const AcademyModule({
    required this.id,
    required this.title,
    required this.description,
    required this.skill,
    required this.emoji,
    required this.lessonCount,
    this.completedCount = 0,
    this.isUnlocked = true,
  });

  double get progress => lessonCount > 0 ? completedCount / lessonCount : 0.0;

  @override
  List<Object?> get props => [id, title, skill];
}
