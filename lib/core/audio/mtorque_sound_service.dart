import 'package:flutter/services.dart';

class MtorqueSoundService {
  MtorqueSoundService._();

  static final MtorqueSoundService instance = MtorqueSoundService._();

  static const MethodChannel _channel = MethodChannel('mtorque/sound');

  Future<void> timerBeep() async {
    await _safeInvoke('timerBeep');
  }

  Future<void> timerDone() async {
    await _safeInvoke('timerDone');
  }

  Future<void> metronomeStartLoop({
    required int concentricMs,
    required int holdTopMs,
    required int eccentricMs,
    required int holdBottomMs,
  }) async {
    await _safeInvoke(
      'metronomeStartLoop',
      <String, Object?>{
        'concentricMs': concentricMs,
        'holdTopMs': holdTopMs,
        'eccentricMs': eccentricMs,
        'holdBottomMs': holdBottomMs,
      },
    );
  }

  Future<void> metronomeStopLoop() async {
    await _safeInvoke('metronomeStopLoop');
  }

  Future<int> getMetronomePositionMs() async {
    try {
      final value = await _channel.invokeMethod<int>('getMetronomePositionMs');
      return value ?? 0;
    } on MissingPluginException {
      return 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> _safeInvoke(
      String method, [
        Map<String, Object?>? arguments,
      ]) async {
    try {
      await _channel.invokeMethod(method, arguments);
    } on MissingPluginException {
      // no-op
    } catch (_) {
      // no-op
    }
  }
}