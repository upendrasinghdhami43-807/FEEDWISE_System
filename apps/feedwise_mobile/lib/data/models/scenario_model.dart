import 'package:equatable/equatable.dart';
import 'skill_model.dart';
import 'evidence_model.dart';
import 'consequence_model.dart';
import 'lesson_model.dart';

enum ScenarioCategory {
  aiGeneratedContent('AI Content', '🤖'),
  deepfake('Deepfakes', '🎭'),
  clickbait('Clickbait', '🎣'),
  misleadingContext('Misleading Context', '🖼️'),
  politicalMisinfo('Political', '🏛️'),
  healthMisinfo('Health', '💊'),
  financialScam('Financial Scam', '💰'),
  statManipulation('Statistics', '📊'),
  satire('Satire', '😄'),
  localNews('Local News', '📰');

  final String displayName;
  final String emoji;
  const ScenarioCategory(this.displayName, this.emoji);
}

enum DifficultyLevel {
  beginner('Beginner', 1),
  easy('Easy', 2),
  intermediate('Intermediate', 3),
  advanced('Advanced', 4),
  expert('Expert', 5);

  final String displayName;
  final int value;
  const DifficultyLevel(this.displayName, this.value);
}

enum Decision {
  share('Share', '📤'),
  verify('Verify', '🔍'),
  report('Report', '🚩'),
  ignore('Ignore', '👁️');

  final String displayName;
  final String emoji;
  const Decision(this.displayName, this.emoji);
}

enum ContentType {
  socialPost,
  newsArticle,
  image,
  video,
  tweet,
  meme,
}

class ContentItemModel extends Equatable {
  final String id;
  final String scenarioId;
  final String headline;
  final String? body;
  final String sourceName;
  final String? authorName;
  final String? imageUrl;
  final ContentType contentType;
  final DateTime publishDate;
  final int likes;
  final int comments;
  final int shares;
  final bool isTrending;
  final List<String> tags;

  const ContentItemModel({
    required this.id,
    required this.scenarioId,
    required this.headline,
    this.body,
    required this.sourceName,
    this.authorName,
    this.imageUrl,
    this.contentType = ContentType.socialPost,
    required this.publishDate,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isTrending = false,
    this.tags = const [],
  });

  String get timeAgo {
    final diff = DateTime.now().difference(publishDate);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  String get formattedLikes => _formatCount(likes);
  String get formattedShares => _formatCount(shares);
  String get formattedComments => _formatCount(comments);

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  @override
  List<Object?> get props => [id, scenarioId, headline, sourceName];
}

class ScenarioModel extends Equatable {
  final String id;
  final String title;
  final String? description;
  final ScenarioCategory category;
  final DifficultyLevel difficulty;
  final List<String> languages;
  final Decision expectedAction;
  final String correctReasoning;
  final String? learningObjective;
  final List<Skill> targetSkills;
  final ContentItemModel content;
  final EvidenceSet evidence;
  final Map<Decision, ConsequenceModel> consequences;
  final LessonModel lesson;
  final DateTime createdAt;

  const ScenarioModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.difficulty,
    this.languages = const ['en'],
    required this.expectedAction,
    required this.correctReasoning,
    this.learningObjective,
    required this.targetSkills,
    required this.content,
    required this.evidence,
    required this.consequences,
    required this.lesson,
    required this.createdAt,
  });

  ConsequenceModel getConsequence(Decision decision) =>
      consequences[decision] ?? consequences[Decision.ignore]!;

  bool isCorrectDecision(Decision decision) => decision == expectedAction;

  int get xpReward => switch (difficulty) {
        DifficultyLevel.beginner => 20,
        DifficultyLevel.easy => 30,
        DifficultyLevel.intermediate => 50,
        DifficultyLevel.advanced => 75,
        DifficultyLevel.expert => 100,
      };

  @override
  List<Object?> get props => [id, title, category, difficulty];
}
