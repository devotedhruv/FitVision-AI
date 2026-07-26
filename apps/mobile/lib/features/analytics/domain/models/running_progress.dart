import 'trend.dart';

class RunningProgress {
  const RunningProgress({
    required this.runCount,
    required this.totalDistanceMeters,
    required this.totalActiveDuration,
    this.averageDistanceMeters,
    this.averagePaceSecondsPerKm,
    this.bestPaceSecondsPerKm,
    required this.distanceTrend,
    required this.paceTrend,
  });
  final int runCount;
  final double totalDistanceMeters;
  final Duration totalActiveDuration;
  final double? averageDistanceMeters,
      averagePaceSecondsPerKm,
      bestPaceSecondsPerKm;
  final TrendState distanceTrend, paceTrend;
}
