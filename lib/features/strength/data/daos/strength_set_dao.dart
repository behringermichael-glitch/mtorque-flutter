import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../tables/strength_sets_table.dart';

part 'strength_set_dao.g.dart';

class StrengthSetWithDay {
  const StrengthSetWithDay({
    required this.set,
    required this.day,
  });

  final StrengthSet set;
  final String day;
}

@DriftAccessor(tables: [StrengthSets])
class StrengthSetDao extends DatabaseAccessor<AppDatabase>
    with _$StrengthSetDaoMixin {
  StrengthSetDao(super.db);

  Future<void> insertSets(List<StrengthSetsCompanion> sets) async {
    if (sets.isEmpty) return;
    await batch((batch) => batch.insertAll(strengthSets, sets));
  }

  Future<void> deleteSetsForSession(int sessionId) {
    return (delete(strengthSets)..where((t) => t.sessionId.equals(sessionId))).go();
  }

  Future<void> deleteSetsForSessionExercise({
    required int sessionId,
    required String exerciseId,
  }) {
    return (delete(strengthSets)
          ..where((t) => t.sessionId.equals(sessionId) & t.exerciseId.equals(exerciseId)))
        .go();
  }

  Future<void> deleteOrphanStrengthSets() async {
    await customStatement('''
      DELETE FROM strength_set
      WHERE sessionId NOT IN (SELECT id FROM strength_session)
    ''');
  }

  Future<void> deleteDuplicateSetsGlobally() async {
    await customStatement('''
      DELETE FROM strength_set
      WHERE sid NOT IN (
        SELECT MIN(sid)
        FROM strength_set
        GROUP BY sessionId, exerciseId, setNumber, reps, COALESCE(durationSec, -1),
                 weightKg, isAllOut, isBfr, COALESCE(bfrPercent, -1),
                 COALESCE(chainsKg, -1.0), COALESCE(bandsKg, -1.0),
                 isSuperSlow, COALESCE(superSlowNote, ''),
                 COALESCE(supersetGroupId, '')
      )
    ''');
  }
}
