import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedwise_mobile/data/models/user_model.dart';
import 'package:feedwise_mobile/data/services/supabase_config.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseConfig.client.auth.onAuthStateChange;
});

final currentSessionProvider = Provider<Session?>((ref) {
  return SupabaseConfig.client.auth.currentSession;
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(currentSessionProvider) != null;
});

final _demoUser = UserModel(
  id: 'demo-001',
  authId: 'demo-auth-001',
  email: 'demo@feedwise.app',
  name: 'Demo User',
  role: UserRole.student,
  xp: 450,
  level: 3,
  currentStreak: 5,
  bestStreak: 12,
  baselineCompleted: true,
  createdAt: DateTime(2026, 1, 1),
);

final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final session = SupabaseConfig.client.auth.currentSession;
  if (session == null) return _demoUser;
  try {
    final response = await SupabaseConfig.client
        .from('users')
        .select()
        .eq('auth_id', session.user.id)
        .maybeSingle();
    if (response == null) return _demoUser;
    return UserModel.fromJson(response as Map<String, dynamic>);
  } catch (_) {
    return _demoUser;
  }
});

final authControllerProvider = NotifierProvider<AuthController, AsyncValue<void>>(() {
  return AuthController();
});

class AuthController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String? ageGroup,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authResponse = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
      );
      if (authResponse.user != null) {
        await SupabaseConfig.client.from('users').insert({
          'auth_id': authResponse.user!.id,
          'email': email,
          'name': name,
          'role': 'student',
          'age_group': ageGroup,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await SupabaseConfig.client.auth.signOut();
    });
  }

  void signInDemo() {
    state = const AsyncValue.data(null);
  }
}
