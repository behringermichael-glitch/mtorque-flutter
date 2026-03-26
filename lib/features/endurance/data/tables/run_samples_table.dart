import 'package:drift/drift.dart';

import 'run_sessions_table.dart';

class RunSamples extends Table {
  @override
  String get tableName => 'run_sample';

  IntColumn get sid => integer().autoIncrement()();
  IntColumn get sessionId =>
      integer().references(RunSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get tEpochMs => integer()();
  RealColumn get lat => real()();
  RealColumn get lon => real()();
  IntColumn get hr => integer().nullable()();
  RealColumn get accM => real().nullable()();
  RealColumn get speedMps => real().nullable()();
  RealColumn get elevM => real().named('elev_m').nullable()();

  List<Set<Column<Object>>> get indexes => [
    {sessionId},
    {tEpochMs},
  ];
}