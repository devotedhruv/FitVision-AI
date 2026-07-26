import '../models/workout_session.dart';
import '../repositories/workout_repository.dart';

class PauseWorkout {
  const PauseWorkout(this.repository);
  final WorkoutRepository repository;
  Future<WorkoutSession> call(String id) => repository.pause(id);
}
