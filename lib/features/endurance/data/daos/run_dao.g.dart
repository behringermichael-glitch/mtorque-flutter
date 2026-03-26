// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_dao.dart';

// ignore_for_file: type=lint
mixin _$RunDaoMixin on DatabaseAccessor<AppDatabase> {
  $RunSessionsTable get runSessions => attachedDatabase.runSessions;
  $RunSamplesTable get runSamples => attachedDatabase.runSamples;
  RunDaoManager get managers => RunDaoManager(this);
}

class RunDaoManager {
  final _$RunDaoMixin _db;
  RunDaoManager(this._db);
  $$RunSessionsTableTableManager get runSessions =>
      $$RunSessionsTableTableManager(_db.attachedDatabase, _db.runSessions);
  $$RunSamplesTableTableManager get runSamples =>
      $$RunSamplesTableTableManager(_db.attachedDatabase, _db.runSamples);
}
