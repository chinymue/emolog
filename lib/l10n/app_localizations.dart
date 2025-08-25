import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Emolog'**
  String get appTitle;

  /// No description provided for @pageHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get pageHome;

  /// No description provided for @pageSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get pageSettings;

  /// No description provided for @pageHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get pageHistory;

  /// No description provided for @pageDetail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get pageDetail;

  /// No description provided for @restoreAcc.
  ///
  /// In en, this message translates to:
  /// **'Restore account'**
  String get restoreAcc;

  /// No description provided for @restoreSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset default settings'**
  String get restoreSettings;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullname.
  ///
  /// In en, this message translates to:
  /// **'Fullname'**
  String get fullname;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @avatarUrl.
  ///
  /// In en, this message translates to:
  /// **'AvatarURL'**
  String get avatarUrl;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Tiếng việt'**
  String get changeLanguage;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @saveChangesNotVaid.
  ///
  /// In en, this message translates to:
  /// **'Can\'t save changes'**
  String get saveChangesNotVaid;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get saveFailed;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Save successed'**
  String get saveSuccess;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @validEmpty.
  ///
  /// In en, this message translates to:
  /// **'Field is required'**
  String get validEmpty;

  /// Message shown after saving a log with id
  ///
  /// In en, this message translates to:
  /// **'Log {savedLogId} has been recorded'**
  String logRecorded(int savedLogId);

  /// No description provided for @helloMessageNeutral.
  ///
  /// In en, this message translates to:
  /// **'Hey, how’s your day going?'**
  String get helloMessageNeutral;

  /// No description provided for @helloMessageBestie.
  ///
  /// In en, this message translates to:
  /// **'Hey bestie, how’s your day been so far?'**
  String get helloMessageBestie;

  /// No description provided for @helloMessageMom.
  ///
  /// In en, this message translates to:
  /// **'Hi dear, how has your day been?'**
  String get helloMessageMom;

  /// No description provided for @moodTerrible.
  ///
  /// In en, this message translates to:
  /// **'Terrible'**
  String get moodTerrible;

  /// No description provided for @moodNotGood.
  ///
  /// In en, this message translates to:
  /// **'Not good'**
  String get moodNotGood;

  /// No description provided for @moodChill.
  ///
  /// In en, this message translates to:
  /// **'Chill'**
  String get moodChill;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// No description provided for @moodAwesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome'**
  String get moodAwesome;

  /// No description provided for @toolbarShow.
  ///
  /// In en, this message translates to:
  /// **'Show toolbar'**
  String get toolbarShow;

  /// No description provided for @toolbarHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden toolbar'**
  String get toolbarHidden;

  /// No description provided for @toolbarBasic.
  ///
  /// In en, this message translates to:
  /// **'Use basic toolbar'**
  String get toolbarBasic;

  /// No description provided for @toolbarFull.
  ///
  /// In en, this message translates to:
  /// **'Use full toolbar'**
  String get toolbarFull;

  /// No description provided for @logPlaceHolderNeutral.
  ///
  /// In en, this message translates to:
  /// **'Write down your feelings...'**
  String get logPlaceHolderNeutral;

  /// No description provided for @filtersClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all filters'**
  String get filtersClear;

  /// No description provided for @filterMood.
  ///
  /// In en, this message translates to:
  /// **'Filter by mood'**
  String get filterMood;

  /// No description provided for @filterMoodPoint.
  ///
  /// In en, this message translates to:
  /// **'Filter by mood point'**
  String get filterMoodPoint;

  /// No description provided for @filterFavor.
  ///
  /// In en, this message translates to:
  /// **'Favorited only'**
  String get filterFavor;

  /// No description provided for @filterFavorClear.
  ///
  /// In en, this message translates to:
  /// **'Remove filter by favorite'**
  String get filterFavorClear;

  /// No description provided for @filterDateRange.
  ///
  /// In en, this message translates to:
  /// **'Choose date range'**
  String get filterDateRange;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Sort by newest'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Sort by oldest'**
  String get sortOldest;

  /// No description provided for @logNotFound.
  ///
  /// In en, this message translates to:
  /// **'No log yet'**
  String get logNotFound;

  /// No description provided for @logFavor.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get logFavor;

  /// No description provided for @logUnfavor.
  ///
  /// In en, this message translates to:
  /// **'Unfavorite'**
  String get logUnfavor;

  /// No description provided for @logNotExist.
  ///
  /// In en, this message translates to:
  /// **'Log does not exist'**
  String get logNotExist;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
