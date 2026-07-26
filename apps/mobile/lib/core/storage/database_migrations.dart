import 'package:drift/drift.dart';

abstract final class DatabaseMigrations {
  static const schemaVersion = 2;

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
      await _runningIndexes(database);
    },
    onUpgrade: (migrator, from, to) async {
      if (from > to) throw StateError('Database downgrades are not supported.');
      if (from < 2) {
        await migrator.createTable(
          database.allTables.firstWhere(
            (table) => table.actualTableName == 'running_sessions',
          ),
        );
        await migrator.createTable(
          database.allTables.firstWhere(
            (table) => table.actualTableName == 'running_points',
          ),
        );
        await _runningIndexes(database);
      }
    },
    beforeOpen: (details) async {
      await database.customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) {
        await database.customStatement('PRAGMA journal_mode = WAL');
      }
    },
  );

  static Future<void> _runningIndexes(GeneratedDatabase database) async {
    await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_run_local_user_started ON running_sessions (user_id, started_at DESC)',
    );
    await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_run_local_status ON running_sessions (status)',
    );
    await database.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_run_local_sync ON running_sessions (sync_status)',
    );
  }
}
