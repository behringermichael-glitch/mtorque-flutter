import 'package:drift/drift.dart';

import 'run_sessions_table.dart';

class RunSamples extends Table {
  @override
  String get tableName => 'run_sample';

  IntColumn get sid => integer()();

  IntColumn get sessionId => integer()
      .named('sessionId')
      .references(RunSessions, #id, onDelete: KeyAction.cascade)();

  IntColumn get tEpochMs => integer().named('tEpochMs')();

  RealColumn get lat => real()();

  RealColumn get lon => real()();

  IntColumn get hr => integer().nullable()();

  RealColumn get accM => real().named('accM').nullable()();

  RealColumn get speedMps => real().named('speedMps').nullable()();

  RealColumn get elevM => real().named('elev_m').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {sid};
}