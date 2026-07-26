import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fitvision_ai/core/storage/local_database.dart' as db;
import '../../domain/models/rep_event.dart';
import '../../domain/models/workout_session.dart';

abstract final class RepEventMapper {
  static RepEvent fromRow(db.RepEvent row) => RepEvent(
    localId: row.localId,
    remoteId: row.remoteId,
    workoutLocalId: row.workoutLocalId,
    sequenceNumber: row.sequenceNumber,
    eventType: RepEventType.values.byName(row.eventType),
    exerciseType: WorkoutExerciseType.values.byName(row.exerciseType),
    startedAt: row.startedAt.toUtc(),
    endedAt: row.endedAt.toUtc(),
    duration: Duration(milliseconds: row.durationMs),
    formValid: row.formValid,
    minimumPrimaryAngle: row.minimumPrimaryAngle,
    maximumPrimaryAngle: row.maximumPrimaryAngle,
    feedbackCodes: row.feedbackCodesJson == null
        ? const []
        : List<String>.from(jsonDecode(row.feedbackCodesJson!) as List),
    createdAt: row.createdAt.toUtc(),
    recordVersion: row.recordVersion,
  );

  static db.RepEventsCompanion toCompanion(RepEvent event) =>
      db.RepEventsCompanion.insert(
        localId: event.localId,
        remoteId: Value(event.remoteId),
        workoutLocalId: event.workoutLocalId,
        sequenceNumber: event.sequenceNumber,
        eventType: event.eventType.name,
        exerciseType: event.exerciseType.name,
        startedAt: event.startedAt.toUtc(),
        endedAt: event.endedAt.toUtc(),
        durationMs: event.duration.inMilliseconds,
        formValid: event.formValid,
        minimumPrimaryAngle: Value(event.minimumPrimaryAngle),
        maximumPrimaryAngle: Value(event.maximumPrimaryAngle),
        feedbackCodesJson: Value(jsonEncode(event.feedbackCodes)),
        createdAt: event.createdAt.toUtc(),
        syncStatus: WorkoutSyncState.pending.name,
        recordVersion: Value(event.recordVersion),
      );

  static Map<String, Object?> toApiJson(RepEvent event) => {
    'client_event_id': event.localId,
    'rep_number': event.sequenceNumber,
    'duration_ms': event.duration.inMilliseconds,
    'minimum_angle': event.minimumPrimaryAngle,
    'maximum_angle': event.maximumPrimaryAngle,
    'is_valid': event.formValid,
    'form_issues': [
      for (final code in event.feedbackCodes) {'code': code},
    ],
    'recorded_at': event.endedAt.toUtc().toIso8601String(),
  };
}
