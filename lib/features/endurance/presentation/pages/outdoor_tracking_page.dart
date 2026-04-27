import 'package:flutter/material.dart';
import 'package:mtorque_flutter/l10n/app_localizations.dart';

import '../../domain/models/endurance_sport.dart';

class OutdoorTrackingPage extends StatelessWidget {
  const OutdoorTrackingPage({
    super.key,
    required this.sport,
    this.sessionId,
  });

  final EnduranceSport? sport;
  final int? sessionId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final title = sport == null
        ? l10n.enduranceOutdoorTitle
        : _sportLabel(l10n, sport!);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            sessionId == null
                ? l10n.enduranceOutdoorComingSoon
                : l10n.enduranceActiveSessionRestored,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  static String _sportLabel(
      AppLocalizations l10n,
      EnduranceSport sport,
      ) {
    switch (sport.code) {
      case 'RUN':
        return l10n.enduranceSportRun;
      case 'MTB':
        return l10n.enduranceSportMountainBike;
      case 'ROADBIKE':
        return l10n.enduranceSportRoadBike;
      case 'ROW':
        return l10n.enduranceSportRowingOutdoor;
      case 'WALKING':
        return l10n.enduranceSportWalking;
      case 'NORDIC_WALKING':
        return l10n.enduranceSportNordicWalking;
      case 'INLINE_SKATING':
        return l10n.enduranceSportInlineSkating;
      default:
        return sport.code;
    }
  }
}