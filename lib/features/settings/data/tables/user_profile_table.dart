import 'package:drift/drift.dart';

class UserProfiles extends Table {
  @override
  String get tableName => 'user_profile';

  IntColumn get id => integer().withDefault(const Constant(1))();

  IntColumn get birthDateEpochDay =>
      integer().named('birthDateEpochDay').nullable()();

  TextColumn get sex => text().nullable()();

  RealColumn get heightCm => real().named('heightCm').nullable()();

  RealColumn get weightKg => real().named('weightKg').nullable()();

  IntColumn get updatedAtMs =>
      integer().named('updatedAtMs').withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}