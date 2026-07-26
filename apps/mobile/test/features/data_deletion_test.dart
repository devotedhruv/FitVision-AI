import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fitvision_ai/core/storage/local_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('user history deletion is isolated and idempotent', () async {
    final db = LocalDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final now = DateTime.utc(2026, 7, 26);
    Future<void> addUser(String user, String suffix) async {
      await db
          .into(db.workoutSessions)
          .insert(
            WorkoutSessionsCompanion.insert(
              localId: 'workout-$suffix',
              userId: user,
              exerciseType: 'squat',
              status: 'completed',
              startedAt: now,
              accumulatedActiveDurationMs: const Value(1000),
              currentActiveSegmentStartedAt: const Value(null),
              completedRepCount: const Value(1),
              incompleteRepCount: const Value(0),
              validFormRepCount: const Value(1),
              totalRepCount: const Value(1),
              createdAt: now,
              updatedAt: now,
              syncStatus: 'synced',
              recordVersion: const Value(1),
            ),
          );
      await db
          .into(db.runningSessions)
          .insert(
            RunningSessionsCompanion.insert(
              localId: 'run-$suffix',
              userId: user,
              status: 'completed',
              startedAt: now,
              accumulatedActiveDurationMs: const Value(1000),
              accumulatedPausedDurationMs: const Value(0),
              totalDistanceMeters: const Value(10),
              acceptedPointCount: const Value(1),
              rejectedPointCount: const Value(0),
              createdAt: now,
              updatedAt: now,
              syncStatus: const Value('synced'),
              recordVersion: const Value(1),
            ),
          );
    }

    await addUser('user-a', 'a');
    await addUser('user-b', 'b');

    await db.deleteUserData('user-a');
    await db.deleteUserData('user-a');

    expect(await db.select(db.workoutSessions).get(), hasLength(1));
    expect((await db.select(db.workoutSessions).get()).single.userId, 'user-b');
    expect(await db.select(db.runningSessions).get(), hasLength(1));
    expect((await db.select(db.runningSessions).get()).single.userId, 'user-b');
  });
}
