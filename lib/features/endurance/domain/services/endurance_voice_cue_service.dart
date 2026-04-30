abstract interface class EnduranceVoiceCueService {
  Future<void> initialize();

  Future<void> setLanguage(String languageTag);

  Future<void> speak(
      String text, {
        required bool flush,
      });

  Future<void> stop();

  Future<void> dispose();
}