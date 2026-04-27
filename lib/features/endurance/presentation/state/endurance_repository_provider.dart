import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/database_provider.dart';
import '../../data/repositories/drift_endurance_repository.dart';
import '../../domain/repositories/endurance_repository.dart';

final enduranceRepositoryProvider = Provider<EnduranceRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftEnduranceRepository(database.runDao);
});