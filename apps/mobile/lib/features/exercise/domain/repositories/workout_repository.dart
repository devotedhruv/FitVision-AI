import '../models/rep_event.dart';
import '../models/workout_session.dart';

abstract interface class WorkoutRepository {
  Future<WorkoutSession> start({
    required String userId,
    required WorkoutExerciseType exerciseType,
  });
  Future<WorkoutSession> pause(String localId);
  Future<WorkoutSession> resume(String localId);
  Future<WorkoutSession> recordRep(RepEvent event);
  Future<WorkoutSession> end(String localId);
  Future<WorkoutSession?> get(String localId);
  Future<WorkoutSession?> recover(String userId);
  Future<List<WorkoutSession>> history(String userId);
  Stream<List<WorkoutSession>> watchHistory(String userId);
}
