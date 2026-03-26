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
  String get dashboardWeekLegendIntro =>
      'The dots below the weekdays indicate whether you trained strength, endurance, or both on that day.';

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
  String get dashboardQuoteOne =>
      'NEVER THROW IN THE TOWEL. USE IT TO WIPE OFF THE SWEAT. THEN KEEP GOING.';

  @override
  String get dashboardQuoteTwo =>
      'Discipline is choosing what you want most over what you want now.';

  @override
  String get dashboardQuoteThree =>
      'Small steps done consistently become big results.';

  @override
  String get dashboardQuoteFour =>
      'Motivation starts you. Routine carries you.';

  @override
  String get dashboardQuoteFive =>
      'Your future self will thank you for today’s effort.';

  @override
  String get dashboardShareQuoteDialogTitle => 'Share motivation';

  @override
  String get dashboardShareQuoteDialogMessage =>
      'Share this motivational quote with a friend.';

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
  String get streakInfoDescription =>
      'For every month in which you achieve your personal strength or endurance goals, you earn a star. You can adjust these goals in the corresponding dashboard tiles.';

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
  String get streakLevel5Months => '(5 months)';

  @override
  String get dashboardQuickStartTitle => 'Quick start';

  @override
  String get dashboardQuickStartStrengthSubtitle =>
      'Start your next strength session.';

  @override
  String get dashboardQuickStartEnduranceSubtitle =>
      'Open endurance with fallback tile.';

  @override
  String get dashboardGymKnowledgeTitle => 'GYM-Knowledge';

  @override
  String get dashboardGymKnowledgeSubtitle =>
      'Evidence-based content and practical insights.';

  @override
  String get dashboardYoutubeItemOneTitle => 'Muscle fatigue explained';

  @override
  String get dashboardYoutubeItemOneSubtitle =>
      'Foundations from exercise physiology.';

  @override
  String get dashboardYoutubeItemTwoTitle => 'Repeated Bout Effect';

  @override
  String get dashboardYoutubeItemTwoSubtitle =>
      'Why the same training hurts less later.';

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
}
