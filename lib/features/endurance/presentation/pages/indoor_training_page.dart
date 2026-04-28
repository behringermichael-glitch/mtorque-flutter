import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtorque_flutter/l10n/app_localizations.dart';

import '../../domain/models/endurance_sport.dart';
import '../../domain/models/indoor_axis_spec.dart';
import '../../domain/models/indoor_interval_protocol.dart';
import '../../domain/services/indoor_protocol_timeline.dart';
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
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            _StatusCard(
              sportLabel: sportLabel,
              elapsedText: _formatElapsed(state.elapsedMs),
              isActive: state.isActive,
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
            const SizedBox(height: 16),
            _ProtocolCard(
              protocol: state.protocol,
              axis: axis,
              elapsedMs: state.elapsedMs,
              selectedIndex: effectivePhaseIndex,
              onAddPhase: controller.addDefaultPhase,
              onPhaseSelected: controller.selectPhase,
            ),
            const SizedBox(height: 16),
            _PhaseEditorCard(
              protocol: state.protocol,
              axis: axis,
              selectedIndex: effectivePhaseIndex,
              isReadOnly: false,
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
            else ...[
              FilledButton.icon(
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
    required this.phaseText,
    required this.phaseRemainingText,
    required this.protocolCompleted,
  });

  final String sportLabel;
  final String elapsedText;
  final bool isActive;
  final bool isBusy;
  final String? phaseText;
  final String? phaseRemainingText;
  final bool protocolCompleted;

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
                        ? protocolCompleted
                        ? l10n.enduranceProtocolCompleted
                        : l10n.enduranceSessionActive
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
            if (phaseText != null && phaseRemainingText != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      phaseText!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    protocolCompleted
                        ? l10n.enduranceProtocolTargetReached
                        : l10n.endurancePhaseRemaining(phaseRemainingText!),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
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
                  onPressed: isReadOnly || protocol.phases.length <= 1
                      ? null
                      : () => onDelete(),
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
              currentValue: phase.intensity,
              min: axis.min,
              max: axis.max,
              step: axis.step,
              enabled: !isReadOnly,
              roundValue: axis.roundValue,
              onValueChanged: (next) {
                return onChanged(
                  intensity: axis.roundValue(next),
                );
              },
              onValueTap: () async {
                final next = await _showAxisValueDial(
                  context: context,
                  label: _axisLabel(l10n, axis.key),
                  axis: axis,
                  value: phase.intensity,
                );

                if (next == null) {
                  return;
                }

                await onChanged(
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
                currentValue:
                phase.extra[axis.extra!.key] ?? axis.extra!.defaultValue,
                min: axis.extra!.min,
                max: axis.extra!.max,
                step: axis.extra!.step,
                enabled: !isReadOnly,
                roundValue: axis.extra!.roundValue,
                onValueChanged: (next) {
                  return onChanged(
                    extra: {
                      ...phase.extra,
                      axis.extra!.key: axis.extra!.roundValue(next),
                    },
                  );
                },
                onValueTap: () async {
                  final extraAxis = axis.extra!;
                  final current =
                      phase.extra[extraAxis.key] ?? extraAxis.defaultValue;

                  final next = await _showAxisValueDial(
                    context: context,
                    label: _axisLabel(l10n, extraAxis.key),
                    axis: extraAxis,
                    value: current,
                  );

                  if (next == null) {
                    return;
                  }

                  await onChanged(
                    extra: {
                      ...phase.extra,
                      extraAxis.key: extraAxis.roundValue(next),
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
              currentValue: phase.durSec.toDouble(),
              min: 30,
              max: (24 * 3600).toDouble(),
              step: 30,
              enabled: !isReadOnly,
              roundValue: (value) {
                return ((value / 30).round() * 30)
                    .clamp(30, 24 * 3600)
                    .toDouble();
              },
              onValueChanged: (next) {
                return onChanged(durSec: next.round());
              },
              onValueTap: () async {
                final next = await _showDurationDial(
                  context: context,
                  label: l10n.enduranceIndoorProtocolDuration,
                  valueSec: phase.durSec,
                );

                if (next == null) {
                  return;
                }

                await onChanged(durSec: next);
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

class _ValueStepper extends StatefulWidget {
  const _ValueStepper({
    required this.label,
    required this.value,
    required this.currentValue,
    required this.min,
    required this.max,
    required this.step,
    required this.enabled,
    required this.roundValue,
    required this.onValueChanged,
    this.onValueTap,
  });

  final String label;
  final String value;
  final double currentValue;
  final double min;
  final double max;
  final double step;
  final bool enabled;
  final double Function(double value) roundValue;
  final Future<void> Function(double value) onValueChanged;
  final Future<void> Function()? onValueTap;

  @override
  State<_ValueStepper> createState() => _ValueStepperState();
}

class _ValueStepperState extends State<_ValueStepper> {
  Timer? _repeatTimer;
  double? _draftValue;
  double _dragOriginX = 0;
  double _dragDistance = 0;
  bool _isApplyingStep = false;

  @override
  void didUpdateWidget(covariant _ValueStepper oldWidget) {
    super.didUpdateWidget(oldWidget);

    final current = widget.currentValue;
    final draft = _draftValue;

    if (draft == null) {
      return;
    }

    if ((current - draft).abs() <= widget.step / 2) {
      _draftValue = null;
    }
  }

  @override
  void dispose() {
    _stopRepeating();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final valueText = Text(
      widget.value,
      textAlign: TextAlign.center,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            widget.label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        _StepGestureButton(
          enabled: widget.enabled,
          icon: Icons.remove,
          direction: -1,
          onTapStep: () => _applyStep(direction: -1),
          onRepeatStart: _startRepeating,
          onRepeatMove: _updateRepeatDrag,
          onRepeatEnd: _stopRepeating,
        ),
        SizedBox(
          width: 104,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.enabled && widget.onValueTap != null
                  ? widget.onValueTap
                  : null,
              onLongPress: widget.enabled
                  ? () {
                // Reserved for later: direct numeric input.
              }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: valueText,
              ),
            ),
          ),
        ),
        _StepGestureButton(
          enabled: widget.enabled,
          icon: Icons.add,
          direction: 1,
          onTapStep: () => _applyStep(direction: 1),
          onRepeatStart: _startRepeating,
          onRepeatMove: _updateRepeatDrag,
          onRepeatEnd: _stopRepeating,
        ),
      ],
    );
  }

  Future<void> _applyStep({
    required int direction,
    int multiplier = 1,
  }) async {
    if (!widget.enabled || _isApplyingStep) {
      return;
    }

    _isApplyingStep = true;

    try {
      final base = _draftValue ?? widget.currentValue;
      final rawNext = base + direction * widget.step * multiplier;
      final next = widget.roundValue(
        rawNext.clamp(widget.min, widget.max).toDouble(),
      );

      _draftValue = next;
      await widget.onValueChanged(next);
    } finally {
      _isApplyingStep = false;
    }
  }

  void _startRepeating({
    required int direction,
    required double globalX,
  }) {
    if (!widget.enabled) {
      return;
    }

    _dragOriginX = globalX;
    _dragDistance = 0;

    _repeatTimer?.cancel();
    _repeatTimer = Timer.periodic(
      const Duration(milliseconds: 140),
          (_) {
        _applyStep(
          direction: direction,
          multiplier: _repeatMultiplier,
        );
      },
    );
  }

  void _updateRepeatDrag({
    required int direction,
    required double globalX,
  }) {
    final distance = (globalX - _dragOriginX).abs();

    if (!mounted) {
      return;
    }

    setState(() {
      _dragDistance = distance;
    });
  }

  int get _repeatMultiplier {
    if (_dragDistance < 16) {
      return 1;
    }

    if (_dragDistance < 32) {
      return 3;
    }

    if (_dragDistance < 56) {
      return 6;
    }

    if (_dragDistance < 88) {
      return 12;
    }

    if (_dragDistance < 128) {
      return 20;
    }

    return 30;
  }

  void _stopRepeating() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
    _dragDistance = 0;
  }
}

class _StepGestureButton extends StatelessWidget {
  const _StepGestureButton({
    required this.enabled,
    required this.icon,
    required this.direction,
    required this.onTapStep,
    required this.onRepeatStart,
    required this.onRepeatMove,
    required this.onRepeatEnd,
  });

  final bool enabled;
  final IconData icon;
  final int direction;
  final Future<void> Function() onTapStep;
  final void Function({
  required int direction,
  required double globalX,
  }) onRepeatStart;
  final void Function({
  required int direction,
  required double globalX,
  }) onRepeatMove;
  final VoidCallback onRepeatEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTapStep : null,
      onLongPressStart: enabled
          ? (details) {
        onRepeatStart(
          direction: direction,
          globalX: details.globalPosition.dx,
        );
      }
          : null,
      onLongPressMoveUpdate: enabled
          ? (details) {
        onRepeatMove(
          direction: direction,
          globalX: details.globalPosition.dx,
        );
      }
          : null,
      onLongPressEnd: enabled ? (_) => onRepeatEnd() : null,
      onLongPressCancel: enabled ? onRepeatEnd : null,
      child: IconButton(
        onPressed: null,
        icon: Icon(icon),
        color: enabled
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).disabledColor,
      ),
    );
  }
}

Future<double?> _showAxisValueDial({
  required BuildContext context,
  required String label,
  required IndoorAxisSpec axis,
  required double value,
}) {
  var draft = axis.roundValue(
    value.clamp(axis.min, axis.max).toDouble(),
  );

  final divisions = ((axis.max - axis.min) / axis.step).round();

  return showModalBottomSheet<double>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final material = MaterialLocalizations.of(context);

      return StatefulBuilder(
        builder: (context, setState) {
          final valueText = _formatAxisDialValue(
            value: draft,
            decimals: axis.decimals,
            unit: _axisUnitForDial(axis.key),
          );

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    valueText,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: draft,
                    min: axis.min,
                    max: axis.max,
                    divisions:
                    divisions > 0 && divisions <= 500 ? divisions : null,
                    label: valueText,
                    onChanged: (next) {
                      setState(() {
                        draft = axis.roundValue(next);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(material.cancelButtonLabel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop(draft);
                          },
                          child: Text(material.okButtonLabel),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<int?> _showDurationDial({
  required BuildContext context,
  required String label,
  required int valueSec,
}) {
  var draft = valueSec.clamp(30, 24 * 3600);

  return showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      final material = MaterialLocalizations.of(context);

      return StatefulBuilder(
        builder: (context, setState) {
          final valueText = _formatDurationForDial(draft);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    valueText,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Slider(
                    value: draft.toDouble(),
                    min: 30,
                    max: (24 * 3600).toDouble(),
                    divisions: ((24 * 3600 - 30) / 30).round(),
                    label: valueText,
                    onChanged: (next) {
                      setState(() {
                        draft = ((next / 30).round() * 30)
                            .clamp(30, 24 * 3600);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(material.cancelButtonLabel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop(draft);
                          },
                          child: Text(material.okButtonLabel),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

String _formatAxisDialValue({
  required double value,
  required int decimals,
  required String unit,
}) {
  final formatted =
  decimals == 0 ? value.round().toString() : value.toStringAsFixed(decimals);

  return unit.isEmpty ? formatted : '$formatted $unit';
}

String _axisUnitForDial(String key) {
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

String _formatDurationForDial(int totalSec) {
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