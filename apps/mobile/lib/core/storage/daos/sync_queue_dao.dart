import 'package:drift/drift.dart';
import '../local_database.dart';

class SyncQueueDao {
  const SyncQueueDao(this.database);
  final LocalDatabase database;

  Future<void> upsert(SyncQueueItemsCompanion item) =>
      database.into(database.syncQueueItems).insertOnConflictUpdate(item);
  Future<List<SyncQueueItem>> eligible(DateTime now) =>
      (database.select(database.syncQueueItems)
            ..where(
              (row) =>
                  row.status.isIn(['pending', 'failed']) &
                  row.nextAttemptAt.isSmallerOrEqualValue(now.toUtc()),
            )
            ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
          .get();
  Future<int> updateItem(String id, SyncQueueItemsCompanion changes) =>
      (database.update(
        database.syncQueueItems,
      )..where((row) => row.id.equals(id))).write(changes);
  Future<int> remove(String id) => (database.delete(
    database.syncQueueItems,
  )..where((row) => row.id.equals(id))).go();
  Future<int> recoverStuck(DateTime now) =>
      (database.update(
        database.syncQueueItems,
      )..where((row) => row.status.equals('processing'))).write(
        SyncQueueItemsCompanion(
          status: const Value('pending'),
          nextAttemptAt: Value(now.toUtc()),
          updatedAt: Value(now.toUtc()),
        ),
      );
  Future<int> pendingCount() async =>
      (database.select(database.syncQueueItems)
            ..where((row) => row.status.isNotValue('completed')))
          .get()
          .then((rows) => rows.length);
}
