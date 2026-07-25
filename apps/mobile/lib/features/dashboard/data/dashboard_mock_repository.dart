import 'package:fitvision_ai/core/constants/app_constants.dart';
import 'package:fitvision_ai/features/dashboard/models/dashboard_summary.dart';
import 'package:fitvision_ai/features/exercise/data/exercise_mock_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardMockRepository {
  const DashboardMockRepository({this.mode = MockDataMode.data});
  final MockDataMode mode;

  Future<DashboardSummary> fetchSummary() async {
    await Future<void>.delayed(AppConstants.mockDelay);
    if (mode == MockDataMode.error) {
      throw StateError('The demo dashboard could not be loaded.');
    }
    // TODO(phase-3): Replace this local summary with user-scoped API data.
    return DashboardSummary(
      streakDays: mode == MockDataMode.empty ? 0 : 3,
      totalWorkouts: mode == MockDataMode.empty ? 0 : 18,
      estimatedCalories: mode == MockDataMode.empty ? 0 : 1240,
      activeMinutes: mode == MockDataMode.empty ? 0 : 146,
      weeklyCompleted: mode == MockDataMode.empty ? 0 : 3,
      weeklyGoal: AppConstants.weeklyWorkoutGoal,
      recentWorkout: mode == MockDataMode.empty
          ? null
          : 'Squat • 8 min • 10 reps',
    );
  }
}

final dashboardRepositoryProvider = Provider<DashboardMockRepository>(
  (ref) => const DashboardMockRepository(),
);

final dashboardSummaryProvider = FutureProvider<DashboardSummary>(
  (ref) => ref.watch(dashboardRepositoryProvider).fetchSummary(),
);
