// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hr_settings_dao.dart';

// ignore_for_file: type=lint
mixin _$HrSettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $HrSettingsTable get hrSettings => attachedDatabase.hrSettings;
  HrSettingsDaoManager get managers => HrSettingsDaoManager(this);
}

class HrSettingsDaoManager {
  final _$HrSettingsDaoMixin _db;
  HrSettingsDaoManager(this._db);
  $$HrSettingsTableTableManager get hrSettings =>
      $$HrSettingsTableTableManager(_db.attachedDatabase, _db.hrSettings);
}
