import 'package:intl/intl.dart';
import '../isar/model/notelog.dart';

/// === DATE UTILS ===

String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

String formatTime(DateTime date) => DateFormat('HH:mm:ss').format(date);

String formatFullDateTime(DateTime date) =>
    DateFormat('EEEE yyyy-MM-dd HH:mm:ss').format(date);

String formatFullDateTimeShortDay(DateTime date) =>
    DateFormat('EEE yyyy-MM-dd HH:mm:ss').format(date);

String formatDateTime(DateTime date) =>
    DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

String formatShortDateTime(DateTime date) =>
    DateFormat('yyyy-MM-dd HH:mm').format(date);

String formatShortWeekday(DateTime date, {String locale = 'vi_VN'}) {
  Intl.defaultLocale = locale;
  return DateFormat('EEE').format(date); // T7
}

String formatFullWeekday(DateTime date, {String locale = 'vi_VN'}) {
  Intl.defaultLocale = locale;
  return DateFormat('EEEE').format(date); // Thứ Bảy
}

/// === STRING & JSON UTILS ===

String shortenText(String text, [int maxLength = 20]) {
  return (text.length <= maxLength)
      ? text
      : '${text.substring(0, maxLength)}...';
}

/// === THIS APP ONLY DATA ===

bool isNoteLogChanged(NoteLog a, NoteLog b) {
  return a.note != b.note ||
      a.labelMood != b.labelMood ||
      a.numericMood != b.numericMood ||
      a.isFavor != b.isFavor ||
      a.date != b.date;
}
