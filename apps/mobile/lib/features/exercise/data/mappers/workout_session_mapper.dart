import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fitvision_ai/core/storage/local_database.dart' as db;
import '../../domain/models/rep_event.dart';
import '../../domain/models/workout_session.dart';
import '../models/rep_event_dto.dart';

abstract final class WorkoutSessionMapper {
  static WorkoutSession fromRow(db.WorkoutSession row, List<RepEvent> events) =>
      WorkoutSession(
        localId: row.localId,
        remoteId: row.remoteId,
        userId: row.userId,
        exerciseType: WorkoutExerciseType.values.byName(row.exerciseType),
        status: WorkoutSessionStatus.values.byName(row.status),
        startedAt: row.startedAt.toUtc(),
        endedAt: row.endedAt?.toUtc(),
        accumulatedActiveDuration: Duration(
          milliseconds: row.accumulatedActiveDurationMs,
        ),
        currentActiveSegmentStartedAt: row.currentActiveSegmentStartedAt
            ?.toUtc(),
        completedRepCount: row.completedRepCount,
        incompleteRepCount: row.incompleteRepCount,
        validFormRepCount: row.validFormRepCount,
        averageRepDuration: row.averageRepDurationMs == null
            ? null
            : Duration(milliseconds: row.averageRepDurationMs!),
        summaryJson: row.summaryJson,
        repEvents: List.unmodifiable(events),
        syncState: WorkoutSyncState.values.byName(row.syncStatus),
        createdAt: row.createdAt.toUtc(),
        updatedAt: row.updatedAt.toUtc(),
        lastSyncedAt: row.lastSyncedAt?.toUtc(),
        recordVersion: row.recordVersion,
      );

  static db.WorkoutSessionsCompanion toCompanion(WorkoutSession session) =>
      db.WorkoutSessionsCompanion.insert(
        localId: session.localId,
        remoteId: Value(session.remoteId),
        userId: session.userId,
        exerciseType: session.exerciseType.name,
        status: session.status.name,
        startedAt: session.startedAt.toUtc(),
        endedAt: Value(session.endedAt?.toUtc()),
        accumulatedActiveDurationMs: Value(
          session.accumulatedActiveDuration.inMilliseconds,
        ),
        currentActiveSegmentStartedAt: Value(
          session.currentActiveSegmentStartedAt?.toUtc(),
        ),
        completedRepCount: Value(session.completedRepCount),
        incompleteRepCount: Value(session.incompleteRepCount),
        validFormRepCount: Value(session.validFormRepCount),
        totalRepCount: Value(session.totalRepCount),
        averageRepDurationMs: Value(session.averageRepDuration?.inMilliseconds),
        summaryJson: Value(session.summaryJson),
        createdAt: session.createdAt.toUtc(),
        updatedAt: session.updatedAt.toUtc(),
        syncStatus: session.syncState.name,
        lastSyncedAt: Value(session.lastSyncedAt?.toUtc()),
        recordVersion: Value(session.recordVersion),
      );

  static Map<String, Object?> toApiJson(WorkoutSession session) => {
    'client_session_id': session.localId,
    'exercise_slug': switch (session.exerciseType) {
      WorkoutExerciseType.squat => 'squat',
      WorkoutExerciseType.curl => 'bicep-curl',
      WorkoutExerciseType.pushup => 'push-up',
    },
    'started_at': session.startedAt.toUtc().toIso8601String(),
    'completed_at': session.endedAt?.toUtc().toIso8601String(),
    'duration_seconds': session.accumulatedActiveDuration.inSeconds,
    'total_reps': session.totalRepCount,
    'valid_reps': session.validFormRepCount,
    'invalid_reps': session.totalRepCount - session.validFormRepCount,
    'form_score': null,
    'average_rep_duration_ms': session.averageRepDuration?.inMilliseconds,
    'rule_version': 'exercise-engine-1.0',
    'rep_events': [
      for (final event in session.repEvents) RepEventDto.fromDomain(event).json,
    ],
  };

  static String summaryJson(
    WorkoutSession session,
    List<String> frequentCodes,
  ) => jsonEncode({
    'completedReps': session.completedRepCount,
    'incompleteReps': session.incompleteRepCount,
    'validFormReps': session.validFormRepCount,
    'frequentFeedbackCodes': frequentCodes,
  });
}
