import 'package:drift/drift.dart';

/// Confirmed from the Android Room migrations.
class DailySteps extends Table {
  @override
  String get tableName => 'daily_steps';

  IntColumn get dateEpochDay => integer()();

  IntColumn get steps => integer()();

  TextColumn get source => text().nullable()();

  IntColumn get updatedAtMs => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {dateEpochDay};
}
