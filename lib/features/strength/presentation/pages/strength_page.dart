import 'package:flutter/material.dart';
import 'package:mtorque_flutter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mtorque_flutter/l10n/generated/app_localizations.dart';

class StrengthPage extends StatelessWidget {
  const StrengthPage({super.key});

  static const String routeName = 'strength';
  static const String routePath = '/strength';

  @override
  Widget build(BuildContext context) {
    return ModulePlaceholderPage(
      title: AppLocalizations.of(context)!.navStrength,
      description: AppLocalizations.of(context)!.strengthPlaceholderDescription,
      icon: Icons.fitness_center,
    );
  }
}