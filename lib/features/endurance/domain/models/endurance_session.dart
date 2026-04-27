class EnduranceSession {
  const EnduranceSession({
    required this.id,
    required this.startEpochMs,
    required this.endEpochMs,
    required this.totalDistanceM,
    required this.totalDurationMs,
    required this.avgHr,
    required this.maxHr,
    required this.elevGainM,
    required this.notes,
    required this.sport,
    required this.indoorSettingsJson,
    required this.rpe0to10,
    required this.timeZ1s,
    required this.timeZ2s,
    required this.timeZ3s,
    required this.timeZ4s,
    required this.timeZ5s,
    required this.hrZoneMethod,
    required this.hrMaxUsed,
    required this.hrRestUsed,
    required this.hrZoneBoundsJson,
  });

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

  bool get isActive => endEpochMs == null;
}