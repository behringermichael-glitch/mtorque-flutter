import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtorque_flutter/l10n/app_localizations.dart';

import '../../domain/models/endurance_sport.dart';
import '../../domain/models/indoor_axis_spec.dart';
import '../../domain/models/indoor_interval_protocol.dart';
import '../state/indoor_training_controller.dart';
import '../widgets/interval_protocol_chart.dart';

class IndoorTrainingPage extends ConsumerWidget {
  const IndoorTrainingPage({
    super.key,
    required this.sport,
    this.sessionId,
  });

  final EnduranceSport sport;
  final int? sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final args = IndoorTrainingArgs(
      sport: sport,
      sessionId: sessionId,
    );

    final state = ref.watch(indoorTrainingControllerProvider(args));
    final controller = ref.read(indoorTrainingControllerProvider(args).notifier);

    ref.listen(
      indoorTrainingControllerProvider(args),
          (previous, next) {
        final message = next.errorMessage;
        if (message == null || message.isEmpty) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.enduranceOperationFailed),
          ),
        );
      },
    );

    final theme = Theme.of(context);
    final panelColor =
        theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow;
    final panelBorderColor = theme.colorScheme.outlineVariant;

    final sportLabel = _sportLabel(l10n, sport);
    final axis = IndoorAxisSpec.forSportCode(sport.code);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: panelColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(color: panelBorderColor, width: 1),
        ),
        title: Text(sportLabel),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            _StatusCard(
              sportLabel: sportLabel,
              elapsedText: _formatElapsed(state.elapsedMs),
              isActive: state.isActive,
              isBusy: state.isBusy,
            ),
            const SizedBox(height: 16),
            _ProtocolCard(
              protocol: state.protocol,
              axis: axis,
              elapsedMs: state.elapsedMs,
              selectedIndex: state.selectedPhaseIndex,
              onAddPhase: controller.addDefaultPhase,
              onPhaseSelected: controller.selectPhase,
            ),
            const SizedBox(height: 16),
            _PhaseEditorCard(
              protocol: state.protocol,
              axis: axis,
              selectedIndex: state.selectedPhaseIndex,
              onChanged: controller.updateSelectedPhase,
              onDelete: controller.deleteSelectedPhase,
            ),
            const SizedBox(height: 24),
            if (!state.isActive)
              FilledButton.icon(
                onPressed: state.isBusy ? null : controller.startSession,
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.enduranceStartSession),
              )
            else
              OutlinedButton.icon(
                onPressed: state.isBusy
                    ? null
                    : () async {
                  await controller.discardSession();
                  if (context.mounted) {
                    Navigator.of(context).maybePop();
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.enduranceDiscardSession),
              ),
            const SizedBox(height: 12),
            Text(
              l10n.enduranceIndoorCompatibilityHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatElapsed(int elapsedMs) {
    final totalSeconds = elapsedMs ~/ 1000;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  static String _sportLabel(
      AppLocalizations l10n,
      EnduranceSport sport,
      ) {
    switch (sport.code) {
      case 'TREADMILL':
        return l10n.enduranceSportTreadmill;
      case 'TREADMILL_WALKING':
        return l10n.enduranceSportTreadmillWalking;
      case 'ERGOMETER':
        return l10n.enduranceSportErgometer;
      case 'ROWER':
        return l10n.enduranceSportRower;
      case 'SPINNING':
        return l10n.enduranceSportSpinning;
      case 'CROSSTRAINER':
        return l10n.enduranceSportCrosstrainer;
      case 'STAIRCLIMBER':
        return l10n.enduranceSportStairclimber;
      case 'STEPPER':
        return l10n.enduranceSportStepper;
      case 'JUMPROPE':
        return l10n.enduranceSportJumpRope;
      case 'SKI_ERGOMETER':
        return l10n.enduranceSportSkiErgometer;
      case 'ARM_ERGOMETER':
        return l10n.enduranceSportArmErgometer;
      case 'AIR_BIKE':
        return l10n.enduranceSportAirBike;
      default:
        return sport.code;
    }
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.sportLabel,
    required this.elapsedText,
    required this.isActive,
    required this.isBusy,
  });

  final String sportLabel;
  final String elapsedText;
  final bool isActive;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sportLabel,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              elapsedText,
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontFeatures: const [],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isActive ? Icons.radio_button_checked : Icons.circle_outlined,
                  size: 18,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isActive
                        ? l10n.enduranceSessionActive
                        : l10n.enduranceSessionNotStarted,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                if (isBusy)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProtocolCard extends StatelessWidget {
  const _ProtocolCard({
    required this.protocol,
    required this.axis,
    required this.elapsedMs,
    required this.selectedIndex,
    required this.onAddPhase,
    required this.onPhaseSelected,
  });

  final IndoorIntervalProtocol protocol;
  final IndoorAxisSpec axis;
  final int elapsedMs;
  final int selectedIndex;
  final VoidCallback onAddPhase;
  final ValueChanged<int> onPhaseSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final intensityAverage = protocol.weightedIntensityAverage(
      decimals: axis.decimals,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProtocolHeader(
              title: l10n.enduranceLoadPlan,
              subtitle: _summaryText(
                protocol: protocol,
                axis: axis,
              ),
            ),
            const SizedBox(height: 10),
            IntervalProtocolChart(
              phases: protocol.phases,
              axisLabel: _axisLabel(l10n, axis.key),
              axisUnit: _axisUnit(axis.key),
              elapsedMs: elapsedMs,
              selectedIndex: selectedIndex,
              showAddButton: true,
              onAddPhase: onAddPhase,
              onPhaseSelected: onPhaseSelected,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: l10n.enduranceIndoorProtocolDuration,
              value: _formatDuration(protocol.totalSec),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: _axisLabel(l10n, axis.key),
              value: _formatAxisValue(
                value: intensityAverage,
                decimals: axis.decimals,
                unit: _axisUnit(axis.key),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _summaryText({
    required IndoorIntervalProtocol protocol,
    required IndoorAxisSpec axis,
  }) {
    final average = protocol.weightedIntensityAverage(
      decimals: axis.decimals,
    );

    final intensity = _formatAxisValue(
      value: average,
      decimals: axis.decimals,
      unit: _axisUnit(axis.key),
    );

    return '${_formatDuration(protocol.totalSec)} · $intensity';
  }

  static String _formatDuration(int totalSec) {
    final minutes = totalSec ~/ 60;
    final seconds = totalSec % 60;

    if (seconds == 0) {
      return '$minutes min';
    }

    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }

  static String _formatAxisValue({
    required double value,
    required int decimals,
    required String unit,
  }) {
    final formatted = decimals == 0
        ? value.round().toString()
        : value.toStringAsFixed(decimals);

    if (unit.isEmpty) {
      return formatted;
    }

    return '$formatted $unit';
  }

  static String _axisLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'speedKmh':
        return l10n.enduranceAxisSpeed;
      case 'powerW':
        return l10n.enduranceAxisPower;
      case 'level':
        return l10n.enduranceAxisLevel;
      case 'inclinePct':
        return l10n.enduranceAxisIncline;
      case 'intensity':
        return l10n.enduranceAxisIntensity;
      default:
        return key;
    }
  }

  static String _axisUnit(String key) {
    switch (key) {
      case 'speedKmh':
        return 'km/h';
      case 'powerW':
        return 'W';
      case 'inclinePct':
        return '%';
      default:
        return '';
    }
  }
}

class _ProtocolHeader extends StatelessWidget {
  const _ProtocolHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Divider(
                height: 1,
                thickness: 1,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.55,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.volume_up_outlined),
        ),
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }
}

class _PhaseEditorCard extends StatelessWidget {
  const _PhaseEditorCard({
    required this.protocol,
    required this.axis,
    required this.selectedIndex,
    required this.onChanged,
    required this.onDelete,
  });

  final IndoorIntervalProtocol protocol;
  final IndoorAxisSpec axis;
  final int selectedIndex;
  final Future<void> Function({
  int? durSec,
  double? intensity,
  Map<String, double>? extra,
  }) onChanged;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    if (protocol.phases.isEmpty ||
        selectedIndex < 0 ||
        selectedIndex >= protocol.phases.length) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final phase = protocol.phases[selectedIndex];

    final minutes = phase.durSec ~/ 60;
    final seconds = phase.durSec % 60;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.enduranceSelectedPhase,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                  protocol.phases.length <= 1 ? null : () => onDelete(),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ValueStepper(
              label: _axisLabel(l10n, axis.key),
              value: _formatValue(
                phase.intensity,
                axis.decimals,
                _axisUnit(axis.key),
              ),
              onDecrease: () {
                final next = (phase.intensity - axis.step)
                    .clamp(axis.min, axis.max)
                    .toDouble();

                return onChanged(
                  intensity: axis.roundValue(next),
                );
              },
              onIncrease: () {
                final next = (phase.intensity + axis.step)
                    .clamp(axis.min, axis.max)
                    .toDouble();

                return onChanged(
                  intensity: axis.roundValue(next),
                );
              },
            ),
            if (axis.extra != null) ...[
              const SizedBox(height: 12),
              _ValueStepper(
                label: _axisLabel(l10n, axis.extra!.key),
                value: _formatValue(
                  phase.extra[axis.extra!.key] ?? axis.extra!.defaultValue,
                  axis.extra!.decimals,
                  _axisUnit(axis.extra!.key),
                ),
                onDecrease: () {
                  final current =
                      phase.extra[axis.extra!.key] ?? axis.extra!.defaultValue;

                  final next = (current - axis.extra!.step)
                      .clamp(axis.extra!.min, axis.extra!.max)
                      .toDouble();

                  return onChanged(
                    extra: {
                      ...phase.extra,
                      axis.extra!.key: axis.extra!.roundValue(next),
                    },
                  );
                },
                onIncrease: () {
                  final current =
                      phase.extra[axis.extra!.key] ?? axis.extra!.defaultValue;

                  final next = (current + axis.extra!.step)
                      .clamp(axis.extra!.min, axis.extra!.max)
                      .toDouble();

                  return onChanged(
                    extra: {
                      ...phase.extra,
                      axis.extra!.key: axis.extra!.roundValue(next),
                    },
                  );
                },
              ),
            ],
            const SizedBox(height: 12),
            _ValueStepper(
              label: l10n.enduranceIndoorProtocolDuration,
              value:
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              onDecrease: () {
                final next = (phase.durSec - 30).clamp(30, 24 * 3600);
                return onChanged(durSec: next);
              },
              onIncrease: () {
                final next = (phase.durSec + 30).clamp(30, 24 * 3600);
                return onChanged(durSec: next);
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _formatValue(
      double value,
      int decimals,
      String unit,
      ) {
    final formatted = decimals == 0
        ? value.round().toString()
        : value.toStringAsFixed(decimals);

    return unit.isEmpty ? formatted : '$formatted $unit';
  }

  static String _axisLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'speedKmh':
        return l10n.enduranceAxisSpeed;
      case 'powerW':
        return l10n.enduranceAxisPower;
      case 'level':
        return l10n.enduranceAxisLevel;
      case 'inclinePct':
        return l10n.enduranceAxisIncline;
      case 'intensity':
        return l10n.enduranceAxisIntensity;
      default:
        return key;
    }
  }

  static String _axisUnit(String key) {
    switch (key) {
      case 'speedKmh':
        return 'km/h';
      case 'powerW':
        return 'W';
      case 'inclinePct':
        return '%';
      default:
        return '';
    }
  }
}

class _ValueStepper extends StatelessWidget {
  const _ValueStepper({
    required this.label,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String label;
  final String value;
  final Future<void> Function() onDecrease;
  final Future<void> Function() onIncrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        IconButton(
          onPressed: onDecrease,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 92,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          onPressed: onIncrease,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}