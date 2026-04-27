import 'package:flutter/material.dart';
import 'package:mtorque_flutter/l10n/app_localizations.dart';

import 'indoor_training_page.dart';
import 'outdoor_tracking_page.dart';

import '../../domain/models/endurance_sport.dart';
import '../widgets/endurance_sport_card.dart';

class EndurancePage extends StatelessWidget {
  const EndurancePage({super.key});

  static const String routeName = 'endurance';
  static const String routePath = '/endurance';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final panelColor =
        theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow;
    final panelBorderColor = theme.colorScheme.outlineVariant;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: panelColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(color: panelBorderColor, width: 1),
        ),
        title: Text(l10n.navEndurance),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            _EnduranceSection(
              title: l10n.enduranceOutdoorTitle,
              sports: EnduranceSports.outdoor,
              labelBuilder: (sport) => _sportLabel(l10n, sport),
              iconBuilder: _sportFallbackIcon,
              onSportSelected: (sport) => _handleSportSelected(
                context,
                sport,
              ),
            ),
            const SizedBox(height: 28),
            _EnduranceSection(
              title: l10n.enduranceIndoorTitle,
              sports: EnduranceSports.indoor,
              labelBuilder: (sport) => _sportLabel(l10n, sport),
              iconBuilder: _sportFallbackIcon,
              onSportSelected: (sport) => _handleSportSelected(
                context,
                sport,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSportSelected(
      BuildContext context,
      EnduranceSport sport,
      ) {
    final page = sport.mode == EnduranceMode.indoor
        ? IndoorTrainingPage(
      sport: sport,
    )
        : OutdoorTrackingPage(
      sport: sport,
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => page,
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

  static IconData _sportFallbackIcon(EnduranceSport sport) {
    switch (sport.code) {
      case 'RUN':
      case 'TREADMILL':
        return Icons.directions_run;
      case 'WALKING':
      case 'TREADMILL_WALKING':
      case 'NORDIC_WALKING':
        return Icons.directions_walk;
      case 'MTB':
      case 'ROADBIKE':
      case 'ERGOMETER':
      case 'SPINNING':
      case 'AIR_BIKE':
        return Icons.directions_bike;
      case 'ROW':
      case 'ROWER':
        return Icons.rowing;
      case 'INLINE_SKATING':
        return Icons.roller_skating;
      case 'CROSSTRAINER':
        return Icons.fitness_center;
      case 'STAIRCLIMBER':
      case 'STEPPER':
        return Icons.stairs;
      case 'JUMPROPE':
        return Icons.sync;
      case 'SKI_ERGOMETER':
        return Icons.downhill_skiing;
      case 'ARM_ERGOMETER':
        return Icons.accessibility_new;
      default:
        return Icons.favorite_border;
    }
  }
}

class _EnduranceSection extends StatelessWidget {
  const _EnduranceSection({
    required this.title,
    required this.sports,
    required this.labelBuilder,
    required this.iconBuilder,
    required this.onSportSelected,
  });

  final String title;
  final List<EnduranceSport> sports;
  final String Function(EnduranceSport sport) labelBuilder;
  final IconData Function(EnduranceSport sport) iconBuilder;
  final ValueChanged<EnduranceSport> onSportSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;

    final crossAxisCount = width >= 900
        ? 4
        : width >= 700
        ? 3
        : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sports.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 18,
            crossAxisSpacing: 18,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (context, index) {
            final sport = sports[index];

            return EnduranceSportCard(
              label: labelBuilder(sport),
              assetPath: sport.assetPath,
              fallbackIcon: iconBuilder(sport),
              onTap: () => onSportSelected(sport),
            );
          },
        ),
      ],
    );
  }
}