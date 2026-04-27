import 'package:flutter/material.dart';
import 'package:mtorque_flutter/l10n/app_localizations.dart';

import '../../domain/models/endurance_sport.dart';

class IndoorTrainingPage extends StatelessWidget {
  const IndoorTrainingPage({
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
        ? l10n.enduranceIndoorTitle
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
                ? l10n.enduranceIndoorComingSoon
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
      case 'TREADMILL':
        return l10n.enduranceSportTreadmill;
      case 'TREADMILL_WALKING':
        return l10n.enduranceSportTreadmillWalking;
      case 'ERGOMETER':
        return l10n.enduranceSportErgometer;
      case 'ROWER':
        return l10n.enduranceSportRower;
      case 'SPINNING':
        return l10n.enduranceSportSpinning;
      case 'CROSSTRAINER':
        return l10n.enduranceSportCrosstrainer;
      case 'STAIRCLIMBER':
        return l10n.enduranceSportStairclimber;
      case 'STEPPER':
        return l10n.enduranceSportStepper;
      case 'JUMPROPE':
        return l10n.enduranceSportJumpRope;
      case 'SKI_ERGOMETER':
        return l10n.enduranceSportSkiErgometer;
      case 'ARM_ERGOMETER':
        return l10n.enduranceSportArmErgometer;
      case 'AIR_BIKE':
        return l10n.enduranceSportAirBike;
      default:
        return sport.code;
    }
  }
}