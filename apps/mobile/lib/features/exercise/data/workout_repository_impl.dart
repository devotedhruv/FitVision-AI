import 'package:uuid/uuid.dart';
import '../domain/models/rep_event.dart';
import '../domain/models/workout_session.dart';
import '../domain/repositories/workout_repository.dart';
import 'workout_local_data_source.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  WorkoutRepositoryImpl(this.local, {Uuid? uuid, DateTime Function()? clock})
    : _uuid = uuid ?? const Uuid(),
      _clock = clock ?? DateTime.now;
  final WorkoutLocalDataSource local;
  final Uuid _uuid;
  final DateTime Function() _clock;
  @override
  Future<WorkoutSession> start({
    required String userId,
    required WorkoutExerciseType exerciseType,
  }) {
    final now = _clock().toUtc();
    return local.createWorkout(
      WorkoutSession(
        localId: _uuid.v4(),
        userId: userId,
        exerciseType: exerciseType,
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
      ),
    );
  }

  @override
  Future<WorkoutSession> pause(String localId) => local.pauseWorkout(localId);
  @override
  Future<WorkoutSession> resume(String localId) => local.resumeWorkout(localId);
  @override
  Future<WorkoutSession> recordRep(RepEvent event) =>
      local.insertRepEvent(event);
  @override
  Future<WorkoutSession> end(String localId) => local.completeWorkout(localId);
  @override
  Future<WorkoutSession?> get(String localId) =>
      local.getWorkoutByLocalId(localId);
  @override
  Future<WorkoutSession?> recover(String userId) =>
      local.recoverInterruptedWorkout(userId);
  @override
  Future<List<WorkoutSession>> history(String userId) =>
      local.getWorkoutHistory(userId);
  @override
  Stream<List<WorkoutSession>> watchHistory(String userId) =>
      local.watchWorkoutHistory(userId);
}
