import '../models/indoor_interval_protocol.dart';

class IndoorProtocolTimelineSnapshot {
  const IndoorProtocolTimelineSnapshot({
    required this.currentPhaseIndex,
    required this.elapsedSec,
    required this.totalSec,
    required this.phaseElapsedSec,
    required this.phaseRemainingSec,
    required this.totalRemainingSec,
    required this.protocolCompleted,
  });

  final int currentPhaseIndex;
  final int elapsedSec;
  final int totalSec;
  final int phaseElapsedSec;
  final int phaseRemainingSec;
  final int totalRemainingSec;
  final bool protocolCompleted;
}

abstract final class IndoorProtocolTimeline {
  static IndoorProtocolTimelineSnapshot resolve({
    required IndoorIntervalProtocol protocol,
    required int elapsedMs,
  }) {
    final phases = protocol.phases;
    final totalSec = protocol.totalSec <= 0 ? 0 : protocol.totalSec;
    final elapsedSec = elapsedMs <= 0 ? 0 : elapsedMs ~/ 1000;

    if (phases.isEmpty || totalSec <= 0) {
      return IndoorProtocolTimelineSnapshot(
        currentPhaseIndex: 0,
        elapsedSec: elapsedSec,
        totalSec: 0,
        phaseElapsedSec: 0,
        phaseRemainingSec: 0,
        totalRemainingSec: 0,
        protocolCompleted: elapsedSec > 0,
      );
    }

    final protocolCompleted = elapsedSec >= totalSec;
    final boundedElapsedSec = protocolCompleted ? totalSec : elapsedSec;

    var accumulatedSec = 0;

    for (var index = 0; index < phases.length; index++) {
      final phase = phases[index];
      final phaseDurationSec = phase.durSec <= 0 ? 1 : phase.durSec;
      final phaseEndSec = accumulatedSec + phaseDurationSec;

      final isCurrentPhase =
          boundedElapsedSec < phaseEndSec || index == phases.length - 1;

      if (isCurrentPhase) {
        final phaseElapsedSec =
        (boundedElapsedSec - accumulatedSec).clamp(0, phaseDurationSec);

        final phaseRemainingSec =
        protocolCompleted ? 0 : phaseDurationSec - phaseElapsedSec;

        final totalRemainingSec =
        protocolCompleted ? 0 : totalSec - boundedElapsedSec;

        return IndoorProtocolTimelineSnapshot(
          currentPhaseIndex: index,
          elapsedSec: elapsedSec,
          totalSec: totalSec,
          phaseElapsedSec: phaseElapsedSec,
          phaseRemainingSec: phaseRemainingSec,
          totalRemainingSec: totalRemainingSec,
          protocolCompleted: protocolCompleted,
        );
      }

      accumulatedSec = phaseEndSec;
    }

    return IndoorProtocolTimelineSnapshot(
      currentPhaseIndex: phases.length - 1,
      elapsedSec: elapsedSec,
      totalSec: totalSec,
      phaseElapsedSec: phases.last.durSec,
      phaseRemainingSec: 0,
      totalRemainingSec: 0,
      protocolCompleted: true,
    );
  }
}