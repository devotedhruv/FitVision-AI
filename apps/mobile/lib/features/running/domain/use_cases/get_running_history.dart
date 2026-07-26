import '../models/running_session.dart';
import '../repositories/running_repository.dart';

class GetRunningHistory {
  const GetRunningHistory(this.repository);
  final RunningRepository repository;
  Stream<List<RunningSession>> call(String userId) =>
      repository.watchHistory(userId);
}
