import 'package:equatable/equatable.dart';

enum Skill {
  sourceVerification('Source Verification', '🔎', 'source'),
  evidenceEvaluation('Evidence Evaluation', '📊', 'evidence'),
  aiLiteracy('AI Literacy', '🤖', 'ai'),
  biasDetection('Bias Detection', '⚖️', 'bias'),
  digitalSafety('Digital Safety', '🛡️', 'safety');

  final String displayName;
  final String emoji;
  final String key;
  const Skill(this.displayName, this.emoji, this.key);
}

class SkillsModel extends Equatable {
  final String userId;
  final double sourceVerification;
  final double evidenceEvaluation;
  final double aiLiteracy;
  final double biasDetection;
  final double digitalSafety;
  final DateTime updatedAt;

  const SkillsModel({
    required this.userId,
    this.sourceVerification = 0.0,
    this.evidenceEvaluation = 0.0,
    this.aiLiteracy = 0.0,
    this.biasDetection = 0.0,
    this.digitalSafety = 0.0,
    required this.updatedAt,
  });

  double getSkill(Skill skill) => switch (skill) {
        Skill.sourceVerification => sourceVerification,
        Skill.evidenceEvaluation => evidenceEvaluation,
        Skill.aiLiteracy => aiLiteracy,
        Skill.biasDetection => biasDetection,
        Skill.digitalSafety => digitalSafety,
      };

  double get overallScore =>
      (sourceVerification + evidenceEvaluation + aiLiteracy + biasDetection + digitalSafety) / 5;

  Skill get weakestSkill {
    final scores = {
      Skill.sourceVerification: sourceVerification,
      Skill.evidenceEvaluation: evidenceEvaluation,
      Skill.aiLiteracy: aiLiteracy,
      Skill.biasDetection: biasDetection,
      Skill.digitalSafety: digitalSafety,
    };
    return scores.entries.reduce((a, b) => a.value < b.value ? a : b).key;
  }

  Skill get strongestSkill {
    final scores = {
      Skill.sourceVerification: sourceVerification,
      Skill.evidenceEvaluation: evidenceEvaluation,
      Skill.aiLiteracy: aiLiteracy,
      Skill.biasDetection: biasDetection,
      Skill.digitalSafety: digitalSafety,
    };
    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Map<Skill, double> toMap() => {
        Skill.sourceVerification: sourceVerification,
        Skill.evidenceEvaluation: evidenceEvaluation,
        Skill.aiLiteracy: aiLiteracy,
        Skill.biasDetection: biasDetection,
        Skill.digitalSafety: digitalSafety,
      };

  factory SkillsModel.fromJson(Map<String, dynamic> json) => SkillsModel(
        userId: json['user_id'] as String,
        sourceVerification: (json['source_verification'] as num?)?.toDouble() ?? 0.0,
        evidenceEvaluation: (json['evidence_evaluation'] as num?)?.toDouble() ?? 0.0,
        aiLiteracy: (json['ai_literacy'] as num?)?.toDouble() ?? 0.0,
        biasDetection: (json['bias_detection'] as num?)?.toDouble() ?? 0.0,
        digitalSafety: (json['digital_safety'] as num?)?.toDouble() ?? 0.0,
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  SkillsModel copyWith({
    double? sourceVerification,
    double? evidenceEvaluation,
    double? aiLiteracy,
    double? biasDetection,
    double? digitalSafety,
  }) =>
      SkillsModel(
        userId: userId,
        sourceVerification: sourceVerification ?? this.sourceVerification,
        evidenceEvaluation: evidenceEvaluation ?? this.evidenceEvaluation,
        aiLiteracy: aiLiteracy ?? this.aiLiteracy,
        biasDetection: biasDetection ?? this.biasDetection,
        digitalSafety: digitalSafety ?? this.digitalSafety,
        updatedAt: DateTime.now(),
      );

  static SkillsModel demo() => SkillsModel(
        userId: 'demo',
        sourceVerification: 72,
        evidenceEvaluation: 58,
        aiLiteracy: 45,
        biasDetection: 63,
        digitalSafety: 80,
        updatedAt: DateTime.now(),
      );

  @override
  List<Object?> get props => [userId, sourceVerification, evidenceEvaluation, aiLiteracy, biasDetection, digitalSafety];
}
