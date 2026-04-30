import 'package:flutter_tts/flutter_tts.dart';

import '../../domain/services/endurance_voice_cue_service.dart';

class FlutterTtsEnduranceVoiceCueService implements EnduranceVoiceCueService {
  final FlutterTts _tts = FlutterTts();

  bool _initialized = false;
  String? _languageTag;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await _tts.awaitSpeakCompletion(true);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _initialized = true;
  }

  @override
  Future<void> setLanguage(String languageTag) async {
    await initialize();

    if (_languageTag == languageTag) {
      return;
    }

    _languageTag = languageTag;

    try {
      await _tts.setLanguage(languageTag);
    } catch (_) {
      final lower = languageTag.toLowerCase();
      await _tts.setLanguage(lower.startsWith('de') ? 'de-DE' : 'en-US');
    }
  }

  @override
  Future<void> speak(
      String text, {
        required bool flush,
      }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    await initialize();

    if (flush) {
      await _tts.stop();
    }

    await _tts.speak(trimmed);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }

  @override
  Future<void> dispose() async {
    await stop();
  }
}