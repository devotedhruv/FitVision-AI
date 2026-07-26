import 'dart:async';
import 'dart:math';
import 'package:drift/native.dart';
import 'package:fitvision_ai/core/errors/app_exception.dart';
import 'package:fitvision_ai/core/errors/failure.dart';
import 'package:fitvision_ai/core/storage/daos/sync_queue_dao.dart';
import 'package:fitvision_ai/core/storage/local_database.dart'
    hide WorkoutSession;
import 'package:fitvision_ai/core/sync/connectivity_monitor.dart';
import 'package:fitvision_ai/core/sync/retry_policy.dart';
import 'package:fitvision_ai/core/sync/sync_manager.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_repository.dart';
import 'package:fitvision_ai/features/authentication/domain/auth_user.dart';
import 'package:fitvision_ai/features/exercise/data/workout_local_data_source.dart';
import 'package:fitvision_ai/features/exercise/data/workout_remote_data_source.dart';
import 'package:fitvision_ai/features/exercise/domain/models/workout_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('retry policy grows with a bounded cap', () {
    final policy = RetryPolicy(random: Random(1));
    expect(policy.delayForAttempt(2), greaterThan(policy.delayForAttempt(1)));
    expect(
      policy.delayForAttempt(20),
      lessThanOrEqualTo(const Duration(minutes: 18)),
    );
  });

  test('completed offline workout syncs once and stores remote ID', () async {
    final database = LocalDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime.utc(2026, 7, 26);
    final local = WorkoutLocalDataSource(database, clock: () => now);
    await local.createWorkout(_session(now));
    await local.completeWorkout('workout-1');
    final remote = _FakeRemote();
    final manager = SyncManager(
      queue: SyncQueueDao(database),
      local: local,
      remote: remote,
      auth: const _FakeAuth(),
      connectivity: const _FakeConnectivity(true),
      clock: () => now,
    );
    await Future.wait([manager.synchronize(), manager.synchronize()]);
    expect(remote.calls, 1);
    final workout = await local.getWorkoutByLocalId('workout-1');
    expect(workout!.remoteId, 'remote-1');
    expect(workout.syncState, WorkoutSyncState.synced);
  });

  test(
    'retryable failure remains queued with increasing attempt count',
    () async {
      final database = LocalDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final now = DateTime.utc(2026, 7, 26);
      final local = WorkoutLocalDataSource(database, clock: () => now);
      await local.createWorkout(_session(now));
      await local.completeWorkout('workout-1');
      final manager = SyncManager(
        queue: SyncQueueDao(database),
        local: local,
        remote: _FailingRemote(const NetworkFailure()),
        auth: const _FakeAuth(),
        connectivity: const _FakeConnectivity(true),
        retryPolicy: RetryPolicy(random: Random(1)),
        clock: () => now,
      );
      await manager.synchronize();
      final jobs = await database.select(database.syncQueueItems).get();
      expect(jobs.single.attemptCount, 1);
      expect(jobs.single.status, 'failed');
      expect(jobs.single.nextAttemptAt.isAfter(now), isTrue);
    },
  );
}

class _FakeRemote implements WorkoutRemoteDataSource {
  int calls = 0;
  @override
  Future<RemoteWorkoutResult> createOrGet(Map<String, Object?> payload) async {
    calls++;
    return const RemoteWorkoutResult(remoteId: 'remote-1');
  }
}

class _FailingRemote implements WorkoutRemoteDataSource {
  const _FailingRemote(this.failure);
  final Failure failure;
  @override
  Future<RemoteWorkoutResult> createOrGet(Map<String, Object?> payload) =>
      throw AppException(failure);
}

class _FakeConnectivity implements ConnectivityMonitor {
  const _FakeConnectivity(this.available);
  final bool available;
  @override
  Future<bool> get hasNetworkInterface async => available;
  @override
  Stream<void> get reconnects => const Stream.empty();
}

class _FakeAuth implements AuthRepository {
  const _FakeAuth();
  @override
  String? get currentAccessToken => 'token';
  @override
  AuthUser? get currentUser => const AuthUser(
    id: 'user-1',
    email: 'test@example.com',
    emailVerified: true,
  );
  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();
  @override
  Future<AuthUser> login({required String email, required String password}) =>
      throw UnimplementedError();
  @override
  Future<void> logout() async {}
  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) => throw UnimplementedError();
}

WorkoutSession _session(DateTime now) => WorkoutSession(
  localId: 'workout-1',
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
