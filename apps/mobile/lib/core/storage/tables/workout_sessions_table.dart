import 'package:drift/drift.dart';

class WorkoutSessions extends Table {
  TextColumn get localId => text()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get userId => text()();
  TextColumn get exerciseType => text()();
  TextColumn get status => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get accumulatedActiveDurationMs =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get currentActiveSegmentStartedAt => dateTime().nullable()();
  IntColumn get completedRepCount => integer().withDefault(const Constant(0))();
  IntColumn get incompleteRepCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get validFormRepCount => integer().withDefault(const Constant(0))();
  IntColumn get totalRepCount => integer().withDefault(const Constant(0))();
  IntColumn get averageRepDurationMs => integer().nullable()();
  RealColumn get formScore => real().nullable()();
  TextColumn get summaryJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  IntColumn get recordVersion => integer().withDefault(const Constant(1))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {localId};
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {userId, localId},
  ];
}
