import '../domain/calculations/consistency_calculator.dart';
import '../domain/calculations/exercise_analytics_calculator.dart';
import '../domain/calculations/running_analytics_calculator.dart';
import '../domain/insights/insight_engine.dart';
import '../domain/insights/rules/analytics_rules.dart';
import '../domain/models/analytics_period.dart';
import '../domain/models/progress_summary.dart';
import '../domain/repositories/analytics_repository.dart';
import 'analytics_local_data_source.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(this.local);
  final AnalyticsLocalDataSource local;
  @override
  Future<ProgressSummary> summary(String user, AnalyticsPeriod period) async {
    final d = await local.load(user, period),
        exercises = ExerciseAnalyticsCalculator.calculate(
          d.currentWorkouts,
          d.previousWorkouts,
        ),
        running = RunningAnalyticsCalculator.calculate(
          d.currentRuns,
          d.previousRuns,
        );
    final completed = d.currentWorkouts.fold(
          0,
          (v, s) => v + s.completedRepCount,
        ),
        incomplete = d.currentWorkouts.fold(
          0,
          (v, s) => v + s.incompleteRepCount,
        ),
        valid = d.currentWorkouts.fold(0, (v, s) => v + s.validFormRepCount);
    final scores = d.currentWorkouts
        .map((s) => s.formScore)
        .whereType<double>()
        .toList();
    final starts = [
          ...d.currentWorkouts.map((s) => s.startedAt),
          ...d.currentRuns.map((s) => s.startedAt),
        ],
        previousStarts = [
          ...d.previousWorkouts.map((s) => s.startedAt),
          ...d.previousRuns.map((s) => s.startedAt),
        ];
    var summary = ProgressSummary(
      period: period,
      exerciseSessions: d.currentWorkouts.length,
      runningSessions: d.currentRuns.length,
      totalActiveDuration: Duration(
        milliseconds:
            d.currentWorkouts.fold(
              0,
              (v, s) => v + s.accumulatedActiveDuration.inMilliseconds,
            ) +
            running.totalActiveDuration.inMilliseconds,
      ),
      completedReps: completed,
      incompleteReps: incomplete,
      validFormReps: valid,
      validRepRatio: completed > 0 ? valid / completed : null,
      averageFormScore: scores.isEmpty
          ? null
          : scores.reduce((a, b) => a + b) / scores.length,
      runningDistanceMeters: running.totalDistanceMeters,
      averageRunningPace: running.averagePaceSecondsPerKm,
      activeDays: ConsistencyCalculator.activeDays(starts),
      previousActiveDays: ConsistencyCalculator.activeDays(previousStarts),
      exercises: exercises,
      running: running,
      chartPoints: const [],
      insights: const [],
      completeness: starts.isEmpty
          ? DataCompleteness.empty
          : scores.length < d.currentWorkouts.length
          ? DataCompleteness.partial
          : DataCompleteness.complete,
    );
    final insights = InsightEngine(const [
      FormImprovementRule(),
      RunningPaceRule(),
      FullRangeRepRule(),
      ConsistencyRule(),
      RunningDistanceRule(),
    ]).generate(summary);
    return ProgressSummary(
      period: summary.period,
      exerciseSessions: summary.exerciseSessions,
      runningSessions: summary.runningSessions,
      totalActiveDuration: summary.totalActiveDuration,
      completedReps: summary.completedReps,
      incompleteReps: summary.incompleteReps,
      validFormReps: summary.validFormReps,
      validRepRatio: summary.validRepRatio,
      averageFormScore: summary.averageFormScore,
      runningDistanceMeters: summary.runningDistanceMeters,
      averageRunningPace: summary.averageRunningPace,
      activeDays: summary.activeDays,
      previousActiveDays: summary.previousActiveDays,
      exercises: summary.exercises,
      running: summary.running,
      chartPoints: summary.chartPoints,
      insights: insights,
      completeness: summary.completeness,
    );
  }
}
