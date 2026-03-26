import 'package:drift/drift.dart';

class RunSessions extends Table {
  @override
  String get tableName => 'run_session';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get startEpochMs => integer()();
  IntColumn get endEpochMs => integer().nullable()();
  RealColumn get totalDistanceM => real().withDefault(const Constant(0.0))();
  IntColumn get totalDurationMs => integer().withDefault(const Constant(0))();
  IntColumn get avgHr => integer().nullable()();
  IntColumn get maxHr => integer().nullable()();
  RealColumn get elevGainM => real().named('elev_gain_m').nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get sport => text().nullable()();
  TextColumn get indoorSettingsJson => text().named('indoor_settings_json').nullable()();
  IntColumn get rpe0to10 => integer().named('rpe_0_10').nullable()();
  IntColumn get timeZ1s => integer().named('time_z1_s').withDefault(const Constant(0))();
  IntColumn get timeZ2s => integer().named('time_z2_s').withDefault(const Constant(0))();
  IntColumn get timeZ3s => integer().named('time_z3_s').withDefault(const Constant(0))();
  IntColumn get timeZ4s => integer().named('time_z4_s').withDefault(const Constant(0))();
  IntColumn get timeZ5s => integer().named('time_z5_s').withDefault(const Constant(0))();
  TextColumn get hrZoneMethod => text().named('hr_zone_method').nullable()();
  IntColumn get hrMaxUsed => integer().named('hrmax_used').nullable()();
  IntColumn get hrRestUsed => integer().named('hrrest_used').nullable()();
  TextColumn get hrZoneBoundsJson => text().named('hr_zone_bounds_json').nullable()();

  List<Set<Column<Object>>> get indexes => [
    {startEpochMs},
    {endEpochMs},
  ];
}