import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mtorque_flutter/app/app_shell.dart';
import 'package:mtorque_flutter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mtorque_flutter/features/endurance/presentation/pages/endurance_page.dart';
import 'package:mtorque_flutter/features/settings/presentation/pages/settings_page.dart';
import 'package:mtorque_flutter/features/stats/presentation/pages/stats_page.dart';
import 'package:mtorque_flutter/features/strength/presentation/pages/strength_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: DashboardPage.routePath,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: DashboardPage.routePath,
                name: DashboardPage.routeName,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: StrengthPage.routePath,
                name: StrengthPage.routeName,
                builder: (context, state) => const StrengthPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: EndurancePage.routePath,
                name: EndurancePage.routeName,
                builder: (context, state) => const EndurancePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: StatsPage.routePath,
                name: StatsPage.routeName,
                builder: (context, state) => const StatsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: SettingsPage.routePath,
                name: SettingsPage.routeName,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});