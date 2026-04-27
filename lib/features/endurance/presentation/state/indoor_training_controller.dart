import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/endurance_session.dart';
import '../../domain/models/endurance_sport.dart';
import '../../domain/models/indoor_interval_phase.dart';
import '../../domain/models/indoor_interval_protocol.dart';
import '../../domain/services/indoor_settings_codec.dart';
import 'endurance_repository_provider.dart';

class IndoorTrainingArgs {
  const IndoorTrainingArgs({
    required this.sport,
    this.sessionId,
  });

  final EnduranceSport sport;
  final int? sessionId;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is IndoorTrainingArgs &&
            other.sport.code == sport.code &&
            other.sessionId == sessionId;
  }

  @override
  int get hashCode => Object.hash(
    sport.code,
    sessionId,
  );
}

class IndoorTrainingState {
  const IndoorTrainingState({
    required this.sport,
    required this.protocol,
    required this.elapsedMs,
    required this.isBusy,
    required this.selectedPhaseIndex,
    this.session,
    this.errorMessage,
  });

  final EnduranceSport sport;
  final IndoorIntervalProtocol protocol;
  final int elapsedMs;
  final bool isBusy;
  final int selectedPhaseIndex;
  final EnduranceSession? session;
  final String? errorMessage;

  bool get isActive => session != null;

  int? get sessionId => session?.id;

  IndoorTrainingState copyWith({
    IndoorIntervalProtocol? protocol,
    int? elapsedMs,
    bool? isBusy,
    int? selectedPhaseIndex,
    EnduranceSession? session,
    bool clearSession = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return IndoorTrainingState(
      sport: sport,
      protocol: protocol ?? this.protocol,
      elapsedMs: elapsedMs ?? this.elapsedMs,
      isBusy: isBusy ?? this.isBusy,
      selectedPhaseIndex: selectedPhaseIndex ?? this.selectedPhaseIndex,
      session: clearSession ? null : session ?? this.session,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  static IndoorTrainingState initial(EnduranceSport sport) {
    return IndoorTrainingState(
      sport: sport,
      protocol: IndoorIntervalProtocol.defaultForSportCode(sport.code),
      elapsedMs: 0,
      isBusy: false,
      selectedPhaseIndex: 0,
    );
  }
}

final indoorTrainingControllerProvider = NotifierProvider.autoDispose.family<
    IndoorTrainingController,
    IndoorTrainingState,
    IndoorTrainingArgs>(
  IndoorTrainingController.new,
);

class IndoorTrainingController extends Notifier<IndoorTrainingState> {
  IndoorTrainingController(this._args);

  final IndoorTrainingArgs _args;

  Timer? _ticker;
  bool _restoreStarted = false;

  @override
  IndoorTrainingState build() {
    ref.onDispose(_stopTicker);

    final initialState = IndoorTrainingState.initial(_args.sport);

    if (!_restoreStarted) {
      _restoreStarted = true;

      Future<void>.microtask(() async {
        await restoreIfNeeded();
      });
    }

    return initialState;
  }

  Future<void> restoreIfNeeded() async {
    final requestedSessionId = _args.sessionId;
    if (requestedSessionId == null) {
      return;
    }

    state = state.copyWith(
      isBusy: true,
      clearError: true,
    );

    try {
      final repository = ref.read(enduranceRepositoryProvider);
      final activeSession = await repository.getActiveSession();

      if (activeSession == null || activeSession.id != requestedSessionId) {
        state = state.copyWith(
          isBusy: false,
          clearSession: true,
        );
        return;
      }

      final restoredProtocol = _protocolFromSession(activeSession);

      state = state.copyWith(
        session: activeSession,
        protocol: restoredProtocol,
        elapsedMs: _elapsedFor(activeSession),
        isBusy: false,
        clearError: true,
      );

      _startTicker();
    } catch (error) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> startSession() async {
    if (state.isActive || state.isBusy) {
      return;
    }

    state = state.copyWith(
      isBusy: true,
      clearError: true,
    );

    try {
      final repository = ref.read(enduranceRepositoryProvider);
      final now = DateTime.now().millisecondsSinceEpoch;

      final indoorSettingsJson = IndoorSettingsCodec.encode(
        protocol: state.protocol,
        sportCode: state.sport.code,
      );

      final sessionId = await repository.createSession(
        sport: state.sport.code,
        startEpochMs: now,
        indoorSettingsJson: indoorSettingsJson,
      );

      final session = EnduranceSession(
        id: sessionId,
        startEpochMs: now,
        endEpochMs: null,
        totalDistanceM: 0.0,
        totalDurationMs: 0,
        avgHr: null,
        maxHr: null,
        elevGainM: null,
        notes: null,
        sport: state.sport.code,
        indoorSettingsJson: indoorSettingsJson,
        rpe0to10: null,
        timeZ1s: 0,
        timeZ2s: 0,
        timeZ3s: 0,
        timeZ4s: 0,
        timeZ5s: 0,
        hrZoneMethod: null,
        hrMaxUsed: null,
        hrRestUsed: null,
        hrZoneBoundsJson: null,
      );

      state = state.copyWith(
        session: session,
        elapsedMs: 0,
        isBusy: false,
        clearError: true,
      );

      _startTicker();
    } catch (error) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> discardSession() async {
    final sessionId = state.sessionId;
    if (sessionId == null || state.isBusy) {
      return;
    }

    state = state.copyWith(
      isBusy: true,
      clearError: true,
    );

    try {
      final repository = ref.read(enduranceRepositoryProvider);
      await repository.discardSession(sessionId);

      _stopTicker();

      state = state.copyWith(
        elapsedMs: 0,
        isBusy: false,
        clearSession: true,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> finishSession({
    required int? rpe0to10,
    required String? notes,
  }) async {
    final session = state.session;
    if (session == null || state.isBusy) {
      return;
    }

    state = state.copyWith(
      isBusy: true,
      clearError: true,
    );

    try {
      final repository = ref.read(enduranceRepositoryProvider);
      final now = DateTime.now().millisecondsSinceEpoch;
      final durationMs = (now - session.startEpochMs).clamp(0, 1 << 53).toInt();

      await repository.finalizeSession(
        sessionId: session.id,
        endEpochMs: now,
        durationMs: durationMs,
        distanceM: 0.0,
        avgHr: null,
        maxHr: null,
        elevationGainM: null,
      );

      await repository.updateRpe(
        sessionId: session.id,
        rpe0to10: rpe0to10,
      );

      final cleanedNotes = notes?.trim();
      await repository.updateNotes(
        sessionId: session.id,
        notes: cleanedNotes == null || cleanedNotes.isEmpty
            ? null
            : cleanedNotes,
      );

      _stopTicker();

      state = state.copyWith(
        elapsedMs: durationMs,
        isBusy: false,
        clearSession: true,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: error.toString(),
      );
    }
  }

  void selectPhase(int index) {
    if (index < 0 || index >= state.protocol.phases.length) {
      return;
    }

    state = state.copyWith(
      selectedPhaseIndex: index,
      clearError: true,
    );
  }

  Future<void> addDefaultPhase() async {
    final phases = [...state.protocol.phases];
    final previous = phases.isEmpty ? null : phases.last;

    phases.add(
      IndoorIntervalPhase(
        durSec: previous?.durSec ?? 120,
        intensity: previous?.intensity ?? 100,
        extra: previous?.extra ?? const <String, double>{},
      ),
    );

    final nextProtocol = IndoorIntervalProtocol(
      axisKey: state.protocol.axisKey,
      protocolName: state.protocol.protocolName,
      phases: phases,
    );

    state = state.copyWith(
      selectedPhaseIndex: phases.length - 1,
    );

    await persistProtocol(nextProtocol);
  }

  Future<void> deleteSelectedPhase() async {
    final index = state.selectedPhaseIndex;
    final phases = [...state.protocol.phases];

    if (phases.length <= 1 || index < 0 || index >= phases.length) {
      return;
    }

    phases.removeAt(index);

    final nextIndex = index.clamp(0, phases.length - 1);

    final nextProtocol = IndoorIntervalProtocol(
      axisKey: state.protocol.axisKey,
      protocolName: state.protocol.protocolName,
      phases: phases,
    );

    state = state.copyWith(
      selectedPhaseIndex: nextIndex,
    );

    await persistProtocol(nextProtocol);
  }

  Future<void> updateSelectedPhase({
    int? durSec,
    double? intensity,
    Map<String, double>? extra,
  }) async {
    final index = state.selectedPhaseIndex;
    final phases = [...state.protocol.phases];

    if (index < 0 || index >= phases.length) {
      return;
    }

    phases[index] = phases[index].copyWith(
      durSec: durSec,
      intensity: intensity,
      extra: extra,
    );

    final nextProtocol = IndoorIntervalProtocol(
      axisKey: state.protocol.axisKey,
      protocolName: state.protocol.protocolName,
      phases: phases,
    );

    await persistProtocol(nextProtocol);
  }

  Future<void> persistProtocol(IndoorIntervalProtocol protocol) async {
    final sessionId = state.sessionId;

    state = state.copyWith(
      protocol: protocol,
      clearError: true,
    );

    if (sessionId == null) {
      return;
    }

    try {
      final repository = ref.read(enduranceRepositoryProvider);
      final json = IndoorSettingsCodec.encode(
        protocol: protocol,
        sportCode: state.sport.code,
      );

      await repository.updateIndoorSettings(
        sessionId: sessionId,
        json: json,
      );
    } catch (error) {
      state = state.copyWith(
        errorMessage: error.toString(),
      );
    }
  }

  IndoorIntervalProtocol _protocolFromSession(EnduranceSession session) {
    final json = session.indoorSettingsJson;

    if (json == null || json.trim().isEmpty) {
      return IndoorIntervalProtocol.defaultForSportCode(state.sport.code);
    }

    return IndoorSettingsCodec.decode(
      json: json,
      sportCode: state.sport.code,
    );
  }

  int _elapsedFor(EnduranceSession session) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - session.startEpochMs).clamp(0, 1 << 53).toInt();
  }

  void _startTicker() {
    _ticker?.cancel();

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final session = state.session;
      if (session == null) {
        return;
      }

      state = state.copyWith(
        elapsedMs: _elapsedFor(session),
      );
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }
}