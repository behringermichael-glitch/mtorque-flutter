import 'package:drift/drift.dart';

/// Confirmed from the Android Room migrations.
class UserProfiles extends Table {
  @override
  String get tableName => 'user_profile';

  IntColumn get id => integer()();

  IntColumn get birthDateEpochDay => integer().nullable()();

  TextColumn get sex => text().nullable()();

  RealColumn get heightCm => real().nullable()();

  RealColumn get weightKg => real().nullable()();

  IntColumn get updatedAtMs => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
