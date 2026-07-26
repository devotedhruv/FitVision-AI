import 'analytics_period.dart';
import 'chart_data_point.dart';
import 'exercise_progress.dart';
import 'progress_insight.dart';
import 'running_progress.dart';

enum DataCompleteness { complete, partial, empty }

class ProgressSummary {
  const ProgressSummary({
    required this.period,
    required this.exerciseSessions,
    required this.runningSessions,
    required this.totalActiveDuration,
    required this.completedReps,
    required this.incompleteReps,
    required this.validFormReps,
    this.validRepRatio,
    this.averageFormScore,
    required this.runningDistanceMeters,
    this.averageRunningPace,
    required this.activeDays,
    required this.previousActiveDays,
    required this.exercises,
    required this.running,
    required this.chartPoints,
    required this.insights,
    required this.completeness,
  });
  final AnalyticsPeriod period;
  final int exerciseSessions,
      runningSessions,
      completedReps,
      incompleteReps,
      validFormReps,
      activeDays,
      previousActiveDays;
  final Duration totalActiveDuration;
  final double? validRepRatio, averageFormScore, averageRunningPace;
  final double runningDistanceMeters;
  final List<ExerciseProgress> exercises;
  final RunningProgress running;
  final List<ChartDataPoint> chartPoints;
  final List<ProgressInsight> insights;
  final DataCompleteness completeness;
}
