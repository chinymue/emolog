import 'package:intl/intl.dart';
import '../isar/model/notelog.dart';
import 'dart:convert'; // Để dùng jsonDecode

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

String shortenText(String? text, [int maxLength = 20]) {
  if (text == null || text.isEmpty) return '';

  // Cắt tại newline nếu có
  final firstLine = text.split('\n').first;

  return (firstLine.length <= maxLength)
      ? firstLine
      : '${firstLine.substring(0, maxLength)}...';
}

String plainTextFromDeltaJson(String? deltaJson) {
  try {
    if (deltaJson == null || deltaJson == '') return '';
    final List<dynamic> ops = jsonDecode(deltaJson);
    final buffer = StringBuffer();

    for (final op in ops) {
      if (op is Map && op.containsKey('insert')) {
        final insertValue = op['insert'];
        if (insertValue is String) {
          buffer.write(insertValue);
        }
      }
    }
    return buffer.toString();
  } catch (_) {
    return '';
  }
}

/// === THIS APP ONLY DATA ===

bool isNoteLogChanged(NoteLog a, NoteLog b) {
  return a.note != b.note ||
      a.labelMood != b.labelMood ||
      a.numericMood != b.numericMood ||
      a.isFavor != b.isFavor ||
      a.date != b.date;
}
