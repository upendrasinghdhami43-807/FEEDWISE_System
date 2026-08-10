import 'package:equatable/equatable.dart';

enum UserRole { student, teacher, admin, moderator }

enum AgeGroup { age16to18, age19to21, age22to24, age25plus }

class UserModel extends Equatable {
  final String id;
  final String authId;
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
    required this.authId,
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
        _ => 'MIL Champion',
      };

  int get xpForNextLevel => switch (level) {
        1 => 200,
        2 => 500,
        3 => 1000,
        4 => 2000,
        5 => 3500,
        6 => 5500,
        7 => 8000,
        8 => 12000,
        9 => 18000,
        _ => 99999,
      };

  double get levelProgress {
    final prevThreshold = level > 1
        ? switch (level - 1) {
            1 => 200,
            2 => 500,
            3 => 1000,
            4 => 2000,
            5 => 3500,
            6 => 5500,
            7 => 8000,
            8 => 12000,
            _ => 0,
          }
        : 0;
    final nextThreshold = xpForNextLevel;
    if (nextThreshold == prevThreshold) return 1.0;
    return ((xp - prevThreshold) / (nextThreshold - prevThreshold)).clamp(0.0, 1.0);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        authId: json['auth_id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        role: UserRole.values.firstWhere(
          (r) => r.name == json['role'],
          orElse: () => UserRole.student,
        ),
        ageGroup: json['age_group'] != null
            ? AgeGroup.values.firstWhere(
                (a) => a.name == json['age_group'],
                orElse: () => AgeGroup.age16to18,
              )
            : null,
        locale: json['locale'] as String? ?? 'en',
        avatarUrl: json['avatar_url'] as String?,
        xp: json['xp'] as int? ?? 0,
        level: json['level'] as int? ?? 1,
        currentStreak: json['current_streak'] as int? ?? 0,
        bestStreak: json['best_streak'] as int? ?? 0,
        lastActiveDate: json['last_active_date'] != null
            ? DateTime.parse(json['last_active_date'] as String)
            : null,
        baselineCompleted: json['baseline_completed'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'auth_id': authId,
        'email': email,
        'name': name,
        'role': role.name,
        'age_group': ageGroup?.name,
        'locale': locale,
        'avatar_url': avatarUrl,
        'xp': xp,
        'level': level,
        'current_streak': currentStreak,
        'best_streak': bestStreak,
        'last_active_date': lastActiveDate?.toIso8601String(),
        'baseline_completed': baselineCompleted,
        'created_at': createdAt.toIso8601String(),
      };

  UserModel copyWith({
    String? name,
    String? avatarUrl,
    int? xp,
    int? level,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastActiveDate,
    bool? baselineCompleted,
    String? locale,
  }) =>
      UserModel(
        id: id,
        authId: authId,
        email: email,
        name: name ?? this.name,
        role: role,
        ageGroup: ageGroup,
        locale: locale ?? this.locale,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        xp: xp ?? this.xp,
        level: level ?? this.level,
        currentStreak: currentStreak ?? this.currentStreak,
        bestStreak: bestStreak ?? this.bestStreak,
        lastActiveDate: lastActiveDate ?? this.lastActiveDate,
        baselineCompleted: baselineCompleted ?? this.baselineCompleted,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props => [id, authId, email, name, role, xp, level];
}
