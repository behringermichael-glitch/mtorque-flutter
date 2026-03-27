import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/set_entry.dart';
import '../state/strength_flow_controller.dart';
import '../state/strength_providers.dart';
import 'exercise_asset_resolver.dart';

class ExercisePage extends ConsumerStatefulWidget {
  const ExercisePage({
    super.key,
    required this.exerciseId,
  });

  final String exerciseId;

  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage> {
  Timer? _pendingSync;

  @override
  void dispose() {
    _pendingSync?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flowState = ref.watch(strengthFlowControllerProvider);
    final flow = ref.read(strengthFlowControllerProvider.notifier);
    final repository = ref.watch(strengthRepositoryProvider);

    final draft = flowState.draftSession;
    final list =
        draft?.setsByExercise[widget.exerciseId] ?? const <SetEntry>[];

    return FutureBuilder<StrengthExerciseSummary?>(
      future: repository.getExerciseById(widget.exerciseId),
      builder: (context, snapshot) {
        final exercise = snapshot.data;
        final isStatic = exercise?.isStatic ?? false;
        final exerciseName = exercise?.label ?? widget.exerciseId;

        return Column(
          children: [
            _ExerciseHeader(
              exerciseId: widget.exerciseId,
              exerciseName: exerciseName,
              onDelete: () async {
                await flow.removeExercise(widget.exerciseId);
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];

                  return _SetRow(
                    key: ValueKey('set_row_${widget.exerciseId}_$index'),
                    index: index,
                    value: item,
                    isStatic: isStatic,
                    onChanged: (next) async {
                      final updated = [...list];
                      updated[index] = next;
                      await flow.replaceExerciseSets(
                        exerciseId: widget.exerciseId,
                        sets: updated,
                      );
                    },
                    onInsertBelow: () async {
                      final updated = [...list];
                      updated.insert(index + 1, const SetEntry());
                      await flow.replaceExerciseSets(
                        exerciseId: widget.exerciseId,
                        sets: updated,
                      );
                    },
                    onCompleted: () async {
                      await _scheduleSync(
                        flow: flow,
                        exerciseName: exerciseName,
                        isStatic: isStatic,
                      );
                    },
                    onDelete: () async {
                      final updated = [...list]..removeAt(index);
                      await flow.replaceExerciseSets(
                        exerciseId: widget.exerciseId,
                        sets: updated,
                      );
                      await _scheduleSync(
                        flow: flow,
                        exerciseName: exerciseName,
                        isStatic: isStatic,
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final next = [...list, const SetEntry()];
                    await flow.replaceExerciseSets(
                      exerciseId: widget.exerciseId,
                      sets: next,
                    );
                  },
                  child: const Text('+ Add set'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _scheduleSync({
    required StrengthFlowController flow,
    required String exerciseName,
    required bool isStatic,
  }) async {
    _pendingSync?.cancel();
    _pendingSync = Timer(const Duration(milliseconds: 350), () async {
      await flow.syncExerciseToDbIfNeeded(
        exerciseId: widget.exerciseId,
        exerciseName: exerciseName,
        isStaticExercise: isStatic,
      );
    });
  }
}

class _ExerciseHeader extends StatelessWidget {
  const _ExerciseHeader({
    required this.exerciseId,
    required this.exerciseName,
    required this.onDelete,
  });

  final String exerciseId;
  final String exerciseName;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final iconColor =
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.80);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: ExerciseAssetImage(
                  exerciseId: exerciseId,
                  fit: BoxFit.contain,
                  borderRadius: BorderRadius.circular(16),
                  placeholderIcon: Icons.image_not_supported_outlined,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Spacer(),
                      Text(
                        exerciseName,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headlineSmall,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.info_outline, color: iconColor),
                          const SizedBox(width: 18),
                          Icon(Icons.fitness_center_outlined, color: iconColor),
                          const SizedBox(width: 18),
                          Icon(Icons.bar_chart_outlined, color: iconColor),
                          const SizedBox(width: 18),
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline),
                            color: iconColor,
                            tooltip: 'Delete exercise',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.chevron_left,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.60),
              ),
              const SizedBox(width: 6),
              const Expanded(child: Divider(height: 1)),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.60),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SetRow extends StatefulWidget {
  const _SetRow({
    super.key,
    required this.index,
    required this.value,
    required this.isStatic,
    required this.onChanged,
    required this.onInsertBelow,
    required this.onCompleted,
    required this.onDelete,
  });

  final int index;
  final SetEntry value;
  final bool isStatic;
  final ValueChanged<SetEntry> onChanged;
  final VoidCallback onInsertBelow;
  final VoidCallback onCompleted;
  final VoidCallback onDelete;

  @override
  State<_SetRow> createState() => _SetRowState();
}

class _SetRowState extends State<_SetRow> {
  late final TextEditingController _loadController;
  late final TextEditingController _secondController;
  late final FocusNode _loadFocusNode;
  late final FocusNode _secondFocusNode;

  @override
  void initState() {
    super.initState();
    _loadController = TextEditingController(text: _formatLoad(widget.value.load));
    _secondController = TextEditingController(
      text: widget.isStatic
          ? _formatInt(widget.value.durationSec)
          : _formatNumber(widget.value.reps),
    );
    _loadFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _SetRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_loadFocusNode.hasFocus) {
      final next = _formatLoad(widget.value.load);
      if (_loadController.text != next) {
        _loadController.text = next;
      }
    }

    if (!_secondFocusNode.hasFocus) {
      final next = widget.isStatic
          ? _formatInt(widget.value.durationSec)
          : _formatNumber(widget.value.reps);
      if (_secondController.text != next) {
        _secondController.text = next;
      }
    }
  }

  @override
  void dispose() {
    _loadController.dispose();
    _secondController.dispose();
    _loadFocusNode.dispose();
    _secondFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondHint = widget.isStatic ? 'Duration' : 'Reps';
    final labelColor =
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.72);
    final lineColor =
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '${widget.index + 1}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _UnderlineNumberField(
              controller: _loadController,
              focusNode: _loadFocusNode,
              hint: 'kg',
              labelColor: labelColor,
              lineColor: lineColor,
              onChanged: (value) {
                widget.onChanged(
                  widget.value.copyWith(
                    load: _tryParseDouble(value),
                  ),
                );
              },
              onSubmitted: (_) => widget.onCompleted(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _UnderlineNumberField(
              controller: _secondController,
              focusNode: _secondFocusNode,
              hint: secondHint,
              labelColor: labelColor,
              lineColor: lineColor,
              onChanged: (value) {
                if (widget.isStatic) {
                  widget.onChanged(
                    widget.value.copyWith(
                      durationSec: int.tryParse(value.trim()),
                    ),
                  );
                } else {
                  widget.onChanged(
                    widget.value.copyWith(
                      reps: _tryParseDouble(value),
                    ),
                  );
                }
              },
              onSubmitted: (_) => widget.onCompleted(),
            ),
          ),
          const SizedBox(width: 12),
          _IconToggleButton(
            icon: Icons.local_fire_department_outlined,
            selected: widget.value.allOut,
            onTap: () {
              widget.onChanged(
                widget.value.copyWith(allOut: !widget.value.allOut),
              );
            },
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: widget.onInsertBelow,
            icon: const Icon(Icons.add),
            tooltip: 'Insert set below',
          ),
          const SizedBox(width: 4),
          FilledButton(
            onPressed: widget.onDelete,
            style: FilledButton.styleFrom(
              minimumSize: const Size(54, 50),
              padding: EdgeInsets.zero,
            ),
            child: const Text('x'),
          ),
        ],
      ),
    );
  }

  static String _formatLoad(double? value) => _formatNumber(value);

  static String _formatNumber(double? value) {
    if (value == null) return '';
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString().replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  static String _formatInt(int? value) {
    if (value == null) return '';
    return value.toString();
  }

  static double? _tryParseDouble(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }
}

class _UnderlineNumberField extends StatelessWidget {
  const _UnderlineNumberField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.labelColor,
    required this.lineColor,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final Color labelColor;
  final Color lineColor;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: labelColor,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          height: 42,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: lineColor, width: 1.4),
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: onChanged,
            onSubmitted: onSubmitted,
          ),
        ),
      ],
    );
  }
}

class _IconToggleButton extends StatelessWidget {
  const _IconToggleButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor =
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.62);

    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: selected ? activeColor : inactiveColor,
      ),
      tooltip: 'All out',
    );
  }
}