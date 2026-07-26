import 'trend.dart';

class ExerciseProgress {
  const ExerciseProgress({
    required this.exerciseType,
    required this.sessionCount,
    required this.completedReps,
    required this.incompleteReps,
    required this.validFormReps,
    required this.validFormRatio,
    this.averageRepsPerSession,
    this.averageRepDurationMs,
    this.averageFormScore,
    required this.trend,
    this.feedbackCodes = const {},
  });
  final String exerciseType;
  final int sessionCount, completedReps, incompleteReps, validFormReps;
  final double? validFormRatio,
      averageRepsPerSession,
      averageRepDurationMs,
      averageFormScore;
  final TrendState trend;
  final Map<String, int> feedbackCodes;
}
