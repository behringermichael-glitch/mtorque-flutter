import 'package:drift/drift.dart';

/// Confirmed from the Android Room migrations.
class HrSettings extends Table {
  @override
  String get tableName => 'hr_settings';

  IntColumn get id => integer()();

  TextColumn get mode => text().withDefault(const Constant('SIMPLE'))();

  TextColumn get sex => text().nullable()();

  IntColumn get birthYear => integer().nullable()();

  IntColumn get hrRestBpm => integer().nullable()();

  IntColumn get hrMaxBpm => integer().nullable()();

  IntColumn get z1Upper => integer().nullable()();

  IntColumn get z2Upper => integer().nullable()();

  IntColumn get z3Upper => integer().nullable()();

  IntColumn get z4Upper => integer().nullable()();

  IntColumn get z5Upper => integer().nullable()();

  IntColumn get updatedAtMs => integer().withDefault(const Constant(0))();

  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
