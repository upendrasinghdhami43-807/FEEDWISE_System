import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/class_model.dart';
import '../mock/mock_data.dart';

// ─── Teacher Providers ────────────────────────────────────────────────────────

final teacherClassesProvider = Provider<List<ClassModel>>((ref) {
  return MockData.classes;
});

final selectedClassIdProvider = StateProvider<String>((ref) => 'class-10a');

final selectedClassStatsProvider = Provider<ClassStats>((ref) {
  final classId = ref.watch(selectedClassIdProvider);
  // In real app: load from API based on classId
  return MockData.classStats10A;
});

final selectedClassStudentsProvider = Provider<List<StudentModel>>((ref) {
  final classId = ref.watch(selectedClassIdProvider);
  return MockData.students.where((s) => s.classId == classId).toList();
});

// ─── All Students Provider ────────────────────────────────────────────────────

final allStudentsProvider = Provider<List<StudentModel>>((ref) {
  return MockData.students;
});

class StudentFilterNotifier extends StateNotifier<StudentFilter> {
  StudentFilterNotifier() : super(const StudentFilter());

  void setSearch(String query) => state = state.copyWith(query: query);
  void setClassId(String? classId) => state = state.copyWith(classId: classId);
  void setSortBy(StudentSortBy sortBy) => state = state.copyWith(sortBy: sortBy);
  void setFilter(String? filter) => state = state.copyWith(filter: filter);
}

class StudentFilter {
  final String query;
  final String? classId;
  final StudentSortBy sortBy;
  final String? filter; // 'struggling', 'high_performers', null

  const StudentFilter({
    this.query = '',
    this.classId,
    this.sortBy = StudentSortBy.name,
    this.filter,
  });

  StudentFilter copyWith({
    String? query,
    String? classId,
    StudentSortBy? sortBy,
    String? filter,
  }) {
    return StudentFilter(
      query: query ?? this.query,
      classId: classId,
      sortBy: sortBy ?? this.sortBy,
      filter: filter,
    );
  }
}

enum StudentSortBy { name, score, progress, streak, lastActive }

final studentFilterProvider =
    StateNotifierProvider<StudentFilterNotifier, StudentFilter>((ref) {
  return StudentFilterNotifier();
});

final filteredStudentsProvider = Provider<List<StudentModel>>((ref) {
  final students = ref.watch(allStudentsProvider);
  final filter = ref.watch(studentFilterProvider);

  var result = students;

  if (filter.query.isNotEmpty) {
    final q = filter.query.toLowerCase();
    result = result.where((s) =>
      s.name.toLowerCase().contains(q) ||
      s.email.toLowerCase().contains(q)
    ).toList();
  }

  if (filter.classId != null) {
    result = result.where((s) => s.classId == filter.classId).toList();
  }

  if (filter.filter == 'struggling') {
    result = result.where((s) => s.averageScore < 60).toList();
  } else if (filter.filter == 'high_performers') {
    result = result.where((s) => s.averageScore >= 80).toList();
  }

  result.sort((a, b) => switch (filter.sortBy) {
    StudentSortBy.name       => a.name.compareTo(b.name),
    StudentSortBy.score      => b.averageScore.compareTo(a.averageScore),
    StudentSortBy.progress   => b.completedChallenges.compareTo(a.completedChallenges),
    StudentSortBy.streak     => b.streak.compareTo(a.streak),
    StudentSortBy.lastActive => (b.lastActive ?? DateTime(2000)).compareTo(a.lastActive ?? DateTime(2000)),
  });

  return result;
});

// ─── Selected Student ─────────────────────────────────────────────────────────

final selectedStudentIdProvider = StateProvider<String?>((ref) => null);

final selectedStudentProvider = Provider<StudentModel?>((ref) {
  final id = ref.watch(selectedStudentIdProvider);
  if (id == null) return null;
  try {
    return MockData.students.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
});
