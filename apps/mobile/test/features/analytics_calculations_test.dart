import 'package:fitvision_ai/features/analytics/domain/calculations/consistency_calculator.dart';
import 'package:fitvision_ai/features/analytics/domain/calculations/running_analytics_calculator.dart';
import 'package:fitvision_ai/features/analytics/domain/calculations/trend_calculator.dart';
import 'package:fitvision_ai/features/analytics/domain/insights/insight_engine.dart';
import 'package:fitvision_ai/features/analytics/domain/insights/rules/analytics_rules.dart';
import 'package:fitvision_ai/features/analytics/domain/models/analytics_period.dart';
import 'package:fitvision_ai/features/analytics/domain/models/progress_summary.dart';
import 'package:fitvision_ai/features/analytics/domain/models/running_progress.dart';
import 'package:fitvision_ai/features/analytics/domain/models/trend.dart';
import 'package:fitvision_ai/features/running/domain/models/location_point.dart';
import 'package:fitvision_ai/features/running/domain/models/running_session.dart';
import 'package:fitvision_ai/features/running/domain/models/running_status.dart';
import 'package:flutter_test/flutter_test.dart';

RunningSession run(String id, double meters, int seconds) => RunningSession(
  localId: id,
  userId: 'u',
  status: RunningStatus.completed,
  startedAt: DateTime.utc(2026, 1, 1),
  endedAt: DateTime.utc(2026, 1, 1, 0, 10),
  accumulatedActiveDuration: Duration(seconds: seconds),
  accumulatedPausedDuration: const Duration(minutes: 2),
  distanceMeters: meters,
  averagePaceSecondsPerKm: meters > 0 ? seconds / (meters / 1000) : null,
  routePoints: const [],
  syncState: RunningSyncState.pending,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);
void main() {
  group('TrendCalculator', () {
    test('higher and lower directions improve correctly', () {
      expect(
        TrendCalculator.calculate(
          current: .8,
          previous: .6,
          currentSamples: 2,
          previousSamples: 2,
          direction: MetricDirection.higherIsBetter,
        ),
        TrendState.improving,
      );
      expect(
        TrendCalculator.calculate(
          current: 300,
          previous: 330,
          currentSamples: 2,
          previousSamples: 2,
          direction: MetricDirection.lowerIsBetter,
          config: const TrendConfig(absoluteTolerance: 3),
        ),
        TrendState.improving,
      );
    });
    test(
      'tiny change is stable',
      () => expect(
        TrendCalculator.calculate(
          current: 101,
          previous: 100,
          currentSamples: 2,
          previousSamples: 2,
          direction: MetricDirection.higherIsBetter,
          config: const TrendConfig(absoluteTolerance: 3),
        ),
        TrendState.stable,
      ),
    );
    test('missing and insufficient samples are explicit', () {
      expect(
        TrendCalculator.calculate(
          current: 1,
          previous: null,
          currentSamples: 2,
          previousSamples: 0,
          direction: MetricDirection.higherIsBetter,
        ),
        TrendState.noPreviousData,
      );
      expect(
        TrendCalculator.calculate(
          current: 1,
          previous: 0,
          currentSamples: 1,
          previousSamples: 2,
          direction: MetricDirection.higherIsBetter,
        ),
        TrendState.insufficientData,
      );
    });
  });
  group('Running analytics', () {
    test('pace is weighted by distance and duration', () {
      final value = RunningAnalyticsCalculator.calculate([
        run('a', 1000, 300),
        run('b', 2000, 800),
      ], []);
      expect(value.totalDistanceMeters, 3000);
      expect(value.averagePaceSecondsPerKm, closeTo(366.67, .01));
      expect(value.totalActiveDuration, const Duration(seconds: 1100));
    });
    test('zero distance is excluded from pace', () {
      final value = RunningAnalyticsCalculator.calculate([
        run('a', 0, 500),
        run('b', 1000, 300),
      ], []);
      expect(value.averagePaceSecondsPerKm, 300);
    });
  });
  test('consistency counts unique local days across activity types', () {
    expect(
      ConsistencyCalculator.activeDays([
        DateTime(2026, 1, 1, 8),
        DateTime(2026, 1, 1, 20),
        DateTime(2026, 1, 2),
      ]),
      2,
    );
  });
  test('weekly period starts Monday and month handles year boundary', () {
    final weekly = AnalyticsPeriod.current(
      AnalyticsPeriodType.weekly,
      DateTime(2026, 1, 7),
    );
    expect(weekly.startLocal.weekday, DateTime.monday);
    final monthly = AnalyticsPeriod.current(
      AnalyticsPeriodType.monthly,
      DateTime(2026, 1, 3),
    );
    expect(monthly.comparisonStartLocal.year, 2025);
    expect(monthly.comparisonStartLocal.month, 12);
  });
  test('insight engine is deterministic bounded and deduplicated', () {
    final period = AnalyticsPeriod.current(
      AnalyticsPeriodType.weekly,
      DateTime(2026, 1, 7),
    );
    final running = RunningProgress(
      runCount: 2,
      totalDistanceMeters: 2000,
      totalActiveDuration: const Duration(minutes: 10),
      averageDistanceMeters: 1000,
      averagePaceSecondsPerKm: 300,
      distanceTrend: TrendState.stable,
      paceTrend: TrendState.stable,
    );
    final summary = ProgressSummary(
      period: period,
      exerciseSessions: 0,
      runningSessions: 2,
      totalActiveDuration: const Duration(minutes: 10),
      completedReps: 0,
      incompleteReps: 0,
      validFormReps: 0,
      runningDistanceMeters: 2000,
      activeDays: 2,
      previousActiveDays: 1,
      exercises: const [],
      running: running,
      chartPoints: const [],
      insights: const [],
      completeness: DataCompleteness.partial,
    );
    final engine = InsightEngine(const [
      RunningPaceRule(),
      RunningPaceRule(),
      ConsistencyRule(),
      RunningDistanceRule(),
    ], maximumInsights: 3);
    final a = engine.generate(summary), b = engine.generate(summary);
    expect(a.map((i) => i.code), b.map((i) => i.code));
    expect(a.length, 3);
    expect(a.map((i) => i.code).toSet().length, a.length);
  });
}
