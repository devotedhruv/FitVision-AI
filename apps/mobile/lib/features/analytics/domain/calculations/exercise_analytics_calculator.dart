import 'dart:convert';
import 'package:fitvision_ai/features/exercise/domain/models/workout_session.dart';
import '../models/exercise_progress.dart';
import '../models/trend.dart';
import 'trend_calculator.dart';

abstract final class ExerciseAnalyticsCalculator {
  static List<ExerciseProgress> calculate(
    List<WorkoutSession> current,
    List<WorkoutSession> previous,
  ) {
    return WorkoutExerciseType.values.map((type) {
      final c = current
              .where(
                (s) =>
                    s.exerciseType == type &&
                    s.status == WorkoutSessionStatus.completed,
              )
              .toList(),
          p = previous
              .where(
                (s) =>
                    s.exerciseType == type &&
                    s.status == WorkoutSessionStatus.completed,
              )
              .toList();
      final completed = c.fold(0, (v, s) => v + s.completedRepCount),
          incomplete = c.fold(0, (v, s) => v + s.incompleteRepCount),
          valid = c.fold(0, (v, s) => v + s.validFormRepCount);
      final ratio = completed > 0 ? valid / completed : null;
      final previousCompleted = p.fold(0, (v, s) => v + s.completedRepCount),
          previousValid = p.fold(0, (v, s) => v + s.validFormRepCount),
          previousRatio = previousCompleted > 0
              ? previousValid / previousCompleted
              : null;
      final scores = c.map((s) => s.formScore).whereType<double>().toList();
      final feedback = <String, int>{};
      for (final s in c) {
        if (s.summaryJson != null) {
          try {
            for (final code in List<String>.from(
              (jsonDecode(s.summaryJson!) as Map)['feedback'] as List? ??
                  const [],
            )) {
              feedback[code] = (feedback[code] ?? 0) + 1;
            }
          } catch (_) {}
        }
      }
      return ExerciseProgress(
        exerciseType: type.name,
        sessionCount: c.length,
        completedReps: completed,
        incompleteReps: incomplete,
        validFormReps: valid,
        validFormRatio: ratio,
        averageRepsPerSession: c.isEmpty ? null : completed / c.length,
        averageRepDurationMs: _average(
          c
              .map((s) => s.averageRepDuration?.inMilliseconds)
              .whereType<int>()
              .map((v) => v.toDouble()),
        ),
        averageFormScore: _average(scores),
        trend: TrendCalculator.calculate(
          current: ratio,
          previous: previousRatio,
          currentSamples: c.length,
          previousSamples: p.length,
          direction: MetricDirection.higherIsBetter,
        ),
        feedbackCodes: feedback,
      );
    }).toList();
  }

  static double? _average(Iterable<double> values) {
    final l = values.toList();
    return l.isEmpty ? null : l.reduce((a, b) => a + b) / l.length;
  }
}
