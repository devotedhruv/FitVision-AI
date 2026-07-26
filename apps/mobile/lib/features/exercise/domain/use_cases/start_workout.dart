import '../models/workout_session.dart';
import '../repositories/workout_repository.dart';

class StartWorkout {
  const StartWorkout(this.repository);
  final WorkoutRepository repository;
  Future<WorkoutSession> call(String userId, WorkoutExerciseType type) =>
      repository.start(userId: userId, exerciseType: type);
}
