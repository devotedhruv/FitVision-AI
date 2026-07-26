import '../../domain/models/workout_session.dart';
import '../mappers/workout_session_mapper.dart';

class WorkoutSessionDto {
  const WorkoutSessionDto(this.json);
  final Map<String, Object?> json;
  factory WorkoutSessionDto.fromDomain(WorkoutSession session) =>
      WorkoutSessionDto(WorkoutSessionMapper.toApiJson(session));
}
