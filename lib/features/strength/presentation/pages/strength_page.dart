
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
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
      appBar: state.hostView == StrengthHostView.pager
          ? AppBar(
        toolbarHeight: 90,
        backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        titleSpacing: 16,
        title: _SessionHeader(
          title: _sessionTitle(context),
          dateText: _sessionDateText(state),
          onDateTap:
          state.draftSession == null ? null : () => _pickSessionDate(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilledButton(
              onPressed: () => _showFinishDialog(context),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 46),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: Text(_endLabel(context)),
            ),
          ),
          PopupMenuButton<_StrengthMenuAction>(
            tooltip: MaterialLocalizations.of(context).showMenuTooltip,
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => _buildMenuItems(context, state),
          ),
        ],
      )
          : AppBar(
        title: Text(AppLocalizations.of(context)!.navStrength),
        actions: [
          PopupMenuButton<_StrengthMenuAction>(
            tooltip: MaterialLocalizations.of(context).showMenuTooltip,
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => _buildMenuItems(context, state),
          ),
        ],
      ),
      body: SafeArea(
        child: state.hostView == StrengthHostView.planGrid
            ? _buildPlanGrid(context, state)
            : _buildPager(context, state, exercises),
      ),
    );
  }

  Widget _buildPlanGrid(BuildContext context, StrengthFlowState state) {
    final l10n = AppLocalizations.of(context)!;
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
            label: Text(l10n.strengthStartEmptyPlan),
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
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(l10n.strengthCommonDelete),
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
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(strengthFlowControllerProvider.notifier);
    final pageIndex = state.pagerIndex.clamp(0, math.max(exerciseIds.length, 0));
    final showExercisePage = exerciseIds.isNotEmpty && pageIndex < exerciseIds.length;
    final showSwipeLeft = showExercisePage && pageIndex > 0;
    final showSwipeRight = showExercisePage && pageIndex < exerciseIds.length - 1;

    return Column(
      children: [
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
                    label: Text(l10n.strengthAddExercise),
                  ),
                );
              }

              final exerciseId = exerciseIds[index];
              return ExercisePage(
                key: ValueKey('exercise_page_$exerciseId'),
                exerciseId: exerciseId,
                showSwipeLeftHint: showSwipeLeft && index == pageIndex,
                showSwipeRightHint: showSwipeRight && index == pageIndex,
              );
            },
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: showExercisePage
              ? const Padding(
            key: ValueKey('timer_panel'),
            padding: EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: _TimerMetronomePanel(),
          )
              : const SizedBox(
            key: ValueKey('timer_panel_hidden'),
            height: 0,
          ),
        ),
      ],
    );
  }

  Future<void> _openExercisePicker(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ExercisePickerSheet(),
    );

    if (result == null || result is! List || result.isEmpty) return;
    await ref.read(strengthFlowControllerProvider.notifier).addExercises(
      List<StrengthExerciseSummary>.from(result),
    );
  }

  Future<void> _pickSessionDate(BuildContext context) async {
    final state = ref.read(strengthFlowControllerProvider);
    final draft = state.draftSession;
    if (draft == null) return;

    final initialDate = DateTime.fromMillisecondsSinceEpoch(
      draft.dateEpochDay * Duration.millisecondsPerDay,
      isUtc: true,
    ).toLocal();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (!mounted || picked == null) return;

    await ref.read(strengthFlowControllerProvider.notifier).updateDraftDate(picked);
  }

  List<PopupMenuEntry<_StrengthMenuAction>> _buildMenuItems(
      BuildContext context,
      StrengthFlowState state,
      ) {
    final items = <PopupMenuEntry<_StrengthMenuAction>>[];
    final hasDraft = state.draftSession != null;
    final hasPlanSelection = (state.selectedPlanName ?? '').trim().isNotEmpty;

    if (state.hostView == StrengthHostView.pager) {
      items.add(
        PopupMenuItem(
          value: _StrengthMenuAction.addExercise,
          child: Text(_menuLabel(context, _StrengthMenuAction.addExercise)),
        ),
      );
    }
    if (hasPlanSelection && hasDraft) {
      items.add(
        PopupMenuItem(
          value: _StrengthMenuAction.savePlan,
          child: Text(_menuLabel(context, _StrengthMenuAction.savePlan)),
        ),
      );
    }
    if (hasDraft) {
      items.add(
        PopupMenuItem(
          value: _StrengthMenuAction.saveAsPlan,
          child: Text(_menuLabel(context, _StrengthMenuAction.saveAsPlan)),
        ),
      );
    }
    items.add(
      PopupMenuItem(
        value: _StrengthMenuAction.loadPlan,
        child: Text(_menuLabel(context, _StrengthMenuAction.loadPlan)),
      ),
    );
    if (hasPlanSelection) {
      items.add(
        PopupMenuItem(
          value: _StrengthMenuAction.renamePlan,
          child: Text(_menuLabel(context, _StrengthMenuAction.renamePlan)),
        ),
      );
      items.add(
        PopupMenuItem(
          value: _StrengthMenuAction.deletePlan,
          child: Text(_menuLabel(context, _StrengthMenuAction.deletePlan)),
        ),
      );
    }
    items.add(
      PopupMenuItem(
        value: _StrengthMenuAction.startEmpty,
        child: Text(_menuLabel(context, _StrengthMenuAction.startEmpty)),
      ),
    );
    if (state.hostView == StrengthHostView.pager) {
      items.add(
        PopupMenuItem(
          value: _StrengthMenuAction.closePlan,
          child: Text(_menuLabel(context, _StrengthMenuAction.closePlan)),
        ),
      );
    }
    return items;
  }

  Future<void> _handleMenuAction(_StrengthMenuAction action) async {
    final state = ref.read(strengthFlowControllerProvider);
    final controller = ref.read(strengthFlowControllerProvider.notifier);
    switch (action) {
      case _StrengthMenuAction.addExercise:
        await _openExercisePicker(context);
        return;
      case _StrengthMenuAction.savePlan:
        final name = state.selectedPlanName;
        if (name == null || name.trim().isEmpty) return;
        await controller.savePlanFromCurrent(planName: name, overwrite: true);
        return;
      case _StrengthMenuAction.startEmpty:
        if (!await _confirmReplaceCurrent(context)) return;
        await controller.startEmptySession(todayEpochDay: _todayEpochDay());
        return;
      case _StrengthMenuAction.closePlan:
        await _handleClosePressed();
        return;
      case _StrengthMenuAction.saveAsPlan:
        final name = await _promptForPlanName(context, initialValue: state.selectedPlanName ?? '');
        if (name == null || name.trim().isEmpty) return;
        await controller.savePlanFromCurrent(planName: name.trim(), overwrite: false);
        return;
      case _StrengthMenuAction.loadPlan:
        final selected = await _showLoadPlanDialog(context, state);
        if (selected == null || selected.trim().isEmpty) return;
        if (!await _confirmReplaceCurrent(context)) return;
        await controller.loadPlan(planName: selected, todayEpochDay: _todayEpochDay());
        return;
      case _StrengthMenuAction.renamePlan:
        final current = state.selectedPlanName;
        if (current == null || current.trim().isEmpty) return;
        final next = await _promptForPlanName(context, initialValue: current);
        if (next == null || next.trim().isEmpty || next.trim() == current) return;
        await controller.renamePlan(oldName: current, newName: next.trim(), overwrite: false);
        return;
      case _StrengthMenuAction.deletePlan:
        final current = state.selectedPlanName;
        if (current == null || current.trim().isEmpty) return;
        final confirm = await _confirmDeletePlan(context, current);
        if (confirm == true) {
          await controller.deletePlan(current);
        }
        return;
    }
  }

  String _menuLabel(BuildContext context, _StrengthMenuAction action) {
    final de = Localizations.localeOf(context).languageCode.toLowerCase() == 'de';
    switch (action) {
      case _StrengthMenuAction.savePlan:
        return de ? 'Aktuellen Plan speichern' : 'Save current plan';
      case _StrengthMenuAction.startEmpty:
        return de ? 'Neue Einheit starten' : 'Start new session';
      case _StrengthMenuAction.closePlan:
        return de ? 'Einheit schließen' : 'Close session';
      case _StrengthMenuAction.saveAsPlan:
        return de ? 'Als neuen Plan speichern' : 'Save as new plan';
      case _StrengthMenuAction.loadPlan:
        return de ? 'Plan laden' : 'Load plan';
      case _StrengthMenuAction.renamePlan:
        return de ? 'Plan umbenennen' : 'Rename plan';
      case _StrengthMenuAction.deletePlan:
        return de ? 'Plan löschen' : 'Delete plan';
      case _StrengthMenuAction.addExercise:
        return de ? 'Übung hinzufügen' : 'Add exercise';
    }
  }

  String _endLabel(BuildContext context) {
    return Localizations.localeOf(context).languageCode.toLowerCase() == 'de'
        ? 'Beenden'
        : 'Finish';
  }

  Future<String?> _promptForPlanName(BuildContext context, {required String initialValue}) async {
    final controller = TextEditingController(text: initialValue);
    final de = Localizations.localeOf(context).languageCode.toLowerCase() == 'de';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(de ? 'Planname' : 'Plan name'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: de ? 'Name eingeben' : 'Enter name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context)!.strengthCommonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
              child: Text(AppLocalizations.of(context)!.strengthCommonSave),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showLoadPlanDialog(BuildContext context, StrengthFlowState state) {
    final de = Localizations.localeOf(context).languageCode.toLowerCase() == 'de';
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(de ? 'Plan laden' : 'Load plan'),
          content: SizedBox(
            width: double.maxFinite,
            child: state.plans.isEmpty
                ? Text(de ? 'Keine Pläne vorhanden.' : 'No plans available.')
                : ListView.builder(
              shrinkWrap: true,
              itemCount: state.plans.length,
              itemBuilder: (context, index) {
                final plan = state.plans[index];
                return ListTile(
                  title: Text(plan.name),
                  onTap: () => Navigator.of(dialogContext).pop(plan.name),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context)!.strengthCommonCancel),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _confirmReplaceCurrent(BuildContext context) async {
    final state = ref.read(strengthFlowControllerProvider);
    final draft = state.draftSession;
    if (draft == null || (!draft.hasEntries && draft.exerciseOrder.isEmpty)) {
      return true;
    }
    final de = Localizations.localeOf(context).languageCode.toLowerCase() == 'de';
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(de ? 'Aktuelle Einheit ersetzen?' : 'Replace current session?'),
          content: Text(de
              ? 'Die aktuelle Einheit wird dadurch verworfen und ersetzt.'
              : 'This will discard and replace the current session.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(AppLocalizations.of(context)!.strengthCommonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(de ? 'Ersetzen' : 'Replace'),
            ),
          ],
        );
      },
    );
    return result == true;
  }

  Future<bool?> _confirmDeletePlan(BuildContext context, String planName) {
    final de = Localizations.localeOf(context).languageCode.toLowerCase() == 'de';
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(de ? 'Plan löschen' : 'Delete plan'),
          content: Text(de
              ? 'Soll der Plan "$planName" gelöscht werden?'
              : 'Delete plan "$planName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(AppLocalizations.of(context)!.strengthCommonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(AppLocalizations.of(context)!.strengthCommonDelete),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleClosePressed() async {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.read(strengthFlowControllerProvider);
    final draft = state.draftSession;

    if (draft == null) {
      await ref.read(strengthFlowControllerProvider.notifier).showPlanGrid();
      return;
    }

    if (!draft.hasEntries) {
      await ref.read(strengthFlowControllerProvider.notifier).discardCurrentSession();
      return;
    }

    if (!mounted) return;

    final action = await showDialog<_CloseAction>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.strengthClosePlanTitle),
          content: Text(l10n.strengthClosePlanMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(_CloseAction.continueEditing),
              child: Text(l10n.strengthContinueEditing),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(_CloseAction.discard),
              child: Text(l10n.strengthDiscard),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(_CloseAction.saveAndClose),
              child: Text(l10n.strengthSaveAndClose),
            ),
          ],
        );
      },
    );

    if (action == _CloseAction.discard) {
      await ref.read(strengthFlowControllerProvider.notifier).discardCurrentSession();
    } else if (action == _CloseAction.saveAndClose) {
      await _showFinishDialog(context);
    }
  }

  Future<void> _showFinishDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final notesController = TextEditingController();

    final save = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.strengthFinishSessionTitle),
          content: TextField(
            controller: notesController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l10n.strengthNotes,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.strengthCommonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.strengthCommonSave),
            ),
          ],
        );
      },
    );

    if (save == true) {
      await ref.read(strengthFlowControllerProvider.notifier).finalizeSession(
        notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      );
    }
  }

  String _sessionTitle(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return languageCode == 'de' ? 'Einheit' : 'Session';
  }

  String _sessionDateText(StrengthFlowState state) {
    final start = state.activeDbSessionStart;
    if (start != null) {
      return _formatDateTime(start);
    }

    final draft = state.draftSession;
    if (draft == null) return '';

    final day = DateTime.fromMillisecondsSinceEpoch(
      draft.dateEpochDay * Duration.millisecondsPerDay,
      isUtc: true,
    ).toLocal();
    return _formatDate(day);
  }

  String _formatDate(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(value.day)}.${two(value.month)}.${value.year}';
  }

  String _formatDateTime(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(value.day)}.${two(value.month)}.${value.year} ${two(value.hour)}:${two(value.minute)}';
  }
}

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({
    required this.title,
    required this.dateText,
    required this.onDateTap,
  });

  final String title;
  final String dateText;
  final VoidCallback? onDateTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: onSurface,
          ),
        ),
        const SizedBox(height: 2),
        InkWell(
          onTap: onDateTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              dateText,
              style: textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.9),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PagerSwipeHintOverlay extends StatefulWidget {
  const _PagerSwipeHintOverlay({
    required this.topOffset,
    required this.showLeft,
    required this.showRight,
  });

  final double topOffset;
  final bool showLeft;
  final bool showRight;

  @override
  State<_PagerSwipeHintOverlay> createState() => _PagerSwipeHintOverlayState();
}

class _PagerSwipeHintOverlayState extends State<_PagerSwipeHintOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _leftDx;
  late final Animation<double> _rightDx;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
    _leftDx = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rightDx = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 0.52, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _animateIfNeeded();
  }

  @override
  void didUpdateWidget(covariant _PagerSwipeHintOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showLeft != widget.showLeft ||
        oldWidget.showRight != widget.showRight) {
      _animateIfNeeded();
    }
  }

  void _animateIfNeeded() {
    if (!widget.showLeft && !widget.showRight) {
      _controller.stop();
      _controller.reset();
      return;
    }
    unawaited(
      _controller.forward(from: 0).then((_) async {
        if (!mounted) return;
        await _controller.reverse();
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor =
    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.52);

    return Positioned(
      left: 0,
      right: 0,
      top: widget.topOffset,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final color = baseColor.withValues(alpha: _opacity.value);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                if (widget.showLeft)
                  Transform.translate(
                    offset: Offset(_leftDx.value, 0),
                    child: Icon(Icons.chevron_left, color: color, size: 34),
                  )
                else
                  const SizedBox(width: 34),
                const Spacer(),
                if (widget.showRight)
                  Transform.translate(
                    offset: Offset(_rightDx.value, 0),
                    child: Icon(Icons.chevron_right, color: color, size: 34),
                  )
                else
                  const SizedBox(width: 34),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TimerMetronomePanel extends StatefulWidget {
  const _TimerMetronomePanel();

  @override
  State<_TimerMetronomePanel> createState() => _TimerMetronomePanelState();
}

class _TimerMetronomePanelState extends State<_TimerMetronomePanel> {
  final PageController _pageController = PageController();
  final TextEditingController _restController = TextEditingController(text: '60');
  final TextEditingController _conController = TextEditingController(text: '1.5');
  final TextEditingController _holdTopController = TextEditingController(text: '0');
  final TextEditingController _eccController = TextEditingController(text: '1.5');
  final TextEditingController _holdBottomController = TextEditingController(text: '0');

  Timer? _timer;
  Timer? _metronomeTimer;
  int _page = 0;

  Duration _total = const Duration(seconds: 60);
  Duration _remaining = const Duration(seconds: 60);
  bool _timerRunning = false;
  int _lastSignalSecond = -999;

  bool _metronomeRunning = false;
  Duration _metronomeElapsed = Duration.zero;

  @override
  void dispose() {
    _timer?.cancel();
    _metronomeTimer?.cancel();
    _pageController.dispose();
    _restController.dispose();
    _conController.dispose();
    _holdTopController.dispose();
    _eccController.dispose();
    _holdBottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: SizedBox(
            height: 100,
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() => _page = value);
                if (value == 0) {
                  _stopMetronome();
                }
              },
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
                  child: Row(
                    children: [
                      _TimerDial(
                        remaining: _remaining,
                        total: _total,
                        running: _timerRunning,
                        dangerThresholdSec: 3,
                        onTap: _handleTimerClicked,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Timer',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(
                                  width: 88,
                                  child: TextField(
                                    controller: _restController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      hintText: 'sec',
                                    ),
                                    onChanged: (_) => _applyTimerInputIfIdle(),
                                    onSubmitted: (_) => _applyTimerInputIfIdle(),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                OutlinedButton(
                                  onPressed: _resetTimer,
                                  child: const Text('Reset'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MetronomeMaze(
                          elapsed: _metronomeElapsed,
                          concentricMs: _phaseMs(_conController.text, 1500),
                          holdTopMs: _phaseMs(_holdTopController.text, 0),
                          eccentricMs: _phaseMs(_eccController.text, 1500),
                          holdBottomMs: _phaseMs(_holdBottomController.text, 0),
                          running: _metronomeRunning,
                          onTap: _toggleMetronome,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _TempoRow(controller: _conController, label: 'Conc.', onChanged: _handleTempoChanged),
                            const SizedBox(height: 6),
                            _TempoRow(controller: _holdTopController, label: 'Top', onChanged: _handleTempoChanged),
                            const SizedBox(height: 6),
                            _TempoRow(controller: _eccController, label: 'Ecc.', onChanged: _handleTempoChanged),
                            const SizedBox(height: 6),
                            _TempoRow(controller: _holdBottomController, label: 'Bottom', onChanged: _handleTempoChanged),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Dot(
              active: _page == 0,
              onTap: () => _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
              ),
            ),
            const SizedBox(width: 8),
            _Dot(
              active: _page == 1,
              onTap: () => _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _applyTimerInputIfIdle() {
    final seconds = int.tryParse(_restController.text.trim());
    if (seconds == null || seconds < 1 || seconds > 7200) return;
    _total = Duration(seconds: seconds);
    if (!_timerRunning) {
      setState(() {
        _remaining = _total;
      });
    }
  }

  void _handleTimerClicked() {
    if (_timerRunning) {
      _stopTimer();
      return;
    }

    final shouldResume = _remaining > Duration.zero && _remaining < _total;
    if (shouldResume) {
      _resumeTimer();
      return;
    }

    final seconds = int.tryParse(_restController.text.trim())?.clamp(1, 7200) ?? 60;
    _startTimer(Duration(seconds: seconds));
  }

  void _startTimer(Duration duration) {
    _pageController.jumpToPage(0);
    _timer?.cancel();
    setState(() {
      _timerRunning = true;
      _total = duration;
      _remaining = duration;
      _lastSignalSecond = duration.inSeconds + 1;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      final next = _remaining - const Duration(milliseconds: 200);
      if (next <= Duration.zero) {
        timer.cancel();
        _playDoneAlert();
        setState(() {
          _remaining = Duration.zero;
          _timerRunning = false;
        });
        return;
      }

      final sec = (next.inMilliseconds / 1000).ceil();
      if (sec != _lastSignalSecond) {
        if (sec == 3 || sec == 2) {
          _playWarningBeep();
        } else if (sec == 1) {
          _playFinalSecondAlert();
        }
        _lastSignalSecond = sec;
      }

      setState(() {
        _remaining = next;
      });
    });
  }

  void _resumeTimer() {
    if (_remaining <= Duration.zero) return;
    _pageController.jumpToPage(0);
    _timer?.cancel();
    setState(() {
      _timerRunning = true;
      _lastSignalSecond = _remaining.inSeconds + 1;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      final next = _remaining - const Duration(milliseconds: 200);
      if (next <= Duration.zero) {
        timer.cancel();
        _playDoneAlert();
        setState(() {
          _remaining = Duration.zero;
          _timerRunning = false;
        });
        return;
      }

      final sec = (next.inMilliseconds / 1000).ceil();
      if (sec != _lastSignalSecond) {
        if (sec == 3 || sec == 2) {
          _playWarningBeep();
        } else if (sec == 1) {
          _playFinalSecondAlert();
        }
        _lastSignalSecond = sec;
      }

      setState(() {
        _remaining = next;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _timerRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    final seconds = int.tryParse(_restController.text.trim())?.clamp(1, 7200) ?? 60;
    setState(() {
      _total = Duration(seconds: seconds);
      _remaining = _total;
    });
  }

  void _toggleMetronome() {
    if (_metronomeRunning) {
      _stopMetronome();
    } else {
      _startMetronome();
    }
  }

  void _startMetronome() {
    _stopMetronome();
    setState(() {
      _metronomeRunning = true;
      _metronomeElapsed = Duration.zero;
    });

    var phaseIndex = -1;

    _metronomeTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      final elapsed = _metronomeElapsed + const Duration(milliseconds: 40);
      final phases = <int>[
        _phaseMs(_conController.text, 1500),
        _phaseMs(_holdTopController.text, 0),
        _phaseMs(_eccController.text, 1500),
        _phaseMs(_holdBottomController.text, 0),
      ];
      final cycle = phases.reduce((a, b) => a + b).clamp(1, 1000000);
      final pos = elapsed.inMilliseconds % cycle;

      var acc = 0;
      var nextPhase = 0;
      for (var i = 0; i < phases.length; i++) {
        acc += phases[i];
        if (pos < acc) {
          nextPhase = i;
          break;
        }
      }
      if (nextPhase != phaseIndex) {
        phaseIndex = nextPhase;
        SystemSound.play(SystemSoundType.click);
      }

      if (!mounted) return;
      setState(() {
        _metronomeElapsed = elapsed;
      });
    });
  }

  void _stopMetronome() {
    _metronomeTimer?.cancel();
    _metronomeTimer = null;
    if (!mounted) return;
    setState(() {
      _metronomeRunning = false;
      _metronomeElapsed = Duration.zero;
    });
  }

  void _handleTempoChanged(String _) {
    if (_metronomeRunning) {
      _startMetronome();
    } else {
      setState(() {});
    }
  }

  int _phaseMs(String raw, int fallback) {
    final normalized = raw.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return fallback;
    final seconds = double.tryParse(normalized);
    if (seconds == null) return fallback;
    return math.max(0, (seconds * 1000).round());
  }

  void _playWarningBeep() {
    SystemSound.play(SystemSoundType.click);
  }

  void _playFinalSecondAlert() {
    SystemSound.play(SystemSoundType.alert);
  }

  void _playDoneAlert() {
    SystemSound.play(SystemSoundType.alert);
  }
}

class _TimerDial extends StatelessWidget {
  const _TimerDial({
    required this.remaining,
    required this.total,
    required this.running,
    required this.dangerThresholdSec,
    required this.onTap,
  });

  final Duration remaining;
  final Duration total;
  final bool running;
  final int dangerThresholdSec;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final danger = remaining.inSeconds <= dangerThresholdSec;
    final elapsedFactor = total.inMilliseconds <= 0
        ? 1.0
        : ((total.inMilliseconds - remaining.inMilliseconds) / total.inMilliseconds)
        .clamp(0.0, 1.0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(48),
      child: SizedBox(
        width: 98,
        height: 98,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size.square(98),
              painter: _TimerDialPainter(
                progress: elapsedFactor,
                danger: danger,
                color: Theme.of(context).colorScheme.primary,
                trackColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.14),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(remaining.inMilliseconds / 1000).ceil().clamp(0, 9999)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 2),
                Icon(running ? Icons.pause : Icons.play_arrow, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerDialPainter extends CustomPainter {
  const _TimerDialPainter({
    required this.progress,
    required this.danger,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final bool danger;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 6.0;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor;

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = danger ? Colors.redAccent : color;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, track);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerDialPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.danger != danger ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor;
  }
}

class _MetronomeMaze extends StatelessWidget {
  const _MetronomeMaze({
    required this.elapsed,
    required this.concentricMs,
    required this.holdTopMs,
    required this.eccentricMs,
    required this.holdBottomMs,
    required this.running,
    required this.onTap,
  });

  final Duration elapsed;
  final int concentricMs;
  final int holdTopMs;
  final int eccentricMs;
  final int holdBottomMs;
  final bool running;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cycle = math.max(1, concentricMs + holdTopMs + eccentricMs + holdBottomMs);
    final pos = elapsed.inMilliseconds % cycle;

    double progress;
    if (pos < concentricMs) {
      progress = concentricMs == 0 ? 0 : pos / concentricMs;
    } else if (pos < concentricMs + holdTopMs) {
      progress = 1;
    } else if (pos < concentricMs + holdTopMs + eccentricMs) {
      final local = pos - concentricMs - holdTopMs;
      progress = eccentricMs == 0 ? 1 : 1 - (local / eccentricMs);
    } else {
      progress = 0;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: CustomPaint(
          painter: _MetronomeMazePainter(
            progress: progress.clamp(0.0, 1.0),
            color: running ? cs.primary : cs.onSurface.withValues(alpha: 0.38),
          ),
          child: Center(
            child: Text(
              running ? 'Tap to stop' : 'Tap to start',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }
}

class _MetronomeMazePainter extends CustomPainter {
  const _MetronomeMazePainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final active = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.78)
      ..lineTo(size.width * 0.18, size.height * 0.22)
      ..lineTo(size.width * 0.82, size.height * 0.22)
      ..lineTo(size.width * 0.82, size.height * 0.78)
      ..lineTo(size.width * 0.18, size.height * 0.78);

    canvas.drawPath(path, paint);

    final dotX = size.width * (0.18 + (0.64 * progress));
    final dotY = size.height * (0.78 - (0.56 * progress));
    canvas.drawCircle(Offset(dotX, dotY), 7, active);
  }

  @override
  bool shouldRepaint(covariant _MetronomeMazePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _TempoRow extends StatelessWidget {
  const _TempoRow({
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 56,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(isDense: true),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.active,
    required this.onTap,
  });

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface.withValues(
      alpha: active ? 0.8 : 0.28,
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

enum _CloseAction {
  continueEditing,
  discard,
  saveAndClose,
}

enum _StrengthMenuAction {
  savePlan,
  startEmpty,
  closePlan,
  saveAsPlan,
  loadPlan,
  renamePlan,
  deletePlan,
  addExercise,
}
