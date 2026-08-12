/// Centralized API endpoint constants for the FeedWise mobile app.
/// All backend routes are defined here to avoid hardcoding paths.
class ApiConstants {
  ApiConstants._();

  // ── Base URL ──────────────────────────────────────────
  // In production, replace with your deployed backend URL.
  static const String baseUrl = 'http://localhost:8000';
  static const String apiPrefix = '/api/v1';

  // ── Auth ──────────────────────────────────────────────
  static const String login = '$apiPrefix/auth/login';
  static const String register = '$apiPrefix/auth/register';
  static const String refreshToken = '$apiPrefix/auth/refresh';

  // ── Users ─────────────────────────────────────────────
  static const String usersMe = '$apiPrefix/users/me';
  static const String usersProfile = '$apiPrefix/users/me/profile';

  // ── Scenarios ─────────────────────────────────────────
  static const String scenarios = '$apiPrefix/scenarios';
  static const String scenariosFeed = '$apiPrefix/scenarios/feed';
  static const String scenariosDaily = '$apiPrefix/scenarios/daily';
  static String scenarioDetail(String id) => '$apiPrefix/scenarios/$id';

  // ── Decisions ─────────────────────────────────────────
  static const String decisions = '$apiPrefix/decisions';
  static String decisionForScenario(String scenarioId) =>
      '$apiPrefix/decisions?scenario_id=$scenarioId';

  // ── Skills ────────────────────────────────────────────
  static const String skills = '$apiPrefix/skills';
  static const String skillsHistory = '$apiPrefix/skills/history';

  // ── Progress ──────────────────────────────────────────
  static const String progress = '$apiPrefix/progress';

  // ── Badges ────────────────────────────────────────────
  static const String badges = '$apiPrefix/badges';
  static const String badgeDefinitions = '$apiPrefix/badges/definitions';

  // ── Academy ───────────────────────────────────────────
  static const String academyModules = '$apiPrefix/academy/modules';
  static String academyLesson(String lessonId) =>
      '$apiPrefix/academy/lessons/$lessonId';
  static String academyLessonComplete(String lessonId) =>
      '$apiPrefix/academy/lessons/$lessonId/complete';

  // ── Newsroom ──────────────────────────────────────────
  static const String newsroom = '$apiPrefix/newsroom';
  static const String newsroomDecision = '$apiPrefix/newsroom/decisions';

  // ── Community ─────────────────────────────────────────
  static const String communitySubmit = '$apiPrefix/community/submissions';
  static const String communityMy = '$apiPrefix/community/submissions/me';

  // ── Admin ─────────────────────────────────────────────
  static const String adminScenarios = '$apiPrefix/admin/scenarios';
  static const String adminUsers = '$apiPrefix/admin/users';
  static const String adminAnalytics = '$apiPrefix/admin/analytics';
}
