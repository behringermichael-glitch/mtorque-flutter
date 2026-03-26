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
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
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
  /// **'(5 months)'**
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
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
