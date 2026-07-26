import 'package:fitvision_ai/features/running/domain/models/running_session.dart';
import 'package:fitvision_ai/features/running/domain/models/running_status.dart';
import '../models/running_progress.dart';
import '../models/trend.dart';
import 'trend_calculator.dart';

abstract final class RunningAnalyticsCalculator {
  static RunningProgress calculate(
    List<RunningSession> current,
    List<RunningSession> previous,
  ) {
    final c = current
            .where((r) => r.status == RunningStatus.completed)
            .toList(),
        p = previous.where((r) => r.status == RunningStatus.completed).toList();
    double distance(List<RunningSession> l) =>
        l.fold(0, (v, r) => v + r.distanceMeters);
    int duration(List<RunningSession> l) =>
        l.fold(0, (v, r) => v + r.accumulatedActiveDuration.inMilliseconds);
    double? pace(List<RunningSession> l) {
      final valid = l
          .where(
            (r) =>
                r.distanceMeters > 0 &&
                r.accumulatedActiveDuration.inMilliseconds > 0,
          )
          .toList();
      final d = distance(valid), ms = duration(valid);
      return d > 0 ? ms / 1000 / (d / 1000) : null;
    }

    final d = distance(c), pc = pace(c), pp = pace(p);
    final paces = c
        .map((r) => r.averagePaceSecondsPerKm)
        .whereType<double>()
        .where((v) => v.isFinite && v > 0)
        .toList();
    return RunningProgress(
      runCount: c.length,
      totalDistanceMeters: d,
      totalActiveDuration: Duration(milliseconds: duration(c)),
      averageDistanceMeters: c.isEmpty ? null : d / c.length,
      averagePaceSecondsPerKm: pc,
      bestPaceSecondsPerKm: paces.isEmpty
          ? null
          : paces.reduce((a, b) => a < b ? a : b),
      distanceTrend: TrendCalculator.calculate(
        current: c.isEmpty ? null : d / c.length,
        previous: p.isEmpty ? null : distance(p) / p.length,
        currentSamples: c.length,
        previousSamples: p.length,
        direction: MetricDirection.neutralComparison,
        config: const TrendConfig(
          absoluteTolerance: 100,
          relativeTolerance: .05,
        ),
      ),
      paceTrend: TrendCalculator.calculate(
        current: pc,
        previous: pp,
        currentSamples: c.length,
        previousSamples: p.length,
        direction: MetricDirection.lowerIsBetter,
        config: const TrendConfig(
          absoluteTolerance: 10,
          relativeTolerance: .03,
        ),
      ),
    );
  }
}
