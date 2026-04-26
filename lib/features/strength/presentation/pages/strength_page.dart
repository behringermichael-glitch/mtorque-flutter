import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audio/mtorque_sound_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/set_entry.dart';
import '../../domain/models/strength_flow_state.dart';
import '../state/strength_providers.dart';
import '../widgets/strength_plan_editor_sheet.dart';
import '../widgets/strength_plan_print_dialogs.dart';
import '../../domain/services/strength_plan_editor_service.dart';
import '../../domain/services/strength_plan_print_service.dart';
import 'exercise_asset_resolver.dart';
import 'exercise_page.dart';
import 'exercise_picker_sheet.dart';

Color _panelSurfaceColor(BuildContext context) {
  final theme = Theme.of(context);
  return theme.cardTheme.color ??
      theme.colorScheme.surfaceContainerLow;
}

class StrengthPage extends ConsumerStatefulWidget {
  static const String routePath = '/strength';
  static const String routeName = 'strength';

  const StrengthPage({super.key});

  @override
  ConsumerState<StrengthPage> createState() => _StrengthPageState();
}

class _StrengthPageState extends ConsumerState<StrengthPage> {
  final PageController _pageController = PageController();
  final GlobalKey _pagerStackKey = GlobalKey();
  final GlobalKey<_TimerMetronomePanelState> _timerPanelKey =
  GlobalKey<_TimerMetronomePanelState>();
  bool _initialized = false;
  double? _swipeHintTopOffset;
  int _currentPageIndex = 0;
  List<String> _lastExerciseOrder = const <String>[];

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


  void _handlePagerChanged(int index) {
    final exercises = ref.read(
      strengthFlowControllerProvider.select(
            (state) => state.draftSession?.exerciseOrder ?? const <String>[],
      ),
    );

    setState(() {
      _currentPageIndex = index;
      _swipeHintTopOffset = null;
    });

    ref.read(strengthFlowControllerProvider.notifier).updatePagerIndex(index);

    _precacheAroundPage(
      exerciseIds: exercises,
      centerIndex: index,
    );
  }

  void _handleHeaderDividerGlobalYChanged(double globalY) {
    if (!mounted) return;

    if (globalY < 0) {
      if (_swipeHintTopOffset != null) {
        setState(() {
          _swipeHintTopOffset = null;
        });
      }
      return;
    }

    final stackContext = _pagerStackKey.currentContext;
    if (stackContext == null) return;
    final renderObject = stackContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final localOffset = renderObject.globalToLocal(Offset(0, globalY));
    final nextTopOffset = localOffset.dy - 17;

    if (_swipeHintTopOffset != null &&
        (_swipeHintTopOffset! - nextTopOffset).abs() < 0.5) {
      return;
    }

    setState(() {
      _swipeHintTopOffset = nextTopOffset;
    });
  }

  int _todayEpochDay() {
    final now = DateTime.now();
    final utcMidnight = DateTime.utc(now.year, now.month, now.day);
    return utcMidnight.millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
  }

  bool _sameExerciseOrder(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _precacheAroundPage({
    required List<String> exerciseIds,
    required int centerIndex,
  }) {
    if (exerciseIds.isEmpty) return;

    final candidates = <int>{
      centerIndex,
      centerIndex - 1,
      centerIndex + 1,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      for (final index in candidates) {
        if (index < 0 || index >= exerciseIds.length) continue;
        ExerciseAssetResolver.warmUp(exerciseIds[index]);
        unawaited(
          ExerciseAssetResolver.precacheExerciseImage(
            context,
            exerciseIds[index],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      strengthFlowControllerProvider.select((state) => state.isLoading),
    );

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final hostView = ref.watch(
      strengthFlowControllerProvider.select((state) => state.hostView),
    );

    final exercises = ref.watch(
      strengthFlowControllerProvider.select(
            (state) => state.draftSession?.exerciseOrder ?? const <String>[],
      ),
    );

    final plans = ref.watch(
      strengthFlowControllerProvider.select((state) => state.plans),
    );

    final selectedPlanName = ref.watch(
      strengthFlowControllerProvider.select((state) => state.selectedPlanName),
    );

    final activeDbSessionStart = ref.watch(
      strengthFlowControllerProvider.select(
            (state) => state.activeDbSessionStart,
      ),
    );

    final draftDateEpochDay = ref.watch(
      strengthFlowControllerProvider.select(
            (state) => state.draftSession?.dateEpochDay,
      ),
    );

    final hasDraft = draftDateEpochDay != null;
    final hasPlanSelection = (selectedPlanName ?? '').trim().isNotEmpty;

    final totalPages = exercises.length + 1;

    final orderChanged = !_sameExerciseOrder(_lastExerciseOrder, exercises);
    if (orderChanged) {
      _lastExerciseOrder = List<String>.from(exercises);
      final maxIndex = totalPages - 1;
      if (_currentPageIndex > maxIndex) {
        _currentPageIndex = maxIndex < 0 ? 0 : maxIndex;
      }
    }

    if (orderChanged && exercises.isNotEmpty) {
      _precacheAroundPage(
        exerciseIds: exercises,
        centerIndex: _currentPageIndex.clamp(0, exercises.length - 1),
      );
    }

    final panelColor = _panelSurfaceColor(context);
    final panelBorderColor =
    Theme.of(context).dividerColor.withValues(alpha: 0.35);

    // PATCH 5: jumpToPage komplett aus build() entfernt.
    // _currentPageIndex wird durch orderChanged bereits korrekt geclippt.
    // Ein PageController-Jump im build()-Aufruf würde einen weiteren
    // Frame-Callback einreihen und die Swipe-Animation unterbrechen.

    return Scaffold(
      appBar: hostView == StrengthHostView.pager
          ? AppBar(
        toolbarHeight: 64,
        backgroundColor: panelColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        titleSpacing: 16,
        shape: Border(
          bottom: BorderSide(
            color: panelBorderColor,
            width: 1,
          ),
        ),
        title: _SessionHeader(
          title: _sessionTitle(context),
          dateText: _sessionDateText(
            activeDbSessionStart: activeDbSessionStart,
            draftDateEpochDay: draftDateEpochDay,
          ),
          onDateTap: hasDraft ? () => _pickSessionDate(context) : null,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: FilledButton(
              onPressed: () => _showFinishDialog(context),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 38),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
                elevation: 0,
              ),
              child: Text(_endLabel(context)),
            ),
          ),
          PopupMenuButton<_StrengthMenuAction>(
            tooltip: MaterialLocalizations.of(context).showMenuTooltip,
            color: panelColor,
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => _buildMenuItems(
              context,
              hostView: hostView,
              hasDraft: hasDraft,
              hasPlanSelection: hasPlanSelection,
            ),
          ),
        ],
      )
          : AppBar(
        backgroundColor: panelColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(
            color: panelBorderColor,
            width: 1,
          ),
        ),
        title: Text(AppLocalizations.of(context)!.navStrength),
        actions: [
          PopupMenuButton<_StrengthMenuAction>(
            tooltip: MaterialLocalizations.of(context).showMenuTooltip,
            color: panelColor,
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => _buildMenuItems(
              context,
              hostView: hostView,
              hasDraft: hasDraft,
              hasPlanSelection: hasPlanSelection,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: NotificationListener<StartRestTimerNotification>(
          onNotification: (notification) {
            _timerPanelKey.currentState?.startRestTimerFromInput();
            return true;
          },
          child: hostView == StrengthHostView.planGrid
              ? _buildPlanGrid(context, plans)
              : _buildPager(
            context,
            exerciseIds: exercises,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanGrid(
      BuildContext context,
      List<dynamic> plans,
      ) {
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
        for (final plan in plans)
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
      BuildContext context, {
        required List<String> exerciseIds,
      }) {
    final l10n = AppLocalizations.of(context)!;
    final pageIndex =
    _currentPageIndex.clamp(0, math.max(exerciseIds.length, 0));
    final showExercisePage =
        exerciseIds.isNotEmpty && pageIndex < exerciseIds.length;
    final showSwipeLeft = showExercisePage && pageIndex > 0;
    final showSwipeRight =
        showExercisePage && pageIndex < exerciseIds.length - 1;

    return Column(
      children: [
        Expanded(
          child: Stack(
            key: _pagerStackKey,
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: exerciseIds.length + 1,
                allowImplicitScrolling: true,
                // PATCH 1: ClampingScrollPhysics entspricht dem Verhalten von
                // ViewPager2 auf Android — kein overscroll-bounce, direktes
                // page-snapping ohne Federeffekt. Das macht den Swipe
                // deterministischer und verhindert Frame-Drops durch
                // die BouncingScrollPhysics auf iOS.
                physics: const ClampingScrollPhysics(),
                onPageChanged: _handlePagerChanged,
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
                    onEditPlanStructure: () => _openPlanEditorSheet(context),
                    onHeaderDividerGlobalYChanged:
                    index == pageIndex
                        ? _handleHeaderDividerGlobalYChanged
                        : null,
                  );
                },
              ),
              if (showExercisePage && _swipeHintTopOffset != null)
                _PagerSwipeHintOverlay(
                  topOffset: _swipeHintTopOffset!,
                  showLeft: showSwipeLeft,
                  showRight: showSwipeRight,
                ),
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: showExercisePage
              ? Padding(
            key: const ValueKey('timer_panel'),
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: _TimerMetronomePanel(key: _timerPanelKey),
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

    await ref
        .read(strengthFlowControllerProvider.notifier)
        .updateDraftDate(picked);
  }

  List<PopupMenuEntry<_StrengthMenuAction>> _buildMenuItems(
      BuildContext context, {
        required StrengthHostView hostView,
        required bool hasDraft,
        required bool hasPlanSelection,
      }) {
    final items = <PopupMenuEntry<_StrengthMenuAction>>[];

    items.add(
      PopupMenuItem(
        value: _StrengthMenuAction.startEmpty,
        child: Text(
          _menuLabel(context, _StrengthMenuAction.startEmpty),
        ),
      ),
    );

    if (hostView == StrengthHostView.pager) {
      items.add(
        PopupMenuItem(
          value: _StrengthMenuAction.closePlan,
          child: Text(
            _menuLabel(context, _StrengthMenuAction.closePlan),
          ),
        ),
      );
    }

    if (hasDraft) {
      items.add(
        PopupMenuItem(
          value: _StrengthMenuAction.saveAsPlan,
          child: Text(
            _menuLabel(context, _StrengthMenuAction.saveAsPlan),
          ),
        ),
      );
    }

    items.add(
      PopupMenuItem(
        value: _StrengthMenuAction.editPlan,
        enabled: hasDraft,
        child: Text(
          _menuLabel(context, _StrengthMenuAction.editPlan),
        ),
      ),
    );

    if (hasDraft) {
      items.add(
        PopupMenuItem(
          value: _StrengthMenuAction.printPlanPdf,
          child: Text(
            _menuLabel(context, _StrengthMenuAction.printPlanPdf),
          ),
        ),
      );
    }

    if (hostView == StrengthHostView.pager) {
      items.add(
        PopupMenuItem(
          value: _StrengthMenuAction.addExercise,
          child: Text(
            _menuLabel(context, _StrengthMenuAction.addExercise),
          ),
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
        await controller.savePlanFromCurrent(
          planName: name,
          overwrite: true,
        );
        return;
      case _StrengthMenuAction.startEmpty:
        if (!await _confirmReplaceCurrent(context)) return;
        await controller.startEmptySession(
          todayEpochDay: _todayEpochDay(),
        );
        return;
      case _StrengthMenuAction.closePlan:
        await _handleClosePressed();
        return;
      case _StrengthMenuAction.saveAsPlan:
        final name = await _promptForPlanName(
          context,
          initialValue: state.selectedPlanName ?? '',
        );
        if (name == null || name.trim().isEmpty) return;
        await controller.savePlanFromCurrent(
          planName: name.trim(),
          overwrite: false,
        );
        return;
      case _StrengthMenuAction.editPlan:
        await _openPlanEditorSheet(context);
        return;
      case _StrengthMenuAction.printPlanPdf:
        await _handlePrintPlanPdf();
        return;
      case _StrengthMenuAction.loadPlan:
        final selected = await _showLoadPlanDialog(context, state);
        if (selected == null || selected.trim().isEmpty) return;
        if (!await _confirmReplaceCurrent(context)) return;
        await controller.loadPlan(
          planName: selected,
          todayEpochDay: _todayEpochDay(),
        );
        return;
      case _StrengthMenuAction.renamePlan:
        final current = state.selectedPlanName;
        if (current == null || current.trim().isEmpty) return;
        final next = await _promptForPlanName(
          context,
          initialValue: current,
        );
        if (next == null ||
            next.trim().isEmpty ||
            next.trim() == current) {
          return;
        }
        await controller.renamePlan(
          oldName: current,
          newName: next.trim(),
          overwrite: false,
        );
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
    final l10n = AppLocalizations.of(context)!;

    switch (action) {
      case _StrengthMenuAction.savePlan:
        return l10n.strengthMenuSaveCurrentPlan;
      case _StrengthMenuAction.startEmpty:
        return l10n.strengthMenuStartEmptyPlan;
      case _StrengthMenuAction.closePlan:
        return l10n.strengthMenuCloseSession;
      case _StrengthMenuAction.saveAsPlan:
        return l10n.strengthMenuSaveAsPlan;
      case _StrengthMenuAction.editPlan:
        return l10n.strengthMenuEditTrainingPlan;
      case _StrengthMenuAction.printPlanPdf:
        return l10n.strengthMenuPrintPlanPdf;
      case _StrengthMenuAction.loadPlan:
        return l10n.strengthMenuLoadPlan;
      case _StrengthMenuAction.renamePlan:
        return l10n.strengthMenuRenamePlan;
      case _StrengthMenuAction.deletePlan:
        return l10n.strengthMenuDeletePlan;
      case _StrengthMenuAction.addExercise:
        return l10n.strengthMenuAddExercise;
    }
  }

  String _endLabel(BuildContext context) {
    return AppLocalizations.of(context)!.strengthEndSessionButton;
  }

  Future<void> _openPlanEditorSheet(BuildContext context) async {
    final state = ref.read(strengthFlowControllerProvider);
    final draft = state.draftSession;

    if (draft == null || draft.exerciseOrder.isEmpty) {
      return;
    }

    final result = await showModalBottomSheet<StrengthPlanEditorResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return StrengthPlanEditorSheet(
          initialExerciseOrder: draft.exerciseOrder,
          initialSupersetGroupByExercise: draft.supersetGroupByExercise,
        );
      },
    );

    if (!mounted || result == null) return;

    await ref
        .read(strengthFlowControllerProvider.notifier)
        .applyPlanStructureEdit(
      exerciseOrder: result.exerciseOrder,
      supersetGroupByExercise: result.supersetGroupByExercise,
    );

    final maxIndex = result.exerciseOrder.isEmpty
        ? 0
        : result.exerciseOrder.length - 1;

    final nextIndex = _currentPageIndex.clamp(0, maxIndex);

    setState(() {
      _currentPageIndex = nextIndex;
      _lastExerciseOrder = List<String>.from(result.exerciseOrder);
    });

    if (_pageController.hasClients) {
      await _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _handlePrintPlanPdf() async {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.read(strengthFlowControllerProvider);

    final selectedPlanName = await StrengthPlanPrintDialogs.selectPlan(
      context,
      plans: state.plans,
    );
    if (!mounted || selectedPlanName == null || selectedPlanName.trim().isEmpty) {
      return;
    }

    final setsPerExercise =
    await StrengthPlanPrintDialogs.selectSetsPerExercise(context);
    if (!mounted || setsPerExercise == null) return;

    final comment =
    await StrengthPlanPrintDialogs.enterOptionalComment(context);
    if (!mounted) return;

    try {
      final printService = ref.read(strengthPlanPrintServiceProvider);

      await printService.printSavedPlan(
        planName: selectedPlanName.trim(),
        setsPerExercise: setsPerExercise,
        languageCode: Localizations.localeOf(context).languageCode,
        jobName: l10n.strengthPrintJobStrengthPlan(selectedPlanName.trim()),
        generatedAtLabel: l10n.strengthPrintPdfGeneratedAt('{date}'),
        dateLabel: l10n.strengthPrintPdfDate,
        kgLabel: l10n.strengthPrintPdfKg,
        repsLabel: l10n.strengthPrintPdfReps,
        pageLabelBuilder: l10n.strengthPrintPdfPageXOfY,
        comment: comment,
      );
    } on StrengthPlanPrintNoExercisesException {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.strengthPrintPlanNoExercises),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.strengthPrintPlanFailed(error.toString()),
          ),
        ),
      );
    }
  }

  Future<String?> _promptForPlanName(
      BuildContext context, {
        required String initialValue,
      }) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: initialValue);

    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.strengthPlanNameTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n.strengthPlanNameHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.strengthCommonCancel),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: Text(l10n.strengthCommonSave),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showLoadPlanDialog(
      BuildContext context,
      StrengthFlowState state,
      ) {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.strengthMenuLoadPlan),
          content: SizedBox(
            width: double.maxFinite,
            child: state.plans.isEmpty
                ? Text(l10n.strengthNoPlansAvailable)
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
              child: Text(l10n.strengthCommonCancel),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _confirmReplaceCurrent(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.read(strengthFlowControllerProvider);
    final draft = state.draftSession;

    if (draft == null || (!draft.hasEntries && draft.exerciseOrder.isEmpty)) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.strengthReplaceCurrentSessionTitle),
          content: Text(l10n.strengthReplaceCurrentSessionMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.strengthCommonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.strengthReplaceCurrentSessionButton),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  Future<bool?> _confirmDeletePlan(
      BuildContext context,
      String planName,
      ) {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.strengthDeletePlanTitle),
          content: Text(l10n.strengthDeletePlanMessage(planName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.strengthCommonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.strengthCommonDelete),
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
      await ref
          .read(strengthFlowControllerProvider.notifier)
          .showPlanGrid();
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
          title: Text(l10n.strengthClosePlanTitle),
          content: Text(l10n.strengthClosePlanMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext)
                  .pop(_CloseAction.continueEditing),
              child: Text(l10n.strengthContinueEditing),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(_CloseAction.discard),
              child: Text(l10n.strengthDiscard),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext)
                  .pop(_CloseAction.saveAndClose),
              child: Text(l10n.strengthSaveAndClose),
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
      await ref
          .read(strengthFlowControllerProvider.notifier)
          .finalizeSession(
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      );
    }
  }

  String _sessionTitle(BuildContext context) {
    return AppLocalizations.of(context)!.strengthSessionTitle;
  }

  String _sessionDateText({
    required DateTime? activeDbSessionStart,
    required int? draftDateEpochDay,
  }) {
    final start = activeDbSessionStart;
    if (start != null) {
      return _formatDateTime(start);
    }

    if (draftDateEpochDay == null) return '';

    final day = DateTime.fromMillisecondsSinceEpoch(
      draftDateEpochDay * Duration.millisecondsPerDay,
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

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: onSurface,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dateText,
            style: textTheme.bodyMedium?.copyWith(
              color: onSurface.withValues(alpha: 0.78),
              height: 1.0,
            ),
          ),
        ],
      ),
    );

    if (onDateTap == null) {
      return content;
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onDateTap,
        borderRadius: BorderRadius.circular(10),
        child: content,
      ),
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
  State<_PagerSwipeHintOverlay> createState() =>
      _PagerSwipeHintOverlayState();
}

class _PagerSwipeHintOverlayState
    extends State<_PagerSwipeHintOverlay>
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
  void didUpdateWidget(
      covariant _PagerSwipeHintOverlay oldWidget) {
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
                    child: Icon(
                      Icons.chevron_left,
                      color: color,
                      size: 34,
                    ),
                  )
                else
                  const SizedBox(width: 34),
                const Spacer(),
                if (widget.showRight)
                  Transform.translate(
                    offset: Offset(_rightDx.value, 0),
                    child: Icon(
                      Icons.chevron_right,
                      color: color,
                      size: 34,
                    ),
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
  const _TimerMetronomePanel({super.key});

  @override
  State<_TimerMetronomePanel> createState() =>
      _TimerMetronomePanelState();
}

class _TimerMetronomePanelState extends State<_TimerMetronomePanel>
    with SingleTickerProviderStateMixin {
  final _soundService = MtorqueSoundService.instance;

  final PageController _pageController = PageController();
  final TextEditingController _restController =
  TextEditingController(text: '60');
  final TextEditingController _conController =
  TextEditingController(text: '1.5');
  final TextEditingController _holdTopController =
  TextEditingController(text: '0');
  final TextEditingController _eccController =
  TextEditingController(text: '1.5');
  final TextEditingController _holdBottomController =
  TextEditingController(text: '0');

  Timer? _timer;

  late final Ticker _metronomeTicker;
  bool _metronomeFrameRequestInFlight = false;
  int _metronomeCycleMs = 1;

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

    _metronomeTicker.stop();
    _metronomeTicker.dispose();

    _pageController.dispose();
    _restController.dispose();
    _conController.dispose();
    _holdTopController.dispose();
    _eccController.dispose();
    _holdBottomController.dispose();
    unawaited(_soundService.metronomeStopLoop());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _metronomeTicker = createTicker((_) async {
      if (!mounted || !_metronomeRunning) return;
      if (_metronomeFrameRequestInFlight) return;

      _metronomeFrameRequestInFlight = true;
      try {
        final posMs = await _soundService.getMetronomePositionMs();
        if (!mounted || !_metronomeRunning) return;

        final cycleMs = math.max(1, _metronomeCycleMs);
        final next = Duration(milliseconds: posMs % cycleMs);

        if (next == _metronomeElapsed) return;

        setState(() {
          _metronomeElapsed = next;
        });
      } finally {
        _metronomeFrameRequestInFlight = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final panelColor = _panelSurfaceColor(context);
    final panelBorderColor =
    Theme.of(context).dividerColor.withValues(alpha: 0.35);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: panelColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: panelBorderColor,
              width: 1,
            ),
          ),
          child: SizedBox(
            height: 120,
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 96,
                        height: 96,
                        child: _TimerDial(
                          remaining: _remaining,
                          total: _total,
                          running: _timerRunning,
                          dangerThresholdSec: 10,
                          onTap: _handleTimerClicked,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.strengthTimerTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 96,
                                  child: TextField(
                                    controller: _restController,
                                    keyboardType: TextInputType.number,
                                    textInputAction:
                                    TextInputAction.done,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: l10n.strengthTimerSecondsHint,
                                      hintStyle: TextStyle(
                                        color: cs.onSurface.withValues(alpha: 0.42),
                                      ),
                                    ),
                                    onChanged: (_) =>
                                        _applyTimerInputIfIdle(),
                                    onSubmitted: (_) =>
                                        _applyTimerInputIfIdle(),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                SizedBox(
                                  height: 42,
                                  child: OutlinedButton(
                                    onPressed: _resetTimer,
                                    style:
                                    OutlinedButton.styleFrom(
                                      minimumSize:
                                      const Size(96, 42),
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            22),
                                      ),
                                    ),
                                    child: Text(l10n.strengthTimerReset),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.strengthTimerRingHint,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: cs.onSurface
                                    .withValues(alpha: 0.68),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 74,
                              child: _MetronomeMaze(
                                elapsed: _metronomeElapsed,
                                concentricMs:
                                _phaseMs(_conController.text, 1500),
                                holdTopMs:
                                _phaseMs(_holdTopController.text, 0),
                                eccentricMs:
                                _phaseMs(_eccController.text, 1500),
                                holdBottomMs:
                                _phaseMs(_holdBottomController.text, 0),
                                running: _metronomeRunning,
                                onTap: _toggleMetronome,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _metronomeRunning
                                  ? l10n.strengthTimerTapStop
                                  : l10n.strengthTimerTapStartStop,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                color: cs.onSurface
                                    .withValues(alpha: 0.74),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _TempoFieldBlock(
                                    controller: _conController,
                                    label: l10n.strengthTempoConcentric,
                                    onChanged: _handleTempoChanged,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _TempoFieldBlock(
                                    controller: _holdTopController,
                                    label: l10n.strengthTempoStatic,
                                    onChanged: _handleTempoChanged,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _TempoFieldBlock(
                                    controller: _eccController,
                                    label: l10n.strengthTempoEccentric,
                                    onChanged: _handleTempoChanged,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _TempoFieldBlock(
                                    controller: _holdBottomController,
                                    label: 'Statisch',
                                    onChanged: _handleTempoChanged,
                                  ),
                                ),
                              ],
                            ),
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

  void startRestTimerFromInput() {
    final seconds =
        int.tryParse(_restController.text.trim())?.clamp(1, 7200) ?? 60;
    _startTimer(Duration(seconds: seconds));
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

    final shouldResume =
        _remaining > Duration.zero && _remaining < _total;
    if (shouldResume) {
      _resumeTimer();
      return;
    }

    final seconds =
        int.tryParse(_restController.text.trim())?.clamp(1, 7200) ??
            60;
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

    _timer = Timer.periodic(const Duration(milliseconds: 200),
            (timer) {
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
            if (sec >= 1 && sec <= 4) {
              _playWarningBeep();
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

    _timer = Timer.periodic(const Duration(milliseconds: 200),
            (timer) {
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
            if (sec >= 1 && sec <= 4) {
              _playWarningBeep();
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
    final seconds =
        int.tryParse(_restController.text.trim())?.clamp(1, 7200) ??
            60;
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

    final con = _phaseMs(_conController.text, 1500);
    final holdTop = _phaseMs(_holdTopController.text, 0);
    final ecc = _phaseMs(_eccController.text, 1500);
    final holdBottom = _phaseMs(_holdBottomController.text, 0);

    _metronomeCycleMs = math.max(1, con + holdTop + ecc + holdBottom);

    setState(() {
      _metronomeRunning = true;
      _metronomeElapsed = Duration.zero;
    });

    unawaited(
      _soundService.metronomeStartLoop(
        concentricMs: con,
        holdTopMs: holdTop,
        eccentricMs: ecc,
        holdBottomMs: holdBottom,
      ),
    );

    _metronomeTicker.start();
  }

  void _stopMetronome() {
    _metronomeTicker.stop();
    _metronomeFrameRequestInFlight = false;

    unawaited(_soundService.metronomeStopLoop());

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
    unawaited(_soundService.timerBeep());
  }

  void _playDoneAlert() {
    unawaited(_soundService.timerDone());
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
    final danger =
        remaining.inMilliseconds <= dangerThresholdSec * 1000;
    final elapsedFactor = total.inMilliseconds <= 0
        ? 1.0
        : ((total.inMilliseconds - remaining.inMilliseconds) /
        total.inMilliseconds)
        .clamp(0.0, 1.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size.square(96),
                painter: _TimerDialPainter(
                  progress: elapsedFactor,
                  danger: danger,
                  color: const Color(0xFF3B82F6),
                  trackColor: const Color(0xFFE5E7EB),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(remaining.inMilliseconds / 1000).ceil().clamp(0, 9999)}',
                    style:
                    Theme.of(context).textTheme.headlineLarge?.copyWith(
                      height: 1.0,
                      color: danger
                          ? Colors.redAccent
                          : Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Icon(
                    running ? Icons.pause : Icons.play_arrow,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
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
    const stroke = 10.0;
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
    final cycle =
    math.max(1, concentricMs + holdTopMs + eccentricMs + holdBottomMs);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        painter: _MetronomeMazePainter(
          playbackPosMs: elapsed.inMilliseconds % cycle,
          concentricMs: concentricMs,
          holdTopMs: holdTopMs,
          eccentricMs: eccentricMs,
          holdBottomMs: holdBottomMs,
          running: running,
          lineColor: const Color(0xFFE5E7EB),
          ballColor: const Color(0xFF3B82F6),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _MetronomeMazePainter extends CustomPainter {
  const _MetronomeMazePainter({
    required this.playbackPosMs,
    required this.concentricMs,
    required this.holdTopMs,
    required this.eccentricMs,
    required this.holdBottomMs,
    required this.running,
    required this.lineColor,
    required this.ballColor,
  });

  final int playbackPosMs;
  final int concentricMs;
  final int holdTopMs;
  final int eccentricMs;
  final int holdBottomMs;
  final bool running;
  final Color lineColor;
  final Color ballColor;

  @override
  void paint(Canvas canvas, Size size) {
    final phases = <_MazePhase>[
      _MazePhase(_MazeKind.concentric, math.max(0, concentricMs)),
      _MazePhase(_MazeKind.holdTop, math.max(0, holdTopMs)),
      _MazePhase(_MazeKind.eccentric, math.max(0, eccentricMs)),
      _MazePhase(_MazeKind.holdBottom, math.max(0, holdBottomMs)),
    ].where((p) => p.ms > 0).toList();

    if (phases.isEmpty) {
      phases.add(const _MazePhase(_MazeKind.concentric, 1));
    }

    final cycleMs =
    phases.fold<int>(0, (sum, p) => sum + p.ms).clamp(1, 1000000);

    final pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 12
      ..color = lineColor;

    final ballPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = running ? ballColor : ballColor.withValues(alpha: 0.55);

    const ballRadius = 6.0;
    const extraInset = 1.0;
    const startXShift = 12.0;

    final safe =
        math.max(ballRadius, pathPaint.strokeWidth * 0.5) + extraInset;
    final xStartBase = safe;
    final xEnd = size.width - safe;
    final cycleW = (xEnd - xStartBase).clamp(1.0, double.infinity);
    final xBall = math.min(
      xStartBase + startXShift,
      xEnd - ballRadius - pathPaint.strokeWidth * 0.5,
    );

    final yTop = safe;
    final yBottom = math.max(size.height - safe, yTop + 1);

    final offsetPx = (playbackPosMs / cycleMs) * cycleW;

    Path buildCyclePath(double x0) {
      final path = Path();
      var x = x0;
      path.moveTo(x, yBottom);

      for (final ph in phases) {
        final segW = (ph.ms / cycleMs) * cycleW;
        switch (ph.kind) {
          case _MazeKind.concentric:
            path.lineTo(x + segW, yTop);
            break;
          case _MazeKind.holdTop:
            path.lineTo(x + segW, yTop);
            break;
          case _MazeKind.eccentric:
            path.lineTo(x + segW, yBottom);
            break;
          case _MazeKind.holdBottom:
            path.lineTo(x + segW, yBottom);
            break;
        }
        x += segW;
      }
      return path;
    }

    final baseX = xBall - offsetPx;
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(buildCyclePath(baseX - cycleW), pathPaint);
    canvas.drawPath(buildCyclePath(baseX), pathPaint);
    canvas.drawPath(buildCyclePath(baseX + cycleW), pathPaint);
    canvas.restore();

    double yForTime(double tMs) {
      var acc = 0.0;
      for (final ph in phases) {
        final dur = ph.ms.toDouble();
        final next = acc + dur;
        if (tMs <= next || ph == phases.last) {
          final u =
          dur <= 0 ? 0.0 : ((tMs - acc) / dur).clamp(0.0, 1.0);
          switch (ph.kind) {
            case _MazeKind.concentric:
              return yBottom + (yTop - yBottom) * u;
            case _MazeKind.holdTop:
              return yTop;
            case _MazeKind.eccentric:
              return yTop + (yBottom - yTop) * u;
            case _MazeKind.holdBottom:
              return yBottom;
          }
        }
        acc = next;
      }
      return yBottom;
    }

    final yBall = yForTime(playbackPosMs.toDouble());
    canvas.drawCircle(Offset(xBall, yBall), ballRadius, ballPaint);
  }

  @override
  bool shouldRepaint(covariant _MetronomeMazePainter oldDelegate) {
    return oldDelegate.playbackPosMs != playbackPosMs ||
        oldDelegate.concentricMs != concentricMs ||
        oldDelegate.holdTopMs != holdTopMs ||
        oldDelegate.eccentricMs != eccentricMs ||
        oldDelegate.holdBottomMs != holdBottomMs ||
        oldDelegate.running != running ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.ballColor != ballColor;
  }
}

enum _MazeKind { concentric, holdTop, eccentric, holdBottom }

class _MazePhase {
  const _MazePhase(this.kind, this.ms);

  final _MazeKind kind;
  final int ms;
}

class _TempoFieldBlock extends StatefulWidget {
  const _TempoFieldBlock({
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  State<_TempoFieldBlock> createState() => _TempoFieldBlockState();
}

class _TempoFieldBlockState extends State<_TempoFieldBlock> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleStateChanged);
    widget.controller.addListener(_handleStateChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleStateChanged);
    _focusNode.removeListener(_handleStateChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final hasValue = widget.controller.text.trim().isNotEmpty;
    final underlineWidth = hasValue || _focusNode.hasFocus ? 1.4 : 1.0;
    final underlineColor = onSurface.withValues(
      alpha: hasValue || _focusNode.hasFocus ? 0.68 : 0.42,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            textAlign: TextAlign.center,
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            style: theme.textTheme.titleMedium?.copyWith(
              height: 1.0,
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding:
              EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              border: InputBorder.none,
            ),
            onChanged: widget.onChanged,
          ),
        ),
        Container(
          height: underlineWidth,
          color: underlineColor,
        ),
        const SizedBox(height: 3),
        SizedBox(
          height: 13,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              widget.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: theme.textTheme.bodySmall,
            ),
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
  editPlan,
  printPlanPdf,
  loadPlan,
  renamePlan,
  deletePlan,
  addExercise,
}