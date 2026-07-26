import 'package:drift/drift.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import '../../domain/models/location_point.dart';
import '../../domain/models/running_session.dart' as domain;
import '../../domain/models/running_status.dart';

abstract final class RunningSessionMapper {
  static domain.RunningSession fromRow(
    RunningSession r,
    List<LocationPoint> points,
  ) => domain.RunningSession(
    localId: r.localId,
    remoteId: r.remoteId,
    userId: r.userId,
    status: RunningStatus.values.byName(r.status),
    startedAt: r.startedAt,
    endedAt: r.endedAt,
    accumulatedActiveDuration: Duration(
      milliseconds: r.accumulatedActiveDurationMs,
    ),
    accumulatedPausedDuration: Duration(
      milliseconds: r.accumulatedPausedDurationMs,
    ),
    currentActiveSegmentStartedAt: r.currentActiveSegmentStartedAt,
    currentPauseStartedAt: r.currentPauseStartedAt,
    distanceMeters: r.totalDistanceMeters,
    averageSpeedMps: r.averageSpeedMps,
    averagePaceSecondsPerKm: r.averagePaceSecondsPerKm,
    elevationGainMeters: r.elevationGainMeters,
    routePoints: points,
    syncState: RunningSyncState.values.byName(r.syncStatus),
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );
  static RunningSessionsCompanion insert(
    domain.RunningSession s,
  ) => RunningSessionsCompanion.insert(
    localId: s.localId,
    remoteId: Value(s.remoteId),
    userId: s.userId,
    status: s.status.name,
    startedAt: s.startedAt.toUtc(),
    endedAt: Value(s.endedAt?.toUtc()),
    accumulatedActiveDurationMs: Value(
      s.accumulatedActiveDuration.inMilliseconds,
    ),
    accumulatedPausedDurationMs: Value(
      s.accumulatedPausedDuration.inMilliseconds,
    ),
    currentActiveSegmentStartedAt: Value(
      s.currentActiveSegmentStartedAt?.toUtc(),
    ),
    currentPauseStartedAt: Value(s.currentPauseStartedAt?.toUtc()),
    totalDistanceMeters: Value(s.distanceMeters),
    averageSpeedMps: Value(s.averageSpeedMps),
    averagePaceSecondsPerKm: Value(s.averagePaceSecondsPerKm),
    elevationGainMeters: Value(s.elevationGainMeters),
    acceptedPointCount: Value(s.routePoints.where((p) => p.accepted).length),
    rejectedPointCount: Value(s.routePoints.where((p) => !p.accepted).length),
    createdAt: s.createdAt.toUtc(),
    updatedAt: s.updatedAt.toUtc(),
    syncStatus: Value(s.syncState.name),
  );
}
