import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../../domain/models/endurance_sample.dart';
import '../../domain/models/endurance_session.dart';
import '../../domain/repositories/endurance_repository.dart';
import '../daos/run_dao.dart';

class DriftEnduranceRepository implements EnduranceRepository {
  const DriftEnduranceRepository(this._runDao);

  final RunDao _runDao;

  @override
  Future<EnduranceSession?> getActiveSession() async {
    final session = await _runDao.activeSession();
    return session == null ? null : _mapSession(session);
  }

  @override
  Future<int> createSession({
    required String sport,
    required int startEpochMs,
    String? indoorSettingsJson,
  }) {
    return _runDao.insertSession(
      RunSessionsCompanion(
        startEpochMs: Value(startEpochMs),
        sport: Value(sport),
        indoorSettingsJson: Value(indoorSettingsJson),
      ),
    );
  }

  @override
  Future<void> finalizeSession({
    required int sessionId,
    required int endEpochMs,
    required int durationMs,
    required double distanceM,
    int? avgHr,
    int? maxHr,
    double? elevationGainM,
  }) {
    return _runDao.finalizeSession(
      id: sessionId,
      endMs: endEpochMs,
      dist: distanceM,
      dur: durationMs,
      avgHr: avgHr,
      maxHr: maxHr,
      elevGainM: elevationGainM,
    );
  }

  @override
  Future<void> discardSession(int sessionId) {
    return _runDao.deleteSession(sessionId);
  }

  @override
  Future<void> updateIndoorSettings({
    required int sessionId,
    required String? json,
  }) {
    return _runDao.updateIndoorSettings(sessionId, json);
  }

  @override
  Future<void> updateNotes({
    required int sessionId,
    required String? notes,
  }) {
    return _runDao.updateNotes(sessionId, notes);
  }

  @override
  Future<void> updateRpe({
    required int sessionId,
    required int? rpe0to10,
  }) {
    return _runDao.updateRpe(sessionId, rpe0to10);
  }

  @override
  Future<void> updateHrZonesForSession({
    required int sessionId,
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
    return _runDao.updateHrZonesForSession(
      id: sessionId,
      z1: z1,
      z2: z2,
      z3: z3,
      z4: z4,
      z5: z5,
      method: method,
      hrMax: hrMax,
      hrRest: hrRest,
      boundsJson: boundsJson,
    );
  }

  @override
  Future<void> insertSamples(List<EnduranceSample> samples) {
    if (samples.isEmpty) {
      return Future<void>.value();
    }

    return _runDao.insertSamples(
      samples
          .map(
            (sample) => RunSamplesCompanion(
          sessionId: Value(sample.sessionId),
          tEpochMs: Value(sample.tEpochMs),
          lat: Value(sample.lat),
          lon: Value(sample.lon),
          hr: Value(sample.hr),
          accM: Value(sample.accM),
          speedMps: Value(sample.speedMps),
          elevM: Value(sample.elevM),
        ),
      )
          .toList(growable: false),
    );
  }

  @override
  Future<List<EnduranceSample>> samplesForSession(int sessionId) async {
    final samples = await _runDao.samplesForSession(sessionId);
    return samples.map(_mapSample).toList(growable: false);
  }

  @override
  Future<List<EnduranceSample>> samplesAfter({
    required int sessionId,
    required int afterEpochMs,
  }) async {
    final samples = await _runDao.samplesAfter(sessionId, afterEpochMs);
    return samples.map(_mapSample).toList(growable: false);
  }

  static EnduranceSession _mapSession(RunSession session) {
    return EnduranceSession(
      id: session.id,
      startEpochMs: session.startEpochMs,
      endEpochMs: session.endEpochMs,
      totalDistanceM: session.totalDistanceM,
      totalDurationMs: session.totalDurationMs,
      avgHr: session.avgHr,
      maxHr: session.maxHr,
      elevGainM: session.elevGainM,
      notes: session.notes,
      sport: session.sport,
      indoorSettingsJson: session.indoorSettingsJson,
      rpe0to10: session.rpe0to10,
      timeZ1s: session.timeZ1s,
      timeZ2s: session.timeZ2s,
      timeZ3s: session.timeZ3s,
      timeZ4s: session.timeZ4s,
      timeZ5s: session.timeZ5s,
      hrZoneMethod: session.hrZoneMethod,
      hrMaxUsed: session.hrMaxUsed,
      hrRestUsed: session.hrRestUsed,
      hrZoneBoundsJson: session.hrZoneBoundsJson,
    );
  }

  static EnduranceSample _mapSample(RunSample sample) {
    return EnduranceSample(
      sid: sample.sid,
      sessionId: sample.sessionId,
      tEpochMs: sample.tEpochMs,
      lat: sample.lat,
      lon: sample.lon,
      hr: sample.hr,
      accM: sample.accM,
      speedMps: sample.speedMps,
      elevM: sample.elevM,
    );
  }
}