import '../models/set_entry.dart';

enum StrengthMuscleRole {
  primary,
  secondary,
}

class StrengthExerciseMuscleUsage {
  const StrengthExerciseMuscleUsage({
    required this.groupCode,
    required this.groupNameDe,
    required this.groupNameEn,
    required this.muscleName,
    required this.role,
  });

  final String groupCode;
  final String groupNameDe;
  final String groupNameEn;
  final String muscleName;
  final StrengthMuscleRole role;

  String groupNameForLanguageCode(String languageCode) {
    return languageCode.toLowerCase() == 'de' ? groupNameDe : groupNameEn;
  }
}

class StrengthExerciseDetail {
  const StrengthExerciseDetail({
    required this.id,
    required this.label,
    required this.isStatic,
    required this.instructionDe,
    required this.instructionEn,
    required this.muscles,
  });

  final String id;
  final String label;
  final bool isStatic;
  final String instructionDe;
  final String instructionEn;
  final List<StrengthExerciseMuscleUsage> muscles;

  String instructionForLanguageCode(String languageCode) {
    final isDe = languageCode.toLowerCase() == 'de';
    if (isDe) {
      if (instructionDe.trim().isNotEmpty) return instructionDe.trim();
      return instructionEn.trim();
    }
    if (instructionEn.trim().isNotEmpty) return instructionEn.trim();
    return instructionDe.trim();
  }
}

class StrengthExerciseStatsSetPoint {
  const StrengthExerciseStatsSetPoint({
    required this.setNumber,
    required this.load,
    required this.secondValue,
  });

  final int setNumber;
  final double load;
  final double secondValue;
}

class StrengthExerciseStatsDay {
  const StrengthExerciseStatsDay({
    required this.date,
    required this.startEpochMs,
    required this.totalLoad,
    required this.totalSecondValue,
    required this.tonnage,
    required this.perSet,
  });

  final DateTime date;
  final int startEpochMs;
  final double totalLoad;
  final double totalSecondValue;
  final double tonnage;
  final List<StrengthExerciseStatsSetPoint> perSet;
}

class StrengthExerciseStats {
  const StrengthExerciseStats({
    required this.exerciseId,
    required this.exerciseLabel,
    required this.isStaticExercise,
    required this.maxSetNumber,
    required this.days,
  });

  final String exerciseId;
  final String exerciseLabel;
  final bool isStaticExercise;
  final int maxSetNumber;
  final List<StrengthExerciseStatsDay> days;
}

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

  Future<StrengthExerciseDetail?> getExerciseDetail(String exerciseId);

  Future<StrengthExerciseStats> loadExerciseStats({
    required String exerciseId,
    required bool isStaticExercise,
  });

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