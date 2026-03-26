class StrengthOverview {
  const StrengthOverview({
    required this.hasOpenSession,
    required this.openSessionId,
    required this.openSessionStartEpochMs,
    required this.openSessionSetCount,
    required this.openSessionExerciseCount,
    required this.finishedSessionCount,
    required this.lastFinishedSessionEndEpochMs,
  });

  final bool hasOpenSession;
  final int? openSessionId;
  final int? openSessionStartEpochMs;
  final int openSessionSetCount;
  final int openSessionExerciseCount;
  final int finishedSessionCount;
  final int? lastFinishedSessionEndEpochMs;
}

abstract class StrengthRepository {
  Future<StrengthOverview> loadOverview();

  Future<void> finalizeOpenSession({
    required int sessionId,
    String? notes,
    int? endEpochMs,
  });
}