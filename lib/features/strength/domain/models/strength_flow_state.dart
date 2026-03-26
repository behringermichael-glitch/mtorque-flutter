class StrengthFlowState {
  const StrengthFlowState({
    required this.isLoading,
    required this.hasOpenSession,
    required this.openSessionId,
    required this.openSessionStartEpochMs,
    required this.openSessionSetCount,
    required this.openSessionExerciseCount,
    required this.finishedSessionCount,
    required this.lastFinishedSessionEndEpochMs,
  });

  const StrengthFlowState.initial()
      : isLoading = true,
        hasOpenSession = false,
        openSessionId = null,
        openSessionStartEpochMs = null,
        openSessionSetCount = 0,
        openSessionExerciseCount = 0,
        finishedSessionCount = 0,
        lastFinishedSessionEndEpochMs = null;

  final bool isLoading;
  final bool hasOpenSession;
  final int? openSessionId;
  final int? openSessionStartEpochMs;
  final int openSessionSetCount;
  final int openSessionExerciseCount;
  final int finishedSessionCount;
  final int? lastFinishedSessionEndEpochMs;

  StrengthFlowState copyWith({
    bool? isLoading,
    bool? hasOpenSession,
    int? openSessionId,
    int? openSessionStartEpochMs,
    int? openSessionSetCount,
    int? openSessionExerciseCount,
    int? finishedSessionCount,
    int? lastFinishedSessionEndEpochMs,
    bool clearOpenSessionId = false,
    bool clearOpenSessionStartEpochMs = false,
    bool clearLastFinishedSessionEndEpochMs = false,
  }) {
    return StrengthFlowState(
      isLoading: isLoading ?? this.isLoading,
      hasOpenSession: hasOpenSession ?? this.hasOpenSession,
      openSessionId:
      clearOpenSessionId ? null : (openSessionId ?? this.openSessionId),
      openSessionStartEpochMs: clearOpenSessionStartEpochMs
          ? null
          : (openSessionStartEpochMs ?? this.openSessionStartEpochMs),
      openSessionSetCount: openSessionSetCount ?? this.openSessionSetCount,
      openSessionExerciseCount:
      openSessionExerciseCount ?? this.openSessionExerciseCount,
      finishedSessionCount: finishedSessionCount ?? this.finishedSessionCount,
      lastFinishedSessionEndEpochMs: clearLastFinishedSessionEndEpochMs
          ? null
          : (lastFinishedSessionEndEpochMs ?? this.lastFinishedSessionEndEpochMs),
    );
  }
}