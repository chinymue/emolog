// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Emolog';

  @override
  String get pageHome => 'Home';

  @override
  String get pageSettings => 'Settings';

  @override
  String get pageHistory => 'History';

  @override
  String get pageDetail => 'Detail';

  @override
  String get restoreAcc => 'Restore account';

  @override
  String get restoreSettings => 'Reset default settings';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get fullname => 'Fullname';

  @override
  String get email => 'Email';

  @override
  String get avatarUrl => 'AvatarURL';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get submit => 'Submit';

  @override
  String get changeLanguage => 'Tiếng việt';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saveChangesNotVaid => 'Can\'t save changes';

  @override
  String get saveFailed => 'Save failed';

  @override
  String get saveSuccess => 'Save successed';

  @override
  String get undo => 'Undo';

  @override
  String get validEmpty => 'Field is required';

  @override
  String logRecorded(int savedLogId) {
    return 'Log $savedLogId has been recorded';
  }

  @override
  String get helloMessageNeutral => 'Hey, how’s your day going?';

  @override
  String get helloMessageBestie => 'Hey bestie, how’s your day been so far?';

  @override
  String get helloMessageMom => 'Hi dear, how has your day been?';

  @override
  String get moodTerrible => 'Terrible';

  @override
  String get moodNotGood => 'Not good';

  @override
  String get moodChill => 'Chill';

  @override
  String get moodGood => 'Good';

  @override
  String get moodAwesome => 'Awesome';

  @override
  String get toolbarShow => 'Show toolbar';

  @override
  String get toolbarHidden => 'Hidden toolbar';

  @override
  String get toolbarBasic => 'Use basic toolbar';

  @override
  String get toolbarFull => 'Use full toolbar';

  @override
  String get logPlaceHolderNeutral => 'Write down your feelings...';

  @override
  String get filtersClear => 'Clear all filters';

  @override
  String get filterMood => 'Filter by mood';

  @override
  String get filterMoodPoint => 'Filter by mood point';

  @override
  String get filterFavor => 'Favorited only';

  @override
  String get filterFavorClear => 'Remove filter by favorite';

  @override
  String get filterDateRange => 'Choose date range';

  @override
  String get sortNewest => 'Sort by newest';

  @override
  String get sortOldest => 'Sort by oldest';

  @override
  String get logNotFound => 'No log yet';

  @override
  String get logFavor => 'Favorite';

  @override
  String get logUnfavor => 'Unfavorite';

  @override
  String get logNotExist => 'Log does not exist';
}
