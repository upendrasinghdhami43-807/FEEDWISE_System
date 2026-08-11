import 'package:flutter/material.dart';

enum UserRole { student, teacher, admin, moderator }

enum AgeGroup { age16to18, age19to21, age22to24, age25plus }

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final AgeGroup? ageGroup;
  final String locale;
  final String? avatarUrl;
  final int xp;
  final int level;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastActiveDate;
  final bool baselineCompleted;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.role = UserRole.student,
    this.ageGroup,
    this.locale = 'en',
    this.avatarUrl,
    this.xp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastActiveDate,
    this.baselineCompleted = false,
    required this.createdAt,
  });

  String get levelTitle => switch (level) {
    1 => 'Newcomer',
    2 => 'Observer',
    3 => 'Reader',
    4 => 'Investigator',
    5 => 'Analyst',
    6 => 'Fact Checker',
    7 => 'Critical Thinker',
    8 => 'MIL Expert',
    9 => 'Information Guardian',
    10 => 'MIL Champion',
    _ => 'Unknown',
  };

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color get avatarColor {
    final colors = [
      const Color(0xFF6C5CE7),
      const Color(0xFFFF6B6B),
      const Color(0xFF2DD4BF),
      const Color(0xFFF59E0B),
      const Color(0xFF3B82F6),
      const Color(0xFF22C55E),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }

  UserModel copyWith({
    String? name,
    String? avatarUrl,
    int? xp,
    int? level,
    int? currentStreak,
    UserRole? role,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      role: role ?? this.role,
      ageGroup: ageGroup,
      locale: locale,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak,
      lastActiveDate: lastActiveDate,
      baselineCompleted: baselineCompleted,
      createdAt: createdAt,
    );
  }
}

// ─── Skills Model ─────────────────────────────────────────────────────────────

enum Skill {
  sourceVerification('Source Verification', '🔎', Color(0xFF6C5CE7)),
  evidenceEvaluation('Evidence Evaluation', '📊', Color(0xFF3B82F6)),
  aiLiteracy('AI Literacy', '🤖', Color(0xFF2DD4BF)),
  biasDetection('Bias Detection', '⚖️', Color(0xFFF59E0B)),
  digitalSafety('Digital Safety', '🛡️', Color(0xFF22C55E));

  final String displayName;
  final String emoji;
  final Color color;
  const Skill(this.displayName, this.emoji, this.color);
}

class SkillsModel {
  final String userId;
  final double sourceVerification;
  final double evidenceEvaluation;
  final double aiLiteracy;
  final double biasDetection;
  final double digitalSafety;
  final DateTime updatedAt;

  const SkillsModel({
    required this.userId,
    this.sourceVerification = 50.0,
    this.evidenceEvaluation = 50.0,
    this.aiLiteracy = 50.0,
    this.biasDetection = 50.0,
    this.digitalSafety = 50.0,
    required this.updatedAt,
  });

  double get overallScore =>
    (sourceVerification + evidenceEvaluation + aiLiteracy + biasDetection + digitalSafety) / 5;

  double getSkill(Skill skill) => switch (skill) {
    Skill.sourceVerification => sourceVerification,
    Skill.evidenceEvaluation => evidenceEvaluation,
    Skill.aiLiteracy         => aiLiteracy,
    Skill.biasDetection      => biasDetection,
    Skill.digitalSafety      => digitalSafety,
  };

  Skill get weakestSkill {
    final scores = {
      Skill.sourceVerification: sourceVerification,
      Skill.evidenceEvaluation: evidenceEvaluation,
      Skill.aiLiteracy:         aiLiteracy,
      Skill.biasDetection:      biasDetection,
      Skill.digitalSafety:      digitalSafety,
    };
    return scores.entries.reduce((a, b) => a.value < b.value ? a : b).key;
  }

  List<double> toList() => [
    sourceVerification,
    evidenceEvaluation,
    aiLiteracy,
    biasDetection,
    digitalSafety,
  ];
}
