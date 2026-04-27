class EnduranceSample {
  const EnduranceSample({
    required this.sid,
    required this.sessionId,
    required this.tEpochMs,
    required this.lat,
    required this.lon,
    required this.hr,
    required this.accM,
    required this.speedMps,
    required this.elevM,
  });

  final int sid;
  final int sessionId;
  final int tEpochMs;
  final double lat;
  final double lon;
  final int? hr;
  final double? accM;
  final double? speedMps;
  final double? elevM;
}