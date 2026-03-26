import '../models/set_entry.dart';

abstract class StrengthRepository {
  Future<StrengthDraftSession?> loadDraftSession();

  Future<void> saveDraftSession(StrengthDraftSession? session);

  Future<List<StrengthPlanSummary>> listPlanSummaries();

  Future<List<String>?> loadPlanExerciseIds(String planName);

  Future<bool> savePlan({
    required String name,
    required List<String> exerciseIds,
    required bool overwrite,
  });

  Future<bool> renamePlan({
    required String oldName,
    required String newName,
    required bool overwrite,
  });

  Future<bool> deletePlan(String name);

  Future<List<StrengthExerciseSummary>> searchExercises({
    String query = '',
  });

  Future<StrengthExerciseSummary?> getExerciseById(String exerciseId);

  Future<int?> getStoredActiveDbSessionId();

  Future<void> setStoredActiveDbSessionId(int? sessionId);

  Future<int> createStrengthSessionIfMissing();

  Future<void> deleteStrengthSessionCompletely(int sessionId);

  Future<void> finalizeStrengthSession({
    required int sessionId,
    required String? notes,
  });

  Future<DateTime?> getStrengthSessionStart(int sessionId);

  Future<void> replaceExerciseSetsForSession({
    required int sessionId,
    required String exerciseId,
    required String exerciseName,
    required bool isStaticExercise,
    required String? supersetGroupId,
    required List<SetEntry> draftSets,
  });

  Future<Map<int, ({double load, double secondValue})>> loadLastSuggestions({
    required String exerciseId,
    required bool isStaticExercise,
    required int minCount,
  });
}