import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/db/database_provider.dart';
import '../../data/repositories/strength_repository_impl.dart';
import '../../domain/models/strength_flow_state.dart';
import '../../domain/repositories/strength_repository.dart';
import 'strength_flow_controller.dart';

final strengthRepositoryProvider = Provider<StrengthRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return StrengthRepositoryImpl(database: db);
});

final strengthFlowControllerProvider =
StateNotifierProvider<StrengthFlowController, StrengthFlowState>((ref) {
  final repository = ref.watch(strengthRepositoryProvider);
  return StrengthFlowController(repository);
});