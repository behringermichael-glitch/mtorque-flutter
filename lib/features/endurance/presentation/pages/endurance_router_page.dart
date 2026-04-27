import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/endurance_sport.dart';
import '../state/endurance_repository_provider.dart';
import 'endurance_page.dart';
import 'indoor_training_page.dart';
import 'outdoor_tracking_page.dart';

class EnduranceRouterPage extends ConsumerWidget {
  const EnduranceRouterPage({super.key});

  static const String routeName = 'endurance';
  static const String routePath = '/endurance';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSessionFuture = ref.watch(_activeEnduranceSessionProvider);

    return activeSessionFuture.when(
      data: (session) {
        if (session == null) {
          return const EndurancePage();
        }

        final sport = EnduranceSports.byCode(session.sport);

        if (sport?.mode == EnduranceMode.indoor) {
          return IndoorTrainingPage(
            sport: sport,
            sessionId: session.id,
          );
        }

        return OutdoorTrackingPage(
          sport: sport,
          sessionId: session.id,
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, stackTrace) {
        return const EndurancePage();
      },
    );
  }
}

final _activeEnduranceSessionProvider =
FutureProvider.autoDispose((ref) async {
  final repository = ref.watch(enduranceRepositoryProvider);
  return repository.getActiveSession();
});