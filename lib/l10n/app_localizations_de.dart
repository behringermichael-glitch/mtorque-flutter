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
  String get dashboardWeekLegendIntro => 'Die Punkte unter den Wochentagen zeigen, ob du an diesem Tag Kraft, Ausdauer oder beides trainiert hast.';

  @override
  String get dashboardWeekLegendStrength => 'Krafttraining';

  @override
  String get dashboardWeekLegendEndurance => 'Ausdauertraining';

  @override
  String get dashboardWeekLegendBoth => 'Kraft + Ausdauer';

  @override
  String get dashboardWeekLegendNone => 'Kein Training';

  @override
  String get dashboardMotivationTeaser => 'Brauchst du Motivation? Hier ist dein heutiges Zitat.';

  @override
  String get dashboardQuoteOne => 'WIRF NIEMALS DAS HANDTUCH. NUTZE ES, UM DEN SCHWEISS ABZUWISCHEN. DANN MACH WEITER.';

  @override
  String get dashboardQuoteTwo => 'Disziplin bedeutet, das zu wählen, was du langfristig willst, statt das, was du gerade willst.';

  @override
  String get dashboardQuoteThree => 'Kleine Schritte werden durch Beständigkeit zu großen Ergebnissen.';

  @override
  String get dashboardQuoteFour => 'Motivation bringt dich in Bewegung. Routine trägt dich weiter.';

  @override
  String get dashboardQuoteFive => 'Dein zukünftiges Ich wird dir für den heutigen Einsatz danken.';

  @override
  String get dashboardShareQuoteDialogTitle => 'Motivation teilen';

  @override
  String get dashboardShareQuoteDialogMessage => 'Teile dieses motivierende Zitat mit einem Freund.';

  @override
  String get dashboardShareQuoteActionShare => 'Teilen';

  @override
  String get dashboardShareQuoteIntro => 'Ein Freund findet, du solltest trainieren.';

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
  String get goalInvalidNumber => 'Bitte eine gültige Zahl > 0 eingeben.';

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
  String get dashboardStepsGoalInvalid => 'Bitte eine gültige Zahl eingeben.';

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
    return '$value M';
  }

  @override
  String get streakInfoTitle => 'Sterne-Belohnungen';

  @override
  String get streakInfoDescription => 'Für jeden Monat, in dem du deine persönlichen Kraft- oder Ausdauerziele erreichst, erhältst du einen Stern. Diese Ziele kannst du in den entsprechenden Dashboard-Kacheln anpassen.';

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
  String get streakLevel5Title => 'High-Performance-Adhärenz';

  @override
  String get streakLevel5Months => '(5+ Monate)';

  @override
  String get dashboardQuickStartTitle => 'Schnellstart';

  @override
  String get dashboardQuickStartStrengthSubtitle => 'Starte deine nächste Krafteinheit.';

  @override
  String get dashboardQuickStartEnduranceSubtitle => 'Öffne Ausdauer mit Fallback-Kachel.';

  @override
  String get dashboardGymKnowledgeTitle => 'GYM-Knowledge';

  @override
  String get dashboardGymKnowledgeSubtitle => 'Evidenzbasierte Inhalte und praktische Einblicke.';

  @override
  String get dashboardYoutubeItemOneTitle => 'Muskelermüdung erklärt';

  @override
  String get dashboardYoutubeItemOneSubtitle => 'Grundlagen der Leistungsphysiologie.';

  @override
  String get dashboardYoutubeItemTwoTitle => 'Repeated Bout Effect';

  @override
  String get dashboardYoutubeItemTwoSubtitle => 'Warum dasselbe Training später weniger schmerzt.';

  @override
  String get dashboardShareQuoteWatermark => 'mTORQUE App';

  @override
  String dashboardShareQuoteMessage(String quote) {
    return 'Ein Freund findet, du solltest trainieren.\n\n„$quote”\n\nHol dir mTORQUE:\nhttps://play.google.com/store/apps/details?id=app.mtorque';
  }

  @override
  String get dashboardShareQuoteFailed => 'Teilen fehlgeschlagen.';

  @override
  String get dashboardYoutubeLoading => 'Videos werden geladen…';

  @override
  String get dashboardYoutubeUnavailable => 'Derzeit sind keine Videos verfügbar.';

  @override
  String get dashboardYoutubeTapToOpen => 'Tippen, um YouTube zu öffnen.';

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
  String get strengthContinueEditing => 'Weiter';

  @override
  String get strengthDiscard => 'Verwerfen';

  @override
  String get strengthSaveAndClose => 'Speichern und schließen';

  @override
  String get strengthFinishSessionTitle => 'Einheit beenden';

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
  String get strengthExercisePickerSearchHint => 'Suche (Übungsname)';

  @override
  String get strengthExercisePickerFilter => 'Filter';

  @override
  String get strengthExercisePickerAdvanced => 'Erweitert';

  @override
  String get strengthExercisePickerInvolvedMuscleLatin => 'Beteiligter Muskel (Latein)';

  @override
  String get strengthExercisePickerClearFilters => 'Filter löschen';

  @override
  String get strengthExercisePickerPrimaryMuscleGroup => 'Primäre Muskelgruppe';

  @override
  String get strengthExercisePickerInvolvedMuscle => 'Beteiligter Muskel';

  @override
  String get strengthExercisePickerBaseExercise => 'Basisübung';

  @override
  String get strengthExercisePickerDevice => 'Gerät';

  @override
  String get strengthExercisePickerAll => 'Alle';

  @override
  String get strengthExercisePickerResults => 'Ergebnisse';

  @override
  String get strengthExercisePickerList => 'Liste';

  @override
  String get strengthExercisePickerImages => 'Bilder';

  @override
  String get strengthExercisePickerAdd => 'Hinzufügen';

  @override
  String strengthExercisePickerAddCount(int count) {
    return 'Hinzufügen ($count)';
  }

  @override
  String get strengthExercisePickerClearSelection => 'Auswahl leeren';

  @override
  String get strengthExerciseAddSetButton => '+ Satz hinzufügen';

  @override
  String get strengthExerciseDeleteExerciseTitle => 'Übung löschen?';

  @override
  String get strengthExerciseDeleteExerciseMessage => 'Möchtest du diese Übung wirklich aus der Einheit entfernen?';

  @override
  String get strengthExerciseMarkersTitle => 'Zusätzliche Marker';

  @override
  String get strengthExerciseMarkerBfr => 'BFR-Training';

  @override
  String get strengthExerciseMarkerChain => 'Gewichtsketten';

  @override
  String get strengthExerciseMarkerBands => 'Widerstandsbänder';

  @override
  String get strengthExerciseMarkerSuperSlow => 'Super-slow';

  @override
  String get strengthExerciseBfrPressureLabel => 'BFR-Druck';

  @override
  String strengthExerciseBfrValue(int value) {
    return '$value% des Okklusionsdrucks';
  }

  @override
  String get strengthExerciseChainWeightLabel => 'Kettengewicht';

  @override
  String get strengthExerciseChainWeightHint => 'z. B. 10';

  @override
  String get strengthExerciseBandResistanceLabel => 'Bandwiderstand';

  @override
  String get strengthExerciseBandResistanceHint => 'z. B. 20';

  @override
  String get strengthExerciseSuperSlowActiveLabel => 'Super-slow aktiv';

  @override
  String get strengthExerciseSuperSlowHint => 'z. B. 5-5-5 oder „sehr langsam”';

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
  String strengthExerciseSupersetSubtitle(String group, int position, int total) {
    return 'Supersatz $group $position/$total';
  }

  @override
  String get muscleLabelFunction => 'Funktion';

  @override
  String get muscleLabelOrigin => 'Ursprung';

  @override
  String get muscleLabelInsertion => 'Ansatz';

  @override
  String get muscleLabelInnervation => 'Innervation';

  @override
  String get strengthMenuStartEmptyPlan => 'Mit leerem Plan starten';

  @override
  String get strengthMenuCloseSession => 'Einheit schließen';

  @override
  String get strengthMenuSaveAsPlan => 'Als Plan speichern...';

  @override
  String get strengthMenuEditTrainingPlan => 'Trainingsplan bearbeiten';

  @override
  String get strengthMenuPrintPlanPdf => 'Plan als PDF drucken';

  @override
  String get strengthMenuAddExercise => 'Übung hinzufügen';

  @override
  String get strengthMenuLoadPlan => 'Plan laden';

  @override
  String get strengthMenuRenamePlan => 'Plan umbenennen';

  @override
  String get strengthMenuDeletePlan => 'Plan löschen';

  @override
  String get strengthMenuSaveCurrentPlan => 'Aktuellen Plan speichern';

  @override
  String get strengthEndSessionButton => 'Beenden';

  @override
  String get strengthSessionTitle => 'Einheit';

  @override
  String get strengthPlanNameTitle => 'Planname';

  @override
  String get strengthPlanNameHint => 'Name eingeben';

  @override
  String get strengthNoPlansAvailable => 'Keine Pläne vorhanden.';

  @override
  String get strengthReplaceCurrentSessionTitle => 'Aktuelle Einheit ersetzen?';

  @override
  String get strengthReplaceCurrentSessionMessage => 'Die aktuelle Einheit wird dadurch verworfen und ersetzt.';

  @override
  String get strengthReplaceCurrentSessionButton => 'Ersetzen';

  @override
  String get strengthDeletePlanTitle => 'Plan löschen';

  @override
  String strengthDeletePlanMessage(String planName) {
    return 'Soll der Plan „$planName” gelöscht werden?';
  }

  @override
  String get strengthPrintPlanPdfNotImplemented => 'Der PDF-Druck des Trainingsplans ist in Flutter noch nicht umgesetzt.';

  @override
  String get strengthTimerTitle => 'Timer';

  @override
  String get strengthTimerSecondsHint => 'Sek.';

  @override
  String get strengthTimerReset => 'Reset';

  @override
  String get strengthTimerRingHint => 'Ring: Tippen = Start/Stopp';

  @override
  String get strengthTimerTapStop => 'Tippen = Stopp';

  @override
  String get strengthTimerTapStartStop => 'Tippen = Start/Stopp';

  @override
  String get strengthTempoConcentric => 'Konzentrisch';

  @override
  String get strengthTempoStatic => 'Statisch';

  @override
  String get strengthTempoEccentric => 'Exzentrisch';

  @override
  String get strengthPrintPlanSelectTitle => 'Plan auswählen';

  @override
  String get strengthPrintPlanSetsTitle => 'Sätze pro Übung';

  @override
  String strengthPrintSetsOption(int sets) {
    return '$sets Sätze';
  }

  @override
  String get strengthPrintPlanCommentTitle => 'Kommentar';

  @override
  String get strengthPrintPlanCommentMessage => 'Füge optional einen Kommentar für den gedruckten Plan hinzu.';

  @override
  String get strengthPrintPlanCommentHint => 'Optionaler Kommentar';

  @override
  String get strengthPrintPlanCommentSkip => 'Überspringen';

  @override
  String get strengthPrintPlanNoExercises => 'Dieser Plan enthält keine Übungen.';

  @override
  String strengthPrintPlanFailed(String message) {
    return 'Plan-PDF konnte nicht gedruckt werden: $message';
  }

  @override
  String strengthPrintJobStrengthPlan(String planName) {
    return 'mTORQUE Trainingsplan – $planName';
  }

  @override
  String strengthPrintPdfGeneratedAt(String date) {
    return 'Erstellt: $date';
  }

  @override
  String get strengthPrintPdfDate => 'Datum';

  @override
  String get strengthPrintPdfKg => 'kg';

  @override
  String get strengthPrintPdfReps => 'Wdh.';

  @override
  String strengthPrintPdfPageXOfY(int pageNumber, int pageCount) {
    return 'Seite $pageNumber von $pageCount';
  }

  @override
  String get strengthPlanEditorStructureTooltip => 'Planstruktur bearbeiten';

  @override
  String get strengthPlanEditorTitle => 'Planstruktur bearbeiten';

  @override
  String get strengthPlanEditorNoExercises => 'Dieser Plan enthält noch keine Übungen.';

  @override
  String get strengthPlanEditorCreateSuperset => 'Supersatz erstellen';

  @override
  String get strengthPlanEditorDissolveSuperset => 'Supersatz lösen';

  @override
  String get strengthPlanEditorDragHandleTooltip => 'Übung verschieben';

  @override
  String get strengthPlanEditorReplaceSupersetTitle => 'Bestehenden Supersatz ersetzen?';

  @override
  String get strengthPlanEditorReplaceSupersetMessage => 'Mindestens eine ausgewählte Übung ist bereits Teil eines Supersatzes. Beim Erstellen eines neuen Supersatzes wird die bisherige Zuordnung für die ausgewählten Übungen ersetzt.';

  @override
  String get strengthPlanEditorReplaceSupersetConfirm => 'Ersetzen';

  @override
  String get strengthCommonDone => 'Fertig';

  @override
  String get strengthPlanEditorOneSelected => '1 ausgewählt';

  @override
  String strengthPlanEditorMultipleSelected(int count) {
    return '$count ausgewählt';
  }
}
