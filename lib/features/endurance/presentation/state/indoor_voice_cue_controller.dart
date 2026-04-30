import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/flutter_tts_endurance_voice_cue_service.dart';
import '../../domain/models/indoor_interval_protocol.dart';
import '../../domain/services/endurance_voice_cue_service.dart';
import 'indoor_training_controller.dart';

class IndoorVoiceCueSpeech {
  const IndoorVoiceCueSpeech({
    required this.languageTag,
    required this.endingIn,
    required this.watts,
    required this.kilometersPerHour,
    required this.percent,
    required this.level,
    required this.intensity,
    required this.countdownThree,
    required this.countdownTwo,
    required this.countdownOne,
  });

  final String languageTag;
  final String endingIn;
  final String watts;
  final String kilometersPerHour;
  final String percent;
  final String level;
  final String intensity;
  final String countdownThree;
  final String countdownTwo;
  final String countdownOne;

  String? unitForAxisKey(String axisKey) {
    switch (axisKey) {
      case 'powerW':
        return watts;
      case 'speedKmh':
        return kilometersPerHour;
      case 'inclinePct':
        return percent;
      case 'level':
        return level;
      case 'intensity':
        return intensity;
      default:
        return null;
    }
  }
}

class IndoorVoiceCueState {
  const IndoorVoiceCueState({
    required this.enabled,
  });

  final bool enabled;

  IndoorVoiceCueState copyWith({
    bool? enabled,
  }) {
    return IndoorVoiceCueState(
      enabled: enabled ?? this.enabled,
    );
  }

  static const initial = IndoorVoiceCueState(
    enabled: true,
  );
}

final enduranceVoiceCueServiceProvider =
Provider.autoDispose<EnduranceVoiceCueService>((ref) {
  final service = FlutterTtsEnduranceVoiceCueService();

  ref.onDispose(() {
    unawaited(service.dispose());
  });

  return service;
});

final indoorVoiceCueControllerProvider =
NotifierProvider.autoDispose<IndoorVoiceCueController, IndoorVoiceCueState>(
  IndoorVoiceCueController.new,
);

class IndoorVoiceCueController extends Notifier<IndoorVoiceCueState> {
  static const _prefsKey = 'endurance_indoor_voice_countdown_enabled';

  static const _headlineBeforeStartMs = 5000;
  static const _countdown3MsBeforeStart = 3000;
  static const _countdown2MsBeforeStart = 2000;
  static const _countdown1MsBeforeStart = 1000;
  static const _schedulerLeadMs = 5500;
  static const _headlineGuardBeforeCountdownMs = 250;

  Timer? _phaseTimer;
  Timer? _finalTimer;

  int _announcedNextPhaseIndex = -1;
  int _scheduledNextPhaseIndex = -1;
  bool _announcedFinalEnd = false;
  int? _scheduledFinalProtocolEndMs;
  bool _prefsLoaded = false;
  final Set<String> _spokenCueKeys = <String>{};

  @override
  IndoorVoiceCueState build() {
    ref.onDispose(_cancelTimersAndStop);

    if (!_prefsLoaded) {
      _prefsLoaded = true;
      Future<void>.microtask(_loadPrefs);
    }

    return IndoorVoiceCueState.initial;
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_prefsKey) ?? true;

    state = state.copyWith(enabled: enabled);

    if (enabled) {
      await ref.read(enduranceVoiceCueServiceProvider).initialize();
    }
  }

  Future<void> toggleEnabled() async {
    final next = !state.enabled;
    state = state.copyWith(enabled: next);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, next);

    final service = ref.read(enduranceVoiceCueServiceProvider);

    if (next) {
      await service.initialize();
    } else {
      _cancelTimers();
      await service.stop();
      _announcedNextPhaseIndex = -1;
      _scheduledNextPhaseIndex = -1;
      _announcedFinalEnd = false;
      _scheduledFinalProtocolEndMs = null;
      _spokenCueKeys.clear();
    }
  }

  void onIndoorStateChanged({
    required IndoorTrainingState indoorState,
    required IndoorVoiceCueSpeech speech,
  }) {
    if (!state.enabled || !indoorState.isRunning || indoorState.isPaused) {
      _cancelTimers();
      return;
    }

    final protocol = indoorState.protocol;
    if (protocol.phases.isEmpty) {
      return;
    }

    unawaited(
      ref.read(enduranceVoiceCueServiceProvider).setLanguage(
        speech.languageTag,
      ),
    );

    _maybeSpeakPhaseCueFromElapsed(
      protocol: protocol,
      elapsedMs: indoorState.elapsedMs,
      speech: speech,
    );

    _maybeSpeakFinalCueFromElapsed(
      protocol: protocol,
      elapsedMs: indoorState.elapsedMs,
      speech: speech,
    );
  }

  void _maybeSpeakPhaseCueFromElapsed({
    required IndoorIntervalProtocol protocol,
    required int elapsedMs,
    required IndoorVoiceCueSpeech speech,
  }) {
    final startsMs = _startsMs(protocol);
    final nextIdx = _findNextPhaseIndex(
      startsMs: startsMs,
      elapsedMs: elapsedMs,
    );

    if (nextIdx == null || nextIdx <= 0) {
      return;
    }

    final targetMs = startsMs[nextIdx];
    final remainingSecond = _remainingSecond(
      targetMs: targetMs,
      elapsedMs: elapsedMs,
    );

    if (remainingSecond == null) {
      return;
    }

    final phase = protocol.phases[nextIdx];

    if (remainingSecond == 5) {
      final headline = _headlinePhrase(
        axisKey: protocol.axisKey,
        intensity: phase.intensity,
        speech: speech,
      );

      _speakCueOnce(
        key: 'phase:$targetMs:headline',
        text: headline,
        flush: true,
      );
      return;
    }

    final countdownText = _countdownTextForSecond(
      remainingSecond: remainingSecond,
      speech: speech,
    );

    if (countdownText == null) {
      return;
    }

    _speakCueOnce(
      key: 'phase:$targetMs:$remainingSecond',
      text: '$countdownText.',
      flush: false,
    );
  }

  void _maybeSpeakFinalCueFromElapsed({
    required IndoorIntervalProtocol protocol,
    required int elapsedMs,
    required IndoorVoiceCueSpeech speech,
  }) {
    final targetMs = math.max(1, protocol.totalSec) * 1000;
    final remainingSecond = _remainingSecond(
      targetMs: targetMs,
      elapsedMs: elapsedMs,
    );

    if (remainingSecond == null) {
      return;
    }

    if (remainingSecond == 5) {
      _speakCueOnce(
        key: 'final:$targetMs:headline',
        text: speech.endingIn,
        flush: true,
      );
      return;
    }

    final countdownText = _countdownTextForSecond(
      remainingSecond: remainingSecond,
      speech: speech,
    );

    if (countdownText == null) {
      return;
    }

    _speakCueOnce(
      key: 'final:$targetMs:$remainingSecond',
      text: '$countdownText.',
      flush: false,
    );
  }

  int? _remainingSecond({
    required int targetMs,
    required int elapsedMs,
  }) {
    final remainingMs = targetMs - elapsedMs;

    if (remainingMs <= 0 || remainingMs > _headlineBeforeStartMs) {
      return null;
    }

    final remainingSecond = (remainingMs / 1000).ceil();

    if (remainingSecond == 5 ||
        remainingSecond == 3 ||
        remainingSecond == 2 ||
        remainingSecond == 1) {
      return remainingSecond;
    }

    return null;
  }

  String? _countdownTextForSecond({
    required int remainingSecond,
    required IndoorVoiceCueSpeech speech,
  }) {
    switch (remainingSecond) {
      case 3:
        return speech.countdownThree;
      case 2:
        return speech.countdownTwo;
      case 1:
        return speech.countdownOne;
      default:
        return null;
    }
  }

  void _speakCueOnce({
    required String key,
    required String text,
    required bool flush,
  }) {
    if (!_spokenCueKeys.add(key)) {
      return;
    }

    unawaited(
      ref.read(enduranceVoiceCueServiceProvider).speak(
        text,
        flush: flush,
      ),
    );
  }

  void reset() {
    _cancelTimers();
    _announcedNextPhaseIndex = -1;
    _scheduledNextPhaseIndex = -1;
    _announcedFinalEnd = false;
    _scheduledFinalProtocolEndMs = null;
    _spokenCueKeys.clear();
    unawaited(ref.read(enduranceVoiceCueServiceProvider).stop());
  }

  void _maybeTriggerPhaseCountdown({
    required IndoorIntervalProtocol protocol,
    required int elapsedMs,
    required IndoorVoiceCueSpeech speech,
  }) {
    final startsMs = _startsMs(protocol);
    final nextIdx = _findNextPhaseIndex(
      startsMs: startsMs,
      elapsedMs: elapsedMs,
    );

    if (nextIdx == null || nextIdx <= 0) {
      return;
    }

    final nextStartMs = startsMs[nextIdx];
    final remainingMs = nextStartMs - elapsedMs;

    if (remainingMs <= 0) {
      return;
    }

    if (_announcedNextPhaseIndex == nextIdx ||
        _scheduledNextPhaseIndex == nextIdx) {
      return;
    }

    _scheduledNextPhaseIndex = nextIdx;

    _startSplitCountdownForPhase(
      protocol: protocol,
      phaseIndex: nextIdx,
      remainingMs: remainingMs,
      speech: speech,
    );
  }

  void _maybeTriggerFinalEndCountdown({
    required IndoorIntervalProtocol protocol,
    required int elapsedMs,
    required IndoorVoiceCueSpeech speech,
  }) {
    final protocolEndMs = math.max(1, protocol.totalSec) * 1000;
    final remainingMs = protocolEndMs - elapsedMs;

    if (remainingMs <= 0) {
      return;
    }

    if (_announcedFinalEnd ||
        _scheduledFinalProtocolEndMs == protocolEndMs) {
      return;
    }

    _scheduledFinalProtocolEndMs = protocolEndMs;

    _finalTimer?.cancel();
    _finalTimer = _scheduleEvents(
      <_VoiceCueEvent>[
        ..._buildHeadlineAndCountdownEvents(
          remainingMs: remainingMs,
          headline: speech.endingIn,
          countdownThree: speech.countdownThree,
          countdownTwo: speech.countdownTwo,
          countdownOne: speech.countdownOne,
          onHeadlineSpoken: () {
            _announcedFinalEnd = true;
          },
        ),
      ],
    );
  }

  void _startSplitCountdownForPhase({
    required IndoorIntervalProtocol protocol,
    required int phaseIndex,
    required int remainingMs,
    required IndoorVoiceCueSpeech speech,
  }) {
    final phase = protocol.phases[phaseIndex];
    final headline = _headlinePhrase(
      axisKey: protocol.axisKey,
      intensity: phase.intensity,
      speech: speech,
    );

    _phaseTimer?.cancel();
    _phaseTimer = _scheduleEvents(
      _buildHeadlineAndCountdownEvents(
        remainingMs: remainingMs,
        headline: headline,
        countdownThree: speech.countdownThree,
        countdownTwo: speech.countdownTwo,
        countdownOne: speech.countdownOne,
        onHeadlineSpoken: () {
          _announcedNextPhaseIndex = phaseIndex;
        },
      ),
    );
  }

  List<_VoiceCueEvent> _buildHeadlineAndCountdownEvents({
    required int remainingMs,
    required String headline,
    required String countdownThree,
    required String countdownTwo,
    required String countdownOne,
    VoidCallback? onHeadlineSpoken,
  }) {
    final latestHeadlineMsBeforeStart =
        _countdown3MsBeforeStart + _headlineGuardBeforeCountdownMs;
    final canStillSpeakHeadline = remainingMs > latestHeadlineMsBeforeStart;

    final events = <_VoiceCueEvent>[];

    if (canStillSpeakHeadline) {
      final desiredDelay = remainingMs - _headlineBeforeStartMs;
      final latestAllowedDelay = remainingMs - latestHeadlineMsBeforeStart;
      final headlineDelay = desiredDelay
          .clamp(0, math.max(0, latestAllowedDelay))
          .toInt();

      events.add(
        _VoiceCueEvent(
          delayFromNowMs: headlineDelay,
          text: headline,
          flush: true,
          onSpoken: onHeadlineSpoken,
        ),
      );
    }

    final d3 = remainingMs - _countdown3MsBeforeStart;
    final d2 = remainingMs - _countdown2MsBeforeStart;
    final d1 = remainingMs - _countdown1MsBeforeStart;

    if (d3 >= 0) {
      events.add(
        const _VoiceCueEvent(delayFromNowMs: 0, text: '', flush: false)
            .copyWith(delayFromNowMs: d3, text: '$countdownThree.'),
      );
    }
    if (d2 >= 0) {
      events.add(
        const _VoiceCueEvent(delayFromNowMs: 0, text: '', flush: false)
            .copyWith(delayFromNowMs: d2, text: '$countdownTwo.'),
      );
    }
    if (d1 >= 0) {
      events.add(
        const _VoiceCueEvent(delayFromNowMs: 0, text: '', flush: false)
            .copyWith(delayFromNowMs: d1, text: '$countdownOne.'),
      );
    }

    events.sort((a, b) => a.delayFromNowMs.compareTo(b.delayFromNowMs));
    return events;
  }

  Timer? _scheduleEvents(List<_VoiceCueEvent> events) {
    if (events.isEmpty) {
      return null;
    }

    var index = 0;
    Timer? timer;

    void runNext() {
      if (!state.enabled || index >= events.length) {
        return;
      }

      final event = events[index];
      index++;

      event.onSpoken?.call();

      unawaited(
        ref.read(enduranceVoiceCueServiceProvider).speak(
          event.text,
          flush: event.flush,
        ),
      );

      if (index >= events.length) {
        return;
      }

      final nextEvent = events[index];
      final delayMs =
      math.max(0, nextEvent.delayFromNowMs - event.delayFromNowMs);

      timer = Timer(Duration(milliseconds: delayMs), runNext);
    }

    timer = Timer(Duration(milliseconds: events.first.delayFromNowMs), runNext);
    return timer;
  }

  String _headlinePhrase({
    required String axisKey,
    required double intensity,
    required IndoorVoiceCueSpeech speech,
  }) {
    final value = _formatIntensityForSpeech(
      axisKey: axisKey,
      value: intensity,
    );

    final unit = speech.unitForAxisKey(axisKey);
    if (unit == null || unit.trim().isEmpty) {
      return value;
    }

    return '$value $unit';
  }

  String _formatIntensityForSpeech({
    required String axisKey,
    required double value,
  }) {
    switch (axisKey) {
      case 'powerW':
      case 'level':
        return value.round().toString();
      case 'speedKmh':
      case 'inclinePct':
      case 'intensity':
      default:
        return value.toStringAsFixed(1);
    }
  }

  static List<int> _startsMs(IndoorIntervalProtocol protocol) {
    final starts = <int>[];
    var accMs = 0;

    for (final phase in protocol.phases) {
      starts.add(accMs);
      accMs += math.max(1, phase.durSec) * 1000;
    }

    return starts;
  }

  static int? _findNextPhaseIndex({
    required List<int> startsMs,
    required int elapsedMs,
  }) {
    for (var i = 1; i < startsMs.length; i++) {
      if (elapsedMs < startsMs[i]) {
        return i;
      }
    }

    return null;
  }

  void _cancelTimersAndStop() {
    _cancelTimers();
    unawaited(ref.read(enduranceVoiceCueServiceProvider).stop());
  }

  void _cancelTimers() {
    _phaseTimer?.cancel();
    _phaseTimer = null;
    _finalTimer?.cancel();
    _finalTimer = null;
  }
}

class _VoiceCueEvent {
  const _VoiceCueEvent({
    required this.delayFromNowMs,
    required this.text,
    required this.flush,
    this.onSpoken,
  });

  final int delayFromNowMs;
  final String text;
  final bool flush;
  final VoidCallback? onSpoken;

  _VoiceCueEvent copyWith({
    int? delayFromNowMs,
    String? text,
    bool? flush,
    VoidCallback? onSpoken,
  }) {
    return _VoiceCueEvent(
      delayFromNowMs: delayFromNowMs ?? this.delayFromNowMs,
      text: text ?? this.text,
      flush: flush ?? this.flush,
      onSpoken: onSpoken ?? this.onSpoken,
    );
  }
}