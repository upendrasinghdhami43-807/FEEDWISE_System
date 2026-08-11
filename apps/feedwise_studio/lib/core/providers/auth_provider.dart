import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../mock/mock_data.dart';

// ─── Auth State ───────────────────────────────────────────────────────────────

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// ─── Auth Notifier ────────────────────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock role-based login
    if (email == 'admin@feedwise.app') {
      state = state.copyWith(
        isLoading: false,
        user: MockData.adminUser,
        isAuthenticated: true,
      );
      return true;
    } else if (email.contains('teacher') || email == 'ms.sharma@school.edu') {
      state = state.copyWith(
        isLoading: false,
        user: MockData.teacherUser,
        isAuthenticated: true,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid credentials. Use admin@feedwise.app or ms.sharma@school.edu',
        isAuthenticated: false,
      );
      return false;
    }
  }

  void logout() {
    state = const AuthState();
  }

  // For demo: directly set role
  void loginAsAdmin() {
    state = AuthState(user: MockData.adminUser, isAuthenticated: true);
  }

  void loginAsTeacher() {
    state = AuthState(user: MockData.teacherUser, isAuthenticated: true);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// ─── Convenience Providers ────────────────────────────────────────────────────

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider)?.role == UserRole.admin;
});

final isTeacherProvider = Provider<bool>((ref) {
  final role = ref.watch(currentUserProvider)?.role;
  return role == UserRole.teacher || role == UserRole.admin;
});
