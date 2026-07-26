import 'package:drift/native.dart';
import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/storage/local_database.dart'
    hide WorkoutSession, RepEvent;
import 'package:fitvision_ai/features/exercise/data/workout_local_data_source.dart';
import 'package:fitvision_ai/features/exercise/domain/models/rep_event.dart';
import 'package:fitvision_ai/features/exercise/domain/models/workout_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LocalDatabase database;
  late WorkoutLocalDataSource local;
  var now = DateTime.utc(2026, 7, 26, 10);

  setUp(() {
    database = LocalDatabase.forTesting(NativeDatabase.memory());
    local = WorkoutLocalDataSource(database, clock: () => now);
  });
  tearDown(() => database.close());

  test(
    'database creation stores a stable local UUID and persistent queue job',
    () async {
      await local.createWorkout(_session(now));
      final restored = await local.getWorkoutByLocalId('workout-1');
      expect(restored!.localId, 'workout-1');
      expect(restored.status, WorkoutSessionStatus.active);
      expect(await local.queue.pendingCount(), 1);
      expect(database.schemaVersion, 1);
    },
  );

  test(
    'pause excludes paused time and resume reconstructs active duration',
    () async {
      await local.createWorkout(_session(now));
      now = now.add(const Duration(seconds: 10));
      final paused = await local.pauseWorkout('workout-1');
      expect(paused.accumulatedActiveDuration, const Duration(seconds: 10));
      now = now.add(const Duration(minutes: 2));
      final resumed = await local.resumeWorkout('workout-1');
      expect(resumed.activeDurationAt(now), const Duration(seconds: 10));
      now = now.add(const Duration(seconds: 5));
      expect(
        (await local.getWorkoutByLocalId('workout-1'))!.activeDurationAt(now),
        const Duration(seconds: 15),
      );
    },
  );

  test(
    'rep insertion and aggregate update are transactional and deduplicated',
    () async {
      await local.createWorkout(_session(now));
      final event = _event(now);
      await local.insertRepEvent(event);
      await local.insertRepEvent(event);
      final workout = await local.getWorkoutByLocalId('workout-1');
      expect(workout!.repEvents, hasLength(1));
      expect(workout.completedRepCount, 1);
      expect(workout.validFormRepCount, 1);
    },
  );

  test('unique active workout and foreign-key cascade are enforced', () async {
    await local.createWorkout(_session(now));
    await expectLater(
      local.createWorkout(_session(now, id: 'workout-2')),
      throwsA(isA<AppException>()),
    );
    await local.insertRepEvent(_event(now));
    await (database.delete(
      database.workoutSessions,
    )..where((row) => row.localId.equals('workout-1'))).go();
    expect(await database.select(database.repEvents).get(), isEmpty);
  });

  test('completion calculates local result and makes queue eligible', () async {
    await local.createWorkout(_session(now));
    await local.insertRepEvent(_event(now));
    now = now.add(const Duration(seconds: 8));
    final result = await local.completeWorkout('workout-1');
    expect(result.status, WorkoutSessionStatus.completed);
    expect(result.averageRepDuration, const Duration(seconds: 1));
    expect((await local.queue.eligible(now)), hasLength(1));
  });

  test(
    'active session recovery closes its segment and returns paused',
    () async {
      await local.createWorkout(_session(now));
      now = now.add(const Duration(seconds: 7));
      final recovered = await local.recoverInterruptedWorkout('user-1');
      expect(recovered!.status, WorkoutSessionStatus.paused);
      expect(recovered.accumulatedActiveDuration, const Duration(seconds: 7));
    },
  );
}

WorkoutSession _session(DateTime now, {String id = 'workout-1'}) =>
    WorkoutSession(
      localId: id,
      userId: 'user-1',
      exerciseType: WorkoutExerciseType.squat,
      status: WorkoutSessionStatus.active,
      startedAt: now,
      accumulatedActiveDuration: Duration.zero,
      currentActiveSegmentStartedAt: now,
      completedRepCount: 0,
      incompleteRepCount: 0,
      validFormRepCount: 0,
      repEvents: const [],
      syncState: WorkoutSyncState.pending,
      createdAt: now,
      updatedAt: now,
    );
RepEvent _event(DateTime now) => RepEvent(
  localId: 'rep-1',
  workoutLocalId: 'workout-1',
  sequenceNumber: 1,
  eventType: RepEventType.completed,
  exerciseType: WorkoutExerciseType.squat,
  startedAt: now,
  endedAt: now.add(const Duration(seconds: 1)),
  duration: const Duration(seconds: 1),
  formValid: true,
  feedbackCodes: const ['repCompleted'],
  createdAt: now,
);
