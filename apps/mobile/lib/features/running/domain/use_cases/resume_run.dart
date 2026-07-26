import '../models/running_session.dart';
import '../repositories/running_repository.dart';

class ResumeRun {
  const ResumeRun(this.repository);
  final RunningRepository repository;
  Future<RunningSession> call(String id) => repository.resume(id);
}
