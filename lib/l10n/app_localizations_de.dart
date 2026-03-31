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
  String get navStrength => 'Kraft';

  @override
  String get navEndurance => 'Ausdauer';

  @override
  String get navStats => 'Statistik';

  @override
  String get navSettings => 'Settings';

  @override
  String get strengthPlaceholderDescription => 'Kraft-Platzhalter für die 1:1-Migration.';

  @override
  String get endurancePlaceholderDescription => 'Ausdauer-Platzhalter für die 1:1-Migration.';

  @override
  String get statsPlaceholderDescription => 'Statistik-Platzhalter für die 1:1-Migration.';

  @override
  String get settingsPlaceholderDescription => 'Settings-Platzhalter für die 1:1-Migration.';

  @override
  String get weekdayMonShort => 'Mo.';

  @override
  String get weekdayTueShort => 'Di.';

  @override
  String get weekdayWedShort => 'Mi.';

  @override
  String get weekdayThuShort => 'Do.';

  @override
  String get weekdayFriShort => 'Fr.';

  @override
  String get weekdaySatShort => 'Sa.';

  @override
  String get weekdaySunShort => 'So.';

  @override
  String get dashboardWeekOverviewHint => 'Tippen für mehr Infos';

  @override
  String get dashboardWeekLegendTitle => 'Wochenübersicht – Legende';

  @override
  String get dashboardWeekLegendIntro => 'Die Punkte unter den Wochentagen zeigen an, ob du an diesem Tag Kraft, Ausdauer oder beides trainiert hast.';

  @override
  String get dashboardWeekLegendStrength => 'Krafttraining';

  @override
  String get dashboardWeekLegendEndurance => 'Ausdauertraining';

  @override
  String get dashboardWeekLegendBoth => 'Kraft + Ausdauer';

  @override
  String get dashboardWeekLegendNone => 'Kein Training';

  @override
  String get dashboardMotivationTeaser => 'Brauchst du einen Schubs? Hier ist dein Spruch des Tages.';

  @override
  String get dashboardQuoteOne => 'WIRF DAS HANDTUCH NIE. NUTZE ES, UM DEN SCHWEISS ABZUWISCHEN. UND MACH WEITER.';

  @override
  String get dashboardQuoteTwo => 'Disziplin bedeutet, das zu wählen, was du wirklich willst, statt das, was du gerade willst.';

  @override
  String get dashboardQuoteThree => 'Kleine Schritte, konsequent umgesetzt, werden zu großen Ergebnissen.';

  @override
  String get dashboardQuoteFour => 'Motivation startet dich. Routine trägt dich weiter.';

  @override
  String get dashboardQuoteFive => 'Dein zukünftiges Ich wird dir für die heutige Einheit danken.';

  @override
  String get dashboardShareQuoteDialogTitle => 'Motivation teilen';

  @override
  String get dashboardShareQuoteDialogMessage => 'Teile dieses Motivationszitat mit einer Freundin oder einem Freund.';

  @override
  String get dashboardShareQuoteActionShare => 'Teilen';

  @override
  String get dashboardShareQuoteIntro => 'Ein Freund denkt, du solltest trainieren.';

  @override
  String get dashboardShareQuoteCopied => 'Motivation in die Zwischenablage kopiert.';

  @override
  String get goalStrengthTitle => 'Kraftziel festlegen';

  @override
  String get goalEnduranceTitle => 'Ausdauerziel festlegen';

  @override
  String get goalUnitsSessions => 'Einheiten';

  @override
  String get goalUnitsSets => 'Sätze';

  @override
  String get goalUnitsDistance => 'Distanz';

  @override
  String get goalUnitsDuration => 'Dauer';

  @override
  String get goalUnitsKm => 'km';

  @override
  String get goalUnitsMin => 'min';

  @override
  String get goalUnitsDistanceShort => 'km';

  @override
  String get goalUnitsDurationShort => 'min';

  @override
  String get goalInvalidNumber => 'Bitte gib eine gültige Zahl > 0 ein.';

  @override
  String get dashboardTapToEdit => 'Tippen zum Bearbeiten';

  @override
  String get dashboardStepsTitle => 'Schritte';

  @override
  String get dashboardStepsGoalDialogTitle => 'Schrittziel bearbeiten';

  @override
  String get dashboardStepsGoalDialogMessage => 'Lege dein tägliches Schrittziel fest.';

  @override
  String get dashboardStepsGoalInputHint => 'Schritte pro Tag';

  @override
  String get dashboardStepsGoalInvalid => 'Bitte gib eine gültige Zahl ein.';

  @override
  String dashboardStepsGoalFormat(int value) {
    return 'Ziel: $value';
  }

  @override
  String get dashboardStreaksTitle => 'Streaks';

  @override
  String get dashboardStreaksHint => 'Tippen für mehr Infos';

  @override
  String dashboardMonthsShort(int value) {
    return '$value m';
  }

  @override
  String get streakInfoTitle => 'Stern-Belohnungen';

  @override
  String get streakInfoDescription => 'Für jeden Monat, in dem du dein persönliches Kraft- oder Ausdauerziel erreichst, bekommst du einen Stern. Diese Ziele kannst du in den entsprechenden Dashboard-Kacheln anpassen.';

  @override
  String get streakLevel1Title => 'Erste Anpassung';

  @override
  String get streakLevel1Months => '(1 Monat)';

  @override
  String get streakLevel2Title => 'Stabile Gewohnheitsbildung';

  @override
  String get streakLevel2Months => '(2 Monate)';

  @override
  String get streakLevel3Title => 'Konsolidierungsphase';

  @override
  String get streakLevel3Months => '(3 Monate)';

  @override
  String get streakLevel4Title => 'Langfristige Konstanz';

  @override
  String get streakLevel4Months => '(4 Monate)';

  @override
  String get streakLevel5Title => 'Hohe Trainingsadhärenz';

  @override
  String get streakLevel5Months => '(5 Monate)';

  @override
  String get dashboardQuickStartTitle => 'Schnellstart';

  @override
  String get dashboardQuickStartStrengthSubtitle => 'Starte deine nächste Krafteinheit.';

  @override
  String get dashboardQuickStartEnduranceSubtitle => 'Öffne Ausdauer mit Fallback-Kachel.';

  @override
  String get dashboardGymKnowledgeTitle => 'GYM-Knowledge';

  @override
  String get dashboardGymKnowledgeSubtitle => 'Evidenzbasierte Inhalte und praktische Impulse.';

  @override
  String get dashboardYoutubeItemOneTitle => 'Muskelermüdung erklärt';

  @override
  String get dashboardYoutubeItemOneSubtitle => 'Grundlagen aus der Leistungsphysiologie.';

  @override
  String get dashboardYoutubeItemTwoTitle => 'Repeated Bout Effect';

  @override
  String get dashboardYoutubeItemTwoSubtitle => 'Warum dasselbe Training später weniger schmerzt.';

  @override
  String get dashboardShareQuoteWatermark => 'mTORQUE App';

  @override
  String dashboardShareQuoteMessage(String quote) {
    return 'Ein Freund denkt, du solltest trainieren.\n\n“$quote”\n\nHol dir mTORQUE:\nhttps://play.google.com/store/apps/details?id=app.mtorque';
  }

  @override
  String get dashboardShareQuoteFailed => 'Teilen fehlgeschlagen.';

  @override
  String get dashboardYoutubeLoading => 'Videos werden geladen…';

  @override
  String get dashboardYoutubeUnavailable => 'Zurzeit sind keine Videos verfügbar.';

  @override
  String get dashboardYoutubeTapToOpen => 'Tippen zum Öffnen auf YouTube.';

  @override
  String get dashboardYoutubeOpenFailed => 'YouTube konnte nicht geöffnet werden.';

  @override
  String get strengthStartEmptyPlan => 'Leeren Plan starten';

  @override
  String get strengthAddExercise => 'Übung hinzufügen';

  @override
  String get strengthClosePlanTitle => 'Plan schließen';

  @override
  String get strengthClosePlanMessage => 'Speichern und schließen, verwerfen oder weiter bearbeiten?';

  @override
  String get strengthContinueEditing => 'Weiter bearbeiten';

  @override
  String get strengthDiscard => 'Verwerfen';

  @override
  String get strengthSaveAndClose => 'Speichern & schließen';

  @override
  String get strengthFinishSessionTitle => 'Session beenden';

  @override
  String get strengthNotes => 'Notizen';

  @override
  String get strengthCommonCancel => 'Abbrechen';

  @override
  String get strengthCommonDelete => 'Löschen';

  @override
  String get strengthCommonSave => 'Speichern';

  @override
  String get strengthCommonOk => 'OK';

  @override
  String get strengthCommonKgLabel => 'kg';

  @override
  String get strengthCommonRepsShort => 'Wdh.';

  @override
  String get strengthCommonDurationShort => 'Sek.';

  @override
  String get strengthExerciseAddSetButton => '+ SATZ HINZUFÜGEN';

  @override
  String get strengthExerciseDeleteExerciseTitle => 'Übung löschen?';

  @override
  String get strengthExerciseDeleteExerciseMessage => 'Möchtest Du diese Übung wirklich aus der Session entfernen?';

  @override
  String get strengthExerciseMarkersTitle => 'Zusätzliche Marker';

  @override
  String get strengthExerciseMarkerBfr => 'BFR-Training';

  @override
  String get strengthExerciseMarkerChain => 'Gewichtskette';

  @override
  String get strengthExerciseMarkerBands => 'Widerstandsbänder';

  @override
  String get strengthExerciseMarkerSuperSlow => 'Super-slow';

  @override
  String get strengthExerciseBfrPressureLabel => 'BFR-Druck';

  @override
  String strengthExerciseBfrValue(int value) {
    return '$value % des Okklusionsdrucks';
  }

  @override
  String get strengthExerciseChainWeightLabel => 'Kettengewicht';

  @override
  String get strengthExerciseChainWeightHint => 'z. B. 10';

  @override
  String get strengthExerciseBandResistanceLabel => 'Band-Widerstand';

  @override
  String get strengthExerciseBandResistanceHint => 'z. B. 20';

  @override
  String get strengthExerciseSuperSlowActiveLabel => 'Super-slow aktiv';

  @override
  String get strengthExerciseSuperSlowHint => 'z. B. 5-5-5 oder „sehr langsam“';

  @override
  String get strengthExerciseDescriptionTitle => 'Übungsbeschreibung';

  @override
  String get strengthExerciseNoDescriptionAvailable => 'Keine Beschreibung verfügbar.';

  @override
  String get strengthExercisePrimaryMuscles => 'Primäre Muskeln';

  @override
  String get strengthExerciseSecondaryMuscles => 'Sekundäre Muskeln';

  @override
  String get strengthExerciseNoMuscleDataAvailable => 'Keine Muskeldaten verfügbar.';

  @override
  String get strengthExerciseNoStatsData => 'Noch keine Daten für diese Übung.';

  @override
  String get strengthExerciseWeightLegend => 'Gewicht';

  @override
  String get strengthExerciseRepsLegend => 'Wiederholungen';

  @override
  String get strengthExerciseDurationLegend => 'Dauer';

  @override
  String get strengthExerciseWeightAxis => 'Gewicht [kg]';

  @override
  String get strengthExerciseRepsAxis => 'Wiederholungen';

  @override
  String get strengthExerciseDurationAxis => 'Dauer [s]';

  @override
  String get strengthExerciseOverallChip => 'Gesamt';

  @override
  String strengthExerciseSetChip(int number) {
    return 'Satz $number';
  }

  @override
  String strengthExerciseTonnageLabel(double valueTons) {
    return '$valueTons t';
  }

  @override
  String get strengthExerciseMuscleZoomHint => 'Doppeltippen zum Zoomen';

  @override
  String get muscleLabelFunction => 'Funktion';

  @override
  String get muscleLabelOrigin => 'Ursprung';

  @override
  String get muscleLabelInsertion => 'Ansatz';

  @override
  String get muscleLabelInnervation => 'Innervation';
}
