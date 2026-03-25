// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'mTORQUE';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navStrength => 'Strength';

  @override
  String get navEndurance => 'Endurance';

  @override
  String get navStats => 'Stats';

  @override
  String get navSettings => 'Settings';

  @override
  String get modulePlaceholderReady =>
      'Structure is ready for feature migration.';

  @override
  String get dashboardPlaceholderDescription =>
      'Dashboard module placeholder for 1:1 migration.';

  @override
  String get strengthPlaceholderDescription =>
      'Strength module placeholder for 1:1 migration.';

  @override
  String get endurancePlaceholderDescription =>
      'Endurance module placeholder for 1:1 migration.';

  @override
  String get statsPlaceholderDescription =>
      'Statistics module placeholder for 1:1 migration.';

  @override
  String get settingsPlaceholderDescription =>
      'Settings module placeholder for 1:1 migration.';
}
