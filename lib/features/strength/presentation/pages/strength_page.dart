import 'package:flutter/material.dart';
import 'package:mtorque_flutter/l10n/generated/app_localizations.dart';

class StrengthPage extends StatelessWidget {
  const StrengthPage({super.key});

  static const String routeName = 'strength';
  static const String routePath = '/strength';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.navStrength,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.strengthPlaceholderDescription,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}