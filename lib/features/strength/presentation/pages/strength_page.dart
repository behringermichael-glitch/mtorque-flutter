import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/set_entry.dart';
import '../../domain/models/strength_flow_state.dart';
import '../state/strength_providers.dart';
import 'exercise_page.dart';
import 'exercise_picker_sheet.dart';

class StrengthPage extends ConsumerStatefulWidget {
  static const String routePath = '/strength';
  static const String routeName = 'strength';

  const StrengthPage({super.key});

  @override
  ConsumerState<StrengthPage> createState() => _StrengthPageState();
}

class _StrengthPageState extends ConsumerState<StrengthPage> {
  final PageController _pageController = PageController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(strengthFlowControllerProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _todayEpochDay() {
    final now = DateTime.now();
    final utcMidnight = DateTime.utc(now.year, now.month, now.day);
    return utcMidnight.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(strengthFlowControllerProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final draft = state.draftSession;
    final exercises = draft?.exerciseOrder ?? const <String>[];
    final totalPages = exercises.length + 1;

    if (_pageController.hasClients &&
        state.hostView == StrengthHostView.pager &&
        (_pageController.page?.round() ?? 0) != state.pagerIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_pageController.hasClients) return;
        final maxPage = totalPages - 1;
        final target = state.pagerIndex.clamp(0, maxPage < 0 ? 0 : maxPage);
        _pageController.jumpToPage(target);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Strength'),
        actions: [
          if (state.hostView == StrengthHostView.pager)
            IconButton(
              onPressed: () => _showFinishDialog(context),
              icon: const Icon(Icons.check),
            ),
          if (state.hostView == StrengthHostView.pager)
            IconButton(
              onPressed: () => _handleClosePressed(),
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      floatingActionButton: state.hostView == StrengthHostView.pager
          ? FloatingActionButton(
        onPressed: () => _openExercisePicker(context),
        child: const Icon(Icons.add),
      )
          : null,
      body: SafeArea(
        child: state.hostView == StrengthHostView.planGrid
            ? _buildPlanGrid(context, state)
            : _buildPager(context, state, exercises),
      ),
    );
  }

  Widget _buildPlanGrid(BuildContext context, StrengthFlowState state) {
    final controller = ref.read(strengthFlowControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          height: 64,
          child: OutlinedButton.icon(
            onPressed: () {
              controller.startEmptySession(
                todayEpochDay: _todayEpochDay(),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Start empty plan'),
          ),
        ),
        const SizedBox(height: 16),
        for (final plan in state.plans)
          Card(
            child: ListTile(
              title: Text(plan.name),
              onTap: () {
                controller.loadPlan(
                  planName: plan.name,
                  todayEpochDay: _todayEpochDay(),
                );
              },
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'delete') {
                    await controller.deletePlan(plan.name);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPager(
      BuildContext context,
      StrengthFlowState state,
      List<String> exerciseIds,
      ) {
    final controller = ref.read(strengthFlowControllerProvider.notifier);

    return Column(
      children: [
        if (state.activeDbSessionStart != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _formatDateTime(state.activeDbSessionStart!),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: exerciseIds.length + 1,
            onPageChanged: controller.updatePagerIndex,
            itemBuilder: (context, index) {
              if (index == exerciseIds.length) {
                return Center(
                  child: FilledButton.icon(
                    onPressed: () => _openExercisePicker(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add exercise'),
                  ),
                );
              }

              final exerciseId = exerciseIds[index];
              return ExercisePage(
                key: ValueKey('exercise_page_$exerciseId'),
                exerciseId: exerciseId,
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _openExercisePicker(BuildContext context) async {
    final result = await showModalBottomSheet<List<StrengthExerciseSummary>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ExercisePickerSheet(),
    );

    if (result == null || result.isEmpty) return;

    await ref.read(strengthFlowControllerProvider.notifier).addExercises(result);
  }

  Future<void> _handleClosePressed() async {
    final state = ref.read(strengthFlowControllerProvider);
    final draft = state.draftSession;

    if (draft == null) {
      await ref.read(strengthFlowControllerProvider.notifier).showPlanGrid();
      return;
    }

    if (!draft.hasEntries) {
      await ref
          .read(strengthFlowControllerProvider.notifier)
          .discardCurrentSession();
      return;
    }

    if (!mounted) return;

    final action = await showDialog<_CloseAction>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Close plan'),
          content: const Text(
            'Save and close, discard, or continue editing?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(_CloseAction.continueEditing),
              child: const Text('Continue'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(_CloseAction.discard),
              child: const Text('Discard'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(_CloseAction.saveAndClose),
              child: const Text('Save and close'),
            ),
          ],
        );
      },
    );

    if (action == _CloseAction.discard) {
      await ref
          .read(strengthFlowControllerProvider.notifier)
          .discardCurrentSession();
    } else if (action == _CloseAction.saveAndClose) {
      await _showFinishDialog(context);
    }
  }

  Future<void> _showFinishDialog(BuildContext context) async {
    final notesController = TextEditingController();

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Finish session'),
          content: TextField(
            controller: notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Notes',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (save == true) {
      await ref.read(strengthFlowControllerProvider.notifier).finalizeSession(
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      );
    }
  }

  String _formatDateTime(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(value.day)}.${two(value.month)}.${value.year} '
        '${two(value.hour)}:${two(value.minute)}';
  }
}

enum _CloseAction {
  continueEditing,
  discard,
  saveAndClose,
}