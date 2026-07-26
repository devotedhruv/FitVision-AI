import '../models/workout_session.dart';
import '../repositories/workout_repository.dart';

class ResumeWorkout {
  const ResumeWorkout(this.repository);
  final WorkoutRepository repository;
  Future<WorkoutSession> call(String id) => repository.resume(id);
}
