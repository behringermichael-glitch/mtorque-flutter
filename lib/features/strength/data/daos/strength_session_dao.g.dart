// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strength_session_dao.dart';

// ignore_for_file: type=lint
mixin _$StrengthSessionDaoMixin on DatabaseAccessor<AppDatabase> {
  $StrengthSessionsTable get strengthSessions =>
      attachedDatabase.strengthSessions;
  $StrengthSetsTable get strengthSets => attachedDatabase.strengthSets;
  StrengthSessionDaoManager get managers => StrengthSessionDaoManager(this);
}

class StrengthSessionDaoManager {
  final _$StrengthSessionDaoMixin _db;
  StrengthSessionDaoManager(this._db);
  $$StrengthSessionsTableTableManager get strengthSessions =>
      $$StrengthSessionsTableTableManager(
        _db.attachedDatabase,
        _db.strengthSessions,
      );
  $$StrengthSetsTableTableManager get strengthSets =>
      $$StrengthSetsTableTableManager(_db.attachedDatabase, _db.strengthSets);
}
