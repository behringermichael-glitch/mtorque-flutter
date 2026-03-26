import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/strength_flow_state.dart';
import '../../domain/repositories/strength_repository.dart';
import 'strength_providers.dart';

class StrengthFlowController extends Notifier<StrengthFlowState> {
  StrengthRepository get _repository => ref.read(strengthRepositoryProvider);

  @override
  StrengthFlowState build() {
    Future.microtask(load);
    return const StrengthFlowState.initial();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true);

    final overview = await _repository.loadOverview();

    state = StrengthFlowState(
      isLoading: false,
      hasOpenSession: overview.hasOpenSession,
      openSessionId: overview.openSessionId,
      openSessionStartEpochMs: overview.openSessionStartEpochMs,
      openSessionSetCount: overview.openSessionSetCount,
      openSessionExerciseCount: overview.openSessionExerciseCount,
      finishedSessionCount: overview.finishedSessionCount,
      lastFinishedSessionEndEpochMs: overview.lastFinishedSessionEndEpochMs,
    );
  }

  Future<void> finalizeOpenSession() async {
    final sessionId = state.openSessionId;
    if (sessionId == null) {
      return;
    }

    await _repository.finalizeOpenSession(sessionId: sessionId);
    await load();
  }
}