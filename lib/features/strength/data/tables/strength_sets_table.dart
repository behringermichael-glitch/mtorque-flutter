import 'package:drift/drift.dart';

import 'strength_sessions_table.dart';

class StrengthSets extends Table {
  @override
  String get tableName => 'strength_set';

  IntColumn get sid => integer()();

  IntColumn get sessionId => integer()
      .named('sessionId')
      .references(StrengthSessions, #id, onDelete: KeyAction.cascade)();

  TextColumn get exerciseId => text().named('exerciseId')();

  TextColumn get exerciseName => text().named('exerciseName')();

  IntColumn get setNumber => integer().named('setNumber')();

  RealColumn get reps => real()();

  IntColumn get durationSec => integer().named('durationSec').nullable()();

  RealColumn get weightKg => real().named('weightKg')();

  BoolColumn get isAllOut =>
      boolean().named('isAllOut').withDefault(const Constant(false))();

  BoolColumn get isBfr =>
      boolean().named('isBfr').withDefault(const Constant(false))();

  IntColumn get bfrPercent => integer().named('bfrPercent').nullable()();

  RealColumn get chainsKg => real().named('chainsKg').nullable()();

  RealColumn get bandsKg => real().named('bandsKg').nullable()();

  BoolColumn get isSuperSlow =>
      boolean().named('isSuperSlow').withDefault(const Constant(false))();

  TextColumn get superSlowNote => text().named('superSlowNote').nullable()();

  TextColumn get supersetGroupId =>
      text().named('supersetGroupId').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {sid};
}