import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../tables/hr_settings_table.dart';

part 'hr_settings_dao.g.dart';

@DriftAccessor(tables: [HrSettings])
class HrSettingsDao extends DatabaseAccessor<AppDatabase> with _$HrSettingsDaoMixin {
  HrSettingsDao(super.db);

  Future<HrSetting?> getSettings() {
    return (select(hrSettings)..where((t) => t.id.equals(1))).getSingleOrNull();
  }

  Future<void> upsertSettings(HrSettingsCompanion settings) {
    return into(hrSettings).insertOnConflictUpdate(settings);
  }
}
