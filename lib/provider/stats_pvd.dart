import 'dart:math';

import 'package:flutter/material.dart';
import '../../isar/model/notelog.dart';
import '../../isar/model/relax.dart';
import '../utils/data_utils.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsProvider extends ChangeNotifier
    with
        StatsStateMixin,
        MoodStatsMixin,
        MoodChartMixin,
        RelaxStatsMixin,
        RelaxChartMixin {
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
}

mixin StatsStateMixin on ChangeNotifier {
  List<NoteLog> _allLogs = [];
  List<Relax> _allRelaxs = [];
  bool isFetchedData = false;
  DateTimeRange? _filterDateRange;
  List<NoteLog> _sortedLogs = [];
  List<Relax> _sortedRelaxs = [];
  Map<DateTime, List<NoteLog>> _groupedByDateLogs = {};
  Map<DateTime, Map<String, int>> _groupedByMoodLogs = {};
  Map<DateTime, double> _avgMoodByDateLogs = {};
  Map<DateTime, List<Relax>> _groupedByDateRelaxs = {};
  Map<DateTime, int> _totalDurationByDateRelaxs = {};

  Future<void> fetchData(List<NoteLog>? logs, List<Relax>? relaxs) async {
    final sw = Stopwatch()..start();
    debugPrint('[Stats] fetchData START');

    if (isFetchedData) {
      debugPrint('[Stats] fetchData skipped (${sw.elapsedMilliseconds}ms)');
      return;
    }

    _allLogs = logs ?? [];
    _allRelaxs = relaxs ?? [];
    isFetchedData = true;

    _sortedLogs = List.of(_allLogs)..sort((a, b) => a.date.compareTo(b.date));
    _sortedRelaxs = List.of(_allRelaxs)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    debugPrint(
      '[Stats] notifyListeners (postFrame): ${sw.elapsedMilliseconds}ms',
    );
    notifyListeners();
  }

  void updateRange(DateTimeRange newRange) {
    final sw = Stopwatch()..start();
    debugPrint('[Stats] updateRange START');
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
    debugPrint(
      '[Stats] notifyListeners (postFrame): ${sw.elapsedMilliseconds}ms',
    );
    notifyListeners();
  }
}
/***
// mixin LogStatsMixin on ChangeNotifier, StatsStateMixin {
//   int get totalLogs => logs.length;

//   int get totalNoteLogs =>
//       logs.where((log) => log.note != null && log.note!.isNotEmpty).length;

//   int get totalFavorLogs => logs.where((log) => log.isFavor).length;

//   double get maxMoodPoint => logs.isEmpty
//       ? 0.0
//       : logs.map((log) => log.moodPoint ?? 0.0).reduce((a, b) => a > b ? a : b);

//   double get minMoodPoint => logs.isEmpty
//       ? 0.0
//       : logs.map((log) => log.moodPoint ?? 0.0).reduce((a, b) => a < b ? a : b);

//   double get avgMoodPoint => logs.isEmpty
//       ? 0.0
//       : logs.map((log) => log.moodPoint ?? 0.0).reduce((a, b) => a + b) /
//             logs.length;
// }

// mixin RelaxStatsMixin on ChangeNotifier, StatsStateMixin {
//   int get totalSessions => relaxs.length;

//   int get totalDuration =>
//       relaxs.map((relax) => relax.durationMiliseconds).reduce((a, b) => a + b);

//   DateTime get earliestDate =>
//       relaxs.firstWhere((relax) => relax.durationMiliseconds > 0).startTime;
//   DateTime get lastestDate =>
//       relaxs.lastWhere((relax) => relax.durationMiliseconds > 0).endTime;

//   int get daysCount {
//     final start = DateTime(
//       earliestDate.year,
//       earliestDate.month,
//       earliestDate.day,
//       0,
//       0,
//       0,
//     );
//     final end = DateTime(
//       lastestDate.year,
//       lastestDate.month,
//       lastestDate.day,
//       0,
//       0,
//       0,
//     );
//     return end.difference(start).inDays;
//   }
// }
 */

mixin MoodStatsMixin on ChangeNotifier, StatsStateMixin {
  Map<DateTime, List<NoteLog>> get groupedByDateLogs => _groupedByDateLogs;

  Map<DateTime, Map<String, int>> get groupedByMoodLogs => _groupedByMoodLogs;

  Map<DateTime, double> get avgMoodByDateLogs => _avgMoodByDateLogs;

  void groupLogsByDate() {
    final map = <DateTime, List<NoteLog>>{};
    for (final log in _sortedLogs) {
      final key = normalizeByPreset(log.date, TimePreset.day);
      map.putIfAbsent(key, () => []).add(log);
    }
    _groupedByDateLogs = map;
    if (map.isEmpty) {
      _groupedByMoodLogs = {};
      _avgMoodByDateLogs = {};
    } else {
      groupLogsByMood();
      calculateAvgMoodByDate();
    }
    notifyListeners();
  }

  void groupLogsByMood({bool notify = false}) {
    final map = <DateTime, Map<String, int>>{};
    for (final entry in _groupedByDateLogs.entries) {
      final moodCountMap = <String, int>{};
      for (final log in entry.value) {
        final mood = log.labelMood;
        moodCountMap[mood] = (moodCountMap[mood] ?? 0) + 1;
      }
      map[entry.key] = moodCountMap;
    }
    _groupedByMoodLogs = map;
    if (notify) notifyListeners();
  }

  void calculateAvgMoodByDate({bool notify = false}) {
    final map = <DateTime, double>{};

    for (final entry in _groupedByDateLogs.entries) {
      final validMoods = entry.value
          .map((e) => e.moodPoint)
          .whereType<double>()
          .toList();

      if (validMoods.isEmpty) {
        continue;
      }

      final totalMood = validMoods.reduce((a, b) => a + b);
      map[entry.key] = totalMood / validMoods.length;
    }

    _avgMoodByDateLogs = map;
    if (notify) notifyListeners();
  }
}

mixin MoodChartMixin on ChangeNotifier, StatsStateMixin, MoodStatsMixin {
  Map<String, int> getMoodCountsInRange(DateTimeRange range) {
    if (groupedByMoodLogs.isEmpty) return {};
    final dates = groupedByMoodLogs.keys.toList();
    final moodCounts = <String, int>{};
    for (final date in dates) {
      if (!inDateRange(range, date)) continue;

      final moodMap = groupedByMoodLogs[date]!;
      for (final moodEntry in moodMap.entries) {
        moodCounts[moodEntry.key] =
            (moodCounts[moodEntry.key] ?? 0) + moodEntry.value;
      }
    }
    // final total = moodCounts.values.fold<int>(0, (p, n) => p + n);
    return moodCounts;
  }

  List<FlSpot> getMoodAvgInRange(DateTimeRange range) {
    if (avgMoodByDateLogs.isEmpty) return [];

    final dates = avgMoodByDateLogs.keys.toList();

    return dates
        .where((date) => inDateRange(range, date))
        .map((date) {
          final x = (date.difference(range.start).inDays + 1).toDouble();
          final y = avgMoodByDateLogs[date]!;

          if (!x.isFinite || !y.isFinite) return null;
          return FlSpot(x, y);
        })
        .whereType<FlSpot>()
        .toList();
  }
}

mixin RelaxStatsMixin on ChangeNotifier, StatsStateMixin {
  Map<DateTime, List<Relax>> get groupedByDateRelax => _groupedByDateRelaxs;

  Map<DateTime, int> get totalDurationByDate => _totalDurationByDateRelaxs;

  void groupRelaxByDate() {
    final map = <DateTime, List<Relax>>{};
    for (final relax in _sortedRelaxs) {
      final key = normalizeByPreset(relax.startTime, TimePreset.day);
      map.putIfAbsent(key, () => []).add(relax);
    }
    _groupedByDateRelaxs = map;
    if (map.isEmpty) {
      _totalDurationByDateRelaxs = {};
    } else {
      calculateTotalDurationByDate();
      debugPrint('Relax grouped by date calculated.');
      for (final entry in groupedByDateRelax.entries) {
        debugPrint('Date: ${entry.key}, Sessions: ${entry.value.length}');
      }
      for (final entry in totalDurationByDate.entries) {
        debugPrint('Date: ${entry.key}, Total Duration: ${entry.value} ms');
      }
    }
    notifyListeners();
  }

  void calculateTotalDurationByDate({bool notify = false}) {
    final map = <DateTime, int>{};

    for (final entry in _groupedByDateRelaxs.entries) {
      final validMoods = entry.value
          .map((e) => e.durationMiliseconds)
          .whereType<int>()
          .toList();

      if (validMoods.isEmpty) {
        continue;
      }

      final totalMood = validMoods.reduce((a, b) => a + b);
      map[entry.key] = totalMood;
    }

    _totalDurationByDateRelaxs = map;
    if (notify) notifyListeners();
  }
}

mixin RelaxChartMixin on ChangeNotifier, StatsStateMixin, RelaxStatsMixin {
  List<BarChartGroupData> getRelaxDurationInRange(
    DateTimeRange range, {
    double? width,
    Color? color,
  }) {
    if (totalDurationByDate.isEmpty) return [];

    final dates = totalDurationByDate.keys.toList();
    final start = dates.first;
    final end = dates.last;

    final days = <DateTime>[];
    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      days.add(d);
    }

    Map<DateTime, int> map = {};

    for (final date in dates) {
      if (!inDateRange(range, date)) continue;
      map[date] = totalDurationByDate[date] ?? 0;
    }

    return List.generate(days.length, (i) {
      final day = days[i];
      final value = (map[day] ?? 0) ~/ (1000 * 60);

      return BarChartGroupData(
        x: day.difference(range.start).inDays + 1,
        barRods: [
          BarChartRodData(
            toY: value.toDouble(),
            width: width == null ? 10 : width / (days.length * 4),
            color: color,
          ),
        ],
      );
    });
  }
}
