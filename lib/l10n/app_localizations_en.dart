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
  String get strengthPlaceholderDescription => 'Strength module placeholder for 1:1 migration.';

  @override
  String get endurancePlaceholderDescription => 'Endurance module placeholder for 1:1 migration.';

  @override
  String get statsPlaceholderDescription => 'Statistics module placeholder for 1:1 migration.';

  @override
  String get settingsPlaceholderDescription => 'Settings module placeholder for 1:1 migration.';

  @override
  String get weekdayMonShort => 'Mo.';

  @override
  String get weekdayTueShort => 'Tu.';

  @override
  String get weekdayWedShort => 'We.';

  @override
  String get weekdayThuShort => 'Th.';

  @override
  String get weekdayFriShort => 'Fr.';

  @override
  String get weekdaySatShort => 'Sa.';

  @override
  String get weekdaySunShort => 'Su.';

  @override
  String get dashboardWeekOverviewHint => 'Tap for more info';

  @override
  String get dashboardWeekLegendTitle => 'Week overview – legend';

  @override
  String get dashboardWeekLegendIntro => 'The dots below the weekdays indicate whether you trained strength, endurance, or both on that day.';

  @override
  String get dashboardWeekLegendStrength => 'Strength training';

  @override
  String get dashboardWeekLegendEndurance => 'Endurance training';

  @override
  String get dashboardWeekLegendBoth => 'Strength + endurance';

  @override
  String get dashboardWeekLegendNone => 'No training';

  @override
  String get dashboardMotivationTeaser => 'Need a push? Here’s today’s quote.';

  @override
  String get dashboardQuoteOne => 'NEVER THROW IN THE TOWEL. USE IT TO WIPE OFF THE SWEAT. THEN KEEP GOING.';

  @override
  String get dashboardQuoteTwo => 'Discipline is choosing what you want most over what you want now.';

  @override
  String get dashboardQuoteThree => 'Small steps done consistently become big results.';

  @override
  String get dashboardQuoteFour => 'Motivation starts you. Routine carries you.';

  @override
  String get dashboardQuoteFive => 'Your future self will thank you for today’s effort.';

  @override
  String get dashboardShareQuoteDialogTitle => 'Share motivation';

  @override
  String get dashboardShareQuoteDialogMessage => 'Share this motivational quote with a friend.';

  @override
  String get dashboardShareQuoteActionShare => 'Share';

  @override
  String get dashboardShareQuoteIntro => 'A friend thinks you should train.';

  @override
  String get dashboardShareQuoteCopied => 'Motivation copied to clipboard.';

  @override
  String get goalStrengthTitle => 'Set strength goal';

  @override
  String get goalEnduranceTitle => 'Set endurance goal';

  @override
  String get goalUnitsSessions => 'Sessions';

  @override
  String get goalUnitsSets => 'Sets';

  @override
  String get goalUnitsDistance => 'Distance';

  @override
  String get goalUnitsDuration => 'Duration';

  @override
  String get goalUnitsKm => 'km';

  @override
  String get goalUnitsMin => 'min';

  @override
  String get goalUnitsDistanceShort => 'km';

  @override
  String get goalUnitsDurationShort => 'min';

  @override
  String get goalInvalidNumber => 'Please enter a valid number > 0.';

  @override
  String get dashboardTapToEdit => 'Tap to edit';

  @override
  String get dashboardStepsTitle => 'Steps';

  @override
  String get dashboardStepsGoalDialogTitle => 'Edit step goal';

  @override
  String get dashboardStepsGoalDialogMessage => 'Set your daily step target.';

  @override
  String get dashboardStepsGoalInputHint => 'Steps per day';

  @override
  String get dashboardStepsGoalInvalid => 'Please enter a valid number.';

  @override
  String dashboardStepsGoalFormat(int value) {
    return 'Goal: $value';
  }

  @override
  String get dashboardStreaksTitle => 'Streaks';

  @override
  String get dashboardStreaksHint => 'Tap for more info';

  @override
  String dashboardMonthsShort(int value) {
    return '$value m';
  }

  @override
  String get streakInfoTitle => 'Star Rewards';

  @override
  String get streakInfoDescription => 'For every month in which you achieve your personal strength or endurance goals, you earn a star. You can adjust these goals in the corresponding dashboard tiles.';

  @override
  String get streakLevel1Title => 'Initial Adaptation';

  @override
  String get streakLevel1Months => '(1 month)';

  @override
  String get streakLevel2Title => 'Stable Habit Formation';

  @override
  String get streakLevel2Months => '(2 months)';

  @override
  String get streakLevel3Title => 'Consolidation Phase';

  @override
  String get streakLevel3Months => '(3 months)';

  @override
  String get streakLevel4Title => 'Long-Term Consistency';

  @override
  String get streakLevel4Months => '(4 months)';

  @override
  String get streakLevel5Title => 'High-Performance Adherence';

  @override
  String get streakLevel5Months => '(5+ months)';

  @override
  String get dashboardQuickStartTitle => 'Quick start';

  @override
  String get dashboardQuickStartStrengthSubtitle => 'Start your next strength session.';

  @override
  String get dashboardQuickStartEnduranceSubtitle => 'Open endurance with fallback tile.';

  @override
  String get dashboardGymKnowledgeTitle => 'GYM-Knowledge';

  @override
  String get dashboardGymKnowledgeSubtitle => 'Evidence-based content and practical insights.';

  @override
  String get dashboardYoutubeItemOneTitle => 'Muscle fatigue explained';

  @override
  String get dashboardYoutubeItemOneSubtitle => 'Foundations from exercise physiology.';

  @override
  String get dashboardYoutubeItemTwoTitle => 'Repeated Bout Effect';

  @override
  String get dashboardYoutubeItemTwoSubtitle => 'Why the same training hurts less later.';

  @override
  String get dashboardShareQuoteWatermark => 'mTORQUE App';

  @override
  String dashboardShareQuoteMessage(String quote) {
    return 'A friend thinks you should train.\n\n“$quote”\n\nGet mTORQUE:\nhttps://play.google.com/store/apps/details?id=app.mtorque';
  }

  @override
  String get dashboardShareQuoteFailed => 'Sharing failed.';

  @override
  String get dashboardYoutubeLoading => 'Loading videos…';

  @override
  String get dashboardYoutubeUnavailable => 'No videos available right now.';

  @override
  String get dashboardYoutubeTapToOpen => 'Tap to open on YouTube.';

  @override
  String get dashboardYoutubeOpenFailed => 'Could not open YouTube.';

  @override
  String get strengthStartEmptyPlan => 'Start empty plan';

  @override
  String get strengthAddExercise => 'Add exercise';

  @override
  String get strengthClosePlanTitle => 'Close plan';

  @override
  String get strengthClosePlanMessage => 'Save and close, discard, or continue editing?';

  @override
  String get strengthContinueEditing => 'Continue';

  @override
  String get strengthDiscard => 'Discard';

  @override
  String get strengthSaveAndClose => 'Save and close';

  @override
  String get strengthFinishSessionTitle => 'Finish session';

  @override
  String get strengthNotes => 'Notes';

  @override
  String get strengthFinishSessionMessage => 'Your training data will be saved when you finish this session.';

  @override
  String get strengthFinishSavePlanHint => 'If you also want to save the current exercise selection as a training plan, choose the plan option.';

  @override
  String get strengthFinishUpdatePlanHint => 'The current exercise selection differs from the saved plan. You can update the plan while saving this session.';

  @override
  String get strengthFinishSaveSessionOnly => 'Save session';

  @override
  String get strengthFinishSaveSessionAndSavePlan => 'Save session & save plan';

  @override
  String get strengthFinishSaveSessionAndUpdatePlan => 'Save session & update plan';

  @override
  String get strengthFinishDiscardWithoutSaving => 'End without saving';

  @override
  String get strengthFinishDiscardConfirmTitle => 'End training without saving?';

  @override
  String get strengthFinishDiscardConfirmMessage => 'Your entered training data will be discarded. This cannot be undone.';

  @override
  String get strengthFinishDiscardConfirmButton => 'End without saving';

  @override
  String get strengthCommonCancel => 'Cancel';

  @override
  String get strengthCommonDelete => 'Delete';

  @override
  String get strengthCommonShare => 'Share';

  @override
  String strengthSharePlanFailed(String error) {
    return 'Could not share training plan: $error';
  }

  @override
  String get strengthCommonSave => 'Save';

  @override
  String get strengthCommonOk => 'OK';

  @override
  String get strengthCommonKgLabel => 'kg';

  @override
  String get strengthCommonRepsShort => 'Reps';

  @override
  String get strengthCommonDurationShort => 'Sec';

  @override
  String get strengthExercisePickerSearchHint => 'Search (exercise name)';

  @override
  String get strengthExercisePickerFilter => 'Filter';

  @override
  String get strengthExercisePickerAdvanced => 'Advanced';

  @override
  String get strengthExercisePickerInvolvedMuscleLatin => 'Involved muscle (Latin)';

  @override
  String get strengthExercisePickerClearFilters => 'Clear filters';

  @override
  String get strengthExercisePickerPrimaryMuscleGroup => 'Primary muscle group';

  @override
  String get strengthExercisePickerInvolvedMuscle => 'Involved muscle';

  @override
  String get strengthExercisePickerBaseExercise => 'Base exercise';

  @override
  String get strengthExercisePickerDevice => 'Device';

  @override
  String get strengthExercisePickerAll => 'All';

  @override
  String get strengthExercisePickerResults => 'Results';

  @override
  String get strengthExercisePickerList => 'List';

  @override
  String get strengthExercisePickerImages => 'Images';

  @override
  String get strengthExercisePickerAdd => 'Add';

  @override
  String strengthExercisePickerAddCount(int count) {
    return 'Add ($count)';
  }

  @override
  String get strengthExercisePickerClearSelection => 'Clear selection';

  @override
  String get strengthExerciseAddSetButton => '+ Add set';

  @override
  String get strengthExerciseDeleteExerciseTitle => 'Delete exercise?';

  @override
  String get strengthExerciseDeleteExerciseMessage => 'Do you really want to remove this exercise from the session?';

  @override
  String get strengthExerciseMarkersTitle => 'Additional markers';

  @override
  String get strengthExerciseMarkerBfr => 'BFR training';

  @override
  String get strengthExerciseMarkerChain => 'Weight chains';

  @override
  String get strengthExerciseMarkerBands => 'Resistance bands';

  @override
  String get strengthExerciseMarkerSuperSlow => 'Super-slow';

  @override
  String get strengthExerciseBfrPressureLabel => 'BFR pressure';

  @override
  String strengthExerciseBfrValue(int value) {
    return '$value% of occlusion pressure';
  }

  @override
  String get strengthExerciseChainWeightLabel => 'Chain weight';

  @override
  String get strengthExerciseChainWeightHint => 'e.g. 10';

  @override
  String get strengthExerciseBandResistanceLabel => 'Band resistance';

  @override
  String get strengthExerciseBandResistanceHint => 'e.g. 20';

  @override
  String get strengthExerciseSuperSlowActiveLabel => 'Super-slow active';

  @override
  String get strengthExerciseSuperSlowHint => 'e.g. 5-5-5 or “very slow”';

  @override
  String get strengthExerciseDescriptionTitle => 'Exercise description';

  @override
  String get strengthExerciseNoDescriptionAvailable => 'No description available.';

  @override
  String get strengthExercisePrimaryMuscles => 'Primary muscles';

  @override
  String get strengthExerciseSecondaryMuscles => 'Secondary muscles';

  @override
  String get strengthExerciseNoMuscleDataAvailable => 'No muscle data available.';

  @override
  String get strengthExerciseNoStatsData => 'No data for this exercise yet.';

  @override
  String get strengthExerciseWeightLegend => 'Weight';

  @override
  String get strengthExerciseRepsLegend => 'Repetitions';

  @override
  String get strengthExerciseDurationLegend => 'Duration';

  @override
  String get strengthExerciseWeightAxis => 'Weight [kg]';

  @override
  String get strengthExerciseRepsAxis => 'Repetitions';

  @override
  String get strengthExerciseDurationAxis => 'Duration [s]';

  @override
  String get strengthExerciseOverallChip => 'Overall';

  @override
  String strengthExerciseSetChip(int number) {
    return 'Set $number';
  }

  @override
  String strengthExerciseTonnageLabel(double valueTons) {
    return '$valueTons t';
  }

  @override
  String get strengthExerciseMuscleZoomHint => 'Double tap to zoom';

  @override
  String strengthExerciseSupersetSubtitle(String group, int position, int total) {
    return 'Superset $group $position/$total';
  }

  @override
  String get muscleLabelFunction => 'Function';

  @override
  String get muscleLabelOrigin => 'Origin';

  @override
  String get muscleLabelInsertion => 'Insertion';

  @override
  String get muscleLabelInnervation => 'Innervation';

  @override
  String get strengthMenuStartEmptyPlan => 'Start with empty plan';

  @override
  String get strengthMenuCloseSession => 'Close session';

  @override
  String get strengthMenuSaveAsPlan => 'Save as plan...';

  @override
  String get strengthMenuEditTrainingPlan => 'Edit training plan';

  @override
  String get strengthMenuPrintPlanPdf => 'Print plan as PDF';

  @override
  String get strengthMenuAddExercise => 'Add exercise';

  @override
  String get strengthMenuLoadPlan => 'Load plan';

  @override
  String get strengthMenuRenamePlan => 'Rename plan';

  @override
  String get strengthMenuDeletePlan => 'Delete plan';

  @override
  String get strengthMenuSaveCurrentPlan => 'Save current plan';

  @override
  String get strengthEndSessionButton => 'Finish';

  @override
  String get strengthSessionTitle => 'Session';

  @override
  String get strengthPlanNameTitle => 'Plan name';

  @override
  String get strengthPlanNameHint => 'Enter name';

  @override
  String get strengthNoPlansAvailable => 'No plans available.';

  @override
  String get strengthReplaceCurrentSessionTitle => 'Replace current session?';

  @override
  String get strengthReplaceCurrentSessionMessage => 'This will discard and replace the current session.';

  @override
  String get strengthReplaceCurrentSessionButton => 'Replace';

  @override
  String get strengthDeletePlanTitle => 'Delete plan';

  @override
  String strengthDeletePlanMessage(String planName) {
    return 'Delete plan “$planName”?';
  }

  @override
  String get strengthPrintPlanPdfNotImplemented => 'Training plan PDF printing is not implemented in Flutter yet.';

  @override
  String get strengthTimerTitle => 'Timer';

  @override
  String get strengthTimerSecondsHint => 'sec';

  @override
  String get strengthTimerReset => 'Reset';

  @override
  String get strengthTimerRingHint => 'Ring: tap = start/stop';

  @override
  String get strengthTimerTapStop => 'Tap = stop';

  @override
  String get strengthTimerTapStartStop => 'Tap = start/stop';

  @override
  String get strengthTempoConcentric => 'Concentric';

  @override
  String get strengthTempoStatic => 'Static';

  @override
  String get strengthTempoEccentric => 'Eccentric';

  @override
  String get strengthPrintPlanSelectTitle => 'Select plan';

  @override
  String get strengthPrintPlanSetsTitle => 'Sets per exercise';

  @override
  String strengthPrintSetsOption(int sets) {
    return '$sets sets';
  }

  @override
  String get strengthPrintPlanCommentTitle => 'Comment';

  @override
  String get strengthPrintPlanCommentMessage => 'Add an optional comment for the printed plan.';

  @override
  String get strengthPrintPlanCommentHint => 'Optional comment';

  @override
  String get strengthPrintPlanCommentSkip => 'Skip';

  @override
  String get strengthPrintPlanNoExercises => 'This plan does not contain exercises.';

  @override
  String strengthPrintPlanFailed(String message) {
    return 'Could not print plan PDF: $message';
  }

  @override
  String strengthPrintJobStrengthPlan(String planName) {
    return 'mTORQUE strength plan – $planName';
  }

  @override
  String strengthPrintPdfGeneratedAt(String date) {
    return 'Generated: $date';
  }

  @override
  String get strengthPrintPdfDate => 'Date';

  @override
  String get strengthPrintPdfKg => 'kg';

  @override
  String get strengthPrintPdfReps => 'reps';

  @override
  String strengthPrintPdfPageXOfY(int pageNumber, int pageCount) {
    return 'Page $pageNumber of $pageCount';
  }

  @override
  String get strengthPlanEditorStructureTooltip => 'Edit plan structure';

  @override
  String get strengthPlanInfoTooltip => 'Show plan details';

  @override
  String get strengthPlanEditorTitle => 'Edit plan structure';

  @override
  String get strengthPlanEditorNoExercises => 'This plan does not contain exercises yet.';

  @override
  String get strengthPlanEditorCreateSuperset => 'Create superset';

  @override
  String get strengthPlanEditorDissolveSuperset => 'Dissolve superset';

  @override
  String get strengthPlanEditorDragHandleTooltip => 'Move exercise';

  @override
  String get strengthPlanEditorReplaceSupersetTitle => 'Replace existing superset?';

  @override
  String get strengthPlanEditorReplaceSupersetMessage => 'At least one selected exercise is already part of a superset. Creating a new superset will replace the previous assignment for the selected exercises.';

  @override
  String get strengthPlanEditorReplaceSupersetConfirm => 'Replace';

  @override
  String get strengthCommonDone => 'Done';

  @override
  String get strengthPlanEditorOneSelected => '1 selected';

  @override
  String strengthPlanEditorMultipleSelected(int count) {
    return '$count selected';
  }

  @override
  String get enduranceSportPickerTitle => 'Choose sport';

  @override
  String get enduranceOutdoorTitle => 'Outdoor';

  @override
  String get enduranceIndoorTitle => 'Indoor';

  @override
  String enduranceSportComingSoon(String sport) {
    return '$sport will be added in the next step.';
  }

  @override
  String get enduranceSportRun => 'Running';

  @override
  String get enduranceSportMountainBike => 'Mountain bike';

  @override
  String get enduranceSportRoadBike => 'Road cycling';

  @override
  String get enduranceSportRowingOutdoor => 'Rowing';

  @override
  String get enduranceSportWalking => 'Walking';

  @override
  String get enduranceSportNordicWalking => 'Nordic walking';

  @override
  String get enduranceSportInlineSkating => 'Inline skating';

  @override
  String get enduranceSportTreadmill => 'Treadmill';

  @override
  String get enduranceSportTreadmillWalking => 'Treadmill walking';

  @override
  String get enduranceSportErgometer => 'Bike ergometer';

  @override
  String get enduranceSportRower => 'Rower';

  @override
  String get enduranceSportSpinning => 'Spinning';

  @override
  String get enduranceSportCrosstrainer => 'Crosstrainer';

  @override
  String get enduranceSportStairclimber => 'Stair climber';

  @override
  String get enduranceSportStepper => 'Stepper';

  @override
  String get enduranceSportJumpRope => 'Jump rope';

  @override
  String get enduranceSportSkiErgometer => 'Ski ergometer';

  @override
  String get enduranceSportArmErgometer => 'Arm ergometer';

  @override
  String get enduranceSportAirBike => 'Air bike';

  @override
  String get enduranceIndoorComingSoon => 'Indoor endurance training will be added next. The database compatibility layer is already prepared.';

  @override
  String get enduranceOutdoorComingSoon => 'Outdoor tracking will be added next. The database compatibility layer is already prepared.';

  @override
  String get enduranceActiveSessionRestored => 'Active endurance session restored.';

  @override
  String get enduranceStartSession => 'Start session';

  @override
  String get enduranceDiscardSession => 'Discard session';

  @override
  String get enduranceSessionActive => 'Session active';

  @override
  String get enduranceSessionPaused => 'Session paused';

  @override
  String get enduranceSessionNotStarted => 'Session not started';

  @override
  String get endurancePauseSession => 'Pause';

  @override
  String get enduranceResumeSession => 'Resume';

  @override
  String get enduranceIndoorProtocolTitle => 'Indoor protocol';

  @override
  String get enduranceIndoorProtocolDuration => 'Duration';

  @override
  String enduranceIndoorProtocolPhaseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phases',
      one: '1 phase',
    );
    return '$_temp0';
  }

  @override
  String get enduranceAxisSpeed => 'Speed';

  @override
  String get enduranceAxisPower => 'Power';

  @override
  String get enduranceAxisLevel => 'Level';

  @override
  String get enduranceAxisIncline => 'Incline';

  @override
  String get enduranceAxisIntensity => 'Intensity';

  @override
  String get enduranceIndoorCompatibilityHint => 'Indoor sessions are stored in the Android-compatible run_session table. Interval settings are saved as indoor_settings_json.';

  @override
  String get enduranceOperationFailed => 'The operation could not be completed.';

  @override
  String get enduranceLoadPlan => 'Load plan';

  @override
  String get enduranceSelectedPhase => 'Selected phase';

  @override
  String get enduranceFinishSession => 'Finish session';

  @override
  String get enduranceRpeLabel => 'Perceived exertion';

  @override
  String get enduranceRpeHint => 'RPE 0–10';

  @override
  String get enduranceRpeNotSet => 'Not set';

  @override
  String get enduranceNotesLabel => 'Notes';

  @override
  String get enduranceDiscardSessionMessage => 'Discard this active session? This will delete it permanently.';

  @override
  String enduranceCurrentPhase(int current, int total) {
    return 'Phase $current of $total';
  }

  @override
  String endurancePhaseRemaining(String time) {
    return '$time remaining';
  }

  @override
  String get enduranceProtocolCompleted => 'Protocol completed';

  @override
  String get enduranceProtocolTargetReached => 'Target reached';
}
