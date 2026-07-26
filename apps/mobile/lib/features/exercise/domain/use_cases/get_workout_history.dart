import '../models/workout_session.dart';
import '../repositories/workout_repository.dart';

class GetWorkoutHistory {
  const GetWorkoutHistory(this.repository);
  final WorkoutRepository repository;
  Future<List<WorkoutSession>> call(String userId) =>
      repository.history(userId);
  Stream<List<WorkoutSession>> watch(String userId) =>
      repository.watchHistory(userId);
}
