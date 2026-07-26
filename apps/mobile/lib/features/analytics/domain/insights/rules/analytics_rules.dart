import '../../models/progress_insight.dart';
import '../../models/progress_summary.dart';
import '../../models/trend.dart';
import '../insight_rule.dart';

abstract class _Rule implements InsightRule {
  const _Rule(this.id, this.priority);
  @override
  final String id;
  @override
  final int priority;
  ProgressInsight insight(
    ProgressSummary s, {
    required String code,
    required InsightCategory category,
    required String metric,
    required TrendState direction,
    double? current,
    double? previous,
    InsightQuality quality = InsightQuality.strong,
  }) => ProgressInsight(
    code: code,
    category: category,
    priority: priority,
    metric: metric,
    currentValue: current,
    previousValue: previous,
    direction: direction,
    localizationKey: code,
    period: s.period,
    quality: quality,
  );
}

class FormImprovementRule extends _Rule {
  const FormImprovementRule() : super('form_change', 1);
  @override
  ProgressInsight? evaluate(ProgressSummary s) {
    for (final e in s.exercises) {
      if (e.trend == TrendState.improving || e.trend == TrendState.stable) {
        return insight(
          s,
          code: e.trend == TrendState.improving
              ? 'form_improved_${e.exerciseType}'
              : 'form_stable_${e.exerciseType}',
          category: InsightCategory.form,
          metric: 'valid_form_ratio_${e.exerciseType}',
          direction: e.trend,
          current: e.validFormRatio,
        );
      }
    }
    return null;
  }
}

class FullRangeRepRule extends _Rule {
  const FullRangeRepRule() : super('full_range', 3);
  @override
  ProgressInsight? evaluate(ProgressSummary s) {
    final comparable = s.exercises.where(
      (e) => e.sessionCount >= 2 && e.validFormRatio != null,
    );
    if (comparable.isEmpty) return null;
    final e = comparable.first;
    return insight(
      s,
      code: e.trend == TrendState.declining
          ? 'full_range_lower_${e.exerciseType}'
          : 'full_range_progress_${e.exerciseType}',
      category: InsightCategory.fullRange,
      metric: 'valid_form_ratio_${e.exerciseType}',
      direction: e.trend,
      current: e.validFormRatio,
      quality: InsightQuality.limited,
    );
  }
}

class ConsistencyRule extends _Rule {
  const ConsistencyRule() : super('consistency', 4);
  @override
  ProgressInsight? evaluate(ProgressSummary s) => insight(
    s,
    code: s.activeDays > s.previousActiveDays
        ? 'activity_days_more'
        : 'activity_days_summary',
    category: InsightCategory.consistency,
    metric: 'active_days',
    direction: TrendState.stable,
    current: s.activeDays.toDouble(),
    previous: s.previousActiveDays.toDouble(),
  );
}

class RunningDistanceRule extends _Rule {
  const RunningDistanceRule() : super('running_distance', 5);
  @override
  ProgressInsight? evaluate(ProgressSummary s) => s.running.runCount < 2
      ? null
      : insight(
          s,
          code: 'running_distance_summary',
          category: InsightCategory.runningDistance,
          metric: 'average_run_distance',
          direction: s.running.distanceTrend,
          current: s.running.averageDistanceMeters,
        );
}

class RunningPaceRule extends _Rule {
  const RunningPaceRule() : super('running_pace', 2);
  @override
  ProgressInsight? evaluate(ProgressSummary s) =>
      s.running.paceTrend == TrendState.insufficientData ||
          s.running.paceTrend == TrendState.noPreviousData
      ? null
      : insight(
          s,
          code: s.running.paceTrend == TrendState.improving
              ? 'pace_improved'
              : 'pace_stable',
          category: InsightCategory.runningPace,
          metric: 'weighted_pace',
          direction: s.running.paceTrend,
          current: s.running.averagePaceSecondsPerKm,
        );
}
