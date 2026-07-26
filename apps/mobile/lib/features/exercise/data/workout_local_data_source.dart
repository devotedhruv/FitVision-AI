import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:fitvision_ai/core/storage/daos/sync_queue_dao.dart';
import 'package:fitvision_ai/core/storage/daos/workout_dao.dart';
import 'package:fitvision_ai/core/storage/local_database.dart' as db;
import '../domain/models/rep_event.dart';
import '../domain/models/workout_session.dart';
import 'mappers/rep_event_mapper.dart';
import 'mappers/workout_session_mapper.dart';

class WorkoutLocalDataSource {
  WorkoutLocalDataSource(this.database, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now,
      workouts = WorkoutDao(database),
      queue = SyncQueueDao(database);
  final db.LocalDatabase database;
  final DateTime Function() clock;
  final WorkoutDao workouts;
  final SyncQueueDao queue;

  DateTime get now => clock().toUtc();

  Future<WorkoutSession> createWorkout(WorkoutSession session) async {
    try {
      return await database.transaction(() async {
        if (await workouts.activeRow(session.userId) != null) {
          throw const AppException(
            SessionStateFailure('Another workout is already active.'),
          );
        }
        await workouts.insertWorkout(WorkoutSessionMapper.toCompanion(session));
        await _upsertQueue(session.localId, '{}', DateTime.utc(9999));
        return session;
      });
    } on AppException {
      rethrow;
    } catch (error) {
      throw AppException(
        const LocalDatabaseFailure(),
        cause: error.runtimeType,
      );
    }
  }

  Future<WorkoutSession?> getWorkoutByLocalId(String id) async {
    final row = await workouts.rowById(id);
    if (row == null) return null;
    return WorkoutSessionMapper.fromRow(
      row,
      (await workouts.repRows(id)).map(RepEventMapper.fromRow).toList(),
    );
  }

  Future<WorkoutSession?> getActiveWorkout(String userId) async {
    final row = await workouts.activeRow(userId);
    return row == null ? null : getWorkoutByLocalId(row.localId);
  }

  Future<WorkoutSession> pauseWorkout(String id) =>
      _changeSegment(id, pause: true);
  Future<WorkoutSession> resumeWorkout(String id) =>
      _changeSegment(id, pause: false);
  Future<WorkoutSession> _changeSegment(
    String id, {
    required bool pause,
  }) async => database.transaction(() async {
    final current = await getWorkoutByLocalId(id);
    if (current == null) {
      throw const AppException(SessionStateFailure('Workout was not found.'));
    }
    final expected = pause
        ? WorkoutSessionStatus.active
        : WorkoutSessionStatus.paused;
    if (current.status != expected) {
      throw AppException(
        SessionStateFailure(
          pause ? 'Workout is not active.' : 'Workout is not paused.',
        ),
      );
    }
    final timestamp = now;
    var accumulated = current.accumulatedActiveDuration;
    if (pause && current.currentActiveSegmentStartedAt != null) {
      final delta = timestamp.difference(
        current.currentActiveSegmentStartedAt!,
      );
      if (!delta.isNegative) accumulated += delta;
    }
    await workouts.updateWorkout(
      id,
      db.WorkoutSessionsCompanion(
        status: Value(pause ? 'paused' : 'active'),
        accumulatedActiveDurationMs: Value(accumulated.inMilliseconds),
        currentActiveSegmentStartedAt: Value(pause ? null : timestamp),
        updatedAt: Value(timestamp),
        syncStatus: const Value('pending'),
        recordVersion: Value(current.recordVersion + 1),
      ),
    );
    return (await getWorkoutByLocalId(id))!;
  });

  Future<WorkoutSession> insertRepEvent(RepEvent event) async =>
      database.transaction(() async {
        final session = await getWorkoutByLocalId(event.workoutLocalId);
        if (session == null ||
            !{
              WorkoutSessionStatus.active,
              WorkoutSessionStatus.paused,
            }.contains(session.status)) {
          throw const AppException(
            SessionStateFailure('No active workout can accept this rep.'),
          );
        }
        if (await workouts.repRowById(event.localId) != null) return session;
        final inserted = await workouts.insertRep(
          RepEventMapper.toCompanion(event),
        );
        if (inserted == 0) return session;
        final completed =
            session.completedRepCount +
            (event.eventType == RepEventType.completed ? 1 : 0);
        final incomplete =
            session.incompleteRepCount +
            (event.eventType == RepEventType.incomplete ? 1 : 0);
        final valid =
            session.validFormRepCount +
            (event.eventType == RepEventType.completed && event.formValid
                ? 1
                : 0);
        await workouts.updateWorkout(
          session.localId,
          db.WorkoutSessionsCompanion(
            completedRepCount: Value(completed),
            incompleteRepCount: Value(incomplete),
            validFormRepCount: Value(valid),
            totalRepCount: Value(completed + incomplete),
            updatedAt: Value(now),
            syncStatus: const Value('pending'),
            recordVersion: Value(session.recordVersion + 1),
          ),
        );
        return (await getWorkoutByLocalId(session.localId))!;
      });

  Future<WorkoutSession> completeWorkout(String id) async =>
      database.transaction(() async {
        var session = await getWorkoutByLocalId(id);
        if (session == null ||
            !{
              WorkoutSessionStatus.active,
              WorkoutSessionStatus.paused,
            }.contains(session.status)) {
          throw const AppException(
            SessionStateFailure('Workout cannot be completed.'),
          );
        }
        final timestamp = now;
        var duration = session.accumulatedActiveDuration;
        if (session.status == WorkoutSessionStatus.active &&
            session.currentActiveSegmentStartedAt != null) {
          final delta = timestamp.difference(
            session.currentActiveSegmentStartedAt!,
          );
          if (!delta.isNegative) duration += delta;
        }
        final completedDurations = session.repEvents
            .where((event) => event.eventType == RepEventType.completed)
            .map((event) => event.duration.inMilliseconds)
            .toList();
        final average = completedDurations.isEmpty
            ? null
            : completedDurations.reduce((a, b) => a + b) ~/
                  completedDurations.length;
        final frequencies = <String, int>{};
        for (final event in session.repEvents) {
          for (final code in event.feedbackCodes) {
            frequencies.update(code, (value) => value + 1, ifAbsent: () => 1);
          }
        }
        final frequent = frequencies.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        await workouts.updateWorkout(
          id,
          db.WorkoutSessionsCompanion(
            status: const Value('completed'),
            endedAt: Value(timestamp),
            accumulatedActiveDurationMs: Value(duration.inMilliseconds),
            currentActiveSegmentStartedAt: const Value(null),
            averageRepDurationMs: Value(average),
            updatedAt: Value(timestamp),
            syncStatus: const Value('pending'),
            recordVersion: Value(session.recordVersion + 1),
          ),
        );
        session = (await getWorkoutByLocalId(id))!;
        final summary = WorkoutSessionMapper.summaryJson(
          session,
          frequent.take(3).map((item) => item.key).toList(),
        );
        await workouts.updateWorkout(
          id,
          db.WorkoutSessionsCompanion(summaryJson: Value(summary)),
        );
        session = (await getWorkoutByLocalId(id))!;
        await _upsertQueue(
          id,
          jsonEncode(WorkoutSessionMapper.toApiJson(session)),
          timestamp,
        );
        return session;
      });

  Future<List<WorkoutSession>> getWorkoutHistory(String userId) async =>
      Future.wait(
        (await workouts.historyRows(userId)).map(
          (row) async => WorkoutSessionMapper.fromRow(
            row,
            (await workouts.repRows(
              row.localId,
            )).map(RepEventMapper.fromRow).toList(),
          ),
        ),
      );
  Stream<List<WorkoutSession>> watchWorkoutHistory(String userId) => workouts
      .watchHistoryRows(userId)
      .asyncMap((_) => getWorkoutHistory(userId));
  Future<WorkoutSession?> getWorkoutWithRepEvents(String id) =>
      getWorkoutByLocalId(id);
  Future<WorkoutSession?> recoverInterruptedWorkout(String userId) async {
    final session = await getActiveWorkout(userId);
    if (session?.status == WorkoutSessionStatus.active) {
      // App process state cannot prove the camera/analyzer is still active.
      // Crash recovery therefore closes the UTC segment and restores paused.
      return pauseWorkout(session!.localId);
    }
    return session;
  }

  Future<void> markWorkoutSyncing(String id) => workouts.updateWorkout(
    id,
    db.WorkoutSessionsCompanion(
      syncStatus: const Value('syncing'),
      updatedAt: Value(now),
    ),
  );
  Future<void> markWorkoutSynced(String id, String remoteId) =>
      workouts.updateWorkout(
        id,
        db.WorkoutSessionsCompanion(
          remoteId: Value(remoteId),
          syncStatus: const Value('synced'),
          lastSyncedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
  Future<void> markWorkoutSyncFailed(String id, {bool conflict = false}) =>
      workouts.updateWorkout(
        id,
        db.WorkoutSessionsCompanion(
          syncStatus: Value(conflict ? 'conflict' : 'failed'),
          updatedAt: Value(now),
        ),
      );

  Future<void> _upsertQueue(
    String localId,
    String payload,
    DateTime eligibleAt,
  ) => queue.upsert(
    db.SyncQueueItemsCompanion.insert(
      id: 'workout:$localId:create',
      entityType: 'workoutSession',
      entityLocalId: localId,
      operation: 'create',
      payloadJson: payload,
      status: 'pending',
      nextAttemptAt: eligibleAt.toUtc(),
      createdAt: now,
      updatedAt: now,
    ),
  );
}
