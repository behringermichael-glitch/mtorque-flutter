import 'set_entry.dart';

enum StrengthHostView {
  planGrid,
  pager,
}

class StrengthFlowState {
  final bool isLoading;
  final StrengthHostView hostView;
  final StrengthDraftSession? draftSession;
  final List<StrengthPlanSummary> plans;
  final List<String>? loadedPlanBaselineIds;
  final bool keepPagerForEmptyQuickstart;
  final int pagerIndex;
  final int? activeDbSessionId;
  final DateTime? activeDbSessionStart;
  final String? selectedPlanName;

  const StrengthFlowState({
    required this.isLoading,
    required this.hostView,
    required this.draftSession,
    required this.plans,
    required this.loadedPlanBaselineIds,
    required this.keepPagerForEmptyQuickstart,
    required this.pagerIndex,
    required this.activeDbSessionId,
    required this.activeDbSessionStart,
    required this.selectedPlanName,
  });

  factory StrengthFlowState.initial() {
    return const StrengthFlowState(
      isLoading: true,
      hostView: StrengthHostView.planGrid,
      draftSession: null,
      plans: [],
      loadedPlanBaselineIds: null,
      keepPagerForEmptyQuickstart: false,
      pagerIndex: 0,
      activeDbSessionId: null,
      activeDbSessionStart: null,
      selectedPlanName: null,
    );
  }

  StrengthFlowState copyWith({
    bool? isLoading,
    StrengthHostView? hostView,
    Object? draftSession = _sentinel,
    List<StrengthPlanSummary>? plans,
    Object? loadedPlanBaselineIds = _sentinel,
    bool? keepPagerForEmptyQuickstart,
    int? pagerIndex,
    Object? activeDbSessionId = _sentinel,
    Object? activeDbSessionStart = _sentinel,
    Object? selectedPlanName = _sentinel,
  }) {
    return StrengthFlowState(
      isLoading: isLoading ?? this.isLoading,
      hostView: hostView ?? this.hostView,
      draftSession: identical(draftSession, _sentinel)
          ? this.draftSession
          : draftSession as StrengthDraftSession?,
      plans: plans ?? this.plans,
      loadedPlanBaselineIds: identical(loadedPlanBaselineIds, _sentinel)
          ? this.loadedPlanBaselineIds
          : loadedPlanBaselineIds as List<String>?,
      keepPagerForEmptyQuickstart:
      keepPagerForEmptyQuickstart ?? this.keepPagerForEmptyQuickstart,
      pagerIndex: pagerIndex ?? this.pagerIndex,
      activeDbSessionId: identical(activeDbSessionId, _sentinel)
          ? this.activeDbSessionId
          : activeDbSessionId as int?,
      activeDbSessionStart: identical(activeDbSessionStart, _sentinel)
          ? this.activeDbSessionStart
          : activeDbSessionStart as DateTime?,
      selectedPlanName: identical(selectedPlanName, _sentinel)
          ? this.selectedPlanName
          : selectedPlanName as String?,
    );
  }

  static const _sentinel = Object();
}