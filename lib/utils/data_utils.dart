import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../isar/model/notelog.dart';
import 'dart:convert'; // Để dùng jsonDecode

/// === DATE UTILS ===

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime normalizeDate(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day, 0, 0, 0);
}

DateTime normalizeHourDate(DateTime dt) {
  return DateTime(dt.year, dt.month, dt.day, dt.hour, 0, 0);
}

bool isInDateTimeRange(DateTimeRange a, DateTime start, DateTime end) {
  final aStart = a.start;
  final aEnd = a.end;
  return (start.isAtSameMomentAs(aStart) ||
          start.isAfter(aStart) && end.isBefore(aEnd)) &&
      (end.isAtSameMomentAs(aEnd) ||
          start.isAfter(aStart) && end.isBefore(aEnd));
}

bool inDateRange(DateTimeRange a, DateTime b) {
  final aStart = a.start;
  final aEnd = a.end;
  return (b.isAtSameMomentAs(aStart) ||
          b.isAfter(aStart) && b.isBefore(aEnd)) ||
      (b.isAtSameMomentAs(aEnd));
}

DateTimeRange getDefaultDateRangeFromDateTime({DateTime? date}) {
  if (date != null) {
    final start = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return DateTimeRange(start: start, end: end);
  } else {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return DateTimeRange(start: start, end: end);
  }
}

DateTime getDateTimeFromDateRange({DateTimeRange? range}) {
  if (range == null) {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
  } else {
    return DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
      range.start.hour,
      range.start.minute,
      range.start.second,
    );
  }
}

String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

String formatFullDate(DateTime date) =>
    DateFormat('EEEE yyyy-MM-dd').format(date);

String formatTime(DateTime date) => DateFormat('HH:mm:ss').format(date);

String formatShortTime(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

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

String formatDuration(int miliseconds) {
  final hour = miliseconds ~/ (1000 * 60 * 60);
  final minute = (miliseconds % (1000 * 60 * 60)) ~/ (1000 * 60);
  final second = (miliseconds % (1000 * 60)) ~/ 1000;
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
}

String formatFullDuration(int miliseconds) {
  final hour = miliseconds ~/ (1000 * 60 * 60);
  final minute = (miliseconds % (1000 * 60 * 60)) ~/ (1000 * 60);
  final second = (miliseconds % (1000 * 60)) ~/ 1000;
  final buffer = StringBuffer();
  if (hour > 0) {
    buffer.write('$hour giờ ');
  }
  if (minute > 0) {
    buffer.write('$minute phút ');
  }
  if (second > 0 || buffer.isEmpty) {
    buffer.write('$second giây');
  }
  return buffer.toString().trim();
}

String format(Duration d) {
  final minutes = d.inMinutes.toString().padLeft(2, '0');
  final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
  final ms = (d.inMilliseconds % 1000 ~/ 100).toString();
  return '$minutes:$seconds.$ms';
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
      a.moodPoint != b.moodPoint ||
      a.isFavor != b.isFavor ||
      a.date != b.date;
}

double moodPointFromLabel(String label) {
  switch (label) {
    case 'terrible':
      return 0;
    case 'not good':
      return 0.25;
    case 'chill':
      return 0.5;
    case 'good':
      return 0.75;
    case 'awesome':
      return 1.0;
    default:
      return 0.5;
  }
}
