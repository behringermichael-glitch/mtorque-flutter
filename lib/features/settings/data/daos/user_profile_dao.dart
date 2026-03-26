import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../tables/user_profile_table.dart';

part 'user_profile_dao.g.dart';

@DriftAccessor(tables: [UserProfiles])
class UserProfileDao extends DatabaseAccessor<AppDatabase> with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  Future<UserProfile?> getProfile() {
    return (select(userProfiles)..where((t) => t.id.equals(1))).getSingleOrNull();
  }

  Future<void> upsertProfile(UserProfilesCompanion profile) {
    return into(userProfiles).insertOnConflictUpdate(profile);
  }
}
