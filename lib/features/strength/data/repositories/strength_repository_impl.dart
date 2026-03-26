import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../../domain/repositories/strength_repository.dart';

class StrengthRepositoryImpl implements StrengthRepository {
  const StrengthRepositoryImpl({
    required this.database,
  });

  final AppDatabase database;

  @override
  Future<StrengthOverview> loadOverview() async {
    final openSessionRow = await database.customSelect(
      '''
      SELECT id, startEpochMs
      FROM strength_session
      WHERE endEpochMs IS NULL
      ORDER BY startEpochMs DESC
      LIMIT 1
      ''',
      readsFrom: {database.strengthSessions},
    ).getSingleOrNull();

    int? openSessionId;
    int? openSessionStartEpochMs;
    int openSessionSetCount = 0;
    int openSessionExerciseCount = 0;

    if (openSessionRow != null) {
      openSessionId = openSessionRow.read<int>('id');
      openSessionStartEpochMs = openSessionRow.read<int>('startEpochMs');

      final setCountRow = await database.customSelect(
        '''
        SELECT COUNT(*) AS cnt
        FROM strength_set
        WHERE sessionId = ?
        ''',
        variables: [Variable<int>(openSessionId)],
        readsFrom: {database.strengthSets},
      ).getSingle();

      openSessionSetCount = setCountRow.read<int>('cnt');

      final exerciseCountRow = await database.customSelect(
        '''
        SELECT COUNT(DISTINCT exerciseId) AS cnt
        FROM strength_set
        WHERE sessionId = ?
        ''',
        variables: [Variable<int>(openSessionId)],
        readsFrom: {database.strengthSets},
      ).getSingle();

      openSessionExerciseCount = exerciseCountRow.read<int>('cnt');
    }

    final finishedCountRow = await database.customSelect(
      '''
      SELECT COUNT(*) AS cnt
      FROM strength_session
      WHERE endEpochMs IS NOT NULL
      ''',
      readsFrom: {database.strengthSessions},
    ).getSingle();

    final lastFinishedRow = await database.customSelect(
      '''
      SELECT endEpochMs
      FROM strength_session
      WHERE endEpochMs IS NOT NULL
      ORDER BY endEpochMs DESC
      LIMIT 1
      ''',
      readsFrom: {database.strengthSessions},
    ).getSingleOrNull();

    return StrengthOverview(
      hasOpenSession: openSessionId != null,
      openSessionId: openSessionId,
      openSessionStartEpochMs: openSessionStartEpochMs,
      openSessionSetCount: openSessionSetCount,
      openSessionExerciseCount: openSessionExerciseCount,
      finishedSessionCount: finishedCountRow.read<int>('cnt'),
      lastFinishedSessionEndEpochMs:
      lastFinishedRow?.read<int>('endEpochMs'),
    );
  }

  @override
  Future<void> finalizeOpenSession({
    required int sessionId,
    String? notes,
    int? endEpochMs,
  }) async {
    await database.strengthSessionDao.finalizeSession(
      id: sessionId,
      endEpochMs: endEpochMs ?? DateTime.now().millisecondsSinceEpoch,
      notes: notes,
    );
  }
}