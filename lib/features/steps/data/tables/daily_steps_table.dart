import 'package:drift/drift.dart';

class DailySteps extends Table {
  @override
  String get tableName => 'daily_steps';

  IntColumn get dateEpochDay => integer().named('dateEpochDay')();

  IntColumn get steps => integer()();

  TextColumn get source => text().nullable()();

  IntColumn get updatedAtMs =>
      integer().named('updatedAtMs').withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {dateEpochDay};
}