// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

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
      'Die Struktur ist für die Feature-Migration vorbereitet.';

  @override
  String get dashboardPlaceholderDescription =>
      'Dashboard-Platzhalter für die 1:1-Migration.';

  @override
  String get strengthPlaceholderDescription =>
      'Strength-Platzhalter für die 1:1-Migration.';

  @override
  String get endurancePlaceholderDescription =>
      'Endurance-Platzhalter für die 1:1-Migration.';

  @override
  String get statsPlaceholderDescription =>
      'Stats-Platzhalter für die 1:1-Migration.';

  @override
  String get settingsPlaceholderDescription =>
      'Settings-Platzhalter für die 1:1-Migration.';
}
