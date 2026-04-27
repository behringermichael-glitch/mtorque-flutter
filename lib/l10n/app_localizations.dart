import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'mTORQUE'**
  String get appName;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get navStrength;

  /// No description provided for @navEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get navEndurance;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @strengthPlaceholderDescription.
  ///
  /// In en, this message translates to:
  /// **'Strength module placeholder for 1:1 migration.'**
  String get strengthPlaceholderDescription;

  /// No description provided for @endurancePlaceholderDescription.
  ///
  /// In en, this message translates to:
  /// **'Endurance module placeholder for 1:1 migration.'**
  String get endurancePlaceholderDescription;

  /// No description provided for @statsPlaceholderDescription.
  ///
  /// In en, this message translates to:
  /// **'Statistics module placeholder for 1:1 migration.'**
  String get statsPlaceholderDescription;

  /// No description provided for @settingsPlaceholderDescription.
  ///
  /// In en, this message translates to:
  /// **'Settings module placeholder for 1:1 migration.'**
  String get settingsPlaceholderDescription;

  /// No description provided for @weekdayMonShort.
  ///
  /// In en, this message translates to:
  /// **'Mo.'**
  String get weekdayMonShort;

  /// No description provided for @weekdayTueShort.
  ///
  /// In en, this message translates to:
  /// **'Tu.'**
  String get weekdayTueShort;

  /// No description provided for @weekdayWedShort.
  ///
  /// In en, this message translates to:
  /// **'We.'**
  String get weekdayWedShort;

  /// No description provided for @weekdayThuShort.
  ///
  /// In en, this message translates to:
  /// **'Th.'**
  String get weekdayThuShort;

  /// No description provided for @weekdayFriShort.
  ///
  /// In en, this message translates to:
  /// **'Fr.'**
  String get weekdayFriShort;

  /// No description provided for @weekdaySatShort.
  ///
  /// In en, this message translates to:
  /// **'Sa.'**
  String get weekdaySatShort;

  /// No description provided for @weekdaySunShort.
  ///
  /// In en, this message translates to:
  /// **'Su.'**
  String get weekdaySunShort;

  /// No description provided for @dashboardWeekOverviewHint.
  ///
  /// In en, this message translates to:
  /// **'Tap for more info'**
  String get dashboardWeekOverviewHint;

  /// No description provided for @dashboardWeekLegendTitle.
  ///
  /// In en, this message translates to:
  /// **'Week overview – legend'**
  String get dashboardWeekLegendTitle;

  /// No description provided for @dashboardWeekLegendIntro.
  ///
  /// In en, this message translates to:
  /// **'The dots below the weekdays indicate whether you trained strength, endurance, or both on that day.'**
  String get dashboardWeekLegendIntro;

  /// No description provided for @dashboardWeekLegendStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength training'**
  String get dashboardWeekLegendStrength;

  /// No description provided for @dashboardWeekLegendEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance training'**
  String get dashboardWeekLegendEndurance;

  /// No description provided for @dashboardWeekLegendBoth.
  ///
  /// In en, this message translates to:
  /// **'Strength + endurance'**
  String get dashboardWeekLegendBoth;

  /// No description provided for @dashboardWeekLegendNone.
  ///
  /// In en, this message translates to:
  /// **'No training'**
  String get dashboardWeekLegendNone;

  /// No description provided for @dashboardMotivationTeaser.
  ///
  /// In en, this message translates to:
  /// **'Need a push? Here’s today’s quote.'**
  String get dashboardMotivationTeaser;

  /// No description provided for @dashboardQuoteOne.
  ///
  /// In en, this message translates to:
  /// **'NEVER THROW IN THE TOWEL. USE IT TO WIPE OFF THE SWEAT. THEN KEEP GOING.'**
  String get dashboardQuoteOne;

  /// No description provided for @dashboardQuoteTwo.
  ///
  /// In en, this message translates to:
  /// **'Discipline is choosing what you want most over what you want now.'**
  String get dashboardQuoteTwo;

  /// No description provided for @dashboardQuoteThree.
  ///
  /// In en, this message translates to:
  /// **'Small steps done consistently become big results.'**
  String get dashboardQuoteThree;

  /// No description provided for @dashboardQuoteFour.
  ///
  /// In en, this message translates to:
  /// **'Motivation starts you. Routine carries you.'**
  String get dashboardQuoteFour;

  /// No description provided for @dashboardQuoteFive.
  ///
  /// In en, this message translates to:
  /// **'Your future self will thank you for today’s effort.'**
  String get dashboardQuoteFive;

  /// No description provided for @dashboardShareQuoteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Share motivation'**
  String get dashboardShareQuoteDialogTitle;

  /// No description provided for @dashboardShareQuoteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Share this motivational quote with a friend.'**
  String get dashboardShareQuoteDialogMessage;

  /// No description provided for @dashboardShareQuoteActionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get dashboardShareQuoteActionShare;

  /// No description provided for @dashboardShareQuoteIntro.
  ///
  /// In en, this message translates to:
  /// **'A friend thinks you should train.'**
  String get dashboardShareQuoteIntro;

  /// No description provided for @dashboardShareQuoteCopied.
  ///
  /// In en, this message translates to:
  /// **'Motivation copied to clipboard.'**
  String get dashboardShareQuoteCopied;

  /// No description provided for @goalStrengthTitle.
  ///
  /// In en, this message translates to:
  /// **'Set strength goal'**
  String get goalStrengthTitle;

  /// No description provided for @goalEnduranceTitle.
  ///
  /// In en, this message translates to:
  /// **'Set endurance goal'**
  String get goalEnduranceTitle;

  /// No description provided for @goalUnitsSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get goalUnitsSessions;

  /// No description provided for @goalUnitsSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get goalUnitsSets;

  /// No description provided for @goalUnitsDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get goalUnitsDistance;

  /// No description provided for @goalUnitsDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get goalUnitsDuration;

  /// No description provided for @goalUnitsKm.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get goalUnitsKm;

  /// No description provided for @goalUnitsMin.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get goalUnitsMin;

  /// No description provided for @goalUnitsDistanceShort.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get goalUnitsDistanceShort;

  /// No description provided for @goalUnitsDurationShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get goalUnitsDurationShort;

  /// No description provided for @goalInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number > 0.'**
  String get goalInvalidNumber;

  /// No description provided for @dashboardTapToEdit.
  ///
  /// In en, this message translates to:
  /// **'Tap to edit'**
  String get dashboardTapToEdit;

  /// No description provided for @dashboardStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get dashboardStepsTitle;

  /// No description provided for @dashboardStepsGoalDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit step goal'**
  String get dashboardStepsGoalDialogTitle;

  /// No description provided for @dashboardStepsGoalDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Set your daily step target.'**
  String get dashboardStepsGoalDialogMessage;

  /// No description provided for @dashboardStepsGoalInputHint.
  ///
  /// In en, this message translates to:
  /// **'Steps per day'**
  String get dashboardStepsGoalInputHint;

  /// No description provided for @dashboardStepsGoalInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number.'**
  String get dashboardStepsGoalInvalid;

  /// No description provided for @dashboardStepsGoalFormat.
  ///
  /// In en, this message translates to:
  /// **'Goal: {value}'**
  String dashboardStepsGoalFormat(int value);

  /// No description provided for @dashboardStreaksTitle.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get dashboardStreaksTitle;

  /// No description provided for @dashboardStreaksHint.
  ///
  /// In en, this message translates to:
  /// **'Tap for more info'**
  String get dashboardStreaksHint;

  /// No description provided for @dashboardMonthsShort.
  ///
  /// In en, this message translates to:
  /// **'{value} m'**
  String dashboardMonthsShort(int value);

  /// No description provided for @streakInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Star Rewards'**
  String get streakInfoTitle;

  /// No description provided for @streakInfoDescription.
  ///
  /// In en, this message translates to:
  /// **'For every month in which you achieve your personal strength or endurance goals, you earn a star. You can adjust these goals in the corresponding dashboard tiles.'**
  String get streakInfoDescription;

  /// No description provided for @streakLevel1Title.
  ///
  /// In en, this message translates to:
  /// **'Initial Adaptation'**
  String get streakLevel1Title;

  /// No description provided for @streakLevel1Months.
  ///
  /// In en, this message translates to:
  /// **'(1 month)'**
  String get streakLevel1Months;

  /// No description provided for @streakLevel2Title.
  ///
  /// In en, this message translates to:
  /// **'Stable Habit Formation'**
  String get streakLevel2Title;

  /// No description provided for @streakLevel2Months.
  ///
  /// In en, this message translates to:
  /// **'(2 months)'**
  String get streakLevel2Months;

  /// No description provided for @streakLevel3Title.
  ///
  /// In en, this message translates to:
  /// **'Consolidation Phase'**
  String get streakLevel3Title;

  /// No description provided for @streakLevel3Months.
  ///
  /// In en, this message translates to:
  /// **'(3 months)'**
  String get streakLevel3Months;

  /// No description provided for @streakLevel4Title.
  ///
  /// In en, this message translates to:
  /// **'Long-Term Consistency'**
  String get streakLevel4Title;

  /// No description provided for @streakLevel4Months.
  ///
  /// In en, this message translates to:
  /// **'(4 months)'**
  String get streakLevel4Months;

  /// No description provided for @streakLevel5Title.
  ///
  /// In en, this message translates to:
  /// **'High-Performance Adherence'**
  String get streakLevel5Title;

  /// No description provided for @streakLevel5Months.
  ///
  /// In en, this message translates to:
  /// **'(5+ months)'**
  String get streakLevel5Months;

  /// No description provided for @dashboardQuickStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick start'**
  String get dashboardQuickStartTitle;

  /// No description provided for @dashboardQuickStartStrengthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your next strength session.'**
  String get dashboardQuickStartStrengthSubtitle;

  /// No description provided for @dashboardQuickStartEnduranceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open endurance with fallback tile.'**
  String get dashboardQuickStartEnduranceSubtitle;

  /// No description provided for @dashboardGymKnowledgeTitle.
  ///
  /// In en, this message translates to:
  /// **'GYM-Knowledge'**
  String get dashboardGymKnowledgeTitle;

  /// No description provided for @dashboardGymKnowledgeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Evidence-based content and practical insights.'**
  String get dashboardGymKnowledgeSubtitle;

  /// No description provided for @dashboardYoutubeItemOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Muscle fatigue explained'**
  String get dashboardYoutubeItemOneTitle;

  /// No description provided for @dashboardYoutubeItemOneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Foundations from exercise physiology.'**
  String get dashboardYoutubeItemOneSubtitle;

  /// No description provided for @dashboardYoutubeItemTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'Repeated Bout Effect'**
  String get dashboardYoutubeItemTwoTitle;

  /// No description provided for @dashboardYoutubeItemTwoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Why the same training hurts less later.'**
  String get dashboardYoutubeItemTwoSubtitle;

  /// No description provided for @dashboardShareQuoteWatermark.
  ///
  /// In en, this message translates to:
  /// **'mTORQUE App'**
  String get dashboardShareQuoteWatermark;

  /// No description provided for @dashboardShareQuoteMessage.
  ///
  /// In en, this message translates to:
  /// **'A friend thinks you should train.\n\n“{quote}”\n\nGet mTORQUE:\nhttps://play.google.com/store/apps/details?id=app.mtorque'**
  String dashboardShareQuoteMessage(String quote);

  /// No description provided for @dashboardShareQuoteFailed.
  ///
  /// In en, this message translates to:
  /// **'Sharing failed.'**
  String get dashboardShareQuoteFailed;

  /// No description provided for @dashboardYoutubeLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading videos…'**
  String get dashboardYoutubeLoading;

  /// No description provided for @dashboardYoutubeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No videos available right now.'**
  String get dashboardYoutubeUnavailable;

  /// No description provided for @dashboardYoutubeTapToOpen.
  ///
  /// In en, this message translates to:
  /// **'Tap to open on YouTube.'**
  String get dashboardYoutubeTapToOpen;

  /// No description provided for @dashboardYoutubeOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open YouTube.'**
  String get dashboardYoutubeOpenFailed;

  /// No description provided for @strengthStartEmptyPlan.
  ///
  /// In en, this message translates to:
  /// **'Start empty plan'**
  String get strengthStartEmptyPlan;

  /// No description provided for @strengthAddExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get strengthAddExercise;

  /// No description provided for @strengthClosePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Close plan'**
  String get strengthClosePlanTitle;

  /// No description provided for @strengthClosePlanMessage.
  ///
  /// In en, this message translates to:
  /// **'Save and close, discard, or continue editing?'**
  String get strengthClosePlanMessage;

  /// No description provided for @strengthContinueEditing.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get strengthContinueEditing;

  /// No description provided for @strengthDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get strengthDiscard;

  /// No description provided for @strengthSaveAndClose.
  ///
  /// In en, this message translates to:
  /// **'Save and close'**
  String get strengthSaveAndClose;

  /// No description provided for @strengthFinishSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish session'**
  String get strengthFinishSessionTitle;

  /// No description provided for @strengthNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get strengthNotes;

  /// No description provided for @strengthFinishSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Your training data will be saved when you finish this session.'**
  String get strengthFinishSessionMessage;

  /// No description provided for @strengthFinishSavePlanHint.
  ///
  /// In en, this message translates to:
  /// **'If you also want to save the current exercise selection as a training plan, choose the plan option.'**
  String get strengthFinishSavePlanHint;

  /// No description provided for @strengthFinishUpdatePlanHint.
  ///
  /// In en, this message translates to:
  /// **'The current exercise selection differs from the saved plan. You can update the plan while saving this session.'**
  String get strengthFinishUpdatePlanHint;

  /// No description provided for @strengthFinishSaveSessionOnly.
  ///
  /// In en, this message translates to:
  /// **'Save session'**
  String get strengthFinishSaveSessionOnly;

  /// No description provided for @strengthFinishSaveSessionAndSavePlan.
  ///
  /// In en, this message translates to:
  /// **'Save session & save plan'**
  String get strengthFinishSaveSessionAndSavePlan;

  /// No description provided for @strengthFinishSaveSessionAndUpdatePlan.
  ///
  /// In en, this message translates to:
  /// **'Save session & update plan'**
  String get strengthFinishSaveSessionAndUpdatePlan;

  /// No description provided for @strengthFinishDiscardWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'End without saving'**
  String get strengthFinishDiscardWithoutSaving;

  /// No description provided for @strengthFinishDiscardConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'End training without saving?'**
  String get strengthFinishDiscardConfirmTitle;

  /// No description provided for @strengthFinishDiscardConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Your entered training data will be discarded. This cannot be undone.'**
  String get strengthFinishDiscardConfirmMessage;

  /// No description provided for @strengthFinishDiscardConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'End without saving'**
  String get strengthFinishDiscardConfirmButton;

  /// No description provided for @strengthCommonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get strengthCommonCancel;

  /// No description provided for @strengthCommonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get strengthCommonDelete;

  /// No description provided for @strengthCommonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get strengthCommonShare;

  /// No description provided for @strengthSharePlanFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not share training plan: {error}'**
  String strengthSharePlanFailed(String error);

  /// No description provided for @strengthCommonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get strengthCommonSave;

  /// No description provided for @strengthCommonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get strengthCommonOk;

  /// No description provided for @strengthCommonKgLabel.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get strengthCommonKgLabel;

  /// No description provided for @strengthCommonRepsShort.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get strengthCommonRepsShort;

  /// No description provided for @strengthCommonDurationShort.
  ///
  /// In en, this message translates to:
  /// **'Sec'**
  String get strengthCommonDurationShort;

  /// No description provided for @strengthExercisePickerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search (exercise name)'**
  String get strengthExercisePickerSearchHint;

  /// No description provided for @strengthExercisePickerFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get strengthExercisePickerFilter;

  /// No description provided for @strengthExercisePickerAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get strengthExercisePickerAdvanced;

  /// No description provided for @strengthExercisePickerInvolvedMuscleLatin.
  ///
  /// In en, this message translates to:
  /// **'Involved muscle (Latin)'**
  String get strengthExercisePickerInvolvedMuscleLatin;

  /// No description provided for @strengthExercisePickerClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get strengthExercisePickerClearFilters;

  /// No description provided for @strengthExercisePickerPrimaryMuscleGroup.
  ///
  /// In en, this message translates to:
  /// **'Primary muscle group'**
  String get strengthExercisePickerPrimaryMuscleGroup;

  /// No description provided for @strengthExercisePickerInvolvedMuscle.
  ///
  /// In en, this message translates to:
  /// **'Involved muscle'**
  String get strengthExercisePickerInvolvedMuscle;

  /// No description provided for @strengthExercisePickerBaseExercise.
  ///
  /// In en, this message translates to:
  /// **'Base exercise'**
  String get strengthExercisePickerBaseExercise;

  /// No description provided for @strengthExercisePickerDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get strengthExercisePickerDevice;

  /// No description provided for @strengthExercisePickerAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get strengthExercisePickerAll;

  /// No description provided for @strengthExercisePickerResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get strengthExercisePickerResults;

  /// No description provided for @strengthExercisePickerList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get strengthExercisePickerList;

  /// No description provided for @strengthExercisePickerImages.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get strengthExercisePickerImages;

  /// No description provided for @strengthExercisePickerAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get strengthExercisePickerAdd;

  /// No description provided for @strengthExercisePickerAddCount.
  ///
  /// In en, this message translates to:
  /// **'Add ({count})'**
  String strengthExercisePickerAddCount(int count);

  /// No description provided for @strengthExercisePickerClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get strengthExercisePickerClearSelection;

  /// No description provided for @strengthExerciseAddSetButton.
  ///
  /// In en, this message translates to:
  /// **'+ Add set'**
  String get strengthExerciseAddSetButton;

  /// No description provided for @strengthExerciseDeleteExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete exercise?'**
  String get strengthExerciseDeleteExerciseTitle;

  /// No description provided for @strengthExerciseDeleteExerciseMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to remove this exercise from the session?'**
  String get strengthExerciseDeleteExerciseMessage;

  /// No description provided for @strengthExerciseMarkersTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional markers'**
  String get strengthExerciseMarkersTitle;

  /// No description provided for @strengthExerciseMarkerBfr.
  ///
  /// In en, this message translates to:
  /// **'BFR training'**
  String get strengthExerciseMarkerBfr;

  /// No description provided for @strengthExerciseMarkerChain.
  ///
  /// In en, this message translates to:
  /// **'Weight chains'**
  String get strengthExerciseMarkerChain;

  /// No description provided for @strengthExerciseMarkerBands.
  ///
  /// In en, this message translates to:
  /// **'Resistance bands'**
  String get strengthExerciseMarkerBands;

  /// No description provided for @strengthExerciseMarkerSuperSlow.
  ///
  /// In en, this message translates to:
  /// **'Super-slow'**
  String get strengthExerciseMarkerSuperSlow;

  /// No description provided for @strengthExerciseBfrPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'BFR pressure'**
  String get strengthExerciseBfrPressureLabel;

  /// No description provided for @strengthExerciseBfrValue.
  ///
  /// In en, this message translates to:
  /// **'{value}% of occlusion pressure'**
  String strengthExerciseBfrValue(int value);

  /// No description provided for @strengthExerciseChainWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Chain weight'**
  String get strengthExerciseChainWeightLabel;

  /// No description provided for @strengthExerciseChainWeightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10'**
  String get strengthExerciseChainWeightHint;

  /// No description provided for @strengthExerciseBandResistanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Band resistance'**
  String get strengthExerciseBandResistanceLabel;

  /// No description provided for @strengthExerciseBandResistanceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 20'**
  String get strengthExerciseBandResistanceHint;

  /// No description provided for @strengthExerciseSuperSlowActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Super-slow active'**
  String get strengthExerciseSuperSlowActiveLabel;

  /// No description provided for @strengthExerciseSuperSlowHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5-5-5 or “very slow”'**
  String get strengthExerciseSuperSlowHint;

  /// No description provided for @strengthExerciseDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise description'**
  String get strengthExerciseDescriptionTitle;

  /// No description provided for @strengthExerciseNoDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get strengthExerciseNoDescriptionAvailable;

  /// No description provided for @strengthExercisePrimaryMuscles.
  ///
  /// In en, this message translates to:
  /// **'Primary muscles'**
  String get strengthExercisePrimaryMuscles;

  /// No description provided for @strengthExerciseSecondaryMuscles.
  ///
  /// In en, this message translates to:
  /// **'Secondary muscles'**
  String get strengthExerciseSecondaryMuscles;

  /// No description provided for @strengthExerciseNoMuscleDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No muscle data available.'**
  String get strengthExerciseNoMuscleDataAvailable;

  /// No description provided for @strengthExerciseNoStatsData.
  ///
  /// In en, this message translates to:
  /// **'No data for this exercise yet.'**
  String get strengthExerciseNoStatsData;

  /// No description provided for @strengthExerciseWeightLegend.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get strengthExerciseWeightLegend;

  /// No description provided for @strengthExerciseRepsLegend.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get strengthExerciseRepsLegend;

  /// No description provided for @strengthExerciseDurationLegend.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get strengthExerciseDurationLegend;

  /// No description provided for @strengthExerciseWeightAxis.
  ///
  /// In en, this message translates to:
  /// **'Weight [kg]'**
  String get strengthExerciseWeightAxis;

  /// No description provided for @strengthExerciseRepsAxis.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get strengthExerciseRepsAxis;

  /// No description provided for @strengthExerciseDurationAxis.
  ///
  /// In en, this message translates to:
  /// **'Duration [s]'**
  String get strengthExerciseDurationAxis;

  /// No description provided for @strengthExerciseOverallChip.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get strengthExerciseOverallChip;

  /// No description provided for @strengthExerciseSetChip.
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String strengthExerciseSetChip(int number);

  /// No description provided for @strengthExerciseTonnageLabel.
  ///
  /// In en, this message translates to:
  /// **'{valueTons} t'**
  String strengthExerciseTonnageLabel(double valueTons);

  /// No description provided for @strengthExerciseMuscleZoomHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to zoom'**
  String get strengthExerciseMuscleZoomHint;

  /// No description provided for @strengthExerciseSupersetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Superset {group} {position}/{total}'**
  String strengthExerciseSupersetSubtitle(String group, int position, int total);

  /// No description provided for @muscleLabelFunction.
  ///
  /// In en, this message translates to:
  /// **'Function'**
  String get muscleLabelFunction;

  /// No description provided for @muscleLabelOrigin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get muscleLabelOrigin;

  /// No description provided for @muscleLabelInsertion.
  ///
  /// In en, this message translates to:
  /// **'Insertion'**
  String get muscleLabelInsertion;

  /// No description provided for @muscleLabelInnervation.
  ///
  /// In en, this message translates to:
  /// **'Innervation'**
  String get muscleLabelInnervation;

  /// No description provided for @strengthMenuStartEmptyPlan.
  ///
  /// In en, this message translates to:
  /// **'Start with empty plan'**
  String get strengthMenuStartEmptyPlan;

  /// No description provided for @strengthMenuCloseSession.
  ///
  /// In en, this message translates to:
  /// **'Close session'**
  String get strengthMenuCloseSession;

  /// No description provided for @strengthMenuSaveAsPlan.
  ///
  /// In en, this message translates to:
  /// **'Save as plan...'**
  String get strengthMenuSaveAsPlan;

  /// No description provided for @strengthMenuEditTrainingPlan.
  ///
  /// In en, this message translates to:
  /// **'Edit training plan'**
  String get strengthMenuEditTrainingPlan;

  /// No description provided for @strengthMenuPrintPlanPdf.
  ///
  /// In en, this message translates to:
  /// **'Print plan as PDF'**
  String get strengthMenuPrintPlanPdf;

  /// No description provided for @strengthMenuAddExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get strengthMenuAddExercise;

  /// No description provided for @strengthMenuLoadPlan.
  ///
  /// In en, this message translates to:
  /// **'Load plan'**
  String get strengthMenuLoadPlan;

  /// No description provided for @strengthMenuRenamePlan.
  ///
  /// In en, this message translates to:
  /// **'Rename plan'**
  String get strengthMenuRenamePlan;

  /// No description provided for @strengthMenuDeletePlan.
  ///
  /// In en, this message translates to:
  /// **'Delete plan'**
  String get strengthMenuDeletePlan;

  /// No description provided for @strengthMenuSaveCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Save current plan'**
  String get strengthMenuSaveCurrentPlan;

  /// No description provided for @strengthEndSessionButton.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get strengthEndSessionButton;

  /// No description provided for @strengthSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get strengthSessionTitle;

  /// No description provided for @strengthPlanNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan name'**
  String get strengthPlanNameTitle;

  /// No description provided for @strengthPlanNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get strengthPlanNameHint;

  /// No description provided for @strengthNoPlansAvailable.
  ///
  /// In en, this message translates to:
  /// **'No plans available.'**
  String get strengthNoPlansAvailable;

  /// No description provided for @strengthReplaceCurrentSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace current session?'**
  String get strengthReplaceCurrentSessionTitle;

  /// No description provided for @strengthReplaceCurrentSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'This will discard and replace the current session.'**
  String get strengthReplaceCurrentSessionMessage;

  /// No description provided for @strengthReplaceCurrentSessionButton.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get strengthReplaceCurrentSessionButton;

  /// No description provided for @strengthDeletePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete plan'**
  String get strengthDeletePlanTitle;

  /// No description provided for @strengthDeletePlanMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete plan “{planName}”?'**
  String strengthDeletePlanMessage(String planName);

  /// No description provided for @strengthPrintPlanPdfNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Training plan PDF printing is not implemented in Flutter yet.'**
  String get strengthPrintPlanPdfNotImplemented;

  /// No description provided for @strengthTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get strengthTimerTitle;

  /// No description provided for @strengthTimerSecondsHint.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get strengthTimerSecondsHint;

  /// No description provided for @strengthTimerReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get strengthTimerReset;

  /// No description provided for @strengthTimerRingHint.
  ///
  /// In en, this message translates to:
  /// **'Ring: tap = start/stop'**
  String get strengthTimerRingHint;

  /// No description provided for @strengthTimerTapStop.
  ///
  /// In en, this message translates to:
  /// **'Tap = stop'**
  String get strengthTimerTapStop;

  /// No description provided for @strengthTimerTapStartStop.
  ///
  /// In en, this message translates to:
  /// **'Tap = start/stop'**
  String get strengthTimerTapStartStop;

  /// No description provided for @strengthTempoConcentric.
  ///
  /// In en, this message translates to:
  /// **'Concentric'**
  String get strengthTempoConcentric;

  /// No description provided for @strengthTempoStatic.
  ///
  /// In en, this message translates to:
  /// **'Static'**
  String get strengthTempoStatic;

  /// No description provided for @strengthTempoEccentric.
  ///
  /// In en, this message translates to:
  /// **'Eccentric'**
  String get strengthTempoEccentric;

  /// No description provided for @strengthPrintPlanSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select plan'**
  String get strengthPrintPlanSelectTitle;

  /// No description provided for @strengthPrintPlanSetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sets per exercise'**
  String get strengthPrintPlanSetsTitle;

  /// No description provided for @strengthPrintSetsOption.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets'**
  String strengthPrintSetsOption(int sets);

  /// No description provided for @strengthPrintPlanCommentTitle.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get strengthPrintPlanCommentTitle;

  /// No description provided for @strengthPrintPlanCommentMessage.
  ///
  /// In en, this message translates to:
  /// **'Add an optional comment for the printed plan.'**
  String get strengthPrintPlanCommentMessage;

  /// No description provided for @strengthPrintPlanCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Optional comment'**
  String get strengthPrintPlanCommentHint;

  /// No description provided for @strengthPrintPlanCommentSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get strengthPrintPlanCommentSkip;

  /// No description provided for @strengthPrintPlanNoExercises.
  ///
  /// In en, this message translates to:
  /// **'This plan does not contain exercises.'**
  String get strengthPrintPlanNoExercises;

  /// No description provided for @strengthPrintPlanFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not print plan PDF: {message}'**
  String strengthPrintPlanFailed(String message);

  /// No description provided for @strengthPrintJobStrengthPlan.
  ///
  /// In en, this message translates to:
  /// **'mTORQUE strength plan – {planName}'**
  String strengthPrintJobStrengthPlan(String planName);

  /// No description provided for @strengthPrintPdfGeneratedAt.
  ///
  /// In en, this message translates to:
  /// **'Generated: {date}'**
  String strengthPrintPdfGeneratedAt(String date);

  /// No description provided for @strengthPrintPdfDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get strengthPrintPdfDate;

  /// No description provided for @strengthPrintPdfKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get strengthPrintPdfKg;

  /// No description provided for @strengthPrintPdfReps.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get strengthPrintPdfReps;

  /// No description provided for @strengthPrintPdfPageXOfY.
  ///
  /// In en, this message translates to:
  /// **'Page {pageNumber} of {pageCount}'**
  String strengthPrintPdfPageXOfY(int pageNumber, int pageCount);

  /// No description provided for @strengthPlanEditorStructureTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit plan structure'**
  String get strengthPlanEditorStructureTooltip;

  /// No description provided for @strengthPlanInfoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show plan details'**
  String get strengthPlanInfoTooltip;

  /// No description provided for @strengthPlanEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit plan structure'**
  String get strengthPlanEditorTitle;

  /// No description provided for @strengthPlanEditorNoExercises.
  ///
  /// In en, this message translates to:
  /// **'This plan does not contain exercises yet.'**
  String get strengthPlanEditorNoExercises;

  /// No description provided for @strengthPlanEditorCreateSuperset.
  ///
  /// In en, this message translates to:
  /// **'Create superset'**
  String get strengthPlanEditorCreateSuperset;

  /// No description provided for @strengthPlanEditorDissolveSuperset.
  ///
  /// In en, this message translates to:
  /// **'Dissolve superset'**
  String get strengthPlanEditorDissolveSuperset;

  /// No description provided for @strengthPlanEditorDragHandleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Move exercise'**
  String get strengthPlanEditorDragHandleTooltip;

  /// No description provided for @strengthPlanEditorReplaceSupersetTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace existing superset?'**
  String get strengthPlanEditorReplaceSupersetTitle;

  /// No description provided for @strengthPlanEditorReplaceSupersetMessage.
  ///
  /// In en, this message translates to:
  /// **'At least one selected exercise is already part of a superset. Creating a new superset will replace the previous assignment for the selected exercises.'**
  String get strengthPlanEditorReplaceSupersetMessage;

  /// No description provided for @strengthPlanEditorReplaceSupersetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get strengthPlanEditorReplaceSupersetConfirm;

  /// No description provided for @strengthCommonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get strengthCommonDone;

  /// No description provided for @strengthPlanEditorOneSelected.
  ///
  /// In en, this message translates to:
  /// **'1 selected'**
  String get strengthPlanEditorOneSelected;

  /// No description provided for @strengthPlanEditorMultipleSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String strengthPlanEditorMultipleSelected(int count);

  /// No description provided for @enduranceSportPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose sport'**
  String get enduranceSportPickerTitle;

  /// No description provided for @enduranceOutdoorTitle.
  ///
  /// In en, this message translates to:
  /// **'Outdoor'**
  String get enduranceOutdoorTitle;

  /// No description provided for @enduranceIndoorTitle.
  ///
  /// In en, this message translates to:
  /// **'Indoor'**
  String get enduranceIndoorTitle;

  /// No description provided for @enduranceSportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{sport} will be added in the next step.'**
  String enduranceSportComingSoon(String sport);

  /// No description provided for @enduranceSportRun.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get enduranceSportRun;

  /// No description provided for @enduranceSportMountainBike.
  ///
  /// In en, this message translates to:
  /// **'Mountain bike'**
  String get enduranceSportMountainBike;

  /// No description provided for @enduranceSportRoadBike.
  ///
  /// In en, this message translates to:
  /// **'Road cycling'**
  String get enduranceSportRoadBike;

  /// No description provided for @enduranceSportRowingOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Rowing'**
  String get enduranceSportRowingOutdoor;

  /// No description provided for @enduranceSportWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get enduranceSportWalking;

  /// No description provided for @enduranceSportNordicWalking.
  ///
  /// In en, this message translates to:
  /// **'Nordic walking'**
  String get enduranceSportNordicWalking;

  /// No description provided for @enduranceSportInlineSkating.
  ///
  /// In en, this message translates to:
  /// **'Inline skating'**
  String get enduranceSportInlineSkating;

  /// No description provided for @enduranceSportTreadmill.
  ///
  /// In en, this message translates to:
  /// **'Treadmill'**
  String get enduranceSportTreadmill;

  /// No description provided for @enduranceSportTreadmillWalking.
  ///
  /// In en, this message translates to:
  /// **'Treadmill walking'**
  String get enduranceSportTreadmillWalking;

  /// No description provided for @enduranceSportErgometer.
  ///
  /// In en, this message translates to:
  /// **'Bike ergometer'**
  String get enduranceSportErgometer;

  /// No description provided for @enduranceSportRower.
  ///
  /// In en, this message translates to:
  /// **'Rower'**
  String get enduranceSportRower;

  /// No description provided for @enduranceSportSpinning.
  ///
  /// In en, this message translates to:
  /// **'Spinning'**
  String get enduranceSportSpinning;

  /// No description provided for @enduranceSportCrosstrainer.
  ///
  /// In en, this message translates to:
  /// **'Crosstrainer'**
  String get enduranceSportCrosstrainer;

  /// No description provided for @enduranceSportStairclimber.
  ///
  /// In en, this message translates to:
  /// **'Stair climber'**
  String get enduranceSportStairclimber;

  /// No description provided for @enduranceSportStepper.
  ///
  /// In en, this message translates to:
  /// **'Stepper'**
  String get enduranceSportStepper;

  /// No description provided for @enduranceSportJumpRope.
  ///
  /// In en, this message translates to:
  /// **'Jump rope'**
  String get enduranceSportJumpRope;

  /// No description provided for @enduranceSportSkiErgometer.
  ///
  /// In en, this message translates to:
  /// **'Ski ergometer'**
  String get enduranceSportSkiErgometer;

  /// No description provided for @enduranceSportArmErgometer.
  ///
  /// In en, this message translates to:
  /// **'Arm ergometer'**
  String get enduranceSportArmErgometer;

  /// No description provided for @enduranceSportAirBike.
  ///
  /// In en, this message translates to:
  /// **'Air bike'**
  String get enduranceSportAirBike;

  /// No description provided for @enduranceIndoorComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Indoor endurance training will be added next. The database compatibility layer is already prepared.'**
  String get enduranceIndoorComingSoon;

  /// No description provided for @enduranceOutdoorComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Outdoor tracking will be added next. The database compatibility layer is already prepared.'**
  String get enduranceOutdoorComingSoon;

  /// No description provided for @enduranceActiveSessionRestored.
  ///
  /// In en, this message translates to:
  /// **'Active endurance session restored.'**
  String get enduranceActiveSessionRestored;

  /// No description provided for @enduranceStartSession.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get enduranceStartSession;

  /// No description provided for @enduranceDiscardSession.
  ///
  /// In en, this message translates to:
  /// **'Discard session'**
  String get enduranceDiscardSession;

  /// No description provided for @enduranceSessionActive.
  ///
  /// In en, this message translates to:
  /// **'Session active'**
  String get enduranceSessionActive;

  /// No description provided for @enduranceSessionNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Session not started'**
  String get enduranceSessionNotStarted;

  /// No description provided for @enduranceIndoorProtocolTitle.
  ///
  /// In en, this message translates to:
  /// **'Indoor protocol'**
  String get enduranceIndoorProtocolTitle;

  /// No description provided for @enduranceIndoorProtocolDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get enduranceIndoorProtocolDuration;

  /// No description provided for @enduranceIndoorProtocolPhaseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 phase} other{{count} phases}}'**
  String enduranceIndoorProtocolPhaseCount(int count);

  /// No description provided for @enduranceAxisSpeed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get enduranceAxisSpeed;

  /// No description provided for @enduranceAxisPower.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get enduranceAxisPower;

  /// No description provided for @enduranceAxisLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get enduranceAxisLevel;

  /// No description provided for @enduranceAxisIncline.
  ///
  /// In en, this message translates to:
  /// **'Incline'**
  String get enduranceAxisIncline;

  /// No description provided for @enduranceAxisIntensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get enduranceAxisIntensity;

  /// No description provided for @enduranceIndoorCompatibilityHint.
  ///
  /// In en, this message translates to:
  /// **'Indoor sessions are stored in the Android-compatible run_session table. Interval settings are saved as indoor_settings_json.'**
  String get enduranceIndoorCompatibilityHint;

  /// No description provided for @enduranceOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'The operation could not be completed.'**
  String get enduranceOperationFailed;

  /// No description provided for @enduranceLoadPlan.
  ///
  /// In en, this message translates to:
  /// **'Load plan'**
  String get enduranceLoadPlan;

  /// No description provided for @enduranceSelectedPhase.
  ///
  /// In en, this message translates to:
  /// **'Selected phase'**
  String get enduranceSelectedPhase;

  /// No description provided for @enduranceFinishSession.
  ///
  /// In en, this message translates to:
  /// **'Finish session'**
  String get enduranceFinishSession;

  /// No description provided for @enduranceRpeLabel.
  ///
  /// In en, this message translates to:
  /// **'Perceived exertion'**
  String get enduranceRpeLabel;

  /// No description provided for @enduranceRpeHint.
  ///
  /// In en, this message translates to:
  /// **'RPE 0–10'**
  String get enduranceRpeHint;

  /// No description provided for @enduranceRpeNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get enduranceRpeNotSet;

  /// No description provided for @enduranceNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get enduranceNotesLabel;

  /// No description provided for @enduranceDiscardSessionMessage.
  ///
  /// In en, this message translates to:
  /// **'Discard this active session? This will delete it permanently.'**
  String get enduranceDiscardSessionMessage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
