import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtorque_flutter/l10n/app_localizations.dart';

import '../../domain/models/endurance_sport.dart';
import '../../domain/models/heart_rate_connection_status.dart';
import '../../domain/models/heart_rate_trace_point.dart';
import '../../domain/models/indoor_axis_spec.dart';
import '../../domain/models/indoor_interval_protocol.dart';
import '../../domain/services/indoor_protocol_timeline.dart';
import '../state/heart_rate_controller.dart';
import '../state/heart_rate_controller.dart';
import '../state/indoor_training_controller.dart';
import '../widgets/indoor_training_value_control.dart';
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

    final heartRateState = ref.watch(heartRateControllerProvider);
    final heartRateController = ref.read(heartRateControllerProvider.notifier);
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

    ref.listen(
      heartRateControllerProvider,
          (previous, next) {
        if (next.status != HeartRateConnectionStatus.error) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.enduranceHeartRateError),
          ),
        );
      },
    );

    ref.listen(
      heartRateControllerProvider,
          (previous, next) {
        final sample = next.latestSample;
        if (sample == null || identical(previous?.latestSample, sample)) {
          return;
        }

        final indoorState = ref.read(indoorTrainingControllerProvider(args));
        if (!indoorState.isRunning) {
          return;
        }

        ref.read(indoorTrainingControllerProvider(args).notifier).addHeartRateSample(
          elapsedMs: indoorState.elapsedMs,
          bpm: sample.bpm,
        );
      },
    );

    final theme = Theme.of(context);
    final panelColor =
        theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow;
    final panelBorderColor = theme.colorScheme.outlineVariant;

    final sportLabel = _sportLabel(l10n, sport);
    final axis = IndoorAxisSpec.forSportCode(sport.code);

    final timeline = IndoorProtocolTimeline.resolve(
      protocol: state.protocol,
      elapsedMs: state.elapsedMs,
    );

    final effectivePhaseIndex = state.selectedPhaseIndex;

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
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          children: [
            _StatusCard(
              sportLabel: sportLabel,
              sportAssetPath: sport.assetPath,
              elapsedText: _formatElapsed(state.elapsedMs),
              heartRateText: _heartRateText(
                l10n: l10n,
                bpm: heartRateState.bpm,
              ),
              heartRateStatusText: _heartRateStatusText(
                l10n: l10n,
                status: heartRateState.status,
              ),
              heartRateActionLabel: _heartRateActionLabel(
                l10n: l10n,
                status: heartRateState.status,
              ),
              isHeartRateBusy: heartRateState.isBusy,
              isHeartRateConnected: heartRateState.isConnected,
              onHeartRatePressed: heartRateController.toggleConnection,
              isActive: state.isActive,
              isPaused: state.isPaused,
              isBusy: state.isBusy,
              phaseText: state.isActive
                  ? l10n.enduranceCurrentPhase(
                timeline.currentPhaseIndex + 1,
                state.protocol.phases.length,
              )
                  : null,
              phaseRemainingText: state.isActive
                  ? _formatElapsed(timeline.phaseRemainingSec * 1000)
                  : null,
              protocolCompleted: timeline.protocolCompleted,
            ),
            const SizedBox(height: 10),
            _ProtocolCard(
              protocol: state.protocol,
              axis: axis,
              elapsedMs: state.elapsedMs,
              heartRateTrace: state.heartRateTrace,
              selectedIndex: effectivePhaseIndex,
              onAddPhase: controller.addDefaultPhase,
              onPhaseSelected: controller.selectPhase,
            ),
            const SizedBox(height: 10),
            _PhaseEditorCard(
              protocol: state.protocol,
              axis: axis,
              selectedIndex: effectivePhaseIndex,
              isReadOnly: false,
              onChanged: controller.updateSelectedPhase,
              onDelete: controller.deleteSelectedPhase,
            ),
            const SizedBox(height: 12),
            if (!state.isActive)
              FilledButton.icon(
                onPressed: state.isBusy ? null : controller.startSession,
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.enduranceStartSession),
              )
            else ...[
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: state.isBusy
                          ? null
                          : state.isPaused
                          ? controller.resumeSession
                          : controller.pauseSession,
                      icon: Icon(
                        state.isPaused ? Icons.play_arrow : Icons.pause,
                      ),
                      label: Text(
                        state.isPaused
                            ? l10n.enduranceResumeSession
                            : l10n.endurancePauseSession,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: state.isBusy
                          ? null
                          : () async {
                        final result = await _showFinishIndoorSessionDialog(
                          context: context,
                          elapsedText: _formatElapsed(state.elapsedMs),
                        );

                        if (result == null) {
                          return;
                        }

                        await controller.finishSession(
                          rpe0to10: result.rpe0to10,
                          notes: result.notes,
                        );

                        if (context.mounted) {
                          Navigator.of(context).maybePop();
                        }
                      },
                      icon: const Icon(Icons.stop),
                      label: Text(l10n.enduranceFinishSession),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: state.isBusy
                    ? null
                    : () async {
                  final confirmed = await _confirmDiscardIndoorSession(
                    context,
                  );

                  if (!confirmed) {
                    return;
                  }

                  await controller.discardSession();

                  if (context.mounted) {
                    Navigator.of(context).maybePop();
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.enduranceDiscardSession),
              ),
            ],
            if (!state.isActive) ...[
              const SizedBox(height: 8),
              Text(
                l10n.enduranceIndoorCompatibilityHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _heartRateText({
    required AppLocalizations l10n,
    required int? bpm,
  }) {
    if (bpm == null) {
      return l10n.enduranceHeartRatePlaceholder;
    }

    return l10n.enduranceHeartRateValue(bpm);
  }

  static String _heartRateStatusText({
    required AppLocalizations l10n,
    required HeartRateConnectionStatus status,
  }) {
    switch (status) {
      case HeartRateConnectionStatus.disconnected:
        return l10n.enduranceHeartRateDisconnected;
      case HeartRateConnectionStatus.requestingPermissions:
        return l10n.enduranceHeartRateRequestingPermissions;
      case HeartRateConnectionStatus.bluetoothOff:
        return l10n.enduranceHeartRateBluetoothOff;
      case HeartRateConnectionStatus.scanning:
        return l10n.enduranceHeartRateScanning;
      case HeartRateConnectionStatus.connecting:
        return l10n.enduranceHeartRateConnecting;
      case HeartRateConnectionStatus.connected:
        return l10n.enduranceHeartRateConnected;
      case HeartRateConnectionStatus.permissionDenied:
        return l10n.enduranceHeartRatePermissionDenied;
      case HeartRateConnectionStatus.unsupported:
        return l10n.enduranceHeartRateUnsupported;
      case HeartRateConnectionStatus.error:
        return l10n.enduranceHeartRateError;
    }
  }

  static String _heartRateActionLabel({
    required AppLocalizations l10n,
    required HeartRateConnectionStatus status,
  }) {
    if (status == HeartRateConnectionStatus.connected || status.isBusy) {
      return l10n.enduranceHeartRateDisconnect;
    }

    return l10n.enduranceHeartRateConnect;
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
    required this.sportAssetPath,
    required this.elapsedText,
    required this.heartRateText,
    required this.heartRateStatusText,
    required this.heartRateActionLabel,
    required this.isHeartRateBusy,
    required this.isHeartRateConnected,
    required this.onHeartRatePressed,
    required this.isActive,
    required this.isPaused,
    required this.isBusy,
    required this.phaseText,
    required this.phaseRemainingText,
    required this.protocolCompleted,
  });

  final String sportLabel;
  final String sportAssetPath;
  final String elapsedText;
  final String heartRateText;
  final String heartRateStatusText;
  final String heartRateActionLabel;
  final bool isHeartRateBusy;
  final bool isHeartRateConnected;
  final VoidCallback onHeartRatePressed;
  final bool isActive;
  final bool isPaused;
  final bool isBusy;
  final String? phaseText;
  final String? phaseRemainingText;
  final bool protocolCompleted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final statusText = !isActive
        ? l10n.enduranceSessionNotStarted
        : isPaused
        ? l10n.enduranceSessionPaused
        : protocolCompleted
        ? l10n.enduranceProtocolCompleted
        : l10n.enduranceSessionActive;

    final statusIcon = !isActive
        ? Icons.circle_outlined
        : isPaused
        ? Icons.pause_circle_outline
        : Icons.radio_button_checked;

    final statusColor = !isActive
        ? theme.colorScheme.onSurfaceVariant
        : isPaused
        ? theme.colorScheme.tertiary
        : theme.colorScheme.primary;

    final largeValueStyle = theme.textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w900,
      fontFeatures: const [],
    );

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    elapsedText,
                    style: largeValueStyle,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 20,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          heartRateText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: largeValueStyle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Tooltip(
                        message: heartRateActionLabel,
                        child: IconButton.filledTonal(
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(
                            foregroundColor: isHeartRateConnected
                                ? null
                                : theme.colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.55,
                            ),
                            backgroundColor: isHeartRateConnected
                                ? null
                                : theme.colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.12,
                            ),
                          ),
                          onPressed: onHeartRatePressed,
                          icon: isHeartRateBusy
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : Icon(
                            isHeartRateConnected
                                ? Icons.bluetooth_connected
                                : Icons.bluetooth,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    heartRateStatusText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        statusIcon,
                        size: 17,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          statusText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isBusy) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    ],
                  ),
                  if (phaseText != null && phaseRemainingText != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      protocolCompleted
                          ? l10n.enduranceProtocolTargetReached
                          : '$phaseText · ${l10n.endurancePhaseRemaining(phaseRemainingText!)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 118,
              height: 108,
              child: Align(
                alignment: Alignment.centerRight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.dividerColor.withValues(alpha: 0.25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                        color: Colors.black.withValues(alpha: 0.08),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        sportAssetPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.favorite_border,
                            size: 56,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.55),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
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
    required this.heartRateTrace,
    required this.selectedIndex,
    required this.onAddPhase,
    required this.onPhaseSelected,
  });

  final IndoorIntervalProtocol protocol;
  final IndoorAxisSpec axis;
  final int elapsedMs;
  final List<HeartRateTracePoint> heartRateTrace;
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
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
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
            const SizedBox(height: 8),
            IntervalProtocolChart(
              phases: protocol.phases,
              axisLabel: _axisLabel(l10n, axis.key),
              axisUnit: _axisUnit(axis.key),
              heartRateAxisLabel: l10n.enduranceHeartRateAxisLabel,
              elapsedMs: elapsedMs,
              heartRateTrace: heartRateTrace,
              selectedIndex: selectedIndex,
              showAddButton: true,
              onAddPhase: onAddPhase,
              onPhaseSelected: onPhaseSelected,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    label: l10n.enduranceIndoorProtocolDuration,
                    value: _formatDuration(protocol.totalSec),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoRow(
                    label: _axisLabel(l10n, axis.key),
                    value: _formatAxisValue(
                      value: intensityAverage,
                      decimals: axis.decimals,
                      unit: _axisUnit(axis.key),
                    ),
                  ),
                ),
              ],
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
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
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
        const SizedBox(width: 8),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(
            width: 36,
            height: 36,
          ),
          onPressed: null,
          icon: const Icon(Icons.volume_up_outlined),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(
            width: 36,
            height: 36,
          ),
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
    required this.isReadOnly,
    required this.onChanged,
    required this.onDelete,
  });

  final IndoorIntervalProtocol protocol;
  final IndoorAxisSpec axis;
  final int selectedIndex;
  final bool isReadOnly;
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.enduranceSelectedPhase,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: isReadOnly || protocol.phases.length <= 1
                      ? null
                      : () => onDelete(),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            IndoorTrainingValueControl(
              label: _axisLabel(l10n, axis.key),
              value: phase.intensity,
              min: axis.min,
              max: axis.max,
              step: axis.step,
              enabled: !isReadOnly,
              roundValue: axis.roundValue,
              formatValue: (value) {
                return _formatValue(
                  value,
                  axis.decimals,
                  _axisUnit(axis.key),
                );
              },
              onChanged: (next) {
                return onChanged(
                  intensity: axis.roundValue(next),
                );
              },
            ),
            if (axis.extra != null) ...[
              const SizedBox(height: 8),
              IndoorTrainingValueControl(
                label: _axisLabel(l10n, axis.extra!.key),
                value:
                phase.extra[axis.extra!.key] ?? axis.extra!.defaultValue,
                min: axis.extra!.min,
                max: axis.extra!.max,
                step: axis.extra!.step,
                enabled: !isReadOnly,
                roundValue: axis.extra!.roundValue,
                formatValue: (value) {
                  return _formatValue(
                    value,
                    axis.extra!.decimals,
                    _axisUnit(axis.extra!.key),
                  );
                },
                onChanged: (next) {
                  return onChanged(
                    extra: {
                      ...phase.extra,
                      axis.extra!.key: axis.extra!.roundValue(next),
                    },
                  );
                },
              ),
            ],
            const SizedBox(height: 8),
            IndoorTrainingValueControl(
              label: l10n.enduranceIndoorProtocolDuration,
              value: phase.durSec.toDouble(),
              min: 30,
              max: (120 * 60).toDouble(),
              step: 30,
              enabled: !isReadOnly,
              roundValue: _roundDurationSeconds,
              formatValue: (value) {
                return _formatDuration(value.round());
              },
              onChanged: (next) {
                return onChanged(
                  durSec: _roundDurationSeconds(next).round(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static double _roundDurationSeconds(double value) {
    return ((value / 30).round() * 30)
        .clamp(30, 120 * 60)
        .toDouble();
  }

  static String _formatDuration(int totalSec) {
    final hours = totalSec ~/ 3600;
    final minutes = (totalSec % 3600) ~/ 60;
    final seconds = totalSec % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _FinishIndoorSessionResult {
  const _FinishIndoorSessionResult({
    required this.rpe0to10,
    required this.notes,
  });

  final int? rpe0to10;
  final String? notes;
}

Future<_FinishIndoorSessionResult?> _showFinishIndoorSessionDialog({
  required BuildContext context,
  required String elapsedText,
}) {
  return showDialog<_FinishIndoorSessionResult>(
    context: context,
    builder: (context) {
      return _FinishIndoorSessionDialog(
        elapsedText: elapsedText,
      );
    },
  );
}

class _FinishIndoorSessionDialog extends StatefulWidget {
  const _FinishIndoorSessionDialog({
    required this.elapsedText,
  });

  final String elapsedText;

  @override
  State<_FinishIndoorSessionDialog> createState() =>
      _FinishIndoorSessionDialogState();
}

class _FinishIndoorSessionDialogState
    extends State<_FinishIndoorSessionDialog> {
  int? _rpe0to10;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.enduranceFinishSession),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FinishInfoRow(
              label: l10n.enduranceIndoorProtocolDuration,
              value: widget.elapsedText,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.enduranceRpeLabel,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int?>(
              value: _rpe0to10,
              decoration: InputDecoration(
                labelText: l10n.enduranceRpeHint,
              ),
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text(l10n.enduranceRpeNotSet),
                ),
                for (var value = 0; value <= 10; value++)
                  DropdownMenuItem<int?>(
                    value: value,
                    child: Text(value.toString()),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  _rpe0to10 = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              minLines: 2,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                labelText: l10n.enduranceNotesLabel,
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(
              _FinishIndoorSessionResult(
                rpe0to10: _rpe0to10,
                notes: _notesController.text,
              ),
            );
          },
          child: Text(l10n.enduranceFinishSession),
        ),
      ],
    );
  }
}

class _FinishInfoRow extends StatelessWidget {
  const _FinishInfoRow({
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
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

Future<bool> _confirmDiscardIndoorSession(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.enduranceDiscardSession),
        content: Text(l10n.enduranceDiscardSessionMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(l10n.enduranceDiscardSession),
          ),
        ],
      );
    },
  );

  return confirmed ?? false;
}