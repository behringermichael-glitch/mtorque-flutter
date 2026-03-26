import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtorque_flutter/app/router/app_router.dart';
import 'package:mtorque_flutter/core/db/database_provider.dart';
import 'package:mtorque_flutter/core/theme/app_theme.dart';
import 'package:mtorque_flutter/l10n/generated/app_localizations.dart';

class MTorqueApp extends ConsumerWidget {
  const MTorqueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appDatabaseProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'mTORQUE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}