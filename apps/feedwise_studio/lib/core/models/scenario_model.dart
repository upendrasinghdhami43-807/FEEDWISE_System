import 'package:flutter/material.dart';

enum ScenarioCategory {
  sourceVerification('Source Verification', '🔎', Color(0xFF6C5CE7)),
  aiGeneratedContent('AI Content',          '🤖', Color(0xFF2DD4BF)),
  deepfakes(         'Deepfakes',            '🎭', Color(0xFF8B5CF6)),
  clickbait(         'Clickbait',            '🎣', Color(0xFFFF6B6B)),
  misleadingContext( 'Misleading Context',   '📸', Color(0xFFF59E0B)),
  manipulatedStats(  'Statistics',           '📊', Color(0xFF3B82F6)),
  hateSpeech(        'Hate Speech',          '🚫', Color(0xFFEF4444)),
  scams(             'Scams',                '⚠️', Color(0xFFF59E0B)),
  satire(            'Satire',               '😏', Color(0xFF94A3B8)),
  politicalMisinfo(  'Political',            '🏛️', Color(0xFF6C5CE7)),
  crisisMisinfo(     'Crisis/Disaster',      '🌊', Color(0xFF3B82F6)),
  aiHallucination(   'AI Hallucination',     '💭', Color(0xFF2DD4BF));

  final String displayName;
  final String emoji;
  final Color color;
  const ScenarioCategory(this.displayName, this.emoji, this.color);
}

enum DifficultyLevel {
  beginner(    1, 'Beginner',     '●○○○○'),
  easy(        2, 'Easy',         '●●○○○'),
  intermediate(3, 'Intermediate', '●●●○○'),
  advanced(    4, 'Advanced',     '●●●●○'),
  expert(      5, 'Expert',       '●●●●●');

  final int value;
  final String label;
  final String dots;
  const DifficultyLevel(this.value, this.label, this.dots);
}

enum Decision {
  share( 'Share',  'shared',                   '↗'),
  verify('Verify', 'flagged for verification',  '🔍'),
  report('Report', 'reported as misleading',    '🚩'),
  ignore('Ignore', 'ignored',                   '✕');

  final String label;
  final String pastTense;
  final String icon;
  const Decision(this.label, this.pastTense, this.icon);
}

enum ScenarioStatus {
  draft(     'Draft',       '📝', Color(0xFF94A3B8)),
  inReview(  'In Review',   '🔄', Color(0xFFF59E0B)),
  factChecked('Fact Checked','✅', Color(0xFF3B82F6)),
  milReviewed('MIL Reviewed','📚', Color(0xFF8B5CF6)),
  published( 'Published',   '🟢', Color(0xFF22C55E)),
  archived(  'Archived',    '📦', Color(0xFF64748B));

  final String label;
  final String emoji;
  final Color color;
  const ScenarioStatus(this.label, this.emoji, this.color);
}

class ScenarioModel {
  final String id;
  final String title;
  final String? description;
  final ScenarioCategory category;
  final DifficultyLevel difficulty;
  final List<String> languages;
  final ScenarioStatus status;
  final Decision expectedAction;
  final String sourceName;
  final String headline;
  final String? body;
  final int likes;
  final int comments;
  final int shares;
  final String lessonTitle;
  final String explanation;
  final String keyTakeaway;
  final List<String> targetSkills;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final double correctRate; // 0-100 percent
  final int completions;
  final double avgTimeSeconds;

  const ScenarioModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.difficulty,
    this.languages = const ['en'],
    this.status = ScenarioStatus.published,
    required this.expectedAction,
    this.sourceName = '',
    this.headline = '',
    this.body,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.lessonTitle = '',
    this.explanation = '',
    this.keyTakeaway = '',
    this.targetSkills = const [],
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.correctRate = 0,
    this.completions = 0,
    this.avgTimeSeconds = 0,
  });

  ScenarioModel copyWith({
    String? title,
    String? description,
    ScenarioCategory? category,
    DifficultyLevel? difficulty,
    List<String>? languages,
    ScenarioStatus? status,
    Decision? expectedAction,
    String? sourceName,
    String? headline,
    String? body,
    int? likes,
    int? comments,
    int? shares,
    String? lessonTitle,
    String? explanation,
    String? keyTakeaway,
    List<String>? targetSkills,
  }) {
    return ScenarioModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      languages: languages ?? this.languages,
      status: status ?? this.status,
      expectedAction: expectedAction ?? this.expectedAction,
      sourceName: sourceName ?? this.sourceName,
      headline: headline ?? this.headline,
      body: body ?? this.body,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      explanation: explanation ?? this.explanation,
      keyTakeaway: keyTakeaway ?? this.keyTakeaway,
      targetSkills: targetSkills ?? this.targetSkills,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      createdBy: createdBy,
      correctRate: correctRate,
      completions: completions,
      avgTimeSeconds: avgTimeSeconds,
    );
  }
}
