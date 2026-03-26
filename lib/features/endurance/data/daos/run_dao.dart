import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../tables/run_samples_table.dart';
import '../tables/run_sessions_table.dart';

part 'run_dao.g.dart';

class DailyTotal {
  const DailyTotal({required this.day, required this.distM, required this.durMs});
  final String day;
  final double distM;
  final int durMs;
}

class WeeklyTotal {
  const WeeklyTotal({required this.yearWeek, required this.distM, required this.durMs});
  final String yearWeek;
  final double distM;
  final int durMs;
}

class DailyTotalsBySportRow {
  const DailyTotalsBySportRow({
    required this.day,
    required this.sport,
    required this.distM,
    required this.durMs,
    required this.avgBpm,
  });

  final String day;
  final String? sport;
  final double distM;
  final int durMs;
  final double? avgBpm;
}

class DailyEnduranceSessionAggRow {
  const DailyEnduranceSessionAggRow({
    required this.day,
    required this.sport,
    required this.sessions,
    required this.distM,
    required this.durMs,
    required this.avgHrBpm,
    required this.maxHrBpm,
    required this.elevGainM,
    required this.avgRpe,
    required this.z1s,
    required this.z2s,
    required this.z3s,
    required this.z4s,
    required this.z5s,
  });

  final String day;
  final String? sport;
  final int sessions;
  final double distM;
  final int durMs;
  final double? avgHrBpm;
  final int? maxHrBpm;
  final double elevGainM;
  final double? avgRpe;
  final int z1s;
  final int z2s;
  final int z3s;
  final int z4s;
  final int z5s;
}

class DailyEnduranceSampleAggRow {
  const DailyEnduranceSampleAggRow({
    required this.day,
    required this.sport,
    required this.maxSpeedMps,
    required this.avgSpeedMps,
    required this.avgAccM,
    required this.maxElevM,
    required this.minElevM,
  });

  final String day;
  final String? sport;
  final double? maxSpeedMps;
  final double? avgSpeedMps;
  final double? avgAccM;
  final double? maxElevM;
  final double? minElevM;
}

class RunDayCount {
  const RunDayCount({required this.day, required this.cnt});
  final String day;
  final int cnt;
}

class RunSums {
  const RunSums({required this.distM, required this.durMs});
  final double distM;
  final int durMs;
}

@DriftAccessor(tables: [RunSessions, RunSamples])
class RunDao extends DatabaseAccessor<AppDatabase> with _$RunDaoMixin {
  RunDao(super.db);

  Future<int> insertSession(RunSessionsCompanion session) {
    return into(runSessions).insert(session);
  }

  Future<void> finalizeSession({
    required int id,
    required int endMs,
    required double dist,
    required int dur,
    int? avgHr,
    int? maxHr,
    double? elevGainM,
  }) {
    return (update(runSessions)..where((t) => t.id.equals(id))).write(
      RunSessionsCompanion(
        endEpochMs: Value(endMs),
        totalDistanceM: Value(dist),
        totalDurationMs: Value(dur),
        avgHr: Value(avgHr),
        maxHr: Value(maxHr),
        elevGainM: Value(elevGainM),
      ),
    );
  }

  Future<void> updateHrZonesForSession({
    required int id,
    required int z1,
    required int z2,
    required int z3,
    required int z4,
    required int z5,
    String? method,
    int? hrMax,
    int? hrRest,
    String? boundsJson,
  }) {
    return (update(runSessions)..where((t) => t.id.equals(id))).write(
      RunSessionsCompanion(
        timeZ1s: Value(z1),
        timeZ2s: Value(z2),
        timeZ3s: Value(z3),
        timeZ4s: Value(z4),
        timeZ5s: Value(z5),
        hrZoneMethod: Value(method),
        hrMaxUsed: Value(hrMax),
        hrRestUsed: Value(hrRest),
        hrZoneBoundsJson: Value(boundsJson),
      ),
    );
  }

  Future<void> updateNotes(int id, String? notes) {
    return (update(runSessions)..where((t) => t.id.equals(id))).write(
      RunSessionsCompanion(notes: Value(notes)),
    );
  }

  Future<void> updateSessionSport(int id, String? sport) {
    return (update(runSessions)..where((t) => t.id.equals(id))).write(
      RunSessionsCompanion(sport: Value(sport)),
    );
  }

  Future<void> updateIndoorSettings(int id, String? json) {
    return (update(runSessions)..where((t) => t.id.equals(id))).write(
      RunSessionsCompanion(indoorSettingsJson: Value(json)),
    );
  }

  Future<void> updateRpe(int id, int? rpe) {
    return (update(runSessions)..where((t) => t.id.equals(id))).write(
      RunSessionsCompanion(rpe0to10: Value(rpe)),
    );
  }

  Future<void> insertSamples(List<RunSamplesCompanion> samples) async {
    if (samples.isEmpty) return;
    await batch((batch) => batch.insertAll(runSamples, samples));
  }

  Future<List<RunSample>> samplesForSession(int sessionId) {
    return (select(runSamples)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.tEpochMs)]))
        .get();
  }

  Future<List<RunSample>> samplesAfter(int sessionId, int afterEpochMs) {
    return (select(runSamples)
          ..where((t) => t.sessionId.equals(sessionId) & t.tEpochMs.isBiggerThanValue(afterEpochMs))
          ..orderBy([(t) => OrderingTerm.asc(t.tEpochMs)]))
        .get();
  }

  Future<void> deleteSession(int sessionId) {
    return (delete(runSessions)..where((t) => t.id.equals(sessionId))).go();
  }

  Future<RunSession?> activeSession() {
    return (select(runSessions)
          ..where((t) => t.endEpochMs.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.startEpochMs)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<RunSession>> recentRuns(int limit) {
    return (select(runSessions)
          ..where((t) => t.endEpochMs.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.endEpochMs)])
          ..limit(limit))
        .get();
  }

  Future<List<RunSession>> allFinishedSessions() {
    return (select(runSessions)
          ..where((t) => t.endEpochMs.isNotNull())
          ..orderBy([(t) => OrderingTerm.asc(t.startEpochMs)]))
        .get();
  }

  Future<List<RunSession>> finishedSessionsInRange({
    required int startEpochMs,
    required int endEpochMs,
  }) {
    return (select(runSessions)
          ..where((t) =>
              t.endEpochMs.isNotNull() &
              t.startEpochMs.isBiggerOrEqualValue(startEpochMs) &
              t.startEpochMs.isSmallerThanValue(endEpochMs))
          ..orderBy([(t) => OrderingTerm.asc(t.startEpochMs)]))
        .get();
  }

  Future<List<RunSession>> sessionsOverlapping({
    required int startEpochMs,
    required int endEpochMs,
  }) {
    return (select(runSessions)
          ..where((t) =>
              t.startEpochMs.isSmallerOrEqualValue(endEpochMs) &
              (t.endEpochMs.isNull() | t.endEpochMs.isBiggerOrEqualValue(startEpochMs)))
          ..orderBy([(t) => OrderingTerm.asc(t.startEpochMs)]))
        .get();
  }

  Future<int> countFinishedSessionsOverlapping({
    required int startEpochMs,
    required int endExclusiveMs,
  }) async {
    final row = await customSelect(
      '''
      SELECT COUNT(*) AS cnt
      FROM run_session
      WHERE endEpochMs IS NOT NULL
        AND NOT (endEpochMs <= ? OR startEpochMs >= ?)
      ''',
      variables: [Variable.withInt(startEpochMs), Variable.withInt(endExclusiveMs)],
      readsFrom: {runSessions},
    ).getSingle();

    return row.read<int>('cnt');
  }

  Future<RunSums> sumsInRange({
    required int startEpochMs,
    required int endEpochMs,
  }) async {
    final row = await customSelect(
      '''
      SELECT
        COALESCE(SUM(totalDistanceM), 0) AS distM,
        COALESCE(SUM(totalDurationMs), 0) AS durMs
      FROM run_session
      WHERE endEpochMs IS NOT NULL
        AND startEpochMs >= ?
        AND startEpochMs < ?
      ''',
      variables: [Variable.withInt(startEpochMs), Variable.withInt(endEpochMs)],
      readsFrom: {runSessions},
    ).getSingle();

    return RunSums(
      distM: row.read<double>('distM'),
      durMs: row.read<int>('durMs'),
    );
  }

  Future<List<DailyTotal>> dailyTotals() async {
    final rows = await customSelect(
      '''
      SELECT date(startEpochMs/1000,'unixepoch','localtime') AS day,
             SUM(totalDistanceM) AS distM,
             SUM(totalDurationMs) AS durMs
      FROM run_session
      WHERE endEpochMs IS NOT NULL
      GROUP BY day
      ORDER BY day DESC
      ''',
      readsFrom: {runSessions},
    ).get();

    return rows
        .map((row) => DailyTotal(
              day: row.read<String>('day'),
              distM: row.read<double>('distM'),
              durMs: row.read<int>('durMs'),
            ))
        .toList(growable: false);
  }

  Future<List<WeeklyTotal>> weeklyTotals() async {
    final rows = await customSelect(
      '''
      SELECT strftime('%Y-%W', startEpochMs/1000,'unixepoch','localtime') AS yearWeek,
             SUM(totalDistanceM) AS distM,
             SUM(totalDurationMs) AS durMs
      FROM run_session
      WHERE endEpochMs IS NOT NULL
      GROUP BY yearWeek
      ORDER BY yearWeek DESC
      ''',
      readsFrom: {runSessions},
    ).get();

    return rows
        .map((row) => WeeklyTotal(
              yearWeek: row.read<String>('yearWeek'),
              distM: row.read<double>('distM'),
              durMs: row.read<int>('durMs'),
            ))
        .toList(growable: false);
  }

  Future<List<DailyTotalsBySportRow>> dailyTotalsGroupedBySport({
    required int startEpochMs,
    required int endEpochMs,
  }) async {
    final rows = await customSelect(
      '''
      SELECT date(startEpochMs/1000,'unixepoch','localtime') AS day,
             sport AS sport,
             COALESCE(SUM(totalDistanceM), 0) AS distM,
             COALESCE(SUM(totalDurationMs), 0) AS durMs,
             AVG(avgHr) AS avgBpm
      FROM run_session
      WHERE endEpochMs IS NOT NULL
        AND startEpochMs >= ?
        AND startEpochMs < ?
      GROUP BY day, sport
      ORDER BY day ASC
      ''',
      variables: [Variable.withInt(startEpochMs), Variable.withInt(endEpochMs)],
      readsFrom: {runSessions},
    ).get();

    return rows
        .map((row) => DailyTotalsBySportRow(
              day: row.read<String>('day'),
              sport: row.readNullable<String>('sport'),
              distM: row.read<double>('distM'),
              durMs: row.read<int>('durMs'),
              avgBpm: row.readNullable<double>('avgBpm'),
            ))
        .toList(growable: false);
  }

  Future<List<DailyEnduranceSessionAggRow>> dailyEnduranceSessionAgg({
    required int startEpochMs,
    required int endEpochMs,
  }) async {
    final rows = await customSelect(
      '''
      SELECT date(startEpochMs/1000,'unixepoch','localtime') AS day,
             sport AS sport,
             COUNT(*) AS sessions,
             COALESCE(SUM(totalDistanceM), 0) AS distM,
             COALESCE(SUM(totalDurationMs), 0) AS durMs,
             AVG(avgHr) AS avgHrBpm,
             MAX(maxHr) AS maxHrBpm,
             COALESCE(SUM(elev_gain_m), 0) AS elevGainM,
             AVG(rpe_0_10) AS avgRpe,
             COALESCE(SUM(time_z1_s), 0) AS z1s,
             COALESCE(SUM(time_z2_s), 0) AS z2s,
             COALESCE(SUM(time_z3_s), 0) AS z3s,
             COALESCE(SUM(time_z4_s), 0) AS z4s,
             COALESCE(SUM(time_z5_s), 0) AS z5s
      FROM run_session
      WHERE endEpochMs IS NOT NULL
        AND startEpochMs >= ?
        AND startEpochMs < ?
      GROUP BY day, sport
      ORDER BY day ASC
      ''',
      variables: [Variable.withInt(startEpochMs), Variable.withInt(endEpochMs)],
      readsFrom: {runSessions},
    ).get();

    return rows
        .map((row) => DailyEnduranceSessionAggRow(
              day: row.read<String>('day'),
              sport: row.readNullable<String>('sport'),
              sessions: row.read<int>('sessions'),
              distM: row.read<double>('distM'),
              durMs: row.read<int>('durMs'),
              avgHrBpm: row.readNullable<double>('avgHrBpm'),
              maxHrBpm: row.readNullable<int>('maxHrBpm'),
              elevGainM: row.read<double>('elevGainM'),
              avgRpe: row.readNullable<double>('avgRpe'),
              z1s: row.read<int>('z1s'),
              z2s: row.read<int>('z2s'),
              z3s: row.read<int>('z3s'),
              z4s: row.read<int>('z4s'),
              z5s: row.read<int>('z5s'),
            ))
        .toList(growable: false);
  }

  Future<List<DailyEnduranceSampleAggRow>> dailyEnduranceSampleAgg({
    required int startEpochMs,
    required int endEpochMs,
  }) async {
    final rows = await customSelect(
      '''
      SELECT date(s.startEpochMs/1000,'unixepoch','localtime') AS day,
             s.sport AS sport,
             MAX(sm.speedMps) AS maxSpeedMps,
             AVG(sm.speedMps) AS avgSpeedMps,
             AVG(sm.accM) AS avgAccM,
             MAX(sm.elev_m) AS maxElevM,
             MIN(sm.elev_m) AS minElevM
      FROM run_session s
      JOIN run_sample sm ON sm.sessionId = s.id
      WHERE s.endEpochMs IS NOT NULL
        AND s.startEpochMs >= ?
        AND s.startEpochMs < ?
      GROUP BY day, sport
      ORDER BY day ASC
      ''',
      variables: [Variable.withInt(startEpochMs), Variable.withInt(endEpochMs)],
      readsFrom: {runSessions, runSamples},
    ).get();

    return rows
        .map((row) => DailyEnduranceSampleAggRow(
              day: row.read<String>('day'),
              sport: row.readNullable<String>('sport'),
              maxSpeedMps: row.readNullable<double>('maxSpeedMps'),
              avgSpeedMps: row.readNullable<double>('avgSpeedMps'),
              avgAccM: row.readNullable<double>('avgAccM'),
              maxElevM: row.readNullable<double>('maxElevM'),
              minElevM: row.readNullable<double>('minElevM'),
            ))
        .toList(growable: false);
  }

  Future<List<RunDayCount>> getRunDaysInRange({
    required int startEpochMs,
    required int endEpochMs,
  }) async {
    final rows = await customSelect(
      '''
      SELECT date(startEpochMs/1000, 'unixepoch', 'localtime') AS day,
             COUNT(*) AS cnt
      FROM run_session
      WHERE endEpochMs IS NOT NULL
        AND startEpochMs >= ?
        AND startEpochMs < ?
      GROUP BY day
      ''',
      variables: [Variable.withInt(startEpochMs), Variable.withInt(endEpochMs)],
      readsFrom: {runSessions},
    ).get();

    return rows
        .map((row) => RunDayCount(day: row.read<String>('day'), cnt: row.read<int>('cnt')))
        .toList(growable: false);
  }

  Future<List<RunDayCount>> getRunDaysOverlapping({
    required int startEpochMs,
    required int endEpochMs,
  }) async {
    final rows = await customSelect(
      '''
      SELECT date(COALESCE(endEpochMs, startEpochMs)/1000, 'unixepoch', 'localtime') AS day,
             COUNT(*) AS cnt
      FROM run_session
      WHERE endEpochMs IS NOT NULL
        AND NOT (COALESCE(endEpochMs, startEpochMs) < ? OR startEpochMs > ?)
      GROUP BY day
      ''',
      variables: [Variable.withInt(startEpochMs), Variable.withInt(endEpochMs)],
      readsFrom: {runSessions},
    ).get();

    return rows
        .map((row) => RunDayCount(day: row.read<String>('day'), cnt: row.read<int>('cnt')))
        .toList(growable: false);
  }
}
