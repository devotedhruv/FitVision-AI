import 'package:drift/drift.dart';

abstract final class DatabaseMigrations {
  static const schemaVersion = 1;

  static MigrationStrategy strategy(
    GeneratedDatabase database,
  ) => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await database.customStatement(
        'CREATE INDEX idx_workout_user_started ON workout_sessions (user_id, started_at DESC)',
      );
      await database.customStatement(
        'CREATE INDEX idx_workout_sync ON workout_sessions (sync_status)',
      );
      await database.customStatement(
        'CREATE INDEX idx_workout_status ON workout_sessions (status)',
      );
      await database.customStatement(
        'CREATE INDEX idx_sync_eligible ON sync_queue_items (status, next_attempt_at, created_at)',
      );
    },
    onUpgrade: (migrator, from, to) async {
      // Version 1 is the first structured local database. Future upgrades must
      // add explicit, non-destructive steps here.
      if (from > to) throw StateError('Database downgrades are not supported.');
    },
    beforeOpen: (details) async {
      await database.customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) {
        await database.customStatement('PRAGMA journal_mode = WAL');
      }
    },
  );
}
