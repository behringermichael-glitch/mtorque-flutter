import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtorque_flutter/core/theme/app_theme.dart';
import 'package:mtorque_flutter/l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  Color _selectedColorForIndex(int index) {
    switch (index) {
      case 0:
        return AppTheme.dashboardCyan;
      case 1:
        return AppTheme.strengthBlue;
      case 2:
        return AppTheme.enduranceRed;
      case 3:
        return AppTheme.statsOrange;
      case 4:
        return AppTheme.settingsGreen;
      default:
        return AppTheme.dashboardCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final selectedIconColor = _selectedColorForIndex(navigationShell.currentIndex);
    final unselectedIconColor = theme.colorScheme.onSurface.withValues(alpha: 0.65);
    final selectedLabelColor = theme.colorScheme.onSurface;
    final unselectedLabelColor = theme.colorScheme.onSurface.withValues(alpha: 0.65);

    final navBackgroundColor = theme.brightness == Brightness.dark
        ? const Color(0xFF3B4566)
        : Colors.white;

    final indicatorColor = theme.brightness == Brightness.dark
        ? const Color(0x22F2EDE7)
        : const Color(0x14000000);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: navBackgroundColor,
          indicatorColor: indicatorColor,
          height: 58,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selectedLabelColor,
              );
            }
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: unselectedLabelColor,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: selectedIconColor, size: 24);
            }
            return IconThemeData(color: unselectedIconColor, size: 24);
          }),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: l10n.navDashboard,
            ),
            NavigationDestination(
              icon: const Icon(Icons.fitness_center_outlined),
              selectedIcon: const Icon(Icons.fitness_center),
              label: l10n.navStrength,
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_border),
              selectedIcon: const Icon(Icons.favorite),
              label: l10n.navEndurance,
            ),
            NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined),
              selectedIcon: const Icon(Icons.bar_chart),
              label: l10n.navStats,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}