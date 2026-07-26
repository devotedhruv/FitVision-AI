import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:fitvision_ai/core/storage/daos/running_dao.dart';
import 'package:fitvision_ai/core/storage/daos/sync_queue_dao.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import '../domain/models/location_point.dart';
import '../domain/models/running_session.dart' as domain;
import '../domain/models/running_status.dart';
import 'mappers/location_point_mapper.dart';
import 'mappers/running_session_mapper.dart';

class RunningLocalDataSource {
  RunningLocalDataSource(
    this.db,
    this.dao,
    this.queue, {
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;
  final LocalDatabase db;
  final RunningDao dao;
  final SyncQueueDao queue;
  final DateTime Function() clock;
  static const _uuid = Uuid();
  Future<domain.RunningSession> start(String userId) async {
    if (await dao.active(userId) != null) {
      throw const InvalidRunningStateFailure('A run is already active.');
    }
    final now = clock().toUtc();
    final s = domain.RunningSession(
      localId: _uuid.v4(),
      userId: userId,
      status: RunningStatus.running,
      startedAt: now,
      accumulatedActiveDuration: Duration.zero,
      accumulatedPausedDuration: Duration.zero,
      currentActiveSegmentStartedAt: now,
      distanceMeters: 0,
      syncState: RunningSyncState.pending,
      createdAt: now,
      updatedAt: now,
    );
    await db.transaction(() async {
      await dao.create(RunningSessionMapper.insert(s));
      await _queue(s, DateTime.utc(9999));
    });
    return s;
  }

  Future<domain.RunningSession?> get(String id) async {
    final row = await dao.session(id);
    if (row == null) return null;
    return RunningSessionMapper.fromRow(
      row,
      (await dao.points(id)).map(LocationPointMapper.fromRow).toList(),
    );
  }

  Future<domain.RunningSession> pause(String id) => _transition(id, true);
  Future<domain.RunningSession> resume(String id) => _transition(id, false);
  Future<domain.RunningSession> _transition(String id, bool pausing) async {
    final s = await get(id);
    if (s == null ||
        (pausing
            ? s.status != RunningStatus.running
            : s.status != RunningStatus.paused)) {
      throw const InvalidRunningStateFailure();
    }
    final now = clock().toUtc();
    final active = s.activeDurationAt(now), paused = s.pausedDurationAt(now);
    await (db.update(
      db.runningSessions,
    )..where((t) => t.localId.equals(id))).write(
      RunningSessionsCompanion(
        status: Value(pausing ? 'paused' : 'running'),
        accumulatedActiveDurationMs: Value(active.inMilliseconds),
        accumulatedPausedDurationMs: Value(paused.inMilliseconds),
        currentActiveSegmentStartedAt: Value(pausing ? null : now),
        currentPauseStartedAt: Value(pausing ? now : null),
        updatedAt: Value(now),
      ),
    );
    return (await get(id))!;
  }

  Future<domain.RunningSession> record(LocationPoint point) async {
    await db.transaction(() async {
      await db
          .into(db.runningPoints)
          .insert(
            LocationPointMapper.toCompanion(point),
            mode: InsertMode.insertOrIgnore,
          );
      final accepted = point.accepted ? 1 : 0,
          rejected = point.accepted ? 0 : 1;
      await db.customUpdate(
        'UPDATE running_sessions SET total_distance_meters=total_distance_meters+?, accepted_point_count=accepted_point_count+?, rejected_point_count=rejected_point_count+?, updated_at=? WHERE local_id=?',
        variables: [
          Variable(point.distanceFromPreviousMeters),
          Variable(accepted),
          Variable(rejected),
          Variable(clock().toUtc()),
          Variable(point.runningSessionLocalId),
        ],
      );
    });
    return (await get(point.runningSessionLocalId))!;
  }

  Future<domain.RunningSession> finish(String id) async {
    final existing = await get(id);
    if (existing == null) throw const InvalidRunningStateFailure();
    if (existing.status == RunningStatus.completed) return existing;
    if (existing.status != RunningStatus.running &&
        existing.status != RunningStatus.paused) {
      throw const InvalidRunningStateFailure();
    }
    final now = clock().toUtc(),
        active = existing.activeDurationAt(now),
        paused = existing.pausedDurationAt(now);
    final speed = active.inMilliseconds > 0
        ? existing.distanceMeters / (active.inMilliseconds / 1000)
        : null;
    final pace = existing.distanceMeters >= 20
        ? active.inMilliseconds / 1000 / (existing.distanceMeters / 1000)
        : null;
    await db.transaction(() async {
      await (db.update(
        db.runningSessions,
      )..where((t) => t.localId.equals(id))).write(
        RunningSessionsCompanion(
          status: const Value('completed'),
          endedAt: Value(now),
          accumulatedActiveDurationMs: Value(active.inMilliseconds),
          accumulatedPausedDurationMs: Value(paused.inMilliseconds),
          currentActiveSegmentStartedAt: const Value(null),
          currentPauseStartedAt: const Value(null),
          averageSpeedMps: Value(speed),
          averagePaceSecondsPerKm: Value(pace),
          updatedAt: Value(now),
        ),
      );
      final completed = (await get(id))!;
      await _queue(completed, now);
    });
    return (await get(id))!;
  }

  Future<void> _queue(domain.RunningSession s, DateTime eligible) async {
    final points = s.routePoints.where((p) => p.accepted).toList();
    final payload = {
      'client_session_id': s.localId,
      'started_at': s.startedAt.toUtc().toIso8601String(),
      'completed_at': s.endedAt?.toUtc().toIso8601String(),
      'distance_meters': s.distanceMeters,
      'duration_seconds': s.accumulatedActiveDuration.inSeconds,
      'average_pace_seconds_per_km': s.averagePaceSecondsPerKm,
      'maximum_speed_mps': s.averageSpeedMps,
      'points': points
          .map(
            (p) => {
              'client_point_id': p.localId,
              'sequence_number': p.sequenceNumber,
              'latitude': p.latitude,
              'longitude': p.longitude,
              'accuracy_meters': p.horizontalAccuracy,
              'recorded_at': p.recordedAt.toUtc().toIso8601String(),
            },
          )
          .toList(),
    };
    final now = clock().toUtc();
    await queue.upsert(
      SyncQueueItemsCompanion.insert(
        id: 'run:${s.localId}:create',
        entityType: 'running_session',
        entityLocalId: s.localId,
        operation: 'create',
        payloadJson: jsonEncode(payload),
        status: 'pending',
        nextAttemptAt: eligible,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}
