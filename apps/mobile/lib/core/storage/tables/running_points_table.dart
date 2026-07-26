import 'package:drift/drift.dart';
import 'running_sessions_table.dart';

class RunningPoints extends Table {
  TextColumn get localId => text()();
  TextColumn get runningSessionLocalId => text().references(
    RunningSessions,
    #localId,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get sequenceNumber => integer()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get altitude => real().nullable()();
  RealColumn get horizontalAccuracy => real()();
  RealColumn get verticalAccuracy => real().nullable()();
  RealColumn get providerSpeed => real().nullable()();
  RealColumn get speedAccuracy => real().nullable()();
  RealColumn get bearing => real().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
  IntColumn get elapsedRealtimeMs => integer().nullable()();
  RealColumn get distanceFromPreviousMeters =>
      real().withDefault(const Constant(0))();
  BoolColumn get accepted => boolean()();
  TextColumn get rejectionCode => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {localId};
  @override
  List<Set<Column>> get uniqueKeys => [
    {runningSessionLocalId, sequenceNumber},
  ];
}
