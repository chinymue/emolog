import 'package:flutter/material.dart';
import '../../isar/model/notelog.dart';
import '../../isar/model/relax.dart';
import '../utils/data_utils.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsProvider extends ChangeNotifier
    with StatsStateMixin, LogStatsMixin, RelaxStatsMixin, MoodChartMixin {
  DateTimeRange? get filterDateRange => _filterDateRange == null
      ? getDefaultDateRangeFromDateTime()
      : DateTimeRange(
          start: _filterDateRange!.start,
          end: DateTime(
            _filterDateRange!.end.year,
            _filterDateRange!.end.month,
            _filterDateRange!.end.day,
            0,
            0,
            0,
          ).subtract(Duration(days: 1)),
        );

  List<FlSpot> get moodDaily => buildLineSpots(logs);

  List<FlSpot> get moodRaw => buildMoodSpots(logs);

  // List<Map<DateTime, dynamic>> get durations {
  //   if (_filterDateRange == null) {
  //     return _durationDaily;
  //   } else {}
  // }
}

mixin StatsStateMixin on ChangeNotifier {
  List<NoteLog> _allLogs = [];
  List<Relax> _allRelaxs = [];
  bool isFetchedData = false;
  DateTimeRange? _filterDateRange;

  Future<void> fetchData(List<NoteLog>? logs, List<Relax>? relaxs) async {
    if (isFetchedData) return;

    _allLogs = logs ?? [];
    _allRelaxs = relaxs ?? [];
    isFetchedData = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void updateRange(DateTimeRange newRange) {
    _filterDateRange = DateTimeRange(
      start: newRange.start,
      end: DateTime(
        newRange.end.year,
        newRange.end.month,
        newRange.end.day,
        0,
        0,
        0,
      ).add(Duration(days: 1)),
    );
    notifyListeners();
  }

  List<NoteLog> get logs {
    if (_filterDateRange == null) {
      return _allLogs;
    } else {
      final filtered = _allLogs.where((log) {
        if (inDateRange(_filterDateRange!, log.date)) return true;
        return false;
      }).toList();

      filtered.sort((a, b) => a.date.compareTo(b.date));
      return filtered;
    }
  }

  List<Relax> get relaxs {
    if (_filterDateRange == null) {
      return _allRelaxs;
    } else {
      final filtered = _allRelaxs.where((relax) {
        if (isInDateTimeRange(
          _filterDateRange!,
          relax.startTime,
          relax.endTime,
        )) {
          return true;
        }
        return false;
      }).toList();

      filtered.sort((a, b) => a.startTime.compareTo(b.startTime));
      return filtered;
    }
  }
}

mixin LogStatsMixin on ChangeNotifier, StatsStateMixin {
  int get totalLogs => logs.length;

  int get totalNoteLogs =>
      logs.where((log) => log.note != null && log.note!.isNotEmpty).length;

  int get totalFavorLogs => logs.where((log) => log.isFavor).length;

  double get maxMoodPoint => logs.isEmpty
      ? 0.0
      : logs.map((log) => log.moodPoint ?? 0.0).reduce((a, b) => a > b ? a : b);

  double get minMoodPoint => logs.isEmpty
      ? 0.0
      : logs.map((log) => log.moodPoint ?? 0.0).reduce((a, b) => a < b ? a : b);

  double get avgMoodPoint => logs.isEmpty
      ? 0.0
      : logs.map((log) => log.moodPoint ?? 0.0).reduce((a, b) => a + b) /
            logs.length;
}

mixin RelaxStatsMixin on ChangeNotifier, StatsStateMixin {
  int get totalSessions => relaxs.length;

  int get totalDuration =>
      relaxs.map((relax) => relax.durationMiliseconds).reduce((a, b) => a + b);

  DateTime get earliestDate =>
      relaxs.firstWhere((relax) => relax.durationMiliseconds > 0).startTime;
  DateTime get lastestDate =>
      relaxs.lastWhere((relax) => relax.durationMiliseconds > 0).endTime;

  int get daysCount {
    final start = DateTime(
      earliestDate.year,
      earliestDate.month,
      earliestDate.day,
      0,
      0,
      0,
    );
    final end = DateTime(
      lastestDate.year,
      lastestDate.month,
      lastestDate.day,
      0,
      0,
      0,
    );
    return end.difference(start).inDays;
  }
}

class DailyMoodData {
  final DateTime date; // đã chuẩn hoá về 00:00:00.000
  final List<double> moodPoints;
  final double avgMood;
  final bool isNoted;

  DailyMoodData({
    required this.date,
    required this.moodPoints,
    required this.avgMood,
    required this.isNoted,
  });
}

mixin MoodChartMixin on ChangeNotifier, StatsStateMixin {
  Map<DateTime, List<NoteLog>> groupByDate(List<NoteLog> logs) {
    final map = <DateTime, List<NoteLog>>{};

    for (final log in logs) {
      final key = normalizeDate(log.date);
      map.putIfAbsent(key, () => []).add(log);
    }

    return map;
  }

  Map<DateTime, List<NoteLog>> groupByHour(List<NoteLog> logs) {
    final map = <DateTime, List<NoteLog>>{};

    for (final log in logs) {
      final key = normalizeHourDate(log.date);
      map.putIfAbsent(key, () => []).add(log);
    }

    return map;
  }

  Map<DateTime, double> calcAvgMood(List<NoteLog> logs, {String type = "day"}) {
    final grouped = type == "day" ? groupByDate(logs) : groupByHour(logs);
    final result = <DateTime, double>{};

    grouped.forEach((date, items) {
      final sum = items.fold<double>(0, (p, e) => p + e.moodPoint!);
      result[date] = sum / items.length;
    });

    return result;
  }

  List<FlSpot> buildLineSpots(List<NoteLog> logs) {
    final data = calcAvgMood(logs);

    final dates = data.keys.toList()..sort();

    return List.generate(dates.length, (i) {
      final date = dates[i];
      return FlSpot(
        i.toDouble(), // trục X: index
        data[date]!, // trục Y
      );
    });
  }

  List<FlSpot> buildMoodSpots(List<NoteLog> logs) {
    return List.generate(logs.length, (i) {
      final log = logs[i];
      return FlSpot(log.date.millisecondsSinceEpoch.toDouble(), log.moodPoint!);
    });
  }
}
