import '../models/running_session.dart';
import '../repositories/running_repository.dart';

class FinishRun {
  const FinishRun(this.repository);
  final RunningRepository repository;
  Future<RunningSession> call(String id) => repository.finish(id);
}
