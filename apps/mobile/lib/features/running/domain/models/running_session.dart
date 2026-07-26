import 'location_point.dart';
import 'running_status.dart';

class RunningSession {
  const RunningSession({
    required this.localId,
    this.remoteId,
    required this.userId,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.accumulatedActiveDuration,
    required this.accumulatedPausedDuration,
    this.currentActiveSegmentStartedAt,
    this.currentPauseStartedAt,
    required this.distanceMeters,
    this.averageSpeedMps,
    this.averagePaceSecondsPerKm,
    this.elevationGainMeters,
    this.routePoints = const [],
    required this.syncState,
    required this.createdAt,
    required this.updatedAt,
  });
  final String localId, userId;
  final String? remoteId;
  final RunningStatus status;
  final DateTime startedAt, createdAt, updatedAt;
  final DateTime? endedAt, currentActiveSegmentStartedAt, currentPauseStartedAt;
  final Duration accumulatedActiveDuration, accumulatedPausedDuration;
  final double distanceMeters;
  final double? averageSpeedMps, averagePaceSecondsPerKm, elevationGainMeters;
  final List<LocationPoint> routePoints;
  final RunningSyncState syncState;
  Duration activeDurationAt(DateTime now) =>
      accumulatedActiveDuration +
      (status == RunningStatus.running && currentActiveSegmentStartedAt != null
          ? _safe(now.toUtc().difference(currentActiveSegmentStartedAt!))
          : Duration.zero);
  Duration pausedDurationAt(DateTime now) =>
      accumulatedPausedDuration +
      (status == RunningStatus.paused && currentPauseStartedAt != null
          ? _safe(now.toUtc().difference(currentPauseStartedAt!))
          : Duration.zero);
  static Duration _safe(Duration value) =>
      value.isNegative ? Duration.zero : value;
}
