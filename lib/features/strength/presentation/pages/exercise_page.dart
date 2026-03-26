import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/set_entry.dart';
import '../state/strength_flow_controller.dart';
import '../state/strength_providers.dart';

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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      exerciseName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await flow.removeExercise(widget.exerciseId);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: list.length + 1,
                itemBuilder: (context, index) {
                  if (index == list.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final next = [...list, const SetEntry()];
                          await flow.replaceExerciseSets(
                            exerciseId: widget.exerciseId,
                            sets: next,
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add set'),
                      ),
                    );
                  }

                  final item = list[index];

                  return _SetCard(
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

class _SetCard extends StatefulWidget {
  const _SetCard({
    required this.index,
    required this.value,
    required this.isStatic,
    required this.onChanged,
    required this.onCompleted,
    required this.onDelete,
  });

  final int index;
  final SetEntry value;
  final bool isStatic;
  final ValueChanged<SetEntry> onChanged;
  final VoidCallback onCompleted;
  final VoidCallback onDelete;

  @override
  State<_SetCard> createState() => _SetCardState();
}

class _SetCardState extends State<_SetCard> {
  late final TextEditingController _loadController;
  late final TextEditingController _secondController;
  late final TextEditingController _noteController;
  late final TextEditingController _rpeController;

  @override
  void initState() {
    super.initState();
    _loadController =
        TextEditingController(text: widget.value.load?.toString() ?? '');
    _secondController = TextEditingController(
      text: widget.isStatic
          ? (widget.value.durationSec?.toString() ?? '')
          : (widget.value.reps?.toString() ?? ''),
    );
    _noteController = TextEditingController(text: widget.value.note ?? '');
    _rpeController =
        TextEditingController(text: widget.value.rpe?.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant _SetCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextLoad = widget.value.load?.toString() ?? '';
    if (_loadController.text != nextLoad) {
      _loadController.text = nextLoad;
    }

    final nextSecond = widget.isStatic
        ? (widget.value.durationSec?.toString() ?? '')
        : (widget.value.reps?.toString() ?? '');
    if (_secondController.text != nextSecond) {
      _secondController.text = nextSecond;
    }

    final nextNote = widget.value.note ?? '';
    if (_noteController.text != nextNote) {
      _noteController.text = nextNote;
    }

    final nextRpe = widget.value.rpe?.toString() ?? '';
    if (_rpeController.text != nextRpe) {
      _rpeController.text = nextRpe;
    }
  }

  @override
  void dispose() {
    _loadController.dispose();
    _secondController.dispose();
    _noteController.dispose();
    _rpeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondLabel = widget.isStatic ? 'Duration (s)' : 'Reps';

    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text('Set ${widget.index + 1}'),
                const Spacer(),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _loadController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Load',
                    ),
                    onChanged: (value) {
                      widget.onChanged(
                        widget.value.copyWith(
                          load: double.tryParse(value.replaceAll(',', '.')),
                        ),
                      );
                    },
                    onSubmitted: (_) => widget.onCompleted(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _secondController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: secondLabel,
                    ),
                    onChanged: (value) {
                      if (widget.isStatic) {
                        widget.onChanged(
                          widget.value.copyWith(
                            durationSec: int.tryParse(value),
                          ),
                        );
                      } else {
                        widget.onChanged(
                          widget.value.copyWith(
                            reps: double.tryParse(value.replaceAll(',', '.')),
                          ),
                        );
                      }
                    },
                    onSubmitted: (_) => widget.onCompleted(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
              ),
              onChanged: (value) {
                widget.onChanged(widget.value.copyWith(note: value));
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('All out'),
                    value: widget.value.allOut,
                    onChanged: (value) {
                      widget.onChanged(
                        widget.value.copyWith(allOut: value ?? false),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _rpeController,
                    decoration: const InputDecoration(
                      labelText: 'RPE',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (value) {
                      widget.onChanged(
                        widget.value.copyWith(
                          rpe: double.tryParse(value.replaceAll(',', '.')),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: widget.onCompleted,
                child: const Text('Complete set'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}