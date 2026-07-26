import 'package:fitvision_ai/app/app_shell.dart';
import 'package:fitvision_ai/features/analytics/presentation/analytics_view.dart';
import 'package:fitvision_ai/features/dashboard/presentation/dashboard_view.dart';
import 'package:fitvision_ai/features/exercise/presentation/exercise_detail_view.dart';
import 'package:fitvision_ai/features/exercise/presentation/exercise_list_view.dart';
import 'package:fitvision_ai/features/exercise/presentation/exercise_route_view.dart';
import 'package:fitvision_ai/features/exercise/presentation/workout_result_view.dart';
import 'package:fitvision_ai/features/history/presentation/history_view.dart';
import 'package:fitvision_ai/features/authentication/presentation/auth_view_model.dart';
import 'package:fitvision_ai/features/authentication/presentation/email_verification_view.dart';
import 'package:fitvision_ai/features/authentication/presentation/login_view.dart';
import 'package:fitvision_ai/features/authentication/presentation/register_view.dart';
import 'package:fitvision_ai/features/onboarding/presentation/onboarding_view.dart';
import 'package:fitvision_ai/features/profile/presentation/profile_view.dart';
import 'package:fitvision_ai/features/history/presentation/session_detail_view.dart';
import 'package:fitvision_ai/features/running/presentation/running_setup_view.dart';
import 'package:fitvision_ai/features/running/presentation/live_running_view.dart';
import 'package:fitvision_ai/features/running/presentation/running_result_view.dart';
import 'package:fitvision_ai/features/settings/presentation/settings_view.dart';
import 'package:fitvision_ai/features/splash/presentation/splash_view.dart';
import 'package:fitvision_ai/features/exercise/domain/models/live_pose_session_state.dart';
import 'package:fitvision_ai/shared/widgets/app_error_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouteNames {
  static const onboarding = 'onboarding';
  static const dashboard = 'dashboard';
  static const exercises = 'exercises';
  static const exerciseDetail = 'exercise-detail';
  static const liveExercise = 'live-exercise';
  static const running = 'running';
  static const history = 'history';
  static const analytics = 'analytics';
  static const profile = 'profile';
  static const login = 'login';
  static const register = 'register';
  static const verifyEmail = 'verify-email';
  static const splash = 'splash';
  static const workoutResult = 'workout-result';
  static const settings = 'settings';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
AuthViewModel? activeAuthViewModel;

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    final auth = activeAuthViewModel;
    if (auth == null || auth.status == AuthStatus.loading) return null;
    final authRoute = {
      '/auth/login',
      '/auth/register',
      '/auth/verify-email',
    }.contains(state.matchedLocation);
    if (state.matchedLocation == '/splash') {
      return switch (auth.status) {
        AuthStatus.unauthenticated => '/auth/login',
        AuthStatus.verificationRequired => '/auth/verify-email',
        AuthStatus.authenticated => '/dashboard',
        AuthStatus.loading => null,
      };
    }
    if (auth.status == AuthStatus.unauthenticated) {
      return authRoute ? null : '/auth/login';
    }
    if (auth.status == AuthStatus.verificationRequired) {
      return state.matchedLocation == '/auth/verify-email'
          ? null
          : '/auth/verify-email';
    }
    if (auth.status == AuthStatus.authenticated && authRoute) {
      return '/dashboard';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/dashboard'),
    GoRoute(
      name: AppRouteNames.splash,
      path: '/splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(path: '/login', redirect: (_, _) => '/auth/login'),
    GoRoute(path: '/register', redirect: (_, _) => '/auth/register'),
    GoRoute(path: '/verify-email', redirect: (_, _) => '/auth/verify-email'),
    GoRoute(path: '/onboarding', redirect: (_, _) => '/onboarding/permissions'),
    GoRoute(
      name: AppRouteNames.onboarding,
      path: '/onboarding/permissions',
      builder: (context, state) => const OnboardingView(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRouteNames.dashboard,
              path: '/dashboard',
              builder: (context, state) => const DashboardView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRouteNames.exercises,
              path: '/exercises',
              builder: (context, state) => const ExerciseListView(),
              routes: [
                GoRoute(
                  name: AppRouteNames.exerciseDetail,
                  path: ':exerciseId',
                  builder: (context, state) => ExerciseRouteView(
                    exerciseId: state.pathParameters['exerciseId'] ?? '',
                    destination: ExerciseRouteDestination.detail,
                  ),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      name: AppRouteNames.liveExercise,
                      path: 'live',
                      builder: (context, state) => ExerciseRouteView(
                        exerciseId: state.pathParameters['exerciseId'] ?? '',
                        destination: ExerciseRouteDestination.live,
                      ),
                    ),
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      name: AppRouteNames.workoutResult,
                      path: 'result',
                      builder: (context, state) {
                        final result = state.extra;
                        if (result is WorkoutResultData) {
                          return WorkoutResultView(result: result);
                        }
                        return const InvalidExerciseView(
                          exerciseId: 'missing session result',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRouteNames.running,
              path: '/running/setup',
              builder: (context, state) => const RunningSetupView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRouteNames.history,
              path: '/history',
              builder: (context, state) => const HistoryView(),
              routes: [
                GoRoute(
                  path: ':sessionId',
                  builder: (context, state) => SessionDetailView(
                    sessionKey: state.pathParameters['sessionId'] ?? '',
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRouteNames.profile,
              path: '/profile',
              builder: (context, state) => const ProfileView(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: AppRouteNames.login,
      path: '/auth/login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      name: AppRouteNames.register,
      path: '/auth/register',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      name: AppRouteNames.verifyEmail,
      path: '/auth/verify-email',
      builder: (context, state) => const EmailVerificationView(),
    ),
    GoRoute(path: '/running', redirect: (_, _) => '/running/setup'),
    GoRoute(
      path: '/running/live',
      builder: (context, state) => const LiveRunningView(),
    ),
    GoRoute(
      path: '/running/result',
      builder: (context, state) => RunningResultView(
        localId: state.extra is String ? state.extra! as String : '',
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: AppRouteNames.settings,
      path: '/settings',
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: AppRouteNames.analytics,
      path: '/analytics',
      builder: (context, state) => const AnalyticsView(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page not found')),
    body: AppErrorView(
      message: 'The requested page does not exist.',
      actionLabel: 'Return home',
      onRetry: () => context.go('/dashboard'),
    ),
  ),
);
