import 'package:flutter/material.dart';
import 'package:mtorque_flutter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mtorque_flutter/l10n/generated/app_localizations.dart';

class EndurancePage extends StatelessWidget {
  const EndurancePage({super.key});

  static const String routeName = 'endurance';
  static const String routePath = '/endurance';

  @override
  Widget build(BuildContext context) {
    return ModulePlaceholderPage(
      title: AppLocalizations.of(context)!.navEndurance,
      description: AppLocalizations.of(context)!.endurancePlaceholderDescription,
      icon: Icons.favorite,
    );
  }
}