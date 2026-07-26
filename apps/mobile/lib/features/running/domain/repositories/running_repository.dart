import '../models/location_point.dart';
import '../models/running_session.dart';

abstract interface class RunningRepository {
  Future<RunningSession> start(String userId);
  Future<RunningSession> pause(String id);
  Future<RunningSession> resume(String id);
  Future<RunningSession> record(LocationPoint point);
  Future<RunningSession> finish(String id);
  Future<RunningSession?> get(String id);
  Future<RunningSession?> active(String userId);
  Future<List<RunningSession>> history(String userId);
  Stream<List<RunningSession>> watchHistory(String userId);
  Future<RunningSession?> recover(String userId);
}
