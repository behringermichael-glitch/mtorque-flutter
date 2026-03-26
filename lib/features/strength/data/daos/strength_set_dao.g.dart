// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strength_set_dao.dart';

// ignore_for_file: type=lint
mixin _$StrengthSetDaoMixin on DatabaseAccessor<AppDatabase> {
  $StrengthSessionsTable get strengthSessions =>
      attachedDatabase.strengthSessions;
  $StrengthSetsTable get strengthSets => attachedDatabase.strengthSets;
  StrengthSetDaoManager get managers => StrengthSetDaoManager(this);
}

class StrengthSetDaoManager {
  final _$StrengthSetDaoMixin _db;
  StrengthSetDaoManager(this._db);
  $$StrengthSessionsTableTableManager get strengthSessions =>
      $$StrengthSessionsTableTableManager(
        _db.attachedDatabase,
        _db.strengthSessions,
      );
  $$StrengthSetsTableTableManager get strengthSets =>
      $$StrengthSetsTableTableManager(_db.attachedDatabase, _db.strengthSets);
}
