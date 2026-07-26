import 'package:drift/drift.dart';
import 'package:fitvision_ai/core/storage/local_database.dart'
    show LocalDatabase;
import 'package:fitvision_ai/features/exercise/domain/models/workout_session.dart';
import 'package:fitvision_ai/features/running/domain/models/location_point.dart';
import 'package:fitvision_ai/features/running/domain/models/running_session.dart';
import 'package:fitvision_ai/features/running/domain/models/running_status.dart';
import '../domain/models/analytics_period.dart';

class AnalyticsDataset {
  const AnalyticsDataset(
    this.currentWorkouts,
    this.previousWorkouts,
    this.currentRuns,
    this.previousRuns,
  );
  final List<WorkoutSession> currentWorkouts, previousWorkouts;
  final List<RunningSession> currentRuns, previousRuns;
}

class AnalyticsLocalDataSource {
  const AnalyticsLocalDataSource(this.db);
  final LocalDatabase db;
  Future<AnalyticsDataset> load(String userId, AnalyticsPeriod period) async {
    final c = period.utcRange, p = period.comparisonUtcRange;
    return AnalyticsDataset(
      await _workouts(userId, c.start, c.end, period.exerciseType),
      await _workouts(userId, p.start, p.end, period.exerciseType),
      await _runs(userId, c.start, c.end),
      await _runs(userId, p.start, p.end),
    );
  }

  Future<List<WorkoutSession>> _workouts(
    String user,
    DateTime start,
    DateTime end,
    String? exercise,
  ) async {
    final q = db.select(db.workoutSessions)
      ..where(
        (t) =>
            t.userId.equals(user) &
            t.status.equals('completed') &
            t.startedAt.isBiggerOrEqualValue(start) &
            t.startedAt.isSmallerThanValue(end) &
            t.deletedAt.isNull(),
      );
    if (exercise != null) q.where((t) => t.exerciseType.equals(exercise));
    final rows = await q.get();
    return rows
        .map(
          (r) => WorkoutSession(
            localId: r.localId,
            remoteId: r.remoteId,
            userId: r.userId,
            exerciseType: WorkoutExerciseType.values.byName(r.exerciseType),
            status: WorkoutSessionStatus.completed,
            startedAt: r.startedAt,
            endedAt: r.endedAt,
            accumulatedActiveDuration: Duration(
              milliseconds: r.accumulatedActiveDurationMs,
            ),
            completedRepCount: r.completedRepCount,
            incompleteRepCount: r.incompleteRepCount,
            validFormRepCount: r.validFormRepCount,
            repEvents: const [],
            syncState: WorkoutSyncState.values.byName(r.syncStatus),
            createdAt: r.createdAt,
            updatedAt: r.updatedAt,
            averageRepDuration: r.averageRepDurationMs == null
                ? null
                : Duration(milliseconds: r.averageRepDurationMs!),
            summaryJson: r.summaryJson,
            formScore: r.formScore,
          ),
        )
        .toList();
  }

  Future<List<RunningSession>> _runs(
    String user,
    DateTime start,
    DateTime end,
  ) async {
    final rows =
        await (db.select(db.runningSessions)..where(
              (t) =>
                  t.userId.equals(user) &
                  t.status.equals('completed') &
                  t.startedAt.isBiggerOrEqualValue(start) &
                  t.startedAt.isSmallerThanValue(end),
            ))
            .get();
    return rows
        .map(
          (r) => RunningSession(
            localId: r.localId,
            remoteId: r.remoteId,
            userId: r.userId,
            status: RunningStatus.completed,
            startedAt: r.startedAt,
            endedAt: r.endedAt,
            accumulatedActiveDuration: Duration(
              milliseconds: r.accumulatedActiveDurationMs,
            ),
            accumulatedPausedDuration: Duration(
              milliseconds: r.accumulatedPausedDurationMs,
            ),
            distanceMeters: r.totalDistanceMeters,
            averageSpeedMps: r.averageSpeedMps,
            averagePaceSecondsPerKm: r.averagePaceSecondsPerKm,
            elevationGainMeters: r.elevationGainMeters,
            routePoints: const [],
            syncState: RunningSyncState.values.byName(r.syncStatus),
            createdAt: r.createdAt,
            updatedAt: r.updatedAt,
          ),
        )
        .toList();
  }
}
