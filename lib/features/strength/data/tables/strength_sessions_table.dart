import 'package:drift/drift.dart';

class StrengthSessions extends Table {
  @override
  String get tableName => 'strength_session';

  IntColumn get id => integer()();

  IntColumn get startEpochMs => integer().named('startEpochMs')();

  IntColumn get endEpochMs => integer().named('endEpochMs').nullable()();

  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}