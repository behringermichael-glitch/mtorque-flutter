import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/services/strength_plan_editor_service.dart';
import '../pages/exercise_asset_resolver.dart';
import '../state/strength_providers.dart';

class StrengthPlanEditorSheet extends ConsumerStatefulWidget {
  const StrengthPlanEditorSheet({
    super.key,
    required this.initialExerciseOrder,
    required this.initialSupersetGroupByExercise,
  });

  final List<String> initialExerciseOrder;
  final Map<String, String> initialSupersetGroupByExercise;

  @override
  ConsumerState<StrengthPlanEditorSheet> createState() =>
      _StrengthPlanEditorSheetState();
}

class _StrengthPlanEditorSheetState
    extends ConsumerState<StrengthPlanEditorSheet> {
  final StrengthPlanEditorService _service = const StrengthPlanEditorService();

  late List<String> _exerciseOrder;
  late Map<String, String> _supersetGroupByExercise;
  final Set<String> _selectedExerciseIds = <String>{};

  late Future<Map<String, String>> _labelFuture;

  @override
  void initState() {
    super.initState();

    _exerciseOrder = List<String>.from(widget.initialExerciseOrder);
    _supersetGroupByExercise = _service.normalizeSupersets(
      exerciseOrder: _exerciseOrder,
      supersetGroupByExercise: widget.initialSupersetGroupByExercise,
    );

    _labelFuture = _loadExerciseLabels();
  }

  Future<Map<String, String>> _loadExerciseLabels() async {
    final repository = ref.read(strengthRepositoryProvider);
    final labels = <String, String>{};

    for (final exerciseId in _exerciseOrder) {
      final exercise = await repository.getExerciseById(exerciseId);
      labels[exerciseId] = exercise?.label ?? exerciseId;
    }

    return labels;
  }

  StrengthPlanEditorSelectionState get _selectionState {
    return _service.evaluateSelection(
      exerciseOrder: _exerciseOrder,
      supersetGroupByExercise: _supersetGroupByExercise,
      selectedExerciseIds: _selectedExerciseIds,
    );
  }

  void _toggleSelection(String exerciseId, bool selected) {
    setState(() {
      if (selected) {
        _selectedExerciseIds.add(exerciseId);
      } else {
        _selectedExerciseIds.remove(exerciseId);
      }
    });
  }

  Future<void> _createSuperset() async {
    final l10n = AppLocalizations.of(context)!;
    final selectionState = _selectionState;

    if (!selectionState.canCreateSuperset) return;

    if (selectionState.replacesExistingSuperset) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(l10n.strengthPlanEditorReplaceSupersetTitle),
            content: Text(l10n.strengthPlanEditorReplaceSupersetMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.strengthCommonCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.strengthPlanEditorReplaceSupersetConfirm),
              ),
            ],
          );
        },
      );

      if (confirmed != true || !mounted) return;
    }

    setState(() {
      _supersetGroupByExercise = _service.createSuperset(
        exerciseOrder: _exerciseOrder,
        supersetGroupByExercise: _supersetGroupByExercise,
        selectedExerciseIds: _selectedExerciseIds,
        groupId: _service.createGroupId(),
      );
      _selectedExerciseIds.clear();
    });
  }

  void _dissolveSuperset() {
    if (!_selectionState.canDissolveSuperset) return;

    setState(() {
      _supersetGroupByExercise = _service.dissolveSuperset(
        exerciseOrder: _exerciseOrder,
        supersetGroupByExercise: _supersetGroupByExercise,
        selectedExerciseIds: _selectedExerciseIds,
      );
      _selectedExerciseIds.clear();
    });
  }

  void _finish() {
    Navigator.of(context).pop(
      StrengthPlanEditorResult(
        exerciseOrder: List<String>.from(_exerciseOrder),
        supersetGroupByExercise: Map<String, String>.from(
          _supersetGroupByExercise,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final selectionState = _selectionState;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.82,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.strengthPlanEditorTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: FutureBuilder<Map<String, String>>(
                  future: _labelFuture,
                  builder: (context, snapshot) {
                    final labels = snapshot.data ?? const <String, String>{};

                    if (_exerciseOrder.isEmpty) {
                      return Center(
                        child: Text(l10n.strengthPlanEditorNoExercises),
                      );
                    }

                    return ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemCount: _exerciseOrder.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          _exerciseOrder = _service.reorderExercise(
                            exerciseOrder: _exerciseOrder,
                            oldIndex: oldIndex,
                            newIndex: newIndex,
                          );
                          _supersetGroupByExercise =
                              _service.normalizeSupersets(
                                exerciseOrder: _exerciseOrder,
                                supersetGroupByExercise:
                                _supersetGroupByExercise,
                              );
                        });
                      },
                      itemBuilder: (context, index) {
                        final exerciseId = _exerciseOrder[index];
                        final selected =
                        _selectedExerciseIds.contains(exerciseId);
                        final label = labels[exerciseId] ?? exerciseId;
                        final supersetLabel =
                        _service.supersetLabelForExercise(
                          exerciseId: exerciseId,
                          exerciseOrder: _exerciseOrder,
                          supersetGroupByExercise:
                          _supersetGroupByExercise,
                        );

                        return _PlanEditorRow(
                          key: ValueKey('plan_editor_$exerciseId'),
                          index: index,
                          exerciseId: exerciseId,
                          label: label,
                          selected: selected,
                          supersetLabel: supersetLabel,
                          onSelectedChanged: (value) {
                            _toggleSelection(exerciseId, value);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.strengthCommonCancel),
                  ),
                  OutlinedButton.icon(
                    onPressed: selectionState.canDissolveSuperset
                        ? _dissolveSuperset
                        : null,
                    icon: const Icon(Icons.link_off),
                    label: Text(l10n.strengthPlanEditorDissolveSuperset),
                  ),
                  FilledButton.icon(
                    onPressed: selectionState.canCreateSuperset
                        ? _createSuperset
                        : null,
                    icon: const Icon(Icons.link),
                    label: Text(l10n.strengthPlanEditorCreateSuperset),
                  ),
                  FilledButton(
                    onPressed: _finish,
                    child: Text(l10n.strengthCommonDone),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanEditorRow extends StatelessWidget {
  const _PlanEditorRow({
    super.key,
    required this.index,
    required this.exerciseId,
    required this.label,
    required this.selected,
    required this.supersetLabel,
    required this.onSelectedChanged,
  });

  final int index;
  final String exerciseId;
  final String label;
  final bool selected;
  final String? supersetLabel;
  final ValueChanged<bool> onSelectedChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onSelectedChanged(!selected),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: Tooltip(
                  message: AppLocalizations.of(context)!
                      .strengthPlanEditorDragHandleTooltip,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.drag_handle),
                  ),
                ),
              ),
              Checkbox(
                value: selected,
                onChanged: (value) => onSelectedChanged(value ?? false),
              ),
              const SizedBox(width: 6),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                child: ExerciseAssetImage(
                  exerciseId: exerciseId,
                  width: 52,
                  height: 52,
                  fit: BoxFit.contain,
                  animate: false,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (supersetLabel != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    supersetLabel!,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}