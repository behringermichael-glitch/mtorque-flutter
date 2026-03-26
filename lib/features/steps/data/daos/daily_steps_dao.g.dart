// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_steps_dao.dart';

// ignore_for_file: type=lint
mixin _$DailyStepsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DailyStepsTable get dailySteps => attachedDatabase.dailySteps;
  DailyStepsDaoManager get managers => DailyStepsDaoManager(this);
}

class DailyStepsDaoManager {
  final _$DailyStepsDaoMixin _db;
  DailyStepsDaoManager(this._db);
  $$DailyStepsTableTableManager get dailySteps =>
      $$DailyStepsTableTableManager(_db.attachedDatabase, _db.dailySteps);
}
