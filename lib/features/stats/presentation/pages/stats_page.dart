import 'package:flutter/material.dart';
import 'package:mtorque_flutter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mtorque_flutter/l10n/generated/app_localizations.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  static const String routeName = 'stats';
  static const String routePath = '/stats';

  @override
  Widget build(BuildContext context) {
    return ModulePlaceholderPage(
      title: AppLocalizations.of(context)!.navStats,
      description: AppLocalizations.of(context)!.statsPlaceholderDescription,
      icon: Icons.bar_chart,
    );
  }
}