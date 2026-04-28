import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef IndoorTrainingValueFormatter = String Function(double value);
typedef IndoorTrainingValueRounder = double Function(double value);

class IndoorTrainingValueControl extends StatefulWidget {
  const IndoorTrainingValueControl({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.enabled,
    required this.formatValue,
    required this.roundValue,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final bool enabled;
  final IndoorTrainingValueFormatter formatValue;
  final IndoorTrainingValueRounder roundValue;
  final Future<void> Function(double value) onChanged;

  @override
  State<IndoorTrainingValueControl> createState() =>
      _IndoorTrainingValueControlState();
}

class _IndoorTrainingValueControlState
    extends State<IndoorTrainingValueControl> {
  Timer? _repeatTimer;
  double? _draftValue;
  double _dragDistance = 0;
  bool _hasTriggeredDragFeedback = false;
  bool _isApplyingStep = false;

  double get _displayValue => _draftValue ?? widget.value;

  @override
  void didUpdateWidget(covariant IndoorTrainingValueControl oldWidget) {
    super.didUpdateWidget(oldWidget);

    final draft = _draftValue;

    if (draft == null) {
      return;
    }

    if ((widget.value - draft).abs() <= widget.step / 2) {
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

    final valueText = widget.formatValue(_displayValue);

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
        _StepButton(
          enabled: widget.enabled,
          icon: Icons.remove,
          direction: -1,
          onTapStep: () => _applyStep(direction: -1),
          onRepeatStart: _startRepeating,
          onRepeatMove: _updateRepeatDrag,
          onRepeatEnd: _stopRepeating,
        ),
        SizedBox(
          width: 108,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: widget.enabled ? _showSliderSheet : null,
              onLongPress: widget.enabled
                  ? () {
                // Reserved for later: direct numeric input.
                HapticFeedback.selectionClick();
              }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Text(
                  valueText,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
        _StepButton(
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
      final base = _draftValue ?? widget.value;
      final rawNext = base + direction * widget.step * multiplier;
      final next = widget.roundValue(
        rawNext.clamp(widget.min, widget.max).toDouble(),
      );

      if ((next - base).abs() < 0.000001) {
        return;
      }

      setState(() {
        _draftValue = next;
      });

      await widget.onChanged(next);
    } finally {
      _isApplyingStep = false;
    }
  }

  void _startRepeating({
    required int direction,
  }) {
    if (!widget.enabled) {
      return;
    }

    _dragDistance = 0;

    HapticFeedback.mediumImpact();

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
    required double distance,
  }) {
    if (!mounted) {
      return;
    }

    setState(() {
      _dragDistance = distance;
    });

    if (!_hasTriggeredDragFeedback && distance >= 16) {
      _hasTriggeredDragFeedback = true;
      HapticFeedback.heavyImpact();
    }
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
    _hasTriggeredDragFeedback = false;

    if (mounted) {
      setState(() {
        _dragDistance = 0;
      });
    }
  }

  Future<void> _showSliderSheet() async {
    if (!widget.enabled) {
      return;
    }

    HapticFeedback.selectionClick();

    final next = await showModalBottomSheet<double>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        var draft = widget.roundValue(
          widget.value.clamp(widget.min, widget.max).toDouble(),
        );

        final divisions = ((widget.max - widget.min) / widget.step).round();

        return StatefulBuilder(
          builder: (context, setState) {
            final material = MaterialLocalizations.of(context);
            final valueText = widget.formatValue(draft);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      valueText,
                      style:
                      Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Slider(
                      value: draft,
                      min: widget.min,
                      max: widget.max,
                      divisions:
                      divisions > 0 && divisions <= 600 ? divisions : null,
                      label: valueText,
                      onChanged: (value) {
                        setState(() {
                          draft = widget.roundValue(value);
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

    if (next == null) {
      return;
    }

    await widget.onChanged(next);
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
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
  }) onRepeatStart;
  final void Function({
  required double distance,
  }) onRepeatMove;
  final VoidCallback onRepeatEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final foregroundColor = enabled
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withValues(alpha: 0.35);

    final backgroundColor = enabled
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45);

    final borderColor = theme.dividerColor.withValues(alpha: 0.35);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled
          ? () async {
        HapticFeedback.mediumImpact();
        await onTapStep();
      }
          : null,
      onLongPressStart: enabled
          ? (_) {
        onRepeatStart(direction: direction);
      }
          : null,
      onLongPressMoveUpdate: enabled
          ? (details) {
        onRepeatMove(
          distance: details.offsetFromOrigin.distance,
        );
      }
          : null,
      onLongPressEnd: enabled ? (_) => onRepeatEnd() : null,
      onLongPressCancel: enabled ? onRepeatEnd : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: SizedBox(
            width: 42,
            height: 42,
            child: Icon(
              icon,
              size: 22,
              color: foregroundColor,
            ),
          ),
        ),
      ),
    );
  }
}