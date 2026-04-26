import 'package:flutter_riverpod/legacy.dart';

import '../../domain/models/set_entry.dart';
import '../../domain/models/strength_flow_state.dart';
import '../../domain/repositories/strength_repository.dart';
import '../../domain/services/strength_plan_editor_service.dart';

class StrengthFlowController extends StateNotifier<StrengthFlowState> {
  StrengthFlowController(this._repository) : super(StrengthFlowState.initial());

  final StrengthRepository _repository;

  Future<void> initialize() async {
    final plans = await _repository.listPlanSummaries();
    final storedDbSessionId = await _repository.getStoredActiveDbSessionId();
    final restoredDraft = await _repository.loadDraftSession();

    DateTime? storedStart;
    if (storedDbSessionId != null) {
      storedStart = await _repository.getStrengthSessionStart(storedDbSessionId);
    }

    state = state.copyWith(
      isLoading: false,
      plans: plans,
      draftSession: restoredDraft,
      activeDbSessionId: storedDbSessionId,
      activeDbSessionStart: storedStart,
      hostView: _deriveInitialView(restoredDraft),
    );
  }

  StrengthHostView _deriveInitialView(StrengthDraftSession? draft) {
    if (draft == null) return StrengthHostView.planGrid;
    if (draft.hasExercises) return StrengthHostView.pager;
    return StrengthHostView.planGrid;
  }

  Future<void> refreshPlans() async {
    final plans = await _repository.listPlanSummaries();
    state = state.copyWith(plans: plans);
  }

  Future<void> startEmptySession({
    required int todayEpochDay,
  }) async {
    final session = StrengthDraftSession.empty(dateEpochDay: todayEpochDay);
    await _repository.saveDraftSession(session);

    state = state.copyWith(
      draftSession: session,
      hostView: StrengthHostView.pager,
      keepPagerForEmptyQuickstart: true,
      loadedPlanBaselineIds: null,
      pagerIndex: 0,
      selectedPlanName: state.selectedPlanName,
      activeDbSessionId: null,
      activeDbSessionStart: null,
    );
  }

  Future<void> loadPlan({
    required String planName,
    required int todayEpochDay,
  }) async {
    final ids = await _repository.loadPlanExerciseIds(planName);
    if (ids == null || ids.isEmpty) return;

    final session = StrengthDraftSession(
      dateEpochDay: todayEpochDay,
      exerciseOrder: ids,
      setsByExercise: {
        for (final id in ids) id: const <SetEntry>[],
      },
      supersetGroupByExercise: const {},
    );

    await _repository.saveDraftSession(session);
    await _repository.setStoredActiveDbSessionId(null);

    state = state.copyWith(
      draftSession: session,
      hostView: StrengthHostView.pager,
      loadedPlanBaselineIds: List<String>.from(ids),
      keepPagerForEmptyQuickstart: false,
      pagerIndex: 0,
      selectedPlanName: planName,
      activeDbSessionId: null,
      activeDbSessionStart: null,
    );
  }

  Future<void> savePlanFromCurrent({
    required String planName,
    required bool overwrite,
  }) async {
    final draft = state.draftSession;
    if (draft == null || draft.exerciseOrder.isEmpty) return;

    final ok = await _repository.savePlan(
      name: planName,
      exerciseIds: draft.exerciseOrder,
      overwrite: overwrite,
    );
    if (!ok) return;

    await refreshPlans();
    state = state.copyWith(selectedPlanName: planName);
  }

  Future<void> deletePlan(String name) async {
    final ok = await _repository.deletePlan(name);
    if (!ok) return;
    await refreshPlans();

    if (state.selectedPlanName == name) {
      state = state.copyWith(selectedPlanName: null);
    }
  }

  Future<void> updatePagerIndex(int index) async {
    state = state.copyWith(pagerIndex: index);
  }

  Future<void> updateDraftDate(DateTime selectedDate) async {
    final draft = state.draftSession;
    if (draft == null) return;

    final utcMidnight = DateTime.utc(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final epochDay = utcMidnight.millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;

    final updated = draft.copyWith(dateEpochDay: epochDay);
    await _repository.saveDraftSession(updated);
    state = state.copyWith(draftSession: updated);
  }

  Future<void> renamePlan({
    required String oldName,
    required String newName,
    required bool overwrite,
  }) async {
    final ok = await _repository.renamePlan(
      oldName: oldName,
      newName: newName,
      overwrite: overwrite,
    );
    if (!ok) return;
    await refreshPlans();
    if (state.selectedPlanName == oldName) {
      state = state.copyWith(selectedPlanName: newName);
    }
  }

  Future<void> addExercises(List<StrengthExerciseSummary> exercises) async {
    final draft = state.draftSession;
    if (draft == null) return;

    final nextOrder = List<String>.from(draft.exerciseOrder);
    final nextSets = <String, List<SetEntry>>{
      ...draft.setsByExercise,
    };

    for (final exercise in exercises) {
      if (!nextOrder.contains(exercise.id)) {
        nextOrder.add(exercise.id);
      }
      nextSets.putIfAbsent(exercise.id, () => const <SetEntry>[]);
    }

    final updated = draft.copyWith(
      exerciseOrder: nextOrder,
      setsByExercise: nextSets,
    );

    await _repository.saveDraftSession(updated);

    state = state.copyWith(
      draftSession: updated,
      hostView: StrengthHostView.pager,
      pagerIndex: nextOrder.isEmpty ? 0 : nextOrder.length - 1,
    );
  }

  Future<void> removeExercise(String exerciseId) async {
    final draft = state.draftSession;
    if (draft == null) return;

    final nextOrder =
    draft.exerciseOrder.where((e) => e != exerciseId).toList();
    final nextSets = <String, List<SetEntry>>{
      ...draft.setsByExercise,
    }..remove(exerciseId);
    final nextSupersets = <String, String>{
      ...draft.supersetGroupByExercise,
    }..remove(exerciseId);

    final updated = draft.copyWith(
      exerciseOrder: nextOrder,
      setsByExercise: nextSets,
      supersetGroupByExercise: nextSupersets,
    );

    await _repository.saveDraftSession(updated);

    state = state.copyWith(
      draftSession: updated,
      hostView:
      nextOrder.isEmpty ? StrengthHostView.planGrid : StrengthHostView.pager,
      pagerIndex:
      nextOrder.isEmpty ? 0 : state.pagerIndex.clamp(0, nextOrder.length - 1),
    );
  }

  Future<void> applyPlanStructureEdit({
    required List<String> exerciseOrder,
    required Map<String, String> supersetGroupByExercise,
  }) async {
    final draft = state.draftSession;
    if (draft == null) return;

    final service = const StrengthPlanEditorService();

    final cleanedOrder = <String>[];
    for (final exerciseId in exerciseOrder) {
      final trimmed = exerciseId.trim();
      if (trimmed.isEmpty) continue;
      if (cleanedOrder.contains(trimmed)) continue;
      if (!draft.exerciseOrder.contains(trimmed)) continue;
      cleanedOrder.add(trimmed);
    }

    for (final exerciseId in draft.exerciseOrder) {
      if (!cleanedOrder.contains(exerciseId)) {
        cleanedOrder.add(exerciseId);
      }
    }

    final cleanedSets = <String, List<SetEntry>>{};
    for (final exerciseId in cleanedOrder) {
      cleanedSets[exerciseId] =
          draft.setsByExercise[exerciseId] ?? const <SetEntry>[];
    }

    final cleanedSupersets = service.normalizeSupersets(
      exerciseOrder: cleanedOrder,
      supersetGroupByExercise: supersetGroupByExercise,
    );

    final updated = draft.copyWith(
      exerciseOrder: cleanedOrder,
      setsByExercise: cleanedSets,
      supersetGroupByExercise: cleanedSupersets,
    );

    await _repository.saveDraftSession(updated);

    final maxIndex = cleanedOrder.isEmpty ? 0 : cleanedOrder.length - 1;

    state = state.copyWith(
      draftSession: updated,
      hostView:
      cleanedOrder.isEmpty ? StrengthHostView.planGrid : StrengthHostView.pager,
      loadedPlanBaselineIds: state.loadedPlanBaselineIds == null
          ? null
          : List<String>.from(cleanedOrder),
      keepPagerForEmptyQuickstart: cleanedOrder.isEmpty,
      pagerIndex: state.pagerIndex.clamp(0, maxIndex),
    );
  }

  Future<void> replaceExerciseSets({
    required String exerciseId,
    required List<SetEntry> sets,
  }) async {
    final draft = state.draftSession;
    if (draft == null) return;

    final updated = draft.copyWith(
      setsByExercise: {
        ...draft.setsByExercise,
        exerciseId: sets,
      },
    );

    await _repository.saveDraftSession(updated);
    state = state.copyWith(draftSession: updated);
  }

  Future<int?> syncExerciseToDbIfNeeded({
    required String exerciseId,
    required String exerciseName,
    required bool isStaticExercise,
  }) async {
    final draft = state.draftSession;
    if (draft == null) return null;

    final list = draft.setsByExercise[exerciseId] ?? const <SetEntry>[];

    final hasCompleteSet = list.any(
          (entry) => isStaticExercise
          ? entry.isCompleteStatic
          : entry.isCompleteDynamic,
    );

    if (!hasCompleteSet) {
      return state.activeDbSessionId;
    }

    final sessionId = await _repository.createStrengthSessionIfMissing();

    await _repository.replaceExerciseSetsForSession(
      sessionId: sessionId,
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      isStaticExercise: isStaticExercise,
      supersetGroupId: draft.supersetGroupByExercise[exerciseId],
      draftSets: list,
    );

    final startedAt = await _repository.getStrengthSessionStart(sessionId);

    state = state.copyWith(
      activeDbSessionId: sessionId,
      activeDbSessionStart: startedAt,
    );

    return sessionId;
  }

  Future<void> finalizeSession({
    required String? notes,
  }) async {
    final dbId = state.activeDbSessionId;
    if (dbId != null) {
      await _repository.finalizeStrengthSession(
        sessionId: dbId,
        notes: notes,
      );
    }

    await _repository.saveDraftSession(null);
    await refreshPlans();

    state = state.copyWith(
      hostView: StrengthHostView.planGrid,
      draftSession: null,
      loadedPlanBaselineIds: null,
      keepPagerForEmptyQuickstart: false,
      pagerIndex: 0,
      activeDbSessionId: null,
      activeDbSessionStart: null,
      selectedPlanName: state.selectedPlanName,
    );
  }

  Future<void> discardCurrentSession() async {
    final dbId = state.activeDbSessionId;
    if (dbId != null) {
      await _repository.deleteStrengthSessionCompletely(dbId);
    } else {
      await _repository.setStoredActiveDbSessionId(null);
    }

    await _repository.saveDraftSession(null);

    state = state.copyWith(
      hostView: StrengthHostView.planGrid,
      draftSession: null,
      loadedPlanBaselineIds: null,
      keepPagerForEmptyQuickstart: false,
      pagerIndex: 0,
      activeDbSessionId: null,
      activeDbSessionStart: null,
      selectedPlanName: null,
    );
  }

  Future<void> showPlanGrid() async {
    state = state.copyWith(hostView: StrengthHostView.planGrid);
  }
}