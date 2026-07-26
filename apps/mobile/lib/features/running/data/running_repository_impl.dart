import '../domain/models/location_point.dart';
import '../domain/models/running_session.dart';
import '../domain/repositories/running_repository.dart';
import 'running_local_data_source.dart';

class RunningRepositoryImpl implements RunningRepository {
  RunningRepositoryImpl(this.local);
  final RunningLocalDataSource local;
  @override
  Future<RunningSession> start(String userId) => local.start(userId);
  @override
  Future<RunningSession> pause(String id) => local.pause(id);
  @override
  Future<RunningSession> resume(String id) => local.resume(id);
  @override
  Future<RunningSession> record(LocationPoint p) => local.record(p);
  @override
  Future<RunningSession> finish(String id) => local.finish(id);
  @override
  Future<RunningSession?> get(String id) => local.get(id);
  @override
  Future<RunningSession?> active(String userId) => local.dao
      .active(userId)
      .then((r) => r == null ? null : local.get(r.localId));
  @override
  Future<List<RunningSession>> history(String userId) => local.dao
      .history(userId)
      .then(
        (rows) =>
            Future.wait(rows.map((r) => local.get(r.localId).then((v) => v!))),
      );
  @override
  Stream<List<RunningSession>> watchHistory(String userId) => local.dao
      .watchHistory(userId)
      .asyncMap(
        (rows) =>
            Future.wait(rows.map((r) => local.get(r.localId).then((v) => v!))),
      );
  @override
  Future<RunningSession?> recover(String userId) async {
    final s = await active(userId);
    if (s?.status.name == 'running') return local.pause(s!.localId);
    return s;
  }
}
