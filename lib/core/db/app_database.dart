import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/endurance/data/daos/run_dao.dart';
import '../../features/endurance/data/tables/run_samples_table.dart';
import '../../features/endurance/data/tables/run_sessions_table.dart';
import '../../features/settings/data/daos/hr_settings_dao.dart';
import '../../features/settings/data/daos/user_profile_dao.dart';
import '../../features/settings/data/tables/hr_settings_table.dart';
import '../../features/settings/data/tables/user_profile_table.dart';
import '../../features/steps/data/daos/daily_steps_dao.dart';
import '../../features/steps/data/tables/daily_steps_table.dart';
import '../../features/strength/data/daos/strength_session_dao.dart';
import '../../features/strength/data/daos/strength_set_dao.dart';
import '../../features/strength/data/tables/strength_sessions_table.dart';
import '../../features/strength/data/tables/strength_sets_table.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'mtorque.db'));

    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    );
  });
}

@DriftDatabase(
  tables: [
    RunSessions,
    RunSamples,
    StrengthSessions,
    StrengthSets,
    DailySteps,
    HrSettings,
    UserProfiles,
  ],
  daos: [
    RunDao,
    StrengthSessionDao,
    StrengthSetDao,
    DailyStepsDao,
    HrSettingsDao,
    UserProfileDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Stay aligned to the existing Android Room schema version first.
          // Real upgrade steps should only be added after testing against a
          // copied production database from the current Android app.
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );
}
