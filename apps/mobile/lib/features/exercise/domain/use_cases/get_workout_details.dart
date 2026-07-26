import '../models/workout_session.dart';
import '../repositories/workout_repository.dart';

class GetWorkoutDetails {
  const GetWorkoutDetails(this.repository);
  final WorkoutRepository repository;
  Future<WorkoutSession?> call(String id) => repository.get(id);
}
