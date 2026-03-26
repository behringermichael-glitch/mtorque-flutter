import 'package:drift/drift.dart';

class HrSettings extends Table {
  @override
  String get tableName => 'hr_settings';

  IntColumn get id => integer().withDefault(const Constant(1))();

  TextColumn get mode =>
      text().withDefault(const Constant('SIMPLE'))();

  TextColumn get sex => text().nullable()();

  IntColumn get birthYear => integer().named('birthYear').nullable()();

  IntColumn get hrRestBpm => integer().named('hrRestBpm').nullable()();

  IntColumn get hrMaxBpm => integer().named('hrMaxBpm').nullable()();

  IntColumn get z1Upper => integer().named('z1Upper').nullable()();

  IntColumn get z2Upper => integer().named('z2Upper').nullable()();

  IntColumn get z3Upper => integer().named('z3Upper').nullable()();

  IntColumn get z4Upper => integer().named('z4Upper').nullable()();

  IntColumn get z5Upper => integer().named('z5Upper').nullable()();

  IntColumn get updatedAtMs =>
      integer().named('updatedAtMs').withDefault(const Constant(0))();

  TextColumn get notes => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}