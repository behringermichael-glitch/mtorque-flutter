// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RunSessionsTable extends RunSessions
    with TableInfo<$RunSessionsTable, RunSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RunSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startEpochMsMeta = const VerificationMeta(
    'startEpochMs',
  );
  @override
  late final GeneratedColumn<int> startEpochMs = GeneratedColumn<int>(
    'startEpochMs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endEpochMsMeta = const VerificationMeta(
    'endEpochMs',
  );
  @override
  late final GeneratedColumn<int> endEpochMs = GeneratedColumn<int>(
    'endEpochMs',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalDistanceMMeta = const VerificationMeta(
    'totalDistanceM',
  );
  @override
  late final GeneratedColumn<double> totalDistanceM = GeneratedColumn<double>(
    'totalDistanceM',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _totalDurationMsMeta = const VerificationMeta(
    'totalDurationMs',
  );
  @override
  late final GeneratedColumn<int> totalDurationMs = GeneratedColumn<int>(
    'totalDurationMs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _avgHrMeta = const VerificationMeta('avgHr');
  @override
  late final GeneratedColumn<int> avgHr = GeneratedColumn<int>(
    'avgHr',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxHrMeta = const VerificationMeta('maxHr');
  @override
  late final GeneratedColumn<int> maxHr = GeneratedColumn<int>(
    'maxHr',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _elevGainMMeta = const VerificationMeta(
    'elevGainM',
  );
  @override
  late final GeneratedColumn<double> elevGainM = GeneratedColumn<double>(
    'elev_gain_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sportMeta = const VerificationMeta('sport');
  @override
  late final GeneratedColumn<String> sport = GeneratedColumn<String>(
    'sport',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _indoorSettingsJsonMeta =
      const VerificationMeta('indoorSettingsJson');
  @override
  late final GeneratedColumn<String> indoorSettingsJson =
      GeneratedColumn<String>(
        'indoor_settings_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _rpe0to10Meta = const VerificationMeta(
    'rpe0to10',
  );
  @override
  late final GeneratedColumn<int> rpe0to10 = GeneratedColumn<int>(
    'rpe_0_10',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeZ1sMeta = const VerificationMeta(
    'timeZ1s',
  );
  @override
  late final GeneratedColumn<int> timeZ1s = GeneratedColumn<int>(
    'time_z1_s',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timeZ2sMeta = const VerificationMeta(
    'timeZ2s',
  );
  @override
  late final GeneratedColumn<int> timeZ2s = GeneratedColumn<int>(
    'time_z2_s',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timeZ3sMeta = const VerificationMeta(
    'timeZ3s',
  );
  @override
  late final GeneratedColumn<int> timeZ3s = GeneratedColumn<int>(
    'time_z3_s',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timeZ4sMeta = const VerificationMeta(
    'timeZ4s',
  );
  @override
  late final GeneratedColumn<int> timeZ4s = GeneratedColumn<int>(
    'time_z4_s',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _timeZ5sMeta = const VerificationMeta(
    'timeZ5s',
  );
  @override
  late final GeneratedColumn<int> timeZ5s = GeneratedColumn<int>(
    'time_z5_s',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hrZoneMethodMeta = const VerificationMeta(
    'hrZoneMethod',
  );
  @override
  late final GeneratedColumn<String> hrZoneMethod = GeneratedColumn<String>(
    'hr_zone_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrMaxUsedMeta = const VerificationMeta(
    'hrMaxUsed',
  );
  @override
  late final GeneratedColumn<int> hrMaxUsed = GeneratedColumn<int>(
    'hrmax_used',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrRestUsedMeta = const VerificationMeta(
    'hrRestUsed',
  );
  @override
  late final GeneratedColumn<int> hrRestUsed = GeneratedColumn<int>(
    'hrrest_used',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrZoneBoundsJsonMeta = const VerificationMeta(
    'hrZoneBoundsJson',
  );
  @override
  late final GeneratedColumn<String> hrZoneBoundsJson = GeneratedColumn<String>(
    'hr_zone_bounds_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startEpochMs,
    endEpochMs,
    totalDistanceM,
    totalDurationMs,
    avgHr,
    maxHr,
    elevGainM,
    notes,
    sport,
    indoorSettingsJson,
    rpe0to10,
    timeZ1s,
    timeZ2s,
    timeZ3s,
    timeZ4s,
    timeZ5s,
    hrZoneMethod,
    hrMaxUsed,
    hrRestUsed,
    hrZoneBoundsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'run_session';
  @override
  VerificationContext validateIntegrity(
    Insertable<RunSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('startEpochMs')) {
      context.handle(
        _startEpochMsMeta,
        startEpochMs.isAcceptableOrUnknown(
          data['startEpochMs']!,
          _startEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startEpochMsMeta);
    }
    if (data.containsKey('endEpochMs')) {
      context.handle(
        _endEpochMsMeta,
        endEpochMs.isAcceptableOrUnknown(data['endEpochMs']!, _endEpochMsMeta),
      );
    }
    if (data.containsKey('totalDistanceM')) {
      context.handle(
        _totalDistanceMMeta,
        totalDistanceM.isAcceptableOrUnknown(
          data['totalDistanceM']!,
          _totalDistanceMMeta,
        ),
      );
    }
    if (data.containsKey('totalDurationMs')) {
      context.handle(
        _totalDurationMsMeta,
        totalDurationMs.isAcceptableOrUnknown(
          data['totalDurationMs']!,
          _totalDurationMsMeta,
        ),
      );
    }
    if (data.containsKey('avgHr')) {
      context.handle(
        _avgHrMeta,
        avgHr.isAcceptableOrUnknown(data['avgHr']!, _avgHrMeta),
      );
    }
    if (data.containsKey('maxHr')) {
      context.handle(
        _maxHrMeta,
        maxHr.isAcceptableOrUnknown(data['maxHr']!, _maxHrMeta),
      );
    }
    if (data.containsKey('elev_gain_m')) {
      context.handle(
        _elevGainMMeta,
        elevGainM.isAcceptableOrUnknown(data['elev_gain_m']!, _elevGainMMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sport')) {
      context.handle(
        _sportMeta,
        sport.isAcceptableOrUnknown(data['sport']!, _sportMeta),
      );
    }
    if (data.containsKey('indoor_settings_json')) {
      context.handle(
        _indoorSettingsJsonMeta,
        indoorSettingsJson.isAcceptableOrUnknown(
          data['indoor_settings_json']!,
          _indoorSettingsJsonMeta,
        ),
      );
    }
    if (data.containsKey('rpe_0_10')) {
      context.handle(
        _rpe0to10Meta,
        rpe0to10.isAcceptableOrUnknown(data['rpe_0_10']!, _rpe0to10Meta),
      );
    }
    if (data.containsKey('time_z1_s')) {
      context.handle(
        _timeZ1sMeta,
        timeZ1s.isAcceptableOrUnknown(data['time_z1_s']!, _timeZ1sMeta),
      );
    }
    if (data.containsKey('time_z2_s')) {
      context.handle(
        _timeZ2sMeta,
        timeZ2s.isAcceptableOrUnknown(data['time_z2_s']!, _timeZ2sMeta),
      );
    }
    if (data.containsKey('time_z3_s')) {
      context.handle(
        _timeZ3sMeta,
        timeZ3s.isAcceptableOrUnknown(data['time_z3_s']!, _timeZ3sMeta),
      );
    }
    if (data.containsKey('time_z4_s')) {
      context.handle(
        _timeZ4sMeta,
        timeZ4s.isAcceptableOrUnknown(data['time_z4_s']!, _timeZ4sMeta),
      );
    }
    if (data.containsKey('time_z5_s')) {
      context.handle(
        _timeZ5sMeta,
        timeZ5s.isAcceptableOrUnknown(data['time_z5_s']!, _timeZ5sMeta),
      );
    }
    if (data.containsKey('hr_zone_method')) {
      context.handle(
        _hrZoneMethodMeta,
        hrZoneMethod.isAcceptableOrUnknown(
          data['hr_zone_method']!,
          _hrZoneMethodMeta,
        ),
      );
    }
    if (data.containsKey('hrmax_used')) {
      context.handle(
        _hrMaxUsedMeta,
        hrMaxUsed.isAcceptableOrUnknown(data['hrmax_used']!, _hrMaxUsedMeta),
      );
    }
    if (data.containsKey('hrrest_used')) {
      context.handle(
        _hrRestUsedMeta,
        hrRestUsed.isAcceptableOrUnknown(data['hrrest_used']!, _hrRestUsedMeta),
      );
    }
    if (data.containsKey('hr_zone_bounds_json')) {
      context.handle(
        _hrZoneBoundsJsonMeta,
        hrZoneBoundsJson.isAcceptableOrUnknown(
          data['hr_zone_bounds_json']!,
          _hrZoneBoundsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RunSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RunSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}startEpochMs'],
      )!,
      endEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}endEpochMs'],
      ),
      totalDistanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}totalDistanceM'],
      )!,
      totalDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}totalDurationMs'],
      )!,
      avgHr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avgHr'],
      ),
      maxHr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}maxHr'],
      ),
      elevGainM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}elev_gain_m'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sport: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sport'],
      ),
      indoorSettingsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}indoor_settings_json'],
      ),
      rpe0to10: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rpe_0_10'],
      ),
      timeZ1s: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_z1_s'],
      )!,
      timeZ2s: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_z2_s'],
      )!,
      timeZ3s: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_z3_s'],
      )!,
      timeZ4s: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_z4_s'],
      )!,
      timeZ5s: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_z5_s'],
      )!,
      hrZoneMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hr_zone_method'],
      ),
      hrMaxUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hrmax_used'],
      ),
      hrRestUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hrrest_used'],
      ),
      hrZoneBoundsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hr_zone_bounds_json'],
      ),
    );
  }

  @override
  $RunSessionsTable createAlias(String alias) {
    return $RunSessionsTable(attachedDatabase, alias);
  }
}

class RunSession extends DataClass implements Insertable<RunSession> {
  final int id;
  final int startEpochMs;
  final int? endEpochMs;
  final double totalDistanceM;
  final int totalDurationMs;
  final int? avgHr;
  final int? maxHr;
  final double? elevGainM;
  final String? notes;
  final String? sport;
  final String? indoorSettingsJson;
  final int? rpe0to10;
  final int timeZ1s;
  final int timeZ2s;
  final int timeZ3s;
  final int timeZ4s;
  final int timeZ5s;
  final String? hrZoneMethod;
  final int? hrMaxUsed;
  final int? hrRestUsed;
  final String? hrZoneBoundsJson;
  const RunSession({
    required this.id,
    required this.startEpochMs,
    this.endEpochMs,
    required this.totalDistanceM,
    required this.totalDurationMs,
    this.avgHr,
    this.maxHr,
    this.elevGainM,
    this.notes,
    this.sport,
    this.indoorSettingsJson,
    this.rpe0to10,
    required this.timeZ1s,
    required this.timeZ2s,
    required this.timeZ3s,
    required this.timeZ4s,
    required this.timeZ5s,
    this.hrZoneMethod,
    this.hrMaxUsed,
    this.hrRestUsed,
    this.hrZoneBoundsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['startEpochMs'] = Variable<int>(startEpochMs);
    if (!nullToAbsent || endEpochMs != null) {
      map['endEpochMs'] = Variable<int>(endEpochMs);
    }
    map['totalDistanceM'] = Variable<double>(totalDistanceM);
    map['totalDurationMs'] = Variable<int>(totalDurationMs);
    if (!nullToAbsent || avgHr != null) {
      map['avgHr'] = Variable<int>(avgHr);
    }
    if (!nullToAbsent || maxHr != null) {
      map['maxHr'] = Variable<int>(maxHr);
    }
    if (!nullToAbsent || elevGainM != null) {
      map['elev_gain_m'] = Variable<double>(elevGainM);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || sport != null) {
      map['sport'] = Variable<String>(sport);
    }
    if (!nullToAbsent || indoorSettingsJson != null) {
      map['indoor_settings_json'] = Variable<String>(indoorSettingsJson);
    }
    if (!nullToAbsent || rpe0to10 != null) {
      map['rpe_0_10'] = Variable<int>(rpe0to10);
    }
    map['time_z1_s'] = Variable<int>(timeZ1s);
    map['time_z2_s'] = Variable<int>(timeZ2s);
    map['time_z3_s'] = Variable<int>(timeZ3s);
    map['time_z4_s'] = Variable<int>(timeZ4s);
    map['time_z5_s'] = Variable<int>(timeZ5s);
    if (!nullToAbsent || hrZoneMethod != null) {
      map['hr_zone_method'] = Variable<String>(hrZoneMethod);
    }
    if (!nullToAbsent || hrMaxUsed != null) {
      map['hrmax_used'] = Variable<int>(hrMaxUsed);
    }
    if (!nullToAbsent || hrRestUsed != null) {
      map['hrrest_used'] = Variable<int>(hrRestUsed);
    }
    if (!nullToAbsent || hrZoneBoundsJson != null) {
      map['hr_zone_bounds_json'] = Variable<String>(hrZoneBoundsJson);
    }
    return map;
  }

  RunSessionsCompanion toCompanion(bool nullToAbsent) {
    return RunSessionsCompanion(
      id: Value(id),
      startEpochMs: Value(startEpochMs),
      endEpochMs: endEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(endEpochMs),
      totalDistanceM: Value(totalDistanceM),
      totalDurationMs: Value(totalDurationMs),
      avgHr: avgHr == null && nullToAbsent
          ? const Value.absent()
          : Value(avgHr),
      maxHr: maxHr == null && nullToAbsent
          ? const Value.absent()
          : Value(maxHr),
      elevGainM: elevGainM == null && nullToAbsent
          ? const Value.absent()
          : Value(elevGainM),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sport: sport == null && nullToAbsent
          ? const Value.absent()
          : Value(sport),
      indoorSettingsJson: indoorSettingsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(indoorSettingsJson),
      rpe0to10: rpe0to10 == null && nullToAbsent
          ? const Value.absent()
          : Value(rpe0to10),
      timeZ1s: Value(timeZ1s),
      timeZ2s: Value(timeZ2s),
      timeZ3s: Value(timeZ3s),
      timeZ4s: Value(timeZ4s),
      timeZ5s: Value(timeZ5s),
      hrZoneMethod: hrZoneMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(hrZoneMethod),
      hrMaxUsed: hrMaxUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(hrMaxUsed),
      hrRestUsed: hrRestUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(hrRestUsed),
      hrZoneBoundsJson: hrZoneBoundsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(hrZoneBoundsJson),
    );
  }

  factory RunSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RunSession(
      id: serializer.fromJson<int>(json['id']),
      startEpochMs: serializer.fromJson<int>(json['startEpochMs']),
      endEpochMs: serializer.fromJson<int?>(json['endEpochMs']),
      totalDistanceM: serializer.fromJson<double>(json['totalDistanceM']),
      totalDurationMs: serializer.fromJson<int>(json['totalDurationMs']),
      avgHr: serializer.fromJson<int?>(json['avgHr']),
      maxHr: serializer.fromJson<int?>(json['maxHr']),
      elevGainM: serializer.fromJson<double?>(json['elevGainM']),
      notes: serializer.fromJson<String?>(json['notes']),
      sport: serializer.fromJson<String?>(json['sport']),
      indoorSettingsJson: serializer.fromJson<String?>(
        json['indoorSettingsJson'],
      ),
      rpe0to10: serializer.fromJson<int?>(json['rpe0to10']),
      timeZ1s: serializer.fromJson<int>(json['timeZ1s']),
      timeZ2s: serializer.fromJson<int>(json['timeZ2s']),
      timeZ3s: serializer.fromJson<int>(json['timeZ3s']),
      timeZ4s: serializer.fromJson<int>(json['timeZ4s']),
      timeZ5s: serializer.fromJson<int>(json['timeZ5s']),
      hrZoneMethod: serializer.fromJson<String?>(json['hrZoneMethod']),
      hrMaxUsed: serializer.fromJson<int?>(json['hrMaxUsed']),
      hrRestUsed: serializer.fromJson<int?>(json['hrRestUsed']),
      hrZoneBoundsJson: serializer.fromJson<String?>(json['hrZoneBoundsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startEpochMs': serializer.toJson<int>(startEpochMs),
      'endEpochMs': serializer.toJson<int?>(endEpochMs),
      'totalDistanceM': serializer.toJson<double>(totalDistanceM),
      'totalDurationMs': serializer.toJson<int>(totalDurationMs),
      'avgHr': serializer.toJson<int?>(avgHr),
      'maxHr': serializer.toJson<int?>(maxHr),
      'elevGainM': serializer.toJson<double?>(elevGainM),
      'notes': serializer.toJson<String?>(notes),
      'sport': serializer.toJson<String?>(sport),
      'indoorSettingsJson': serializer.toJson<String?>(indoorSettingsJson),
      'rpe0to10': serializer.toJson<int?>(rpe0to10),
      'timeZ1s': serializer.toJson<int>(timeZ1s),
      'timeZ2s': serializer.toJson<int>(timeZ2s),
      'timeZ3s': serializer.toJson<int>(timeZ3s),
      'timeZ4s': serializer.toJson<int>(timeZ4s),
      'timeZ5s': serializer.toJson<int>(timeZ5s),
      'hrZoneMethod': serializer.toJson<String?>(hrZoneMethod),
      'hrMaxUsed': serializer.toJson<int?>(hrMaxUsed),
      'hrRestUsed': serializer.toJson<int?>(hrRestUsed),
      'hrZoneBoundsJson': serializer.toJson<String?>(hrZoneBoundsJson),
    };
  }

  RunSession copyWith({
    int? id,
    int? startEpochMs,
    Value<int?> endEpochMs = const Value.absent(),
    double? totalDistanceM,
    int? totalDurationMs,
    Value<int?> avgHr = const Value.absent(),
    Value<int?> maxHr = const Value.absent(),
    Value<double?> elevGainM = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> sport = const Value.absent(),
    Value<String?> indoorSettingsJson = const Value.absent(),
    Value<int?> rpe0to10 = const Value.absent(),
    int? timeZ1s,
    int? timeZ2s,
    int? timeZ3s,
    int? timeZ4s,
    int? timeZ5s,
    Value<String?> hrZoneMethod = const Value.absent(),
    Value<int?> hrMaxUsed = const Value.absent(),
    Value<int?> hrRestUsed = const Value.absent(),
    Value<String?> hrZoneBoundsJson = const Value.absent(),
  }) => RunSession(
    id: id ?? this.id,
    startEpochMs: startEpochMs ?? this.startEpochMs,
    endEpochMs: endEpochMs.present ? endEpochMs.value : this.endEpochMs,
    totalDistanceM: totalDistanceM ?? this.totalDistanceM,
    totalDurationMs: totalDurationMs ?? this.totalDurationMs,
    avgHr: avgHr.present ? avgHr.value : this.avgHr,
    maxHr: maxHr.present ? maxHr.value : this.maxHr,
    elevGainM: elevGainM.present ? elevGainM.value : this.elevGainM,
    notes: notes.present ? notes.value : this.notes,
    sport: sport.present ? sport.value : this.sport,
    indoorSettingsJson: indoorSettingsJson.present
        ? indoorSettingsJson.value
        : this.indoorSettingsJson,
    rpe0to10: rpe0to10.present ? rpe0to10.value : this.rpe0to10,
    timeZ1s: timeZ1s ?? this.timeZ1s,
    timeZ2s: timeZ2s ?? this.timeZ2s,
    timeZ3s: timeZ3s ?? this.timeZ3s,
    timeZ4s: timeZ4s ?? this.timeZ4s,
    timeZ5s: timeZ5s ?? this.timeZ5s,
    hrZoneMethod: hrZoneMethod.present ? hrZoneMethod.value : this.hrZoneMethod,
    hrMaxUsed: hrMaxUsed.present ? hrMaxUsed.value : this.hrMaxUsed,
    hrRestUsed: hrRestUsed.present ? hrRestUsed.value : this.hrRestUsed,
    hrZoneBoundsJson: hrZoneBoundsJson.present
        ? hrZoneBoundsJson.value
        : this.hrZoneBoundsJson,
  );
  RunSession copyWithCompanion(RunSessionsCompanion data) {
    return RunSession(
      id: data.id.present ? data.id.value : this.id,
      startEpochMs: data.startEpochMs.present
          ? data.startEpochMs.value
          : this.startEpochMs,
      endEpochMs: data.endEpochMs.present
          ? data.endEpochMs.value
          : this.endEpochMs,
      totalDistanceM: data.totalDistanceM.present
          ? data.totalDistanceM.value
          : this.totalDistanceM,
      totalDurationMs: data.totalDurationMs.present
          ? data.totalDurationMs.value
          : this.totalDurationMs,
      avgHr: data.avgHr.present ? data.avgHr.value : this.avgHr,
      maxHr: data.maxHr.present ? data.maxHr.value : this.maxHr,
      elevGainM: data.elevGainM.present ? data.elevGainM.value : this.elevGainM,
      notes: data.notes.present ? data.notes.value : this.notes,
      sport: data.sport.present ? data.sport.value : this.sport,
      indoorSettingsJson: data.indoorSettingsJson.present
          ? data.indoorSettingsJson.value
          : this.indoorSettingsJson,
      rpe0to10: data.rpe0to10.present ? data.rpe0to10.value : this.rpe0to10,
      timeZ1s: data.timeZ1s.present ? data.timeZ1s.value : this.timeZ1s,
      timeZ2s: data.timeZ2s.present ? data.timeZ2s.value : this.timeZ2s,
      timeZ3s: data.timeZ3s.present ? data.timeZ3s.value : this.timeZ3s,
      timeZ4s: data.timeZ4s.present ? data.timeZ4s.value : this.timeZ4s,
      timeZ5s: data.timeZ5s.present ? data.timeZ5s.value : this.timeZ5s,
      hrZoneMethod: data.hrZoneMethod.present
          ? data.hrZoneMethod.value
          : this.hrZoneMethod,
      hrMaxUsed: data.hrMaxUsed.present ? data.hrMaxUsed.value : this.hrMaxUsed,
      hrRestUsed: data.hrRestUsed.present
          ? data.hrRestUsed.value
          : this.hrRestUsed,
      hrZoneBoundsJson: data.hrZoneBoundsJson.present
          ? data.hrZoneBoundsJson.value
          : this.hrZoneBoundsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RunSession(')
          ..write('id: $id, ')
          ..write('startEpochMs: $startEpochMs, ')
          ..write('endEpochMs: $endEpochMs, ')
          ..write('totalDistanceM: $totalDistanceM, ')
          ..write('totalDurationMs: $totalDurationMs, ')
          ..write('avgHr: $avgHr, ')
          ..write('maxHr: $maxHr, ')
          ..write('elevGainM: $elevGainM, ')
          ..write('notes: $notes, ')
          ..write('sport: $sport, ')
          ..write('indoorSettingsJson: $indoorSettingsJson, ')
          ..write('rpe0to10: $rpe0to10, ')
          ..write('timeZ1s: $timeZ1s, ')
          ..write('timeZ2s: $timeZ2s, ')
          ..write('timeZ3s: $timeZ3s, ')
          ..write('timeZ4s: $timeZ4s, ')
          ..write('timeZ5s: $timeZ5s, ')
          ..write('hrZoneMethod: $hrZoneMethod, ')
          ..write('hrMaxUsed: $hrMaxUsed, ')
          ..write('hrRestUsed: $hrRestUsed, ')
          ..write('hrZoneBoundsJson: $hrZoneBoundsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    startEpochMs,
    endEpochMs,
    totalDistanceM,
    totalDurationMs,
    avgHr,
    maxHr,
    elevGainM,
    notes,
    sport,
    indoorSettingsJson,
    rpe0to10,
    timeZ1s,
    timeZ2s,
    timeZ3s,
    timeZ4s,
    timeZ5s,
    hrZoneMethod,
    hrMaxUsed,
    hrRestUsed,
    hrZoneBoundsJson,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RunSession &&
          other.id == this.id &&
          other.startEpochMs == this.startEpochMs &&
          other.endEpochMs == this.endEpochMs &&
          other.totalDistanceM == this.totalDistanceM &&
          other.totalDurationMs == this.totalDurationMs &&
          other.avgHr == this.avgHr &&
          other.maxHr == this.maxHr &&
          other.elevGainM == this.elevGainM &&
          other.notes == this.notes &&
          other.sport == this.sport &&
          other.indoorSettingsJson == this.indoorSettingsJson &&
          other.rpe0to10 == this.rpe0to10 &&
          other.timeZ1s == this.timeZ1s &&
          other.timeZ2s == this.timeZ2s &&
          other.timeZ3s == this.timeZ3s &&
          other.timeZ4s == this.timeZ4s &&
          other.timeZ5s == this.timeZ5s &&
          other.hrZoneMethod == this.hrZoneMethod &&
          other.hrMaxUsed == this.hrMaxUsed &&
          other.hrRestUsed == this.hrRestUsed &&
          other.hrZoneBoundsJson == this.hrZoneBoundsJson);
}

class RunSessionsCompanion extends UpdateCompanion<RunSession> {
  final Value<int> id;
  final Value<int> startEpochMs;
  final Value<int?> endEpochMs;
  final Value<double> totalDistanceM;
  final Value<int> totalDurationMs;
  final Value<int?> avgHr;
  final Value<int?> maxHr;
  final Value<double?> elevGainM;
  final Value<String?> notes;
  final Value<String?> sport;
  final Value<String?> indoorSettingsJson;
  final Value<int?> rpe0to10;
  final Value<int> timeZ1s;
  final Value<int> timeZ2s;
  final Value<int> timeZ3s;
  final Value<int> timeZ4s;
  final Value<int> timeZ5s;
  final Value<String?> hrZoneMethod;
  final Value<int?> hrMaxUsed;
  final Value<int?> hrRestUsed;
  final Value<String?> hrZoneBoundsJson;
  const RunSessionsCompanion({
    this.id = const Value.absent(),
    this.startEpochMs = const Value.absent(),
    this.endEpochMs = const Value.absent(),
    this.totalDistanceM = const Value.absent(),
    this.totalDurationMs = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.maxHr = const Value.absent(),
    this.elevGainM = const Value.absent(),
    this.notes = const Value.absent(),
    this.sport = const Value.absent(),
    this.indoorSettingsJson = const Value.absent(),
    this.rpe0to10 = const Value.absent(),
    this.timeZ1s = const Value.absent(),
    this.timeZ2s = const Value.absent(),
    this.timeZ3s = const Value.absent(),
    this.timeZ4s = const Value.absent(),
    this.timeZ5s = const Value.absent(),
    this.hrZoneMethod = const Value.absent(),
    this.hrMaxUsed = const Value.absent(),
    this.hrRestUsed = const Value.absent(),
    this.hrZoneBoundsJson = const Value.absent(),
  });
  RunSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int startEpochMs,
    this.endEpochMs = const Value.absent(),
    this.totalDistanceM = const Value.absent(),
    this.totalDurationMs = const Value.absent(),
    this.avgHr = const Value.absent(),
    this.maxHr = const Value.absent(),
    this.elevGainM = const Value.absent(),
    this.notes = const Value.absent(),
    this.sport = const Value.absent(),
    this.indoorSettingsJson = const Value.absent(),
    this.rpe0to10 = const Value.absent(),
    this.timeZ1s = const Value.absent(),
    this.timeZ2s = const Value.absent(),
    this.timeZ3s = const Value.absent(),
    this.timeZ4s = const Value.absent(),
    this.timeZ5s = const Value.absent(),
    this.hrZoneMethod = const Value.absent(),
    this.hrMaxUsed = const Value.absent(),
    this.hrRestUsed = const Value.absent(),
    this.hrZoneBoundsJson = const Value.absent(),
  }) : startEpochMs = Value(startEpochMs);
  static Insertable<RunSession> custom({
    Expression<int>? id,
    Expression<int>? startEpochMs,
    Expression<int>? endEpochMs,
    Expression<double>? totalDistanceM,
    Expression<int>? totalDurationMs,
    Expression<int>? avgHr,
    Expression<int>? maxHr,
    Expression<double>? elevGainM,
    Expression<String>? notes,
    Expression<String>? sport,
    Expression<String>? indoorSettingsJson,
    Expression<int>? rpe0to10,
    Expression<int>? timeZ1s,
    Expression<int>? timeZ2s,
    Expression<int>? timeZ3s,
    Expression<int>? timeZ4s,
    Expression<int>? timeZ5s,
    Expression<String>? hrZoneMethod,
    Expression<int>? hrMaxUsed,
    Expression<int>? hrRestUsed,
    Expression<String>? hrZoneBoundsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startEpochMs != null) 'startEpochMs': startEpochMs,
      if (endEpochMs != null) 'endEpochMs': endEpochMs,
      if (totalDistanceM != null) 'totalDistanceM': totalDistanceM,
      if (totalDurationMs != null) 'totalDurationMs': totalDurationMs,
      if (avgHr != null) 'avgHr': avgHr,
      if (maxHr != null) 'maxHr': maxHr,
      if (elevGainM != null) 'elev_gain_m': elevGainM,
      if (notes != null) 'notes': notes,
      if (sport != null) 'sport': sport,
      if (indoorSettingsJson != null)
        'indoor_settings_json': indoorSettingsJson,
      if (rpe0to10 != null) 'rpe_0_10': rpe0to10,
      if (timeZ1s != null) 'time_z1_s': timeZ1s,
      if (timeZ2s != null) 'time_z2_s': timeZ2s,
      if (timeZ3s != null) 'time_z3_s': timeZ3s,
      if (timeZ4s != null) 'time_z4_s': timeZ4s,
      if (timeZ5s != null) 'time_z5_s': timeZ5s,
      if (hrZoneMethod != null) 'hr_zone_method': hrZoneMethod,
      if (hrMaxUsed != null) 'hrmax_used': hrMaxUsed,
      if (hrRestUsed != null) 'hrrest_used': hrRestUsed,
      if (hrZoneBoundsJson != null) 'hr_zone_bounds_json': hrZoneBoundsJson,
    });
  }

  RunSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? startEpochMs,
    Value<int?>? endEpochMs,
    Value<double>? totalDistanceM,
    Value<int>? totalDurationMs,
    Value<int?>? avgHr,
    Value<int?>? maxHr,
    Value<double?>? elevGainM,
    Value<String?>? notes,
    Value<String?>? sport,
    Value<String?>? indoorSettingsJson,
    Value<int?>? rpe0to10,
    Value<int>? timeZ1s,
    Value<int>? timeZ2s,
    Value<int>? timeZ3s,
    Value<int>? timeZ4s,
    Value<int>? timeZ5s,
    Value<String?>? hrZoneMethod,
    Value<int?>? hrMaxUsed,
    Value<int?>? hrRestUsed,
    Value<String?>? hrZoneBoundsJson,
  }) {
    return RunSessionsCompanion(
      id: id ?? this.id,
      startEpochMs: startEpochMs ?? this.startEpochMs,
      endEpochMs: endEpochMs ?? this.endEpochMs,
      totalDistanceM: totalDistanceM ?? this.totalDistanceM,
      totalDurationMs: totalDurationMs ?? this.totalDurationMs,
      avgHr: avgHr ?? this.avgHr,
      maxHr: maxHr ?? this.maxHr,
      elevGainM: elevGainM ?? this.elevGainM,
      notes: notes ?? this.notes,
      sport: sport ?? this.sport,
      indoorSettingsJson: indoorSettingsJson ?? this.indoorSettingsJson,
      rpe0to10: rpe0to10 ?? this.rpe0to10,
      timeZ1s: timeZ1s ?? this.timeZ1s,
      timeZ2s: timeZ2s ?? this.timeZ2s,
      timeZ3s: timeZ3s ?? this.timeZ3s,
      timeZ4s: timeZ4s ?? this.timeZ4s,
      timeZ5s: timeZ5s ?? this.timeZ5s,
      hrZoneMethod: hrZoneMethod ?? this.hrZoneMethod,
      hrMaxUsed: hrMaxUsed ?? this.hrMaxUsed,
      hrRestUsed: hrRestUsed ?? this.hrRestUsed,
      hrZoneBoundsJson: hrZoneBoundsJson ?? this.hrZoneBoundsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startEpochMs.present) {
      map['startEpochMs'] = Variable<int>(startEpochMs.value);
    }
    if (endEpochMs.present) {
      map['endEpochMs'] = Variable<int>(endEpochMs.value);
    }
    if (totalDistanceM.present) {
      map['totalDistanceM'] = Variable<double>(totalDistanceM.value);
    }
    if (totalDurationMs.present) {
      map['totalDurationMs'] = Variable<int>(totalDurationMs.value);
    }
    if (avgHr.present) {
      map['avgHr'] = Variable<int>(avgHr.value);
    }
    if (maxHr.present) {
      map['maxHr'] = Variable<int>(maxHr.value);
    }
    if (elevGainM.present) {
      map['elev_gain_m'] = Variable<double>(elevGainM.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sport.present) {
      map['sport'] = Variable<String>(sport.value);
    }
    if (indoorSettingsJson.present) {
      map['indoor_settings_json'] = Variable<String>(indoorSettingsJson.value);
    }
    if (rpe0to10.present) {
      map['rpe_0_10'] = Variable<int>(rpe0to10.value);
    }
    if (timeZ1s.present) {
      map['time_z1_s'] = Variable<int>(timeZ1s.value);
    }
    if (timeZ2s.present) {
      map['time_z2_s'] = Variable<int>(timeZ2s.value);
    }
    if (timeZ3s.present) {
      map['time_z3_s'] = Variable<int>(timeZ3s.value);
    }
    if (timeZ4s.present) {
      map['time_z4_s'] = Variable<int>(timeZ4s.value);
    }
    if (timeZ5s.present) {
      map['time_z5_s'] = Variable<int>(timeZ5s.value);
    }
    if (hrZoneMethod.present) {
      map['hr_zone_method'] = Variable<String>(hrZoneMethod.value);
    }
    if (hrMaxUsed.present) {
      map['hrmax_used'] = Variable<int>(hrMaxUsed.value);
    }
    if (hrRestUsed.present) {
      map['hrrest_used'] = Variable<int>(hrRestUsed.value);
    }
    if (hrZoneBoundsJson.present) {
      map['hr_zone_bounds_json'] = Variable<String>(hrZoneBoundsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RunSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startEpochMs: $startEpochMs, ')
          ..write('endEpochMs: $endEpochMs, ')
          ..write('totalDistanceM: $totalDistanceM, ')
          ..write('totalDurationMs: $totalDurationMs, ')
          ..write('avgHr: $avgHr, ')
          ..write('maxHr: $maxHr, ')
          ..write('elevGainM: $elevGainM, ')
          ..write('notes: $notes, ')
          ..write('sport: $sport, ')
          ..write('indoorSettingsJson: $indoorSettingsJson, ')
          ..write('rpe0to10: $rpe0to10, ')
          ..write('timeZ1s: $timeZ1s, ')
          ..write('timeZ2s: $timeZ2s, ')
          ..write('timeZ3s: $timeZ3s, ')
          ..write('timeZ4s: $timeZ4s, ')
          ..write('timeZ5s: $timeZ5s, ')
          ..write('hrZoneMethod: $hrZoneMethod, ')
          ..write('hrMaxUsed: $hrMaxUsed, ')
          ..write('hrRestUsed: $hrRestUsed, ')
          ..write('hrZoneBoundsJson: $hrZoneBoundsJson')
          ..write(')'))
        .toString();
  }
}

class $RunSamplesTable extends RunSamples
    with TableInfo<$RunSamplesTable, RunSample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RunSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sidMeta = const VerificationMeta('sid');
  @override
  late final GeneratedColumn<int> sid = GeneratedColumn<int>(
    'sid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'sessionId',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES run_session (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tEpochMsMeta = const VerificationMeta(
    'tEpochMs',
  );
  @override
  late final GeneratedColumn<int> tEpochMs = GeneratedColumn<int>(
    'tEpochMs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hrMeta = const VerificationMeta('hr');
  @override
  late final GeneratedColumn<int> hr = GeneratedColumn<int>(
    'hr',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accMMeta = const VerificationMeta('accM');
  @override
  late final GeneratedColumn<double> accM = GeneratedColumn<double>(
    'accM',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedMpsMeta = const VerificationMeta(
    'speedMps',
  );
  @override
  late final GeneratedColumn<double> speedMps = GeneratedColumn<double>(
    'speedMps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _elevMMeta = const VerificationMeta('elevM');
  @override
  late final GeneratedColumn<double> elevM = GeneratedColumn<double>(
    'elev_m',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sid,
    sessionId,
    tEpochMs,
    lat,
    lon,
    hr,
    accM,
    speedMps,
    elevM,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'run_sample';
  @override
  VerificationContext validateIntegrity(
    Insertable<RunSample> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sid')) {
      context.handle(
        _sidMeta,
        sid.isAcceptableOrUnknown(data['sid']!, _sidMeta),
      );
    }
    if (data.containsKey('sessionId')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['sessionId']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('tEpochMs')) {
      context.handle(
        _tEpochMsMeta,
        tEpochMs.isAcceptableOrUnknown(data['tEpochMs']!, _tEpochMsMeta),
      );
    } else if (isInserting) {
      context.missing(_tEpochMsMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    if (data.containsKey('hr')) {
      context.handle(_hrMeta, hr.isAcceptableOrUnknown(data['hr']!, _hrMeta));
    }
    if (data.containsKey('accM')) {
      context.handle(
        _accMMeta,
        accM.isAcceptableOrUnknown(data['accM']!, _accMMeta),
      );
    }
    if (data.containsKey('speedMps')) {
      context.handle(
        _speedMpsMeta,
        speedMps.isAcceptableOrUnknown(data['speedMps']!, _speedMpsMeta),
      );
    }
    if (data.containsKey('elev_m')) {
      context.handle(
        _elevMMeta,
        elevM.isAcceptableOrUnknown(data['elev_m']!, _elevMMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sid};
  @override
  RunSample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RunSample(
      sid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sid'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sessionId'],
      )!,
      tEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tEpochMs'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      )!,
      hr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hr'],
      ),
      accM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accM'],
      ),
      speedMps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speedMps'],
      ),
      elevM: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}elev_m'],
      ),
    );
  }

  @override
  $RunSamplesTable createAlias(String alias) {
    return $RunSamplesTable(attachedDatabase, alias);
  }
}

class RunSample extends DataClass implements Insertable<RunSample> {
  final int sid;
  final int sessionId;
  final int tEpochMs;
  final double lat;
  final double lon;
  final int? hr;
  final double? accM;
  final double? speedMps;
  final double? elevM;
  const RunSample({
    required this.sid,
    required this.sessionId,
    required this.tEpochMs,
    required this.lat,
    required this.lon,
    this.hr,
    this.accM,
    this.speedMps,
    this.elevM,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sid'] = Variable<int>(sid);
    map['sessionId'] = Variable<int>(sessionId);
    map['tEpochMs'] = Variable<int>(tEpochMs);
    map['lat'] = Variable<double>(lat);
    map['lon'] = Variable<double>(lon);
    if (!nullToAbsent || hr != null) {
      map['hr'] = Variable<int>(hr);
    }
    if (!nullToAbsent || accM != null) {
      map['accM'] = Variable<double>(accM);
    }
    if (!nullToAbsent || speedMps != null) {
      map['speedMps'] = Variable<double>(speedMps);
    }
    if (!nullToAbsent || elevM != null) {
      map['elev_m'] = Variable<double>(elevM);
    }
    return map;
  }

  RunSamplesCompanion toCompanion(bool nullToAbsent) {
    return RunSamplesCompanion(
      sid: Value(sid),
      sessionId: Value(sessionId),
      tEpochMs: Value(tEpochMs),
      lat: Value(lat),
      lon: Value(lon),
      hr: hr == null && nullToAbsent ? const Value.absent() : Value(hr),
      accM: accM == null && nullToAbsent ? const Value.absent() : Value(accM),
      speedMps: speedMps == null && nullToAbsent
          ? const Value.absent()
          : Value(speedMps),
      elevM: elevM == null && nullToAbsent
          ? const Value.absent()
          : Value(elevM),
    );
  }

  factory RunSample.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RunSample(
      sid: serializer.fromJson<int>(json['sid']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      tEpochMs: serializer.fromJson<int>(json['tEpochMs']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
      hr: serializer.fromJson<int?>(json['hr']),
      accM: serializer.fromJson<double?>(json['accM']),
      speedMps: serializer.fromJson<double?>(json['speedMps']),
      elevM: serializer.fromJson<double?>(json['elevM']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sid': serializer.toJson<int>(sid),
      'sessionId': serializer.toJson<int>(sessionId),
      'tEpochMs': serializer.toJson<int>(tEpochMs),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
      'hr': serializer.toJson<int?>(hr),
      'accM': serializer.toJson<double?>(accM),
      'speedMps': serializer.toJson<double?>(speedMps),
      'elevM': serializer.toJson<double?>(elevM),
    };
  }

  RunSample copyWith({
    int? sid,
    int? sessionId,
    int? tEpochMs,
    double? lat,
    double? lon,
    Value<int?> hr = const Value.absent(),
    Value<double?> accM = const Value.absent(),
    Value<double?> speedMps = const Value.absent(),
    Value<double?> elevM = const Value.absent(),
  }) => RunSample(
    sid: sid ?? this.sid,
    sessionId: sessionId ?? this.sessionId,
    tEpochMs: tEpochMs ?? this.tEpochMs,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
    hr: hr.present ? hr.value : this.hr,
    accM: accM.present ? accM.value : this.accM,
    speedMps: speedMps.present ? speedMps.value : this.speedMps,
    elevM: elevM.present ? elevM.value : this.elevM,
  );
  RunSample copyWithCompanion(RunSamplesCompanion data) {
    return RunSample(
      sid: data.sid.present ? data.sid.value : this.sid,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      tEpochMs: data.tEpochMs.present ? data.tEpochMs.value : this.tEpochMs,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      hr: data.hr.present ? data.hr.value : this.hr,
      accM: data.accM.present ? data.accM.value : this.accM,
      speedMps: data.speedMps.present ? data.speedMps.value : this.speedMps,
      elevM: data.elevM.present ? data.elevM.value : this.elevM,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RunSample(')
          ..write('sid: $sid, ')
          ..write('sessionId: $sessionId, ')
          ..write('tEpochMs: $tEpochMs, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('hr: $hr, ')
          ..write('accM: $accM, ')
          ..write('speedMps: $speedMps, ')
          ..write('elevM: $elevM')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sid,
    sessionId,
    tEpochMs,
    lat,
    lon,
    hr,
    accM,
    speedMps,
    elevM,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RunSample &&
          other.sid == this.sid &&
          other.sessionId == this.sessionId &&
          other.tEpochMs == this.tEpochMs &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.hr == this.hr &&
          other.accM == this.accM &&
          other.speedMps == this.speedMps &&
          other.elevM == this.elevM);
}

class RunSamplesCompanion extends UpdateCompanion<RunSample> {
  final Value<int> sid;
  final Value<int> sessionId;
  final Value<int> tEpochMs;
  final Value<double> lat;
  final Value<double> lon;
  final Value<int?> hr;
  final Value<double?> accM;
  final Value<double?> speedMps;
  final Value<double?> elevM;
  const RunSamplesCompanion({
    this.sid = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.tEpochMs = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.hr = const Value.absent(),
    this.accM = const Value.absent(),
    this.speedMps = const Value.absent(),
    this.elevM = const Value.absent(),
  });
  RunSamplesCompanion.insert({
    this.sid = const Value.absent(),
    required int sessionId,
    required int tEpochMs,
    required double lat,
    required double lon,
    this.hr = const Value.absent(),
    this.accM = const Value.absent(),
    this.speedMps = const Value.absent(),
    this.elevM = const Value.absent(),
  }) : sessionId = Value(sessionId),
       tEpochMs = Value(tEpochMs),
       lat = Value(lat),
       lon = Value(lon);
  static Insertable<RunSample> custom({
    Expression<int>? sid,
    Expression<int>? sessionId,
    Expression<int>? tEpochMs,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<int>? hr,
    Expression<double>? accM,
    Expression<double>? speedMps,
    Expression<double>? elevM,
  }) {
    return RawValuesInsertable({
      if (sid != null) 'sid': sid,
      if (sessionId != null) 'sessionId': sessionId,
      if (tEpochMs != null) 'tEpochMs': tEpochMs,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (hr != null) 'hr': hr,
      if (accM != null) 'accM': accM,
      if (speedMps != null) 'speedMps': speedMps,
      if (elevM != null) 'elev_m': elevM,
    });
  }

  RunSamplesCompanion copyWith({
    Value<int>? sid,
    Value<int>? sessionId,
    Value<int>? tEpochMs,
    Value<double>? lat,
    Value<double>? lon,
    Value<int?>? hr,
    Value<double?>? accM,
    Value<double?>? speedMps,
    Value<double?>? elevM,
  }) {
    return RunSamplesCompanion(
      sid: sid ?? this.sid,
      sessionId: sessionId ?? this.sessionId,
      tEpochMs: tEpochMs ?? this.tEpochMs,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      hr: hr ?? this.hr,
      accM: accM ?? this.accM,
      speedMps: speedMps ?? this.speedMps,
      elevM: elevM ?? this.elevM,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sid.present) {
      map['sid'] = Variable<int>(sid.value);
    }
    if (sessionId.present) {
      map['sessionId'] = Variable<int>(sessionId.value);
    }
    if (tEpochMs.present) {
      map['tEpochMs'] = Variable<int>(tEpochMs.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (hr.present) {
      map['hr'] = Variable<int>(hr.value);
    }
    if (accM.present) {
      map['accM'] = Variable<double>(accM.value);
    }
    if (speedMps.present) {
      map['speedMps'] = Variable<double>(speedMps.value);
    }
    if (elevM.present) {
      map['elev_m'] = Variable<double>(elevM.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RunSamplesCompanion(')
          ..write('sid: $sid, ')
          ..write('sessionId: $sessionId, ')
          ..write('tEpochMs: $tEpochMs, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('hr: $hr, ')
          ..write('accM: $accM, ')
          ..write('speedMps: $speedMps, ')
          ..write('elevM: $elevM')
          ..write(')'))
        .toString();
  }
}

class $StrengthSessionsTable extends StrengthSessions
    with TableInfo<$StrengthSessionsTable, StrengthSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StrengthSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startEpochMsMeta = const VerificationMeta(
    'startEpochMs',
  );
  @override
  late final GeneratedColumn<int> startEpochMs = GeneratedColumn<int>(
    'startEpochMs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endEpochMsMeta = const VerificationMeta(
    'endEpochMs',
  );
  @override
  late final GeneratedColumn<int> endEpochMs = GeneratedColumn<int>(
    'endEpochMs',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, startEpochMs, endEpochMs, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'strength_session';
  @override
  VerificationContext validateIntegrity(
    Insertable<StrengthSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('startEpochMs')) {
      context.handle(
        _startEpochMsMeta,
        startEpochMs.isAcceptableOrUnknown(
          data['startEpochMs']!,
          _startEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startEpochMsMeta);
    }
    if (data.containsKey('endEpochMs')) {
      context.handle(
        _endEpochMsMeta,
        endEpochMs.isAcceptableOrUnknown(data['endEpochMs']!, _endEpochMsMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StrengthSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrengthSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}startEpochMs'],
      )!,
      endEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}endEpochMs'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $StrengthSessionsTable createAlias(String alias) {
    return $StrengthSessionsTable(attachedDatabase, alias);
  }
}

class StrengthSession extends DataClass implements Insertable<StrengthSession> {
  final int id;
  final int startEpochMs;
  final int? endEpochMs;
  final String? notes;
  const StrengthSession({
    required this.id,
    required this.startEpochMs,
    this.endEpochMs,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['startEpochMs'] = Variable<int>(startEpochMs);
    if (!nullToAbsent || endEpochMs != null) {
      map['endEpochMs'] = Variable<int>(endEpochMs);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  StrengthSessionsCompanion toCompanion(bool nullToAbsent) {
    return StrengthSessionsCompanion(
      id: Value(id),
      startEpochMs: Value(startEpochMs),
      endEpochMs: endEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(endEpochMs),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory StrengthSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StrengthSession(
      id: serializer.fromJson<int>(json['id']),
      startEpochMs: serializer.fromJson<int>(json['startEpochMs']),
      endEpochMs: serializer.fromJson<int?>(json['endEpochMs']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startEpochMs': serializer.toJson<int>(startEpochMs),
      'endEpochMs': serializer.toJson<int?>(endEpochMs),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  StrengthSession copyWith({
    int? id,
    int? startEpochMs,
    Value<int?> endEpochMs = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => StrengthSession(
    id: id ?? this.id,
    startEpochMs: startEpochMs ?? this.startEpochMs,
    endEpochMs: endEpochMs.present ? endEpochMs.value : this.endEpochMs,
    notes: notes.present ? notes.value : this.notes,
  );
  StrengthSession copyWithCompanion(StrengthSessionsCompanion data) {
    return StrengthSession(
      id: data.id.present ? data.id.value : this.id,
      startEpochMs: data.startEpochMs.present
          ? data.startEpochMs.value
          : this.startEpochMs,
      endEpochMs: data.endEpochMs.present
          ? data.endEpochMs.value
          : this.endEpochMs,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StrengthSession(')
          ..write('id: $id, ')
          ..write('startEpochMs: $startEpochMs, ')
          ..write('endEpochMs: $endEpochMs, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startEpochMs, endEpochMs, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StrengthSession &&
          other.id == this.id &&
          other.startEpochMs == this.startEpochMs &&
          other.endEpochMs == this.endEpochMs &&
          other.notes == this.notes);
}

class StrengthSessionsCompanion extends UpdateCompanion<StrengthSession> {
  final Value<int> id;
  final Value<int> startEpochMs;
  final Value<int?> endEpochMs;
  final Value<String?> notes;
  const StrengthSessionsCompanion({
    this.id = const Value.absent(),
    this.startEpochMs = const Value.absent(),
    this.endEpochMs = const Value.absent(),
    this.notes = const Value.absent(),
  });
  StrengthSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int startEpochMs,
    this.endEpochMs = const Value.absent(),
    this.notes = const Value.absent(),
  }) : startEpochMs = Value(startEpochMs);
  static Insertable<StrengthSession> custom({
    Expression<int>? id,
    Expression<int>? startEpochMs,
    Expression<int>? endEpochMs,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startEpochMs != null) 'startEpochMs': startEpochMs,
      if (endEpochMs != null) 'endEpochMs': endEpochMs,
      if (notes != null) 'notes': notes,
    });
  }

  StrengthSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? startEpochMs,
    Value<int?>? endEpochMs,
    Value<String?>? notes,
  }) {
    return StrengthSessionsCompanion(
      id: id ?? this.id,
      startEpochMs: startEpochMs ?? this.startEpochMs,
      endEpochMs: endEpochMs ?? this.endEpochMs,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startEpochMs.present) {
      map['startEpochMs'] = Variable<int>(startEpochMs.value);
    }
    if (endEpochMs.present) {
      map['endEpochMs'] = Variable<int>(endEpochMs.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrengthSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startEpochMs: $startEpochMs, ')
          ..write('endEpochMs: $endEpochMs, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $StrengthSetsTable extends StrengthSets
    with TableInfo<$StrengthSetsTable, StrengthSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StrengthSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sidMeta = const VerificationMeta('sid');
  @override
  late final GeneratedColumn<int> sid = GeneratedColumn<int>(
    'sid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'sessionId',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES strength_session (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exerciseId',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exerciseName',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'setNumber',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<double> reps = GeneratedColumn<double>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'durationSec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weightKg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAllOutMeta = const VerificationMeta(
    'isAllOut',
  );
  @override
  late final GeneratedColumn<bool> isAllOut = GeneratedColumn<bool>(
    'isAllOut',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("isAllOut" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isBfrMeta = const VerificationMeta('isBfr');
  @override
  late final GeneratedColumn<bool> isBfr = GeneratedColumn<bool>(
    'isBfr',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("isBfr" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _bfrPercentMeta = const VerificationMeta(
    'bfrPercent',
  );
  @override
  late final GeneratedColumn<int> bfrPercent = GeneratedColumn<int>(
    'bfrPercent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chainsKgMeta = const VerificationMeta(
    'chainsKg',
  );
  @override
  late final GeneratedColumn<double> chainsKg = GeneratedColumn<double>(
    'chainsKg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bandsKgMeta = const VerificationMeta(
    'bandsKg',
  );
  @override
  late final GeneratedColumn<double> bandsKg = GeneratedColumn<double>(
    'bandsKg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSuperSlowMeta = const VerificationMeta(
    'isSuperSlow',
  );
  @override
  late final GeneratedColumn<bool> isSuperSlow = GeneratedColumn<bool>(
    'isSuperSlow',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("isSuperSlow" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _superSlowNoteMeta = const VerificationMeta(
    'superSlowNote',
  );
  @override
  late final GeneratedColumn<String> superSlowNote = GeneratedColumn<String>(
    'superSlowNote',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supersetGroupIdMeta = const VerificationMeta(
    'supersetGroupId',
  );
  @override
  late final GeneratedColumn<String> supersetGroupId = GeneratedColumn<String>(
    'supersetGroupId',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sid,
    sessionId,
    exerciseId,
    exerciseName,
    setNumber,
    reps,
    durationSec,
    weightKg,
    isAllOut,
    isBfr,
    bfrPercent,
    chainsKg,
    bandsKg,
    isSuperSlow,
    superSlowNote,
    supersetGroupId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'strength_set';
  @override
  VerificationContext validateIntegrity(
    Insertable<StrengthSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sid')) {
      context.handle(
        _sidMeta,
        sid.isAcceptableOrUnknown(data['sid']!, _sidMeta),
      );
    }
    if (data.containsKey('sessionId')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['sessionId']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exerciseId')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exerciseId']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('exerciseName')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exerciseName']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('setNumber')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['setNumber']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('durationSec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['durationSec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('weightKg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weightKg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('isAllOut')) {
      context.handle(
        _isAllOutMeta,
        isAllOut.isAcceptableOrUnknown(data['isAllOut']!, _isAllOutMeta),
      );
    }
    if (data.containsKey('isBfr')) {
      context.handle(
        _isBfrMeta,
        isBfr.isAcceptableOrUnknown(data['isBfr']!, _isBfrMeta),
      );
    }
    if (data.containsKey('bfrPercent')) {
      context.handle(
        _bfrPercentMeta,
        bfrPercent.isAcceptableOrUnknown(data['bfrPercent']!, _bfrPercentMeta),
      );
    }
    if (data.containsKey('chainsKg')) {
      context.handle(
        _chainsKgMeta,
        chainsKg.isAcceptableOrUnknown(data['chainsKg']!, _chainsKgMeta),
      );
    }
    if (data.containsKey('bandsKg')) {
      context.handle(
        _bandsKgMeta,
        bandsKg.isAcceptableOrUnknown(data['bandsKg']!, _bandsKgMeta),
      );
    }
    if (data.containsKey('isSuperSlow')) {
      context.handle(
        _isSuperSlowMeta,
        isSuperSlow.isAcceptableOrUnknown(
          data['isSuperSlow']!,
          _isSuperSlowMeta,
        ),
      );
    }
    if (data.containsKey('superSlowNote')) {
      context.handle(
        _superSlowNoteMeta,
        superSlowNote.isAcceptableOrUnknown(
          data['superSlowNote']!,
          _superSlowNoteMeta,
        ),
      );
    }
    if (data.containsKey('supersetGroupId')) {
      context.handle(
        _supersetGroupIdMeta,
        supersetGroupId.isAcceptableOrUnknown(
          data['supersetGroupId']!,
          _supersetGroupIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sid};
  @override
  StrengthSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrengthSet(
      sid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sid'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sessionId'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exerciseId'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exerciseName'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}setNumber'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reps'],
      )!,
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}durationSec'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weightKg'],
      )!,
      isAllOut: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}isAllOut'],
      )!,
      isBfr: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}isBfr'],
      )!,
      bfrPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bfrPercent'],
      ),
      chainsKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chainsKg'],
      ),
      bandsKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bandsKg'],
      ),
      isSuperSlow: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}isSuperSlow'],
      )!,
      superSlowNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}superSlowNote'],
      ),
      supersetGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supersetGroupId'],
      ),
    );
  }

  @override
  $StrengthSetsTable createAlias(String alias) {
    return $StrengthSetsTable(attachedDatabase, alias);
  }
}

class StrengthSet extends DataClass implements Insertable<StrengthSet> {
  final int sid;
  final int sessionId;
  final String exerciseId;
  final String exerciseName;
  final int setNumber;
  final double reps;
  final int? durationSec;
  final double weightKg;
  final bool isAllOut;
  final bool isBfr;
  final int? bfrPercent;
  final double? chainsKg;
  final double? bandsKg;
  final bool isSuperSlow;
  final String? superSlowNote;
  final String? supersetGroupId;
  const StrengthSet({
    required this.sid,
    required this.sessionId,
    required this.exerciseId,
    required this.exerciseName,
    required this.setNumber,
    required this.reps,
    this.durationSec,
    required this.weightKg,
    required this.isAllOut,
    required this.isBfr,
    this.bfrPercent,
    this.chainsKg,
    this.bandsKg,
    required this.isSuperSlow,
    this.superSlowNote,
    this.supersetGroupId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sid'] = Variable<int>(sid);
    map['sessionId'] = Variable<int>(sessionId);
    map['exerciseId'] = Variable<String>(exerciseId);
    map['exerciseName'] = Variable<String>(exerciseName);
    map['setNumber'] = Variable<int>(setNumber);
    map['reps'] = Variable<double>(reps);
    if (!nullToAbsent || durationSec != null) {
      map['durationSec'] = Variable<int>(durationSec);
    }
    map['weightKg'] = Variable<double>(weightKg);
    map['isAllOut'] = Variable<bool>(isAllOut);
    map['isBfr'] = Variable<bool>(isBfr);
    if (!nullToAbsent || bfrPercent != null) {
      map['bfrPercent'] = Variable<int>(bfrPercent);
    }
    if (!nullToAbsent || chainsKg != null) {
      map['chainsKg'] = Variable<double>(chainsKg);
    }
    if (!nullToAbsent || bandsKg != null) {
      map['bandsKg'] = Variable<double>(bandsKg);
    }
    map['isSuperSlow'] = Variable<bool>(isSuperSlow);
    if (!nullToAbsent || superSlowNote != null) {
      map['superSlowNote'] = Variable<String>(superSlowNote);
    }
    if (!nullToAbsent || supersetGroupId != null) {
      map['supersetGroupId'] = Variable<String>(supersetGroupId);
    }
    return map;
  }

  StrengthSetsCompanion toCompanion(bool nullToAbsent) {
    return StrengthSetsCompanion(
      sid: Value(sid),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      exerciseName: Value(exerciseName),
      setNumber: Value(setNumber),
      reps: Value(reps),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      weightKg: Value(weightKg),
      isAllOut: Value(isAllOut),
      isBfr: Value(isBfr),
      bfrPercent: bfrPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(bfrPercent),
      chainsKg: chainsKg == null && nullToAbsent
          ? const Value.absent()
          : Value(chainsKg),
      bandsKg: bandsKg == null && nullToAbsent
          ? const Value.absent()
          : Value(bandsKg),
      isSuperSlow: Value(isSuperSlow),
      superSlowNote: superSlowNote == null && nullToAbsent
          ? const Value.absent()
          : Value(superSlowNote),
      supersetGroupId: supersetGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(supersetGroupId),
    );
  }

  factory StrengthSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StrengthSet(
      sid: serializer.fromJson<int>(json['sid']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      reps: serializer.fromJson<double>(json['reps']),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      isAllOut: serializer.fromJson<bool>(json['isAllOut']),
      isBfr: serializer.fromJson<bool>(json['isBfr']),
      bfrPercent: serializer.fromJson<int?>(json['bfrPercent']),
      chainsKg: serializer.fromJson<double?>(json['chainsKg']),
      bandsKg: serializer.fromJson<double?>(json['bandsKg']),
      isSuperSlow: serializer.fromJson<bool>(json['isSuperSlow']),
      superSlowNote: serializer.fromJson<String?>(json['superSlowNote']),
      supersetGroupId: serializer.fromJson<String?>(json['supersetGroupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sid': serializer.toJson<int>(sid),
      'sessionId': serializer.toJson<int>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'setNumber': serializer.toJson<int>(setNumber),
      'reps': serializer.toJson<double>(reps),
      'durationSec': serializer.toJson<int?>(durationSec),
      'weightKg': serializer.toJson<double>(weightKg),
      'isAllOut': serializer.toJson<bool>(isAllOut),
      'isBfr': serializer.toJson<bool>(isBfr),
      'bfrPercent': serializer.toJson<int?>(bfrPercent),
      'chainsKg': serializer.toJson<double?>(chainsKg),
      'bandsKg': serializer.toJson<double?>(bandsKg),
      'isSuperSlow': serializer.toJson<bool>(isSuperSlow),
      'superSlowNote': serializer.toJson<String?>(superSlowNote),
      'supersetGroupId': serializer.toJson<String?>(supersetGroupId),
    };
  }

  StrengthSet copyWith({
    int? sid,
    int? sessionId,
    String? exerciseId,
    String? exerciseName,
    int? setNumber,
    double? reps,
    Value<int?> durationSec = const Value.absent(),
    double? weightKg,
    bool? isAllOut,
    bool? isBfr,
    Value<int?> bfrPercent = const Value.absent(),
    Value<double?> chainsKg = const Value.absent(),
    Value<double?> bandsKg = const Value.absent(),
    bool? isSuperSlow,
    Value<String?> superSlowNote = const Value.absent(),
    Value<String?> supersetGroupId = const Value.absent(),
  }) => StrengthSet(
    sid: sid ?? this.sid,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    exerciseName: exerciseName ?? this.exerciseName,
    setNumber: setNumber ?? this.setNumber,
    reps: reps ?? this.reps,
    durationSec: durationSec.present ? durationSec.value : this.durationSec,
    weightKg: weightKg ?? this.weightKg,
    isAllOut: isAllOut ?? this.isAllOut,
    isBfr: isBfr ?? this.isBfr,
    bfrPercent: bfrPercent.present ? bfrPercent.value : this.bfrPercent,
    chainsKg: chainsKg.present ? chainsKg.value : this.chainsKg,
    bandsKg: bandsKg.present ? bandsKg.value : this.bandsKg,
    isSuperSlow: isSuperSlow ?? this.isSuperSlow,
    superSlowNote: superSlowNote.present
        ? superSlowNote.value
        : this.superSlowNote,
    supersetGroupId: supersetGroupId.present
        ? supersetGroupId.value
        : this.supersetGroupId,
  );
  StrengthSet copyWithCompanion(StrengthSetsCompanion data) {
    return StrengthSet(
      sid: data.sid.present ? data.sid.value : this.sid,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      reps: data.reps.present ? data.reps.value : this.reps,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      isAllOut: data.isAllOut.present ? data.isAllOut.value : this.isAllOut,
      isBfr: data.isBfr.present ? data.isBfr.value : this.isBfr,
      bfrPercent: data.bfrPercent.present
          ? data.bfrPercent.value
          : this.bfrPercent,
      chainsKg: data.chainsKg.present ? data.chainsKg.value : this.chainsKg,
      bandsKg: data.bandsKg.present ? data.bandsKg.value : this.bandsKg,
      isSuperSlow: data.isSuperSlow.present
          ? data.isSuperSlow.value
          : this.isSuperSlow,
      superSlowNote: data.superSlowNote.present
          ? data.superSlowNote.value
          : this.superSlowNote,
      supersetGroupId: data.supersetGroupId.present
          ? data.supersetGroupId.value
          : this.supersetGroupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StrengthSet(')
          ..write('sid: $sid, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('setNumber: $setNumber, ')
          ..write('reps: $reps, ')
          ..write('durationSec: $durationSec, ')
          ..write('weightKg: $weightKg, ')
          ..write('isAllOut: $isAllOut, ')
          ..write('isBfr: $isBfr, ')
          ..write('bfrPercent: $bfrPercent, ')
          ..write('chainsKg: $chainsKg, ')
          ..write('bandsKg: $bandsKg, ')
          ..write('isSuperSlow: $isSuperSlow, ')
          ..write('superSlowNote: $superSlowNote, ')
          ..write('supersetGroupId: $supersetGroupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sid,
    sessionId,
    exerciseId,
    exerciseName,
    setNumber,
    reps,
    durationSec,
    weightKg,
    isAllOut,
    isBfr,
    bfrPercent,
    chainsKg,
    bandsKg,
    isSuperSlow,
    superSlowNote,
    supersetGroupId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StrengthSet &&
          other.sid == this.sid &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.exerciseName == this.exerciseName &&
          other.setNumber == this.setNumber &&
          other.reps == this.reps &&
          other.durationSec == this.durationSec &&
          other.weightKg == this.weightKg &&
          other.isAllOut == this.isAllOut &&
          other.isBfr == this.isBfr &&
          other.bfrPercent == this.bfrPercent &&
          other.chainsKg == this.chainsKg &&
          other.bandsKg == this.bandsKg &&
          other.isSuperSlow == this.isSuperSlow &&
          other.superSlowNote == this.superSlowNote &&
          other.supersetGroupId == this.supersetGroupId);
}

class StrengthSetsCompanion extends UpdateCompanion<StrengthSet> {
  final Value<int> sid;
  final Value<int> sessionId;
  final Value<String> exerciseId;
  final Value<String> exerciseName;
  final Value<int> setNumber;
  final Value<double> reps;
  final Value<int?> durationSec;
  final Value<double> weightKg;
  final Value<bool> isAllOut;
  final Value<bool> isBfr;
  final Value<int?> bfrPercent;
  final Value<double?> chainsKg;
  final Value<double?> bandsKg;
  final Value<bool> isSuperSlow;
  final Value<String?> superSlowNote;
  final Value<String?> supersetGroupId;
  const StrengthSetsCompanion({
    this.sid = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.reps = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.isAllOut = const Value.absent(),
    this.isBfr = const Value.absent(),
    this.bfrPercent = const Value.absent(),
    this.chainsKg = const Value.absent(),
    this.bandsKg = const Value.absent(),
    this.isSuperSlow = const Value.absent(),
    this.superSlowNote = const Value.absent(),
    this.supersetGroupId = const Value.absent(),
  });
  StrengthSetsCompanion.insert({
    this.sid = const Value.absent(),
    required int sessionId,
    required String exerciseId,
    required String exerciseName,
    required int setNumber,
    required double reps,
    this.durationSec = const Value.absent(),
    required double weightKg,
    this.isAllOut = const Value.absent(),
    this.isBfr = const Value.absent(),
    this.bfrPercent = const Value.absent(),
    this.chainsKg = const Value.absent(),
    this.bandsKg = const Value.absent(),
    this.isSuperSlow = const Value.absent(),
    this.superSlowNote = const Value.absent(),
    this.supersetGroupId = const Value.absent(),
  }) : sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       exerciseName = Value(exerciseName),
       setNumber = Value(setNumber),
       reps = Value(reps),
       weightKg = Value(weightKg);
  static Insertable<StrengthSet> custom({
    Expression<int>? sid,
    Expression<int>? sessionId,
    Expression<String>? exerciseId,
    Expression<String>? exerciseName,
    Expression<int>? setNumber,
    Expression<double>? reps,
    Expression<int>? durationSec,
    Expression<double>? weightKg,
    Expression<bool>? isAllOut,
    Expression<bool>? isBfr,
    Expression<int>? bfrPercent,
    Expression<double>? chainsKg,
    Expression<double>? bandsKg,
    Expression<bool>? isSuperSlow,
    Expression<String>? superSlowNote,
    Expression<String>? supersetGroupId,
  }) {
    return RawValuesInsertable({
      if (sid != null) 'sid': sid,
      if (sessionId != null) 'sessionId': sessionId,
      if (exerciseId != null) 'exerciseId': exerciseId,
      if (exerciseName != null) 'exerciseName': exerciseName,
      if (setNumber != null) 'setNumber': setNumber,
      if (reps != null) 'reps': reps,
      if (durationSec != null) 'durationSec': durationSec,
      if (weightKg != null) 'weightKg': weightKg,
      if (isAllOut != null) 'isAllOut': isAllOut,
      if (isBfr != null) 'isBfr': isBfr,
      if (bfrPercent != null) 'bfrPercent': bfrPercent,
      if (chainsKg != null) 'chainsKg': chainsKg,
      if (bandsKg != null) 'bandsKg': bandsKg,
      if (isSuperSlow != null) 'isSuperSlow': isSuperSlow,
      if (superSlowNote != null) 'superSlowNote': superSlowNote,
      if (supersetGroupId != null) 'supersetGroupId': supersetGroupId,
    });
  }

  StrengthSetsCompanion copyWith({
    Value<int>? sid,
    Value<int>? sessionId,
    Value<String>? exerciseId,
    Value<String>? exerciseName,
    Value<int>? setNumber,
    Value<double>? reps,
    Value<int?>? durationSec,
    Value<double>? weightKg,
    Value<bool>? isAllOut,
    Value<bool>? isBfr,
    Value<int?>? bfrPercent,
    Value<double?>? chainsKg,
    Value<double?>? bandsKg,
    Value<bool>? isSuperSlow,
    Value<String?>? superSlowNote,
    Value<String?>? supersetGroupId,
  }) {
    return StrengthSetsCompanion(
      sid: sid ?? this.sid,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      durationSec: durationSec ?? this.durationSec,
      weightKg: weightKg ?? this.weightKg,
      isAllOut: isAllOut ?? this.isAllOut,
      isBfr: isBfr ?? this.isBfr,
      bfrPercent: bfrPercent ?? this.bfrPercent,
      chainsKg: chainsKg ?? this.chainsKg,
      bandsKg: bandsKg ?? this.bandsKg,
      isSuperSlow: isSuperSlow ?? this.isSuperSlow,
      superSlowNote: superSlowNote ?? this.superSlowNote,
      supersetGroupId: supersetGroupId ?? this.supersetGroupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sid.present) {
      map['sid'] = Variable<int>(sid.value);
    }
    if (sessionId.present) {
      map['sessionId'] = Variable<int>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exerciseId'] = Variable<String>(exerciseId.value);
    }
    if (exerciseName.present) {
      map['exerciseName'] = Variable<String>(exerciseName.value);
    }
    if (setNumber.present) {
      map['setNumber'] = Variable<int>(setNumber.value);
    }
    if (reps.present) {
      map['reps'] = Variable<double>(reps.value);
    }
    if (durationSec.present) {
      map['durationSec'] = Variable<int>(durationSec.value);
    }
    if (weightKg.present) {
      map['weightKg'] = Variable<double>(weightKg.value);
    }
    if (isAllOut.present) {
      map['isAllOut'] = Variable<bool>(isAllOut.value);
    }
    if (isBfr.present) {
      map['isBfr'] = Variable<bool>(isBfr.value);
    }
    if (bfrPercent.present) {
      map['bfrPercent'] = Variable<int>(bfrPercent.value);
    }
    if (chainsKg.present) {
      map['chainsKg'] = Variable<double>(chainsKg.value);
    }
    if (bandsKg.present) {
      map['bandsKg'] = Variable<double>(bandsKg.value);
    }
    if (isSuperSlow.present) {
      map['isSuperSlow'] = Variable<bool>(isSuperSlow.value);
    }
    if (superSlowNote.present) {
      map['superSlowNote'] = Variable<String>(superSlowNote.value);
    }
    if (supersetGroupId.present) {
      map['supersetGroupId'] = Variable<String>(supersetGroupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrengthSetsCompanion(')
          ..write('sid: $sid, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('setNumber: $setNumber, ')
          ..write('reps: $reps, ')
          ..write('durationSec: $durationSec, ')
          ..write('weightKg: $weightKg, ')
          ..write('isAllOut: $isAllOut, ')
          ..write('isBfr: $isBfr, ')
          ..write('bfrPercent: $bfrPercent, ')
          ..write('chainsKg: $chainsKg, ')
          ..write('bandsKg: $bandsKg, ')
          ..write('isSuperSlow: $isSuperSlow, ')
          ..write('superSlowNote: $superSlowNote, ')
          ..write('supersetGroupId: $supersetGroupId')
          ..write(')'))
        .toString();
  }
}

class $DailyStepsTable extends DailySteps
    with TableInfo<$DailyStepsTable, DailyStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateEpochDayMeta = const VerificationMeta(
    'dateEpochDay',
  );
  @override
  late final GeneratedColumn<int> dateEpochDay = GeneratedColumn<int>(
    'dateEpochDay',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updatedAtMs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    dateEpochDay,
    steps,
    source,
    updatedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyStep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dateEpochDay')) {
      context.handle(
        _dateEpochDayMeta,
        dateEpochDay.isAcceptableOrUnknown(
          data['dateEpochDay']!,
          _dateEpochDayMeta,
        ),
      );
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    } else if (isInserting) {
      context.missing(_stepsMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('updatedAtMs')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updatedAtMs']!,
          _updatedAtMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dateEpochDay};
  @override
  DailyStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStep(
      dateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dateEpochDay'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updatedAtMs'],
      )!,
    );
  }

  @override
  $DailyStepsTable createAlias(String alias) {
    return $DailyStepsTable(attachedDatabase, alias);
  }
}

class DailyStep extends DataClass implements Insertable<DailyStep> {
  final int dateEpochDay;
  final int steps;
  final String? source;
  final int updatedAtMs;
  const DailyStep({
    required this.dateEpochDay,
    required this.steps,
    this.source,
    required this.updatedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dateEpochDay'] = Variable<int>(dateEpochDay);
    map['steps'] = Variable<int>(steps);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['updatedAtMs'] = Variable<int>(updatedAtMs);
    return map;
  }

  DailyStepsCompanion toCompanion(bool nullToAbsent) {
    return DailyStepsCompanion(
      dateEpochDay: Value(dateEpochDay),
      steps: Value(steps),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      updatedAtMs: Value(updatedAtMs),
    );
  }

  factory DailyStep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStep(
      dateEpochDay: serializer.fromJson<int>(json['dateEpochDay']),
      steps: serializer.fromJson<int>(json['steps']),
      source: serializer.fromJson<String?>(json['source']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dateEpochDay': serializer.toJson<int>(dateEpochDay),
      'steps': serializer.toJson<int>(steps),
      'source': serializer.toJson<String?>(source),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
    };
  }

  DailyStep copyWith({
    int? dateEpochDay,
    int? steps,
    Value<String?> source = const Value.absent(),
    int? updatedAtMs,
  }) => DailyStep(
    dateEpochDay: dateEpochDay ?? this.dateEpochDay,
    steps: steps ?? this.steps,
    source: source.present ? source.value : this.source,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );
  DailyStep copyWithCompanion(DailyStepsCompanion data) {
    return DailyStep(
      dateEpochDay: data.dateEpochDay.present
          ? data.dateEpochDay.value
          : this.dateEpochDay,
      steps: data.steps.present ? data.steps.value : this.steps,
      source: data.source.present ? data.source.value : this.source,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStep(')
          ..write('dateEpochDay: $dateEpochDay, ')
          ..write('steps: $steps, ')
          ..write('source: $source, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dateEpochDay, steps, source, updatedAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStep &&
          other.dateEpochDay == this.dateEpochDay &&
          other.steps == this.steps &&
          other.source == this.source &&
          other.updatedAtMs == this.updatedAtMs);
}

class DailyStepsCompanion extends UpdateCompanion<DailyStep> {
  final Value<int> dateEpochDay;
  final Value<int> steps;
  final Value<String?> source;
  final Value<int> updatedAtMs;
  const DailyStepsCompanion({
    this.dateEpochDay = const Value.absent(),
    this.steps = const Value.absent(),
    this.source = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
  });
  DailyStepsCompanion.insert({
    this.dateEpochDay = const Value.absent(),
    required int steps,
    this.source = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
  }) : steps = Value(steps);
  static Insertable<DailyStep> custom({
    Expression<int>? dateEpochDay,
    Expression<int>? steps,
    Expression<String>? source,
    Expression<int>? updatedAtMs,
  }) {
    return RawValuesInsertable({
      if (dateEpochDay != null) 'dateEpochDay': dateEpochDay,
      if (steps != null) 'steps': steps,
      if (source != null) 'source': source,
      if (updatedAtMs != null) 'updatedAtMs': updatedAtMs,
    });
  }

  DailyStepsCompanion copyWith({
    Value<int>? dateEpochDay,
    Value<int>? steps,
    Value<String?>? source,
    Value<int>? updatedAtMs,
  }) {
    return DailyStepsCompanion(
      dateEpochDay: dateEpochDay ?? this.dateEpochDay,
      steps: steps ?? this.steps,
      source: source ?? this.source,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dateEpochDay.present) {
      map['dateEpochDay'] = Variable<int>(dateEpochDay.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (updatedAtMs.present) {
      map['updatedAtMs'] = Variable<int>(updatedAtMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStepsCompanion(')
          ..write('dateEpochDay: $dateEpochDay, ')
          ..write('steps: $steps, ')
          ..write('source: $source, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }
}

class $HrSettingsTable extends HrSettings
    with TableInfo<$HrSettingsTable, HrSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HrSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('SIMPLE'),
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthYearMeta = const VerificationMeta(
    'birthYear',
  );
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
    'birthYear',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrRestBpmMeta = const VerificationMeta(
    'hrRestBpm',
  );
  @override
  late final GeneratedColumn<int> hrRestBpm = GeneratedColumn<int>(
    'hrRestBpm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrMaxBpmMeta = const VerificationMeta(
    'hrMaxBpm',
  );
  @override
  late final GeneratedColumn<int> hrMaxBpm = GeneratedColumn<int>(
    'hrMaxBpm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _z1UpperMeta = const VerificationMeta(
    'z1Upper',
  );
  @override
  late final GeneratedColumn<int> z1Upper = GeneratedColumn<int>(
    'z1Upper',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _z2UpperMeta = const VerificationMeta(
    'z2Upper',
  );
  @override
  late final GeneratedColumn<int> z2Upper = GeneratedColumn<int>(
    'z2Upper',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _z3UpperMeta = const VerificationMeta(
    'z3Upper',
  );
  @override
  late final GeneratedColumn<int> z3Upper = GeneratedColumn<int>(
    'z3Upper',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _z4UpperMeta = const VerificationMeta(
    'z4Upper',
  );
  @override
  late final GeneratedColumn<int> z4Upper = GeneratedColumn<int>(
    'z4Upper',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _z5UpperMeta = const VerificationMeta(
    'z5Upper',
  );
  @override
  late final GeneratedColumn<int> z5Upper = GeneratedColumn<int>(
    'z5Upper',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updatedAtMs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mode,
    sex,
    birthYear,
    hrRestBpm,
    hrMaxBpm,
    z1Upper,
    z2Upper,
    z3Upper,
    z4Upper,
    z5Upper,
    updatedAtMs,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hr_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<HrSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    }
    if (data.containsKey('birthYear')) {
      context.handle(
        _birthYearMeta,
        birthYear.isAcceptableOrUnknown(data['birthYear']!, _birthYearMeta),
      );
    }
    if (data.containsKey('hrRestBpm')) {
      context.handle(
        _hrRestBpmMeta,
        hrRestBpm.isAcceptableOrUnknown(data['hrRestBpm']!, _hrRestBpmMeta),
      );
    }
    if (data.containsKey('hrMaxBpm')) {
      context.handle(
        _hrMaxBpmMeta,
        hrMaxBpm.isAcceptableOrUnknown(data['hrMaxBpm']!, _hrMaxBpmMeta),
      );
    }
    if (data.containsKey('z1Upper')) {
      context.handle(
        _z1UpperMeta,
        z1Upper.isAcceptableOrUnknown(data['z1Upper']!, _z1UpperMeta),
      );
    }
    if (data.containsKey('z2Upper')) {
      context.handle(
        _z2UpperMeta,
        z2Upper.isAcceptableOrUnknown(data['z2Upper']!, _z2UpperMeta),
      );
    }
    if (data.containsKey('z3Upper')) {
      context.handle(
        _z3UpperMeta,
        z3Upper.isAcceptableOrUnknown(data['z3Upper']!, _z3UpperMeta),
      );
    }
    if (data.containsKey('z4Upper')) {
      context.handle(
        _z4UpperMeta,
        z4Upper.isAcceptableOrUnknown(data['z4Upper']!, _z4UpperMeta),
      );
    }
    if (data.containsKey('z5Upper')) {
      context.handle(
        _z5UpperMeta,
        z5Upper.isAcceptableOrUnknown(data['z5Upper']!, _z5UpperMeta),
      );
    }
    if (data.containsKey('updatedAtMs')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updatedAtMs']!,
          _updatedAtMsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HrSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HrSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      ),
      birthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birthYear'],
      ),
      hrRestBpm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hrRestBpm'],
      ),
      hrMaxBpm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hrMaxBpm'],
      ),
      z1Upper: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z1Upper'],
      ),
      z2Upper: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z2Upper'],
      ),
      z3Upper: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z3Upper'],
      ),
      z4Upper: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z4Upper'],
      ),
      z5Upper: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}z5Upper'],
      ),
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updatedAtMs'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $HrSettingsTable createAlias(String alias) {
    return $HrSettingsTable(attachedDatabase, alias);
  }
}

class HrSetting extends DataClass implements Insertable<HrSetting> {
  final int id;
  final String mode;
  final String? sex;
  final int? birthYear;
  final int? hrRestBpm;
  final int? hrMaxBpm;
  final int? z1Upper;
  final int? z2Upper;
  final int? z3Upper;
  final int? z4Upper;
  final int? z5Upper;
  final int updatedAtMs;
  final String? notes;
  const HrSetting({
    required this.id,
    required this.mode,
    this.sex,
    this.birthYear,
    this.hrRestBpm,
    this.hrMaxBpm,
    this.z1Upper,
    this.z2Upper,
    this.z3Upper,
    this.z4Upper,
    this.z5Upper,
    required this.updatedAtMs,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(sex);
    }
    if (!nullToAbsent || birthYear != null) {
      map['birthYear'] = Variable<int>(birthYear);
    }
    if (!nullToAbsent || hrRestBpm != null) {
      map['hrRestBpm'] = Variable<int>(hrRestBpm);
    }
    if (!nullToAbsent || hrMaxBpm != null) {
      map['hrMaxBpm'] = Variable<int>(hrMaxBpm);
    }
    if (!nullToAbsent || z1Upper != null) {
      map['z1Upper'] = Variable<int>(z1Upper);
    }
    if (!nullToAbsent || z2Upper != null) {
      map['z2Upper'] = Variable<int>(z2Upper);
    }
    if (!nullToAbsent || z3Upper != null) {
      map['z3Upper'] = Variable<int>(z3Upper);
    }
    if (!nullToAbsent || z4Upper != null) {
      map['z4Upper'] = Variable<int>(z4Upper);
    }
    if (!nullToAbsent || z5Upper != null) {
      map['z5Upper'] = Variable<int>(z5Upper);
    }
    map['updatedAtMs'] = Variable<int>(updatedAtMs);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  HrSettingsCompanion toCompanion(bool nullToAbsent) {
    return HrSettingsCompanion(
      id: Value(id),
      mode: Value(mode),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      birthYear: birthYear == null && nullToAbsent
          ? const Value.absent()
          : Value(birthYear),
      hrRestBpm: hrRestBpm == null && nullToAbsent
          ? const Value.absent()
          : Value(hrRestBpm),
      hrMaxBpm: hrMaxBpm == null && nullToAbsent
          ? const Value.absent()
          : Value(hrMaxBpm),
      z1Upper: z1Upper == null && nullToAbsent
          ? const Value.absent()
          : Value(z1Upper),
      z2Upper: z2Upper == null && nullToAbsent
          ? const Value.absent()
          : Value(z2Upper),
      z3Upper: z3Upper == null && nullToAbsent
          ? const Value.absent()
          : Value(z3Upper),
      z4Upper: z4Upper == null && nullToAbsent
          ? const Value.absent()
          : Value(z4Upper),
      z5Upper: z5Upper == null && nullToAbsent
          ? const Value.absent()
          : Value(z5Upper),
      updatedAtMs: Value(updatedAtMs),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory HrSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HrSetting(
      id: serializer.fromJson<int>(json['id']),
      mode: serializer.fromJson<String>(json['mode']),
      sex: serializer.fromJson<String?>(json['sex']),
      birthYear: serializer.fromJson<int?>(json['birthYear']),
      hrRestBpm: serializer.fromJson<int?>(json['hrRestBpm']),
      hrMaxBpm: serializer.fromJson<int?>(json['hrMaxBpm']),
      z1Upper: serializer.fromJson<int?>(json['z1Upper']),
      z2Upper: serializer.fromJson<int?>(json['z2Upper']),
      z3Upper: serializer.fromJson<int?>(json['z3Upper']),
      z4Upper: serializer.fromJson<int?>(json['z4Upper']),
      z5Upper: serializer.fromJson<int?>(json['z5Upper']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mode': serializer.toJson<String>(mode),
      'sex': serializer.toJson<String?>(sex),
      'birthYear': serializer.toJson<int?>(birthYear),
      'hrRestBpm': serializer.toJson<int?>(hrRestBpm),
      'hrMaxBpm': serializer.toJson<int?>(hrMaxBpm),
      'z1Upper': serializer.toJson<int?>(z1Upper),
      'z2Upper': serializer.toJson<int?>(z2Upper),
      'z3Upper': serializer.toJson<int?>(z3Upper),
      'z4Upper': serializer.toJson<int?>(z4Upper),
      'z5Upper': serializer.toJson<int?>(z5Upper),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  HrSetting copyWith({
    int? id,
    String? mode,
    Value<String?> sex = const Value.absent(),
    Value<int?> birthYear = const Value.absent(),
    Value<int?> hrRestBpm = const Value.absent(),
    Value<int?> hrMaxBpm = const Value.absent(),
    Value<int?> z1Upper = const Value.absent(),
    Value<int?> z2Upper = const Value.absent(),
    Value<int?> z3Upper = const Value.absent(),
    Value<int?> z4Upper = const Value.absent(),
    Value<int?> z5Upper = const Value.absent(),
    int? updatedAtMs,
    Value<String?> notes = const Value.absent(),
  }) => HrSetting(
    id: id ?? this.id,
    mode: mode ?? this.mode,
    sex: sex.present ? sex.value : this.sex,
    birthYear: birthYear.present ? birthYear.value : this.birthYear,
    hrRestBpm: hrRestBpm.present ? hrRestBpm.value : this.hrRestBpm,
    hrMaxBpm: hrMaxBpm.present ? hrMaxBpm.value : this.hrMaxBpm,
    z1Upper: z1Upper.present ? z1Upper.value : this.z1Upper,
    z2Upper: z2Upper.present ? z2Upper.value : this.z2Upper,
    z3Upper: z3Upper.present ? z3Upper.value : this.z3Upper,
    z4Upper: z4Upper.present ? z4Upper.value : this.z4Upper,
    z5Upper: z5Upper.present ? z5Upper.value : this.z5Upper,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    notes: notes.present ? notes.value : this.notes,
  );
  HrSetting copyWithCompanion(HrSettingsCompanion data) {
    return HrSetting(
      id: data.id.present ? data.id.value : this.id,
      mode: data.mode.present ? data.mode.value : this.mode,
      sex: data.sex.present ? data.sex.value : this.sex,
      birthYear: data.birthYear.present ? data.birthYear.value : this.birthYear,
      hrRestBpm: data.hrRestBpm.present ? data.hrRestBpm.value : this.hrRestBpm,
      hrMaxBpm: data.hrMaxBpm.present ? data.hrMaxBpm.value : this.hrMaxBpm,
      z1Upper: data.z1Upper.present ? data.z1Upper.value : this.z1Upper,
      z2Upper: data.z2Upper.present ? data.z2Upper.value : this.z2Upper,
      z3Upper: data.z3Upper.present ? data.z3Upper.value : this.z3Upper,
      z4Upper: data.z4Upper.present ? data.z4Upper.value : this.z4Upper,
      z5Upper: data.z5Upper.present ? data.z5Upper.value : this.z5Upper,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HrSetting(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('sex: $sex, ')
          ..write('birthYear: $birthYear, ')
          ..write('hrRestBpm: $hrRestBpm, ')
          ..write('hrMaxBpm: $hrMaxBpm, ')
          ..write('z1Upper: $z1Upper, ')
          ..write('z2Upper: $z2Upper, ')
          ..write('z3Upper: $z3Upper, ')
          ..write('z4Upper: $z4Upper, ')
          ..write('z5Upper: $z5Upper, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mode,
    sex,
    birthYear,
    hrRestBpm,
    hrMaxBpm,
    z1Upper,
    z2Upper,
    z3Upper,
    z4Upper,
    z5Upper,
    updatedAtMs,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HrSetting &&
          other.id == this.id &&
          other.mode == this.mode &&
          other.sex == this.sex &&
          other.birthYear == this.birthYear &&
          other.hrRestBpm == this.hrRestBpm &&
          other.hrMaxBpm == this.hrMaxBpm &&
          other.z1Upper == this.z1Upper &&
          other.z2Upper == this.z2Upper &&
          other.z3Upper == this.z3Upper &&
          other.z4Upper == this.z4Upper &&
          other.z5Upper == this.z5Upper &&
          other.updatedAtMs == this.updatedAtMs &&
          other.notes == this.notes);
}

class HrSettingsCompanion extends UpdateCompanion<HrSetting> {
  final Value<int> id;
  final Value<String> mode;
  final Value<String?> sex;
  final Value<int?> birthYear;
  final Value<int?> hrRestBpm;
  final Value<int?> hrMaxBpm;
  final Value<int?> z1Upper;
  final Value<int?> z2Upper;
  final Value<int?> z3Upper;
  final Value<int?> z4Upper;
  final Value<int?> z5Upper;
  final Value<int> updatedAtMs;
  final Value<String?> notes;
  const HrSettingsCompanion({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.hrRestBpm = const Value.absent(),
    this.hrMaxBpm = const Value.absent(),
    this.z1Upper = const Value.absent(),
    this.z2Upper = const Value.absent(),
    this.z3Upper = const Value.absent(),
    this.z4Upper = const Value.absent(),
    this.z5Upper = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.notes = const Value.absent(),
  });
  HrSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.mode = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.hrRestBpm = const Value.absent(),
    this.hrMaxBpm = const Value.absent(),
    this.z1Upper = const Value.absent(),
    this.z2Upper = const Value.absent(),
    this.z3Upper = const Value.absent(),
    this.z4Upper = const Value.absent(),
    this.z5Upper = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
    this.notes = const Value.absent(),
  });
  static Insertable<HrSetting> custom({
    Expression<int>? id,
    Expression<String>? mode,
    Expression<String>? sex,
    Expression<int>? birthYear,
    Expression<int>? hrRestBpm,
    Expression<int>? hrMaxBpm,
    Expression<int>? z1Upper,
    Expression<int>? z2Upper,
    Expression<int>? z3Upper,
    Expression<int>? z4Upper,
    Expression<int>? z5Upper,
    Expression<int>? updatedAtMs,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mode != null) 'mode': mode,
      if (sex != null) 'sex': sex,
      if (birthYear != null) 'birthYear': birthYear,
      if (hrRestBpm != null) 'hrRestBpm': hrRestBpm,
      if (hrMaxBpm != null) 'hrMaxBpm': hrMaxBpm,
      if (z1Upper != null) 'z1Upper': z1Upper,
      if (z2Upper != null) 'z2Upper': z2Upper,
      if (z3Upper != null) 'z3Upper': z3Upper,
      if (z4Upper != null) 'z4Upper': z4Upper,
      if (z5Upper != null) 'z5Upper': z5Upper,
      if (updatedAtMs != null) 'updatedAtMs': updatedAtMs,
      if (notes != null) 'notes': notes,
    });
  }

  HrSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? mode,
    Value<String?>? sex,
    Value<int?>? birthYear,
    Value<int?>? hrRestBpm,
    Value<int?>? hrMaxBpm,
    Value<int?>? z1Upper,
    Value<int?>? z2Upper,
    Value<int?>? z3Upper,
    Value<int?>? z4Upper,
    Value<int?>? z5Upper,
    Value<int>? updatedAtMs,
    Value<String?>? notes,
  }) {
    return HrSettingsCompanion(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      sex: sex ?? this.sex,
      birthYear: birthYear ?? this.birthYear,
      hrRestBpm: hrRestBpm ?? this.hrRestBpm,
      hrMaxBpm: hrMaxBpm ?? this.hrMaxBpm,
      z1Upper: z1Upper ?? this.z1Upper,
      z2Upper: z2Upper ?? this.z2Upper,
      z3Upper: z3Upper ?? this.z3Upper,
      z4Upper: z4Upper ?? this.z4Upper,
      z5Upper: z5Upper ?? this.z5Upper,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (birthYear.present) {
      map['birthYear'] = Variable<int>(birthYear.value);
    }
    if (hrRestBpm.present) {
      map['hrRestBpm'] = Variable<int>(hrRestBpm.value);
    }
    if (hrMaxBpm.present) {
      map['hrMaxBpm'] = Variable<int>(hrMaxBpm.value);
    }
    if (z1Upper.present) {
      map['z1Upper'] = Variable<int>(z1Upper.value);
    }
    if (z2Upper.present) {
      map['z2Upper'] = Variable<int>(z2Upper.value);
    }
    if (z3Upper.present) {
      map['z3Upper'] = Variable<int>(z3Upper.value);
    }
    if (z4Upper.present) {
      map['z4Upper'] = Variable<int>(z4Upper.value);
    }
    if (z5Upper.present) {
      map['z5Upper'] = Variable<int>(z5Upper.value);
    }
    if (updatedAtMs.present) {
      map['updatedAtMs'] = Variable<int>(updatedAtMs.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HrSettingsCompanion(')
          ..write('id: $id, ')
          ..write('mode: $mode, ')
          ..write('sex: $sex, ')
          ..write('birthYear: $birthYear, ')
          ..write('hrRestBpm: $hrRestBpm, ')
          ..write('hrMaxBpm: $hrMaxBpm, ')
          ..write('z1Upper: $z1Upper, ')
          ..write('z2Upper: $z2Upper, ')
          ..write('z3Upper: $z3Upper, ')
          ..write('z4Upper: $z4Upper, ')
          ..write('z5Upper: $z5Upper, ')
          ..write('updatedAtMs: $updatedAtMs, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _birthDateEpochDayMeta = const VerificationMeta(
    'birthDateEpochDay',
  );
  @override
  late final GeneratedColumn<int> birthDateEpochDay = GeneratedColumn<int>(
    'birthDateEpochDay',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'heightCm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weightKg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMsMeta = const VerificationMeta(
    'updatedAtMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtMs = GeneratedColumn<int>(
    'updatedAtMs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    birthDateEpochDay,
    sex,
    heightCm,
    weightKg,
    updatedAtMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('birthDateEpochDay')) {
      context.handle(
        _birthDateEpochDayMeta,
        birthDateEpochDay.isAcceptableOrUnknown(
          data['birthDateEpochDay']!,
          _birthDateEpochDayMeta,
        ),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    }
    if (data.containsKey('heightCm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['heightCm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('weightKg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weightKg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('updatedAtMs')) {
      context.handle(
        _updatedAtMsMeta,
        updatedAtMs.isAcceptableOrUnknown(
          data['updatedAtMs']!,
          _updatedAtMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      birthDateEpochDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birthDateEpochDay'],
      ),
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heightCm'],
      ),
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weightKg'],
      ),
      updatedAtMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updatedAtMs'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final int? birthDateEpochDay;
  final String? sex;
  final double? heightCm;
  final double? weightKg;
  final int updatedAtMs;
  const UserProfile({
    required this.id,
    this.birthDateEpochDay,
    this.sex,
    this.heightCm,
    this.weightKg,
    required this.updatedAtMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || birthDateEpochDay != null) {
      map['birthDateEpochDay'] = Variable<int>(birthDateEpochDay);
    }
    if (!nullToAbsent || sex != null) {
      map['sex'] = Variable<String>(sex);
    }
    if (!nullToAbsent || heightCm != null) {
      map['heightCm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || weightKg != null) {
      map['weightKg'] = Variable<double>(weightKg);
    }
    map['updatedAtMs'] = Variable<int>(updatedAtMs);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      birthDateEpochDay: birthDateEpochDay == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDateEpochDay),
      sex: sex == null && nullToAbsent ? const Value.absent() : Value(sex),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      updatedAtMs: Value(updatedAtMs),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      birthDateEpochDay: serializer.fromJson<int?>(json['birthDateEpochDay']),
      sex: serializer.fromJson<String?>(json['sex']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      updatedAtMs: serializer.fromJson<int>(json['updatedAtMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'birthDateEpochDay': serializer.toJson<int?>(birthDateEpochDay),
      'sex': serializer.toJson<String?>(sex),
      'heightCm': serializer.toJson<double?>(heightCm),
      'weightKg': serializer.toJson<double?>(weightKg),
      'updatedAtMs': serializer.toJson<int>(updatedAtMs),
    };
  }

  UserProfile copyWith({
    int? id,
    Value<int?> birthDateEpochDay = const Value.absent(),
    Value<String?> sex = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<double?> weightKg = const Value.absent(),
    int? updatedAtMs,
  }) => UserProfile(
    id: id ?? this.id,
    birthDateEpochDay: birthDateEpochDay.present
        ? birthDateEpochDay.value
        : this.birthDateEpochDay,
    sex: sex.present ? sex.value : this.sex,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      birthDateEpochDay: data.birthDateEpochDay.present
          ? data.birthDateEpochDay.value
          : this.birthDateEpochDay,
      sex: data.sex.present ? data.sex.value : this.sex,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      updatedAtMs: data.updatedAtMs.present
          ? data.updatedAtMs.value
          : this.updatedAtMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('birthDateEpochDay: $birthDateEpochDay, ')
          ..write('sex: $sex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, birthDateEpochDay, sex, heightCm, weightKg, updatedAtMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.birthDateEpochDay == this.birthDateEpochDay &&
          other.sex == this.sex &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.updatedAtMs == this.updatedAtMs);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<int?> birthDateEpochDay;
  final Value<String?> sex;
  final Value<double?> heightCm;
  final Value<double?> weightKg;
  final Value<int> updatedAtMs;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.birthDateEpochDay = const Value.absent(),
    this.sex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.birthDateEpochDay = const Value.absent(),
    this.sex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.updatedAtMs = const Value.absent(),
  });
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<int>? birthDateEpochDay,
    Expression<String>? sex,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<int>? updatedAtMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (birthDateEpochDay != null) 'birthDateEpochDay': birthDateEpochDay,
      if (sex != null) 'sex': sex,
      if (heightCm != null) 'heightCm': heightCm,
      if (weightKg != null) 'weightKg': weightKg,
      if (updatedAtMs != null) 'updatedAtMs': updatedAtMs,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<int?>? birthDateEpochDay,
    Value<String?>? sex,
    Value<double?>? heightCm,
    Value<double?>? weightKg,
    Value<int>? updatedAtMs,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      birthDateEpochDay: birthDateEpochDay ?? this.birthDateEpochDay,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      updatedAtMs: updatedAtMs ?? this.updatedAtMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (birthDateEpochDay.present) {
      map['birthDateEpochDay'] = Variable<int>(birthDateEpochDay.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (heightCm.present) {
      map['heightCm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weightKg'] = Variable<double>(weightKg.value);
    }
    if (updatedAtMs.present) {
      map['updatedAtMs'] = Variable<int>(updatedAtMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('birthDateEpochDay: $birthDateEpochDay, ')
          ..write('sex: $sex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('updatedAtMs: $updatedAtMs')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RunSessionsTable runSessions = $RunSessionsTable(this);
  late final $RunSamplesTable runSamples = $RunSamplesTable(this);
  late final $StrengthSessionsTable strengthSessions = $StrengthSessionsTable(
    this,
  );
  late final $StrengthSetsTable strengthSets = $StrengthSetsTable(this);
  late final $DailyStepsTable dailySteps = $DailyStepsTable(this);
  late final $HrSettingsTable hrSettings = $HrSettingsTable(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final RunDao runDao = RunDao(this as AppDatabase);
  late final StrengthSessionDao strengthSessionDao = StrengthSessionDao(
    this as AppDatabase,
  );
  late final StrengthSetDao strengthSetDao = StrengthSetDao(
    this as AppDatabase,
  );
  late final DailyStepsDao dailyStepsDao = DailyStepsDao(this as AppDatabase);
  late final HrSettingsDao hrSettingsDao = HrSettingsDao(this as AppDatabase);
  late final UserProfileDao userProfileDao = UserProfileDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    runSessions,
    runSamples,
    strengthSessions,
    strengthSets,
    dailySteps,
    hrSettings,
    userProfiles,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'run_session',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('run_sample', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'strength_session',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('strength_set', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$RunSessionsTableCreateCompanionBuilder =
    RunSessionsCompanion Function({
      Value<int> id,
      required int startEpochMs,
      Value<int?> endEpochMs,
      Value<double> totalDistanceM,
      Value<int> totalDurationMs,
      Value<int?> avgHr,
      Value<int?> maxHr,
      Value<double?> elevGainM,
      Value<String?> notes,
      Value<String?> sport,
      Value<String?> indoorSettingsJson,
      Value<int?> rpe0to10,
      Value<int> timeZ1s,
      Value<int> timeZ2s,
      Value<int> timeZ3s,
      Value<int> timeZ4s,
      Value<int> timeZ5s,
      Value<String?> hrZoneMethod,
      Value<int?> hrMaxUsed,
      Value<int?> hrRestUsed,
      Value<String?> hrZoneBoundsJson,
    });
typedef $$RunSessionsTableUpdateCompanionBuilder =
    RunSessionsCompanion Function({
      Value<int> id,
      Value<int> startEpochMs,
      Value<int?> endEpochMs,
      Value<double> totalDistanceM,
      Value<int> totalDurationMs,
      Value<int?> avgHr,
      Value<int?> maxHr,
      Value<double?> elevGainM,
      Value<String?> notes,
      Value<String?> sport,
      Value<String?> indoorSettingsJson,
      Value<int?> rpe0to10,
      Value<int> timeZ1s,
      Value<int> timeZ2s,
      Value<int> timeZ3s,
      Value<int> timeZ4s,
      Value<int> timeZ5s,
      Value<String?> hrZoneMethod,
      Value<int?> hrMaxUsed,
      Value<int?> hrRestUsed,
      Value<String?> hrZoneBoundsJson,
    });

final class $$RunSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $RunSessionsTable, RunSession> {
  $$RunSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RunSamplesTable, List<RunSample>>
  _runSamplesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.runSamples,
    aliasName: $_aliasNameGenerator(db.runSessions.id, db.runSamples.sessionId),
  );

  $$RunSamplesTableProcessedTableManager get runSamplesRefs {
    final manager = $$RunSamplesTableTableManager(
      $_db,
      $_db.runSamples,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_runSamplesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RunSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $RunSessionsTable> {
  $$RunSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startEpochMs => $composableBuilder(
    column: $table.startEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endEpochMs => $composableBuilder(
    column: $table.endEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalDistanceM => $composableBuilder(
    column: $table.totalDistanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDurationMs => $composableBuilder(
    column: $table.totalDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgHr => $composableBuilder(
    column: $table.avgHr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHr => $composableBuilder(
    column: $table.maxHr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get elevGainM => $composableBuilder(
    column: $table.elevGainM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sport => $composableBuilder(
    column: $table.sport,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get indoorSettingsJson => $composableBuilder(
    column: $table.indoorSettingsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rpe0to10 => $composableBuilder(
    column: $table.rpe0to10,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeZ1s => $composableBuilder(
    column: $table.timeZ1s,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeZ2s => $composableBuilder(
    column: $table.timeZ2s,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeZ3s => $composableBuilder(
    column: $table.timeZ3s,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeZ4s => $composableBuilder(
    column: $table.timeZ4s,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeZ5s => $composableBuilder(
    column: $table.timeZ5s,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hrZoneMethod => $composableBuilder(
    column: $table.hrZoneMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrMaxUsed => $composableBuilder(
    column: $table.hrMaxUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrRestUsed => $composableBuilder(
    column: $table.hrRestUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hrZoneBoundsJson => $composableBuilder(
    column: $table.hrZoneBoundsJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> runSamplesRefs(
    Expression<bool> Function($$RunSamplesTableFilterComposer f) f,
  ) {
    final $$RunSamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runSamples,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunSamplesTableFilterComposer(
            $db: $db,
            $table: $db.runSamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RunSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RunSessionsTable> {
  $$RunSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startEpochMs => $composableBuilder(
    column: $table.startEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endEpochMs => $composableBuilder(
    column: $table.endEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalDistanceM => $composableBuilder(
    column: $table.totalDistanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDurationMs => $composableBuilder(
    column: $table.totalDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgHr => $composableBuilder(
    column: $table.avgHr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHr => $composableBuilder(
    column: $table.maxHr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get elevGainM => $composableBuilder(
    column: $table.elevGainM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sport => $composableBuilder(
    column: $table.sport,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get indoorSettingsJson => $composableBuilder(
    column: $table.indoorSettingsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rpe0to10 => $composableBuilder(
    column: $table.rpe0to10,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeZ1s => $composableBuilder(
    column: $table.timeZ1s,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeZ2s => $composableBuilder(
    column: $table.timeZ2s,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeZ3s => $composableBuilder(
    column: $table.timeZ3s,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeZ4s => $composableBuilder(
    column: $table.timeZ4s,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeZ5s => $composableBuilder(
    column: $table.timeZ5s,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hrZoneMethod => $composableBuilder(
    column: $table.hrZoneMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrMaxUsed => $composableBuilder(
    column: $table.hrMaxUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrRestUsed => $composableBuilder(
    column: $table.hrRestUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hrZoneBoundsJson => $composableBuilder(
    column: $table.hrZoneBoundsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RunSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RunSessionsTable> {
  $$RunSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startEpochMs => $composableBuilder(
    column: $table.startEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endEpochMs => $composableBuilder(
    column: $table.endEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalDistanceM => $composableBuilder(
    column: $table.totalDistanceM,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDurationMs => $composableBuilder(
    column: $table.totalDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get avgHr =>
      $composableBuilder(column: $table.avgHr, builder: (column) => column);

  GeneratedColumn<int> get maxHr =>
      $composableBuilder(column: $table.maxHr, builder: (column) => column);

  GeneratedColumn<double> get elevGainM =>
      $composableBuilder(column: $table.elevGainM, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get sport =>
      $composableBuilder(column: $table.sport, builder: (column) => column);

  GeneratedColumn<String> get indoorSettingsJson => $composableBuilder(
    column: $table.indoorSettingsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rpe0to10 =>
      $composableBuilder(column: $table.rpe0to10, builder: (column) => column);

  GeneratedColumn<int> get timeZ1s =>
      $composableBuilder(column: $table.timeZ1s, builder: (column) => column);

  GeneratedColumn<int> get timeZ2s =>
      $composableBuilder(column: $table.timeZ2s, builder: (column) => column);

  GeneratedColumn<int> get timeZ3s =>
      $composableBuilder(column: $table.timeZ3s, builder: (column) => column);

  GeneratedColumn<int> get timeZ4s =>
      $composableBuilder(column: $table.timeZ4s, builder: (column) => column);

  GeneratedColumn<int> get timeZ5s =>
      $composableBuilder(column: $table.timeZ5s, builder: (column) => column);

  GeneratedColumn<String> get hrZoneMethod => $composableBuilder(
    column: $table.hrZoneMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hrMaxUsed =>
      $composableBuilder(column: $table.hrMaxUsed, builder: (column) => column);

  GeneratedColumn<int> get hrRestUsed => $composableBuilder(
    column: $table.hrRestUsed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hrZoneBoundsJson => $composableBuilder(
    column: $table.hrZoneBoundsJson,
    builder: (column) => column,
  );

  Expression<T> runSamplesRefs<T extends Object>(
    Expression<T> Function($$RunSamplesTableAnnotationComposer a) f,
  ) {
    final $$RunSamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.runSamples,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunSamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.runSamples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RunSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RunSessionsTable,
          RunSession,
          $$RunSessionsTableFilterComposer,
          $$RunSessionsTableOrderingComposer,
          $$RunSessionsTableAnnotationComposer,
          $$RunSessionsTableCreateCompanionBuilder,
          $$RunSessionsTableUpdateCompanionBuilder,
          (RunSession, $$RunSessionsTableReferences),
          RunSession,
          PrefetchHooks Function({bool runSamplesRefs})
        > {
  $$RunSessionsTableTableManager(_$AppDatabase db, $RunSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RunSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RunSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RunSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> startEpochMs = const Value.absent(),
                Value<int?> endEpochMs = const Value.absent(),
                Value<double> totalDistanceM = const Value.absent(),
                Value<int> totalDurationMs = const Value.absent(),
                Value<int?> avgHr = const Value.absent(),
                Value<int?> maxHr = const Value.absent(),
                Value<double?> elevGainM = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> sport = const Value.absent(),
                Value<String?> indoorSettingsJson = const Value.absent(),
                Value<int?> rpe0to10 = const Value.absent(),
                Value<int> timeZ1s = const Value.absent(),
                Value<int> timeZ2s = const Value.absent(),
                Value<int> timeZ3s = const Value.absent(),
                Value<int> timeZ4s = const Value.absent(),
                Value<int> timeZ5s = const Value.absent(),
                Value<String?> hrZoneMethod = const Value.absent(),
                Value<int?> hrMaxUsed = const Value.absent(),
                Value<int?> hrRestUsed = const Value.absent(),
                Value<String?> hrZoneBoundsJson = const Value.absent(),
              }) => RunSessionsCompanion(
                id: id,
                startEpochMs: startEpochMs,
                endEpochMs: endEpochMs,
                totalDistanceM: totalDistanceM,
                totalDurationMs: totalDurationMs,
                avgHr: avgHr,
                maxHr: maxHr,
                elevGainM: elevGainM,
                notes: notes,
                sport: sport,
                indoorSettingsJson: indoorSettingsJson,
                rpe0to10: rpe0to10,
                timeZ1s: timeZ1s,
                timeZ2s: timeZ2s,
                timeZ3s: timeZ3s,
                timeZ4s: timeZ4s,
                timeZ5s: timeZ5s,
                hrZoneMethod: hrZoneMethod,
                hrMaxUsed: hrMaxUsed,
                hrRestUsed: hrRestUsed,
                hrZoneBoundsJson: hrZoneBoundsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int startEpochMs,
                Value<int?> endEpochMs = const Value.absent(),
                Value<double> totalDistanceM = const Value.absent(),
                Value<int> totalDurationMs = const Value.absent(),
                Value<int?> avgHr = const Value.absent(),
                Value<int?> maxHr = const Value.absent(),
                Value<double?> elevGainM = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> sport = const Value.absent(),
                Value<String?> indoorSettingsJson = const Value.absent(),
                Value<int?> rpe0to10 = const Value.absent(),
                Value<int> timeZ1s = const Value.absent(),
                Value<int> timeZ2s = const Value.absent(),
                Value<int> timeZ3s = const Value.absent(),
                Value<int> timeZ4s = const Value.absent(),
                Value<int> timeZ5s = const Value.absent(),
                Value<String?> hrZoneMethod = const Value.absent(),
                Value<int?> hrMaxUsed = const Value.absent(),
                Value<int?> hrRestUsed = const Value.absent(),
                Value<String?> hrZoneBoundsJson = const Value.absent(),
              }) => RunSessionsCompanion.insert(
                id: id,
                startEpochMs: startEpochMs,
                endEpochMs: endEpochMs,
                totalDistanceM: totalDistanceM,
                totalDurationMs: totalDurationMs,
                avgHr: avgHr,
                maxHr: maxHr,
                elevGainM: elevGainM,
                notes: notes,
                sport: sport,
                indoorSettingsJson: indoorSettingsJson,
                rpe0to10: rpe0to10,
                timeZ1s: timeZ1s,
                timeZ2s: timeZ2s,
                timeZ3s: timeZ3s,
                timeZ4s: timeZ4s,
                timeZ5s: timeZ5s,
                hrZoneMethod: hrZoneMethod,
                hrMaxUsed: hrMaxUsed,
                hrRestUsed: hrRestUsed,
                hrZoneBoundsJson: hrZoneBoundsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RunSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({runSamplesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (runSamplesRefs) db.runSamples],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (runSamplesRefs)
                    await $_getPrefetchedData<
                      RunSession,
                      $RunSessionsTable,
                      RunSample
                    >(
                      currentTable: table,
                      referencedTable: $$RunSessionsTableReferences
                          ._runSamplesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RunSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).runSamplesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RunSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RunSessionsTable,
      RunSession,
      $$RunSessionsTableFilterComposer,
      $$RunSessionsTableOrderingComposer,
      $$RunSessionsTableAnnotationComposer,
      $$RunSessionsTableCreateCompanionBuilder,
      $$RunSessionsTableUpdateCompanionBuilder,
      (RunSession, $$RunSessionsTableReferences),
      RunSession,
      PrefetchHooks Function({bool runSamplesRefs})
    >;
typedef $$RunSamplesTableCreateCompanionBuilder =
    RunSamplesCompanion Function({
      Value<int> sid,
      required int sessionId,
      required int tEpochMs,
      required double lat,
      required double lon,
      Value<int?> hr,
      Value<double?> accM,
      Value<double?> speedMps,
      Value<double?> elevM,
    });
typedef $$RunSamplesTableUpdateCompanionBuilder =
    RunSamplesCompanion Function({
      Value<int> sid,
      Value<int> sessionId,
      Value<int> tEpochMs,
      Value<double> lat,
      Value<double> lon,
      Value<int?> hr,
      Value<double?> accM,
      Value<double?> speedMps,
      Value<double?> elevM,
    });

final class $$RunSamplesTableReferences
    extends BaseReferences<_$AppDatabase, $RunSamplesTable, RunSample> {
  $$RunSamplesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RunSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.runSessions.createAlias(
        $_aliasNameGenerator(db.runSamples.sessionId, db.runSessions.id),
      );

  $$RunSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('sessionId')!;

    final manager = $$RunSessionsTableTableManager(
      $_db,
      $_db.runSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RunSamplesTableFilterComposer
    extends Composer<_$AppDatabase, $RunSamplesTable> {
  $$RunSamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sid => $composableBuilder(
    column: $table.sid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tEpochMs => $composableBuilder(
    column: $table.tEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hr => $composableBuilder(
    column: $table.hr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accM => $composableBuilder(
    column: $table.accM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedMps => $composableBuilder(
    column: $table.speedMps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get elevM => $composableBuilder(
    column: $table.elevM,
    builder: (column) => ColumnFilters(column),
  );

  $$RunSessionsTableFilterComposer get sessionId {
    final $$RunSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.runSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunSessionsTableFilterComposer(
            $db: $db,
            $table: $db.runSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RunSamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $RunSamplesTable> {
  $$RunSamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sid => $composableBuilder(
    column: $table.sid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tEpochMs => $composableBuilder(
    column: $table.tEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hr => $composableBuilder(
    column: $table.hr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accM => $composableBuilder(
    column: $table.accM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedMps => $composableBuilder(
    column: $table.speedMps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get elevM => $composableBuilder(
    column: $table.elevM,
    builder: (column) => ColumnOrderings(column),
  );

  $$RunSessionsTableOrderingComposer get sessionId {
    final $$RunSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.runSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.runSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RunSamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RunSamplesTable> {
  $$RunSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sid =>
      $composableBuilder(column: $table.sid, builder: (column) => column);

  GeneratedColumn<int> get tEpochMs =>
      $composableBuilder(column: $table.tEpochMs, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<int> get hr =>
      $composableBuilder(column: $table.hr, builder: (column) => column);

  GeneratedColumn<double> get accM =>
      $composableBuilder(column: $table.accM, builder: (column) => column);

  GeneratedColumn<double> get speedMps =>
      $composableBuilder(column: $table.speedMps, builder: (column) => column);

  GeneratedColumn<double> get elevM =>
      $composableBuilder(column: $table.elevM, builder: (column) => column);

  $$RunSessionsTableAnnotationComposer get sessionId {
    final $$RunSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.runSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RunSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.runSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RunSamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RunSamplesTable,
          RunSample,
          $$RunSamplesTableFilterComposer,
          $$RunSamplesTableOrderingComposer,
          $$RunSamplesTableAnnotationComposer,
          $$RunSamplesTableCreateCompanionBuilder,
          $$RunSamplesTableUpdateCompanionBuilder,
          (RunSample, $$RunSamplesTableReferences),
          RunSample,
          PrefetchHooks Function({bool sessionId})
        > {
  $$RunSamplesTableTableManager(_$AppDatabase db, $RunSamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RunSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RunSamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RunSamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> sid = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> tEpochMs = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<int?> hr = const Value.absent(),
                Value<double?> accM = const Value.absent(),
                Value<double?> speedMps = const Value.absent(),
                Value<double?> elevM = const Value.absent(),
              }) => RunSamplesCompanion(
                sid: sid,
                sessionId: sessionId,
                tEpochMs: tEpochMs,
                lat: lat,
                lon: lon,
                hr: hr,
                accM: accM,
                speedMps: speedMps,
                elevM: elevM,
              ),
          createCompanionCallback:
              ({
                Value<int> sid = const Value.absent(),
                required int sessionId,
                required int tEpochMs,
                required double lat,
                required double lon,
                Value<int?> hr = const Value.absent(),
                Value<double?> accM = const Value.absent(),
                Value<double?> speedMps = const Value.absent(),
                Value<double?> elevM = const Value.absent(),
              }) => RunSamplesCompanion.insert(
                sid: sid,
                sessionId: sessionId,
                tEpochMs: tEpochMs,
                lat: lat,
                lon: lon,
                hr: hr,
                accM: accM,
                speedMps: speedMps,
                elevM: elevM,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RunSamplesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$RunSamplesTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$RunSamplesTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RunSamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RunSamplesTable,
      RunSample,
      $$RunSamplesTableFilterComposer,
      $$RunSamplesTableOrderingComposer,
      $$RunSamplesTableAnnotationComposer,
      $$RunSamplesTableCreateCompanionBuilder,
      $$RunSamplesTableUpdateCompanionBuilder,
      (RunSample, $$RunSamplesTableReferences),
      RunSample,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$StrengthSessionsTableCreateCompanionBuilder =
    StrengthSessionsCompanion Function({
      Value<int> id,
      required int startEpochMs,
      Value<int?> endEpochMs,
      Value<String?> notes,
    });
typedef $$StrengthSessionsTableUpdateCompanionBuilder =
    StrengthSessionsCompanion Function({
      Value<int> id,
      Value<int> startEpochMs,
      Value<int?> endEpochMs,
      Value<String?> notes,
    });

final class $$StrengthSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StrengthSessionsTable, StrengthSession> {
  $$StrengthSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$StrengthSetsTable, List<StrengthSet>>
  _strengthSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.strengthSets,
    aliasName: $_aliasNameGenerator(
      db.strengthSessions.id,
      db.strengthSets.sessionId,
    ),
  );

  $$StrengthSetsTableProcessedTableManager get strengthSetsRefs {
    final manager = $$StrengthSetsTableTableManager(
      $_db,
      $_db.strengthSets,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_strengthSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StrengthSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $StrengthSessionsTable> {
  $$StrengthSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startEpochMs => $composableBuilder(
    column: $table.startEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endEpochMs => $composableBuilder(
    column: $table.endEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> strengthSetsRefs(
    Expression<bool> Function($$StrengthSetsTableFilterComposer f) f,
  ) {
    final $$StrengthSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.strengthSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StrengthSetsTableFilterComposer(
            $db: $db,
            $table: $db.strengthSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StrengthSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StrengthSessionsTable> {
  $$StrengthSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startEpochMs => $composableBuilder(
    column: $table.startEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endEpochMs => $composableBuilder(
    column: $table.endEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StrengthSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StrengthSessionsTable> {
  $$StrengthSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startEpochMs => $composableBuilder(
    column: $table.startEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endEpochMs => $composableBuilder(
    column: $table.endEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> strengthSetsRefs<T extends Object>(
    Expression<T> Function($$StrengthSetsTableAnnotationComposer a) f,
  ) {
    final $$StrengthSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.strengthSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StrengthSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.strengthSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StrengthSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StrengthSessionsTable,
          StrengthSession,
          $$StrengthSessionsTableFilterComposer,
          $$StrengthSessionsTableOrderingComposer,
          $$StrengthSessionsTableAnnotationComposer,
          $$StrengthSessionsTableCreateCompanionBuilder,
          $$StrengthSessionsTableUpdateCompanionBuilder,
          (StrengthSession, $$StrengthSessionsTableReferences),
          StrengthSession,
          PrefetchHooks Function({bool strengthSetsRefs})
        > {
  $$StrengthSessionsTableTableManager(
    _$AppDatabase db,
    $StrengthSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StrengthSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StrengthSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StrengthSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> startEpochMs = const Value.absent(),
                Value<int?> endEpochMs = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => StrengthSessionsCompanion(
                id: id,
                startEpochMs: startEpochMs,
                endEpochMs: endEpochMs,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int startEpochMs,
                Value<int?> endEpochMs = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => StrengthSessionsCompanion.insert(
                id: id,
                startEpochMs: startEpochMs,
                endEpochMs: endEpochMs,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StrengthSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({strengthSetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (strengthSetsRefs) db.strengthSets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (strengthSetsRefs)
                    await $_getPrefetchedData<
                      StrengthSession,
                      $StrengthSessionsTable,
                      StrengthSet
                    >(
                      currentTable: table,
                      referencedTable: $$StrengthSessionsTableReferences
                          ._strengthSetsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StrengthSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).strengthSetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StrengthSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StrengthSessionsTable,
      StrengthSession,
      $$StrengthSessionsTableFilterComposer,
      $$StrengthSessionsTableOrderingComposer,
      $$StrengthSessionsTableAnnotationComposer,
      $$StrengthSessionsTableCreateCompanionBuilder,
      $$StrengthSessionsTableUpdateCompanionBuilder,
      (StrengthSession, $$StrengthSessionsTableReferences),
      StrengthSession,
      PrefetchHooks Function({bool strengthSetsRefs})
    >;
typedef $$StrengthSetsTableCreateCompanionBuilder =
    StrengthSetsCompanion Function({
      Value<int> sid,
      required int sessionId,
      required String exerciseId,
      required String exerciseName,
      required int setNumber,
      required double reps,
      Value<int?> durationSec,
      required double weightKg,
      Value<bool> isAllOut,
      Value<bool> isBfr,
      Value<int?> bfrPercent,
      Value<double?> chainsKg,
      Value<double?> bandsKg,
      Value<bool> isSuperSlow,
      Value<String?> superSlowNote,
      Value<String?> supersetGroupId,
    });
typedef $$StrengthSetsTableUpdateCompanionBuilder =
    StrengthSetsCompanion Function({
      Value<int> sid,
      Value<int> sessionId,
      Value<String> exerciseId,
      Value<String> exerciseName,
      Value<int> setNumber,
      Value<double> reps,
      Value<int?> durationSec,
      Value<double> weightKg,
      Value<bool> isAllOut,
      Value<bool> isBfr,
      Value<int?> bfrPercent,
      Value<double?> chainsKg,
      Value<double?> bandsKg,
      Value<bool> isSuperSlow,
      Value<String?> superSlowNote,
      Value<String?> supersetGroupId,
    });

final class $$StrengthSetsTableReferences
    extends BaseReferences<_$AppDatabase, $StrengthSetsTable, StrengthSet> {
  $$StrengthSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StrengthSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.strengthSessions.createAlias(
        $_aliasNameGenerator(db.strengthSets.sessionId, db.strengthSessions.id),
      );

  $$StrengthSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('sessionId')!;

    final manager = $$StrengthSessionsTableTableManager(
      $_db,
      $_db.strengthSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StrengthSetsTableFilterComposer
    extends Composer<_$AppDatabase, $StrengthSetsTable> {
  $$StrengthSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sid => $composableBuilder(
    column: $table.sid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAllOut => $composableBuilder(
    column: $table.isAllOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBfr => $composableBuilder(
    column: $table.isBfr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bfrPercent => $composableBuilder(
    column: $table.bfrPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chainsKg => $composableBuilder(
    column: $table.chainsKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bandsKg => $composableBuilder(
    column: $table.bandsKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSuperSlow => $composableBuilder(
    column: $table.isSuperSlow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get superSlowNote => $composableBuilder(
    column: $table.superSlowNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supersetGroupId => $composableBuilder(
    column: $table.supersetGroupId,
    builder: (column) => ColumnFilters(column),
  );

  $$StrengthSessionsTableFilterComposer get sessionId {
    final $$StrengthSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.strengthSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StrengthSessionsTableFilterComposer(
            $db: $db,
            $table: $db.strengthSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StrengthSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $StrengthSetsTable> {
  $$StrengthSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sid => $composableBuilder(
    column: $table.sid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAllOut => $composableBuilder(
    column: $table.isAllOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBfr => $composableBuilder(
    column: $table.isBfr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bfrPercent => $composableBuilder(
    column: $table.bfrPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chainsKg => $composableBuilder(
    column: $table.chainsKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bandsKg => $composableBuilder(
    column: $table.bandsKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSuperSlow => $composableBuilder(
    column: $table.isSuperSlow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get superSlowNote => $composableBuilder(
    column: $table.superSlowNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supersetGroupId => $composableBuilder(
    column: $table.supersetGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  $$StrengthSessionsTableOrderingComposer get sessionId {
    final $$StrengthSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.strengthSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StrengthSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.strengthSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StrengthSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StrengthSetsTable> {
  $$StrengthSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sid =>
      $composableBuilder(column: $table.sid, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<bool> get isAllOut =>
      $composableBuilder(column: $table.isAllOut, builder: (column) => column);

  GeneratedColumn<bool> get isBfr =>
      $composableBuilder(column: $table.isBfr, builder: (column) => column);

  GeneratedColumn<int> get bfrPercent => $composableBuilder(
    column: $table.bfrPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get chainsKg =>
      $composableBuilder(column: $table.chainsKg, builder: (column) => column);

  GeneratedColumn<double> get bandsKg =>
      $composableBuilder(column: $table.bandsKg, builder: (column) => column);

  GeneratedColumn<bool> get isSuperSlow => $composableBuilder(
    column: $table.isSuperSlow,
    builder: (column) => column,
  );

  GeneratedColumn<String> get superSlowNote => $composableBuilder(
    column: $table.superSlowNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supersetGroupId => $composableBuilder(
    column: $table.supersetGroupId,
    builder: (column) => column,
  );

  $$StrengthSessionsTableAnnotationComposer get sessionId {
    final $$StrengthSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.strengthSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StrengthSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.strengthSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StrengthSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StrengthSetsTable,
          StrengthSet,
          $$StrengthSetsTableFilterComposer,
          $$StrengthSetsTableOrderingComposer,
          $$StrengthSetsTableAnnotationComposer,
          $$StrengthSetsTableCreateCompanionBuilder,
          $$StrengthSetsTableUpdateCompanionBuilder,
          (StrengthSet, $$StrengthSetsTableReferences),
          StrengthSet,
          PrefetchHooks Function({bool sessionId})
        > {
  $$StrengthSetsTableTableManager(_$AppDatabase db, $StrengthSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StrengthSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StrengthSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StrengthSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> sid = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<double> reps = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<bool> isAllOut = const Value.absent(),
                Value<bool> isBfr = const Value.absent(),
                Value<int?> bfrPercent = const Value.absent(),
                Value<double?> chainsKg = const Value.absent(),
                Value<double?> bandsKg = const Value.absent(),
                Value<bool> isSuperSlow = const Value.absent(),
                Value<String?> superSlowNote = const Value.absent(),
                Value<String?> supersetGroupId = const Value.absent(),
              }) => StrengthSetsCompanion(
                sid: sid,
                sessionId: sessionId,
                exerciseId: exerciseId,
                exerciseName: exerciseName,
                setNumber: setNumber,
                reps: reps,
                durationSec: durationSec,
                weightKg: weightKg,
                isAllOut: isAllOut,
                isBfr: isBfr,
                bfrPercent: bfrPercent,
                chainsKg: chainsKg,
                bandsKg: bandsKg,
                isSuperSlow: isSuperSlow,
                superSlowNote: superSlowNote,
                supersetGroupId: supersetGroupId,
              ),
          createCompanionCallback:
              ({
                Value<int> sid = const Value.absent(),
                required int sessionId,
                required String exerciseId,
                required String exerciseName,
                required int setNumber,
                required double reps,
                Value<int?> durationSec = const Value.absent(),
                required double weightKg,
                Value<bool> isAllOut = const Value.absent(),
                Value<bool> isBfr = const Value.absent(),
                Value<int?> bfrPercent = const Value.absent(),
                Value<double?> chainsKg = const Value.absent(),
                Value<double?> bandsKg = const Value.absent(),
                Value<bool> isSuperSlow = const Value.absent(),
                Value<String?> superSlowNote = const Value.absent(),
                Value<String?> supersetGroupId = const Value.absent(),
              }) => StrengthSetsCompanion.insert(
                sid: sid,
                sessionId: sessionId,
                exerciseId: exerciseId,
                exerciseName: exerciseName,
                setNumber: setNumber,
                reps: reps,
                durationSec: durationSec,
                weightKg: weightKg,
                isAllOut: isAllOut,
                isBfr: isBfr,
                bfrPercent: bfrPercent,
                chainsKg: chainsKg,
                bandsKg: bandsKg,
                isSuperSlow: isSuperSlow,
                superSlowNote: superSlowNote,
                supersetGroupId: supersetGroupId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StrengthSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$StrengthSetsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$StrengthSetsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StrengthSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StrengthSetsTable,
      StrengthSet,
      $$StrengthSetsTableFilterComposer,
      $$StrengthSetsTableOrderingComposer,
      $$StrengthSetsTableAnnotationComposer,
      $$StrengthSetsTableCreateCompanionBuilder,
      $$StrengthSetsTableUpdateCompanionBuilder,
      (StrengthSet, $$StrengthSetsTableReferences),
      StrengthSet,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$DailyStepsTableCreateCompanionBuilder =
    DailyStepsCompanion Function({
      Value<int> dateEpochDay,
      required int steps,
      Value<String?> source,
      Value<int> updatedAtMs,
    });
typedef $$DailyStepsTableUpdateCompanionBuilder =
    DailyStepsCompanion Function({
      Value<int> dateEpochDay,
      Value<int> steps,
      Value<String?> source,
      Value<int> updatedAtMs,
    });

class $$DailyStepsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyStepsTable> {
  $$DailyStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyStepsTable> {
  $$DailyStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyStepsTable> {
  $$DailyStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get dateEpochDay => $composableBuilder(
    column: $table.dateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );
}

class $$DailyStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyStepsTable,
          DailyStep,
          $$DailyStepsTableFilterComposer,
          $$DailyStepsTableOrderingComposer,
          $$DailyStepsTableAnnotationComposer,
          $$DailyStepsTableCreateCompanionBuilder,
          $$DailyStepsTableUpdateCompanionBuilder,
          (
            DailyStep,
            BaseReferences<_$AppDatabase, $DailyStepsTable, DailyStep>,
          ),
          DailyStep,
          PrefetchHooks Function()
        > {
  $$DailyStepsTableTableManager(_$AppDatabase db, $DailyStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> dateEpochDay = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
              }) => DailyStepsCompanion(
                dateEpochDay: dateEpochDay,
                steps: steps,
                source: source,
                updatedAtMs: updatedAtMs,
              ),
          createCompanionCallback:
              ({
                Value<int> dateEpochDay = const Value.absent(),
                required int steps,
                Value<String?> source = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
              }) => DailyStepsCompanion.insert(
                dateEpochDay: dateEpochDay,
                steps: steps,
                source: source,
                updatedAtMs: updatedAtMs,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyStepsTable,
      DailyStep,
      $$DailyStepsTableFilterComposer,
      $$DailyStepsTableOrderingComposer,
      $$DailyStepsTableAnnotationComposer,
      $$DailyStepsTableCreateCompanionBuilder,
      $$DailyStepsTableUpdateCompanionBuilder,
      (DailyStep, BaseReferences<_$AppDatabase, $DailyStepsTable, DailyStep>),
      DailyStep,
      PrefetchHooks Function()
    >;
typedef $$HrSettingsTableCreateCompanionBuilder =
    HrSettingsCompanion Function({
      Value<int> id,
      Value<String> mode,
      Value<String?> sex,
      Value<int?> birthYear,
      Value<int?> hrRestBpm,
      Value<int?> hrMaxBpm,
      Value<int?> z1Upper,
      Value<int?> z2Upper,
      Value<int?> z3Upper,
      Value<int?> z4Upper,
      Value<int?> z5Upper,
      Value<int> updatedAtMs,
      Value<String?> notes,
    });
typedef $$HrSettingsTableUpdateCompanionBuilder =
    HrSettingsCompanion Function({
      Value<int> id,
      Value<String> mode,
      Value<String?> sex,
      Value<int?> birthYear,
      Value<int?> hrRestBpm,
      Value<int?> hrMaxBpm,
      Value<int?> z1Upper,
      Value<int?> z2Upper,
      Value<int?> z3Upper,
      Value<int?> z4Upper,
      Value<int?> z5Upper,
      Value<int> updatedAtMs,
      Value<String?> notes,
    });

class $$HrSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $HrSettingsTable> {
  $$HrSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrRestBpm => $composableBuilder(
    column: $table.hrRestBpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrMaxBpm => $composableBuilder(
    column: $table.hrMaxBpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get z1Upper => $composableBuilder(
    column: $table.z1Upper,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get z2Upper => $composableBuilder(
    column: $table.z2Upper,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get z3Upper => $composableBuilder(
    column: $table.z3Upper,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get z4Upper => $composableBuilder(
    column: $table.z4Upper,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get z5Upper => $composableBuilder(
    column: $table.z5Upper,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HrSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $HrSettingsTable> {
  $$HrSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrRestBpm => $composableBuilder(
    column: $table.hrRestBpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrMaxBpm => $composableBuilder(
    column: $table.hrMaxBpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get z1Upper => $composableBuilder(
    column: $table.z1Upper,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get z2Upper => $composableBuilder(
    column: $table.z2Upper,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get z3Upper => $composableBuilder(
    column: $table.z3Upper,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get z4Upper => $composableBuilder(
    column: $table.z4Upper,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get z5Upper => $composableBuilder(
    column: $table.z5Upper,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HrSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HrSettingsTable> {
  $$HrSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<int> get birthYear =>
      $composableBuilder(column: $table.birthYear, builder: (column) => column);

  GeneratedColumn<int> get hrRestBpm =>
      $composableBuilder(column: $table.hrRestBpm, builder: (column) => column);

  GeneratedColumn<int> get hrMaxBpm =>
      $composableBuilder(column: $table.hrMaxBpm, builder: (column) => column);

  GeneratedColumn<int> get z1Upper =>
      $composableBuilder(column: $table.z1Upper, builder: (column) => column);

  GeneratedColumn<int> get z2Upper =>
      $composableBuilder(column: $table.z2Upper, builder: (column) => column);

  GeneratedColumn<int> get z3Upper =>
      $composableBuilder(column: $table.z3Upper, builder: (column) => column);

  GeneratedColumn<int> get z4Upper =>
      $composableBuilder(column: $table.z4Upper, builder: (column) => column);

  GeneratedColumn<int> get z5Upper =>
      $composableBuilder(column: $table.z5Upper, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$HrSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HrSettingsTable,
          HrSetting,
          $$HrSettingsTableFilterComposer,
          $$HrSettingsTableOrderingComposer,
          $$HrSettingsTableAnnotationComposer,
          $$HrSettingsTableCreateCompanionBuilder,
          $$HrSettingsTableUpdateCompanionBuilder,
          (
            HrSetting,
            BaseReferences<_$AppDatabase, $HrSettingsTable, HrSetting>,
          ),
          HrSetting,
          PrefetchHooks Function()
        > {
  $$HrSettingsTableTableManager(_$AppDatabase db, $HrSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HrSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HrSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HrSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<int?> hrRestBpm = const Value.absent(),
                Value<int?> hrMaxBpm = const Value.absent(),
                Value<int?> z1Upper = const Value.absent(),
                Value<int?> z2Upper = const Value.absent(),
                Value<int?> z3Upper = const Value.absent(),
                Value<int?> z4Upper = const Value.absent(),
                Value<int?> z5Upper = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => HrSettingsCompanion(
                id: id,
                mode: mode,
                sex: sex,
                birthYear: birthYear,
                hrRestBpm: hrRestBpm,
                hrMaxBpm: hrMaxBpm,
                z1Upper: z1Upper,
                z2Upper: z2Upper,
                z3Upper: z3Upper,
                z4Upper: z4Upper,
                z5Upper: z5Upper,
                updatedAtMs: updatedAtMs,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<int?> hrRestBpm = const Value.absent(),
                Value<int?> hrMaxBpm = const Value.absent(),
                Value<int?> z1Upper = const Value.absent(),
                Value<int?> z2Upper = const Value.absent(),
                Value<int?> z3Upper = const Value.absent(),
                Value<int?> z4Upper = const Value.absent(),
                Value<int?> z5Upper = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => HrSettingsCompanion.insert(
                id: id,
                mode: mode,
                sex: sex,
                birthYear: birthYear,
                hrRestBpm: hrRestBpm,
                hrMaxBpm: hrMaxBpm,
                z1Upper: z1Upper,
                z2Upper: z2Upper,
                z3Upper: z3Upper,
                z4Upper: z4Upper,
                z5Upper: z5Upper,
                updatedAtMs: updatedAtMs,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HrSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HrSettingsTable,
      HrSetting,
      $$HrSettingsTableFilterComposer,
      $$HrSettingsTableOrderingComposer,
      $$HrSettingsTableAnnotationComposer,
      $$HrSettingsTableCreateCompanionBuilder,
      $$HrSettingsTableUpdateCompanionBuilder,
      (HrSetting, BaseReferences<_$AppDatabase, $HrSettingsTable, HrSetting>),
      HrSetting,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<int?> birthDateEpochDay,
      Value<String?> sex,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<int> updatedAtMs,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<int?> birthDateEpochDay,
      Value<String?> sex,
      Value<double?> heightCm,
      Value<double?> weightKg,
      Value<int> updatedAtMs,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthDateEpochDay => $composableBuilder(
    column: $table.birthDateEpochDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthDateEpochDay => $composableBuilder(
    column: $table.birthDateEpochDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get birthDateEpochDay => $composableBuilder(
    column: $table.birthDateEpochDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get updatedAtMs => $composableBuilder(
    column: $table.updatedAtMs,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> birthDateEpochDay = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                birthDateEpochDay: birthDateEpochDay,
                sex: sex,
                heightCm: heightCm,
                weightKg: weightKg,
                updatedAtMs: updatedAtMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> birthDateEpochDay = const Value.absent(),
                Value<String?> sex = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int> updatedAtMs = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                birthDateEpochDay: birthDateEpochDay,
                sex: sex,
                heightCm: heightCm,
                weightKg: weightKg,
                updatedAtMs: updatedAtMs,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RunSessionsTableTableManager get runSessions =>
      $$RunSessionsTableTableManager(_db, _db.runSessions);
  $$RunSamplesTableTableManager get runSamples =>
      $$RunSamplesTableTableManager(_db, _db.runSamples);
  $$StrengthSessionsTableTableManager get strengthSessions =>
      $$StrengthSessionsTableTableManager(_db, _db.strengthSessions);
  $$StrengthSetsTableTableManager get strengthSets =>
      $$StrengthSetsTableTableManager(_db, _db.strengthSets);
  $$DailyStepsTableTableManager get dailySteps =>
      $$DailyStepsTableTableManager(_db, _db.dailySteps);
  $$HrSettingsTableTableManager get hrSettings =>
      $$HrSettingsTableTableManager(_db, _db.hrSettings);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
}
