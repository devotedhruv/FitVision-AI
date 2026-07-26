import 'running_status.dart';

class RunningMetrics {
  const RunningMetrics({
    this.elapsedDuration = Duration.zero,
    this.activeDuration = Duration.zero,
    this.pausedDuration = Duration.zero,
    this.totalAcceptedDistanceMeters = 0,
    this.currentSpeedMps = 0,
    this.smoothedSpeedMps = 0,
    this.averageSpeedMps = 0,
    this.currentPaceSecondsPerKm,
    this.averagePaceSecondsPerKm,
    this.acceptedPointCount = 0,
    this.rejectedPointCount = 0,
    this.gpsQuality = GpsQuality.searching,
  });
  final Duration elapsedDuration, activeDuration, pausedDuration;
  final double totalAcceptedDistanceMeters,
      currentSpeedMps,
      smoothedSpeedMps,
      averageSpeedMps;
  final double? currentPaceSecondsPerKm, averagePaceSecondsPerKm;
  final int acceptedPointCount, rejectedPointCount;
  final GpsQuality gpsQuality;
}
