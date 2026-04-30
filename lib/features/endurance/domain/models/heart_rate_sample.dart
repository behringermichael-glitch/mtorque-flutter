class HeartRateSample {
  const HeartRateSample({
    required this.bpm,
    required this.timestampMs,
    this.deviceName,
  });

  final int bpm;
  final int timestampMs;
  final String? deviceName;
}