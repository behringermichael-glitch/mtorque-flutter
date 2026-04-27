import 'indoor_axis_spec.dart';
import 'indoor_interval_phase.dart';

class IndoorIntervalProtocol {
  const IndoorIntervalProtocol({
    required this.axisKey,
    required this.phases,
    this.protocolName,
  });

  final String axisKey;
  final String? protocolName;
  final List<IndoorIntervalPhase> phases;

  int get totalSec {
    var total = 0;
    for (final phase in phases) {
      total += phase.durSec;
    }
    return total;
  }

  double weightedIntensityAverage({
    required int decimals,
  }) {
    final duration = totalSec;
    if (duration <= 0 || phases.isEmpty) {
      return 0.0;
    }

    var weighted = 0.0;
    for (final phase in phases) {
      weighted += phase.intensity * phase.durSec;
    }

    final factor = _pow10(decimals);
    return ((weighted / duration) * factor).roundToDouble() / factor;
  }

  double? weightedExtraAverage({
    required String key,
    required double fallback,
    required int decimals,
  }) {
    final duration = totalSec;
    if (duration <= 0 || phases.isEmpty) {
      return null;
    }

    var weighted = 0.0;
    for (final phase in phases) {
      weighted += (phase.extra[key] ?? fallback) * phase.durSec;
    }

    final factor = _pow10(decimals);
    return ((weighted / duration) * factor).roundToDouble() / factor;
  }

  static IndoorIntervalProtocol defaultForSportCode(
      String sportCode, {
        String? protocolName,
      }) {
    final axis = IndoorAxisSpec.forSportCode(sportCode);
    final extra = axis.extra;

    return IndoorIntervalProtocol(
      axisKey: axis.key,
      protocolName: protocolName,
      phases: [
        IndoorIntervalPhase(
          durSec: 10 * 60,
          intensity: axis.roundValue(axis.defaultValue),
          extra: extra == null
              ? const <String, double>{}
              : <String, double>{
            extra.key: extra.roundValue(extra.defaultValue),
          },
        ),
      ],
    );
  }

  static double _pow10(int decimals) {
    var result = 1.0;
    for (var i = 0; i < decimals; i++) {
      result *= 10.0;
    }
    return result;
  }
}