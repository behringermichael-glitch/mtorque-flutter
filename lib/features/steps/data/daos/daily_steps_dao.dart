import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../tables/daily_steps_table.dart';

part 'daily_steps_dao.g.dart';

@DriftAccessor(tables: [DailySteps])
class DailyStepsDao extends DatabaseAccessor<AppDatabase> with _$DailyStepsDaoMixin {
  DailyStepsDao(super.db);

  Future<DailyStep?> getByDay(int day) {
    return (select(dailySteps)..where((t) => t.dateEpochDay.equals(day))).getSingleOrNull();
  }

  Future<void> upsertEntry(DailyStepsCompanion entity) {
    return into(dailySteps).insertOnConflictUpdate(entity);
  }

  Future<List<DailyStep>> range({required int startDay, required int endDay}) {
    return (select(dailySteps)
          ..where((t) => t.dateEpochDay.isBetweenValues(startDay, endDay))
          ..orderBy([(t) => OrderingTerm.asc(t.dateEpochDay)]))
        .get();
  }
}
