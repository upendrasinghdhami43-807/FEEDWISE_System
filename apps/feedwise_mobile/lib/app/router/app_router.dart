import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/layouts/scaffold_with_nav.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/feed/presentation/pages/feed_page.dart';
import '../../features/investigation/presentation/pages/investigation_page.dart';
import '../../features/investigation/presentation/pages/decision_page.dart';
import '../../features/consequence/presentation/pages/consequence_page.dart';
import '../../features/learning/presentation/pages/lesson_page.dart';
import '../../features/challenges/presentation/pages/challenges_page.dart';
import '../../features/simulation/presentation/pages/newsroom_zero_page.dart';
import '../../features/academy/presentation/pages/academy_page.dart';
import '../../features/academy/presentation/pages/module_detail_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/achievements/presentation/pages/achievements_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/community/presentation/pages/community_page.dart';
import '../../features/community/presentation/pages/create_post_page.dart';
import '../../features/community/presentation/pages/post_preview_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      // ── Pre-auth ──────────────────────────────────────
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (_, __) => const NoTransitionPage(child: SplashPage()),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (_, __) => const RegisterPage(),
      ),

      // ── Main Shell ───────────────────────────────────
      ShellRoute(
        builder: (_, state, child) => ScaffoldWithNav(child: child),
        routes: [
          // Home
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (_, __) => const HomePage(),
          ),

          // Explore / Feed
          GoRoute(
            path: '/explore',
            name: 'explore',
            builder: (_, __) => const FeedPage(),
            routes: [
              GoRoute(
                path: ':scenarioId/investigate',
                name: 'investigate',
                builder: (_, state) => InvestigationPage(
                  scenarioId: state.pathParameters['scenarioId']!,
                ),
              ),
              GoRoute(
                path: ':scenarioId/decide',
                name: 'decide',
                builder: (_, state) => DecisionPage(
                  scenarioId: state.pathParameters['scenarioId']!,
                ),
              ),
              GoRoute(
                path: ':scenarioId/consequence',
                name: 'consequence',
                builder: (_, state) => ConsequencePage(
                  scenarioId: state.pathParameters['scenarioId']!,
                  decision: state.uri.queryParameters['decision'] ?? 'ignore',
                ),
              ),
              GoRoute(
                path: ':scenarioId/lesson',
                name: 'lesson',
                builder: (_, state) => LessonPage(
                  scenarioId: state.pathParameters['scenarioId']!,
                ),
              ),
            ],
          ),

          // Play
          GoRoute(
            path: '/play',
            name: 'play',
            builder: (_, __) => const ChallengesPage(),
            routes: [
              GoRoute(
                path: 'newsroom',
                name: 'newsroom',
                builder: (_, __) => const NewsroomZeroPage(),
              ),
            ],
          ),

          // Academy
          GoRoute(
            path: '/academy',
            name: 'academy',
            builder: (_, __) => const AcademyPage(),
            routes: [
              GoRoute(
                path: ':moduleId',
                name: 'moduleDetail',
                builder: (_, state) => ModuleDetailPage(
                  moduleId: state.pathParameters['moduleId']!,
                ),
              ),
            ],
          ),

          // Me / Profile
          GoRoute(
            path: '/me',
            name: 'me',
            builder: (_, __) => const ProfilePage(),
            routes: [
              GoRoute(
                path: 'achievements',
                name: 'achievements',
                builder: (_, __) => const AchievementsPage(),
              ),
              GoRoute(
                path: 'progress',
                name: 'progress',
                builder: (_, __) => const ProgressPage(),
              ),
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (_, __) => const SettingsPage(),
              ),
              GoRoute(
                path: 'notifications',
                name: 'notifications',
                builder: (_, __) => const NotificationsPage(),
              ),
              GoRoute(
                path: 'community',
                name: 'community',
                builder: (_, __) => const CommunityPage(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'createPost',
                    builder: (_, __) => const CreatePostPage(),
                  ),
                  GoRoute(
                    path: 'preview',
                    name: 'postPreview',
                    builder: (_, __) => const PostPreviewPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
