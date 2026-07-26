import 'package:drift/drift.dart';
import '../local_database.dart';

class WorkoutDao {
  const WorkoutDao(this.database);
  final LocalDatabase database;

  Future<void> insertWorkout(WorkoutSessionsCompanion workout) =>
      database.into(database.workoutSessions).insert(workout);
  Future<WorkoutSession?> rowById(String id) => (database.select(
    database.workoutSessions,
  )..where((row) => row.localId.equals(id))).getSingleOrNull();
  Future<WorkoutSession?> activeRow(String userId) =>
      (database.select(database.workoutSessions)
            ..where(
              (row) =>
                  row.userId.equals(userId) &
                  row.status.isIn(['active', 'paused']),
            )
            ..orderBy([(row) => OrderingTerm.desc(row.startedAt)])
            ..limit(1))
          .getSingleOrNull();
  Future<List<RepEvent>> repRows(String workoutId) =>
      (database.select(database.repEvents)
            ..where((row) => row.workoutLocalId.equals(workoutId))
            ..orderBy([(row) => OrderingTerm.asc(row.sequenceNumber)]))
          .get();
  Future<List<WorkoutSession>> historyRows(String userId) =>
      (database.select(database.workoutSessions)
            ..where((row) => row.userId.equals(userId) & row.deletedAt.isNull())
            ..orderBy([(row) => OrderingTerm.desc(row.startedAt)]))
          .get();
  Stream<List<WorkoutSession>> watchHistoryRows(String userId) =>
      (database.select(database.workoutSessions)
            ..where((row) => row.userId.equals(userId) & row.deletedAt.isNull())
            ..orderBy([(row) => OrderingTerm.desc(row.startedAt)]))
          .watch();
  Future<int> updateWorkout(String id, WorkoutSessionsCompanion changes) =>
      (database.update(
        database.workoutSessions,
      )..where((row) => row.localId.equals(id))).write(changes);
  Future<int> insertRep(RepEventsCompanion rep) => database
      .into(database.repEvents)
      .insert(rep, mode: InsertMode.insertOrIgnore);
  Future<RepEvent?> repRowById(String id) => (database.select(
    database.repEvents,
  )..where((row) => row.localId.equals(id))).getSingleOrNull();
}
