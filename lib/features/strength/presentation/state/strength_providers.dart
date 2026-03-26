import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/database_provider.dart';
import '../../data/repositories/strength_repository_impl.dart';
import '../../domain/models/strength_flow_state.dart';
import '../../domain/repositories/strength_repository.dart';
import 'strength_flow_controller.dart';

final strengthRepositoryProvider = Provider<StrengthRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return StrengthRepositoryImpl(database: database);
});

final strengthFlowControllerProvider =
NotifierProvider<StrengthFlowController, StrengthFlowState>(
  StrengthFlowController.new,
);