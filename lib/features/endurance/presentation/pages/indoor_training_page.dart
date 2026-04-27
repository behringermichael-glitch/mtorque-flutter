import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtorque_flutter/l10n/app_localizations.dart';

import '../../domain/models/endurance_sport.dart';
import '../../domain/models/indoor_axis_spec.dart';
import '../../domain/models/indoor_interval_protocol.dart';
import '../state/indoor_training_controller.dart';

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
  });

  final IndoorIntervalProtocol protocol;
  final IndoorAxisSpec axis;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final intensityAverage = protocol.weightedIntensityAverage(
      decimals: axis.decimals,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.enduranceIndoorProtocolTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
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
            if (axis.extra != null) ...[
              const SizedBox(height: 8),
              _InfoRow(
                label: _axisLabel(l10n, axis.extra!.key),
                value: _formatAxisValue(
                  value: protocol.weightedExtraAverage(
                    key: axis.extra!.key,
                    fallback: axis.extra!.defaultValue,
                    decimals: axis.extra!.decimals,
                  ) ??
                      axis.extra!.defaultValue,
                  decimals: axis.extra!.decimals,
                  unit: _axisUnit(axis.extra!.key),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              l10n.enduranceIndoorProtocolPhaseCount(protocol.phases.length),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
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