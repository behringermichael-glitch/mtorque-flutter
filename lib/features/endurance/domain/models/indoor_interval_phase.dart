class IndoorIntervalPhase {
  const IndoorIntervalPhase({
    required this.durSec,
    required this.intensity,
    this.extra = const <String, double>{},
  });

  final int durSec;
  final double intensity;
  final Map<String, double> extra;

  IndoorIntervalPhase copyWith({
    int? durSec,
    double? intensity,
    Map<String, double>? extra,
  }) {
    return IndoorIntervalPhase(
      durSec: durSec ?? this.durSec,
      intensity: intensity ?? this.intensity,
      extra: extra ?? this.extra,
    );
  }
}