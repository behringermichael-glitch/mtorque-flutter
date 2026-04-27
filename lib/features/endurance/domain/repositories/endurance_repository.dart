import '../models/endurance_sample.dart';
import '../models/endurance_session.dart';

abstract class EnduranceRepository {
  Future<EnduranceSession?> getActiveSession();

  Future<int> createSession({
    required String sport,
    required int startEpochMs,
    String? indoorSettingsJson,
  });

  Future<void> finalizeSession({
    required int sessionId,
    required int endEpochMs,
    required int durationMs,
    required double distanceM,
    int? avgHr,
    int? maxHr,
    double? elevationGainM,
  });

  Future<void> discardSession(int sessionId);

  Future<void> updateIndoorSettings({
    required int sessionId,
    required String? json,
  });

  Future<void> updateNotes({
    required int sessionId,
    required String? notes,
  });

  Future<void> updateRpe({
    required int sessionId,
    required int? rpe0to10,
  });

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
  });

  Future<void> insertSamples(List<EnduranceSample> samples);

  Future<List<EnduranceSample>> samplesForSession(int sessionId);

  Future<List<EnduranceSample>> samplesAfter({
    required int sessionId,
    required int afterEpochMs,
  });
}