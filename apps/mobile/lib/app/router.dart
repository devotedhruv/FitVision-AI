import 'package:fitvision_ai/app/app_shell.dart';
import 'package:fitvision_ai/features/analytics/presentation/analytics_view.dart';
import 'package:fitvision_ai/features/dashboard/presentation/dashboard_view.dart';
import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:fitvision_ai/features/exercise/presentation/exercise_detail_view.dart';
import 'package:fitvision_ai/features/exercise/presentation/exercise_list_view.dart';
import 'package:fitvision_ai/features/exercise/presentation/live_exercise_view.dart';
import 'package:fitvision_ai/features/history/presentation/history_view.dart';
import 'package:fitvision_ai/features/onboarding/presentation/onboarding_view.dart';
import 'package:fitvision_ai/features/profile/presentation/profile_view.dart';
import 'package:fitvision_ai/features/running/presentation/running_view.dart';
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
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/dashboard'),
    GoRoute(
      name: AppRouteNames.onboarding,
      path: '/onboarding',
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
                  builder: (context, state) {
                    final id = state.pathParameters['exerciseId'] ?? '';
                    final exercise = const ExerciseMockRepository().findById(
                      id,
                    );
                    return exercise == null
                        ? InvalidExerciseView(exerciseId: id)
                        : ExerciseDetailView(exercise: exercise);
                  },
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      name: AppRouteNames.liveExercise,
                      path: 'live',
                      builder: (context, state) {
                        final id = state.pathParameters['exerciseId'] ?? '';
                        final exercise = const ExerciseMockRepository()
                            .findById(id);
                        return exercise == null
                            ? InvalidExerciseView(exerciseId: id)
                            : LiveExerciseView(exercise: exercise);
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
              path: '/running',
              builder: (context, state) => const RunningView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRouteNames.history,
              path: '/history',
              builder: (context, state) => const HistoryView(),
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
