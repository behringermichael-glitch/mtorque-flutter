import 'package:drift/drift.dart' show Value;

import '../../../../core/db/app_database.dart';
import '../../data/daos/strength_session_dao.dart';
import '../../data/daos/strength_set_dao.dart';
import '../models/set_entry.dart';

/// Encapsulates the most important Android rule of the current app:
/// a strength session is created only when at least one complete set exists.
class StrengthSessionService {
  const StrengthSessionService({
    required this.sessionDao,
    required this.setDao,
  });

  final StrengthSessionDao sessionDao;
  final StrengthSetDao setDao;

  Future<int?> syncExerciseSets({
    required int? activeSessionId,
    required String exerciseId,
    required String exerciseName,
    required bool isStaticExercise,
    required List<SetEntry> entries,
    String? supersetGroupId,
    int? nowEpochMs,
  }) async {
    final mapped = <StrengthSetsCompanion>[];

    for (var index = 0; index < entries.length; index++) {
      final entry = entries[index];
      if (!entry.isComplete(isStaticExercise: isStaticExercise)) {
        continue;
      }

      final reps = isStaticExercise ? 1.0 : entry.reps!;
      final durationSec = isStaticExercise ? entry.durationSec : null;
      final loadKg = entry.loadKg!;
      final isBfr = entry.bfrPercent != null;

      mapped.add(
        StrengthSetsCompanion.insert(
          sessionId: activeSessionId ?? 0,
          exerciseId: exerciseId,
          exerciseName: exerciseName,
          setNumber: index + 1,
          reps: reps,
          durationSec: Value(durationSec),
          weightKg: loadKg,
          isAllOut: Value(entry.allOut),
          isBfr: Value(isBfr),
          bfrPercent: Value(entry.bfrPercent),
          chainsKg: Value(entry.chainsKg),
          bandsKg: Value(entry.bandsKg),
          isSuperSlow: Value(entry.superSlowEnabled),
          superSlowNote: Value(entry.superSlowNote),
          supersetGroupId: Value(
            supersetGroupId == null || supersetGroupId.trim().isEmpty
                ? null
                : supersetGroupId.trim(),
          ),
        ),
      );
    }

    if (mapped.isEmpty) {
      return null;
    }

    var sessionId = activeSessionId;
    if (sessionId == null || await sessionDao.sessionExists(sessionId) == 0) {
      sessionId = await sessionDao.createSession(
        startEpochMs: nowEpochMs ?? DateTime.now().millisecondsSinceEpoch,
      );
    }

    final resolvedSessionId = sessionId;

    final rows = mapped
        .map((row) => row.copyWith(sessionId: Value(resolvedSessionId)))
        .toList(growable: false);

    await setDao.deleteSetsForSessionExercise(
      sessionId: resolvedSessionId,
      exerciseId: exerciseId,
    );
    await setDao.insertSets(rows);

    return resolvedSessionId;
  }
}