import 'package:drift/drift.dart';
import '../local_database.dart';

class RunningDao {
  RunningDao(this.db);
  final LocalDatabase db;
  Future<void> create(RunningSessionsCompanion row) =>
      db.into(db.runningSessions).insert(row);
  Future<RunningSession?> session(String id) => (db.select(
    db.runningSessions,
  )..where((t) => t.localId.equals(id))).getSingleOrNull();
  Future<List<RunningPoint>> points(String id) =>
      (db.select(db.runningPoints)
            ..where((t) => t.runningSessionLocalId.equals(id))
            ..orderBy([(t) => OrderingTerm.asc(t.sequenceNumber)]))
          .get();
  Future<RunningSession?> active(String userId) =>
      (db.select(db.runningSessions)
            ..where(
              (t) =>
                  t.userId.equals(userId) &
                  t.status.isIn(['running', 'paused']),
            )
            ..limit(1))
          .getSingleOrNull();
  Future<List<RunningSession>> history(String userId) =>
      (db.select(db.runningSessions)
            ..where(
              (t) => t.userId.equals(userId) & t.status.equals('completed'),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();
  Stream<List<RunningSession>> watchHistory(String userId) =>
      (db.select(db.runningSessions)
            ..where(
              (t) => t.userId.equals(userId) & t.status.equals('completed'),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .watch();
}
