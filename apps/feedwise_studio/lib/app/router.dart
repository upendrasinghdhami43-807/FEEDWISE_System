import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/models/user_model.dart';
import '../core/providers/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/dashboard/admin_dashboard_screen.dart';
import '../features/scenarios/scenarios_list_screen.dart';
import '../features/scenarios/scenario_editor_screen.dart';
import '../features/users/users_screen.dart';
import '../features/analytics/analytics_screen.dart';
import '../features/moderation/moderation_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/teacher/teacher_dashboard_screen.dart';
import '../features/students/students_screen.dart';
import '../features/students/student_detail_screen.dart';
import '../features/classes/classes_screen.dart';


// ─── Router Provider ──────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<AuthState>(ref.watch(authProvider));
  ref.listen<AuthState>(authProvider, (_, next) => authNotifier.value = next);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authNotifier,

    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) {
        final role = authState.user?.role;
        return (role == UserRole.admin || role == UserRole.moderator) ? '/dashboard' : '/teacher';
      }
      return null;
    },

    routes: [
      // ─ Auth
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _buildPage(state, const LoginScreen()),
      ),

      // ─ Admin routes
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => _buildPage(state, const AdminDashboardScreen()),
      ),
      GoRoute(
        path: '/scenarios',
        pageBuilder: (context, state) => _buildPage(state, const ScenariosListScreen()),
        routes: [
          GoRoute(
            path: 'new',
            pageBuilder: (context, state) => _buildPage(state, const ScenarioEditorScreen()),
          ),
          GoRoute(
            path: ':id/edit',
            pageBuilder: (context, state) => _buildPage(
              state,
              ScenarioEditorScreen(scenarioId: state.pathParameters['id']),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/users',
        pageBuilder: (context, state) => _buildPage(state, const UsersScreen()),
      ),
      GoRoute(
        path: '/analytics',
        pageBuilder: (context, state) => _buildPage(state, const AnalyticsScreen()),
      ),
      GoRoute(
        path: '/moderation',
        pageBuilder: (context, state) => _buildPage(state, const ModerationScreen()),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _buildPage(state, const SettingsScreen()),
      ),

      // ─ Teacher routes
      GoRoute(
        path: '/teacher',
        pageBuilder: (context, state) => _buildPage(state, const TeacherDashboardScreen()),
      ),
      GoRoute(
        path: '/classes',
        pageBuilder: (context, state) => _buildPage(state, const ClassesScreen()),
      ),
      GoRoute(
        path: '/students',
        pageBuilder: (context, state) => _buildPage(state, const StudentsScreen()),
        routes: [
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) => _buildPage(
              state,
              StudentDetailScreen(studentId: state.pathParameters['id'] ?? ''),
            ),
          ),
        ],
      ),
    ],

    errorPageBuilder: (context, state) => _buildPage(state, const _NotFoundScreen()),
  );
});

CustomTransitionPage<void> _buildPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

// ─── Placeholder screens ──────────────────────────────────────────────────────

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('404', style: TextStyle(color: Color(0xFF6C5CE7), fontSize: 80, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            const Text('Page not found', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 24)),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go home', style: TextStyle(color: Color(0xFF6C5CE7))),
            ),
          ],
        ),
      ),
    );
  }
}
