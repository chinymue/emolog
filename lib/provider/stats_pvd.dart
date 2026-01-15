import 'package:flutter/material.dart';
import '../../isar/model/notelog.dart';
import '../../isar/model/relax.dart';
import '../utils/data_utils.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsProvider extends ChangeNotifier
    with StatsStateMixin, MoodStatsMixin, MoodChartMixin {
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

  // List<FlSpot> get moodSpots => _moodSpots;
  // // ChartXMapper? get mapper => _mapper;
  // // bool get hasMoodData => _moodSpots.isNotEmpty && _mapper != null;

  // void rebuildMood(RangePreset type, DateTimeRange range) {
  //   final source = _logsSorted ? _sortedLogs : _allLogs;

  //   final filtered = source.where((log) {
  //     return inDateRange(range, log.date);
  //   }).toList();

  //   final spots = buildMoodLineSpots(filtered, range, type);

  //   if (spots.length == _moodSpots.length) return;
  //   _moodSpots = spots;
  //   // if (spots.isEmpty) {
  //   //   _mapper = null;
  //   // }

  //   notifyListeners();
  // }
}

mixin StatsStateMixin on ChangeNotifier {
  List<NoteLog> _allLogs = [];
  List<Relax> _allRelaxs = [];
  bool isFetchedData = false;
  DateTimeRange? _filterDateRange;
  List<NoteLog> _sortedLogs = [];
  bool _logsSorted = false;
  Map<DateTime, List<NoteLog>> _groupedByDateLogs = {};
  Map<DateTime, Map<String, int>> _groupedByMoodLogs = {};
  Map<DateTime, double> _avgMoodByDateLogs = {};

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
    _logsSorted = true;

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
        final mood = log.labelMood ?? 'unknown';
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
      final totalMood = entry.value.fold<double>(
        0.0,
        (previousValue, log) => previousValue + (log.moodPoint ?? 0.0),
      );
      final avgMood = totalMood / entry.value.length;
      map[entry.key] = avgMood;
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
    // final base = dates.first;

    return dates
        .where((date) => inDateRange(range, date))
        .map((date) {
          final x = date.difference(range.start).inDays.toDouble();
          final y = avgMoodByDateLogs[date]!;

          if (!x.isFinite || !y.isFinite) return null;
          return FlSpot(x, y);
        })
        .whereType<FlSpot>()
        .toList();
  }
}

// mixin MoodChartMixin on ChangeNotifier, StatsStateMixin {
//   double dateToX(DateTime date, DateTime base, RangePreset type) {
//     switch (type) {
//       case RangePreset.day:
//         return date.difference(base).inHours.toDouble();
//       case RangePreset.week:
//       case RangePreset.month:
//         return date.difference(base).inDays.toDouble();
//       case RangePreset.sixMonths:
//         return (date.difference(base).inDays / 7).floorToDouble();
//       case RangePreset.year:
//         return (date.year - base.year) * 12 +
//             (date.month - base.month).toDouble();
//     }
//   }

//   DateTime normalizeDateToGroup(RangePreset type, DateTime dt) {
//     switch (type) {
//       case RangePreset.day:
//         return normalizeByPreset(dt, TimePreset.hour);
//       case RangePreset.week:
//       case RangePreset.month:
//         return normalizeByPreset(dt, TimePreset.day);
//       case RangePreset.sixMonths:
//         return normalizeByPreset(dt, TimePreset.week);
//       case RangePreset.year:
//         return normalizeByPreset(dt, TimePreset.month);
//     }
//   }

//   Map<DateTime, List<NoteLog>> groupByRange(
//     List<NoteLog> logs,
//     RangePreset type,
//   ) {
//     final map = <DateTime, List<NoteLog>>{};
//     for (final log in logs) {
//       final key = normalizeDateToGroup(type, log.date);
//       map.putIfAbsent(key, () => []).add(log);
//     }

//     return map;
//   }

//   Map<DateTime, double> calcAvgMood(List<NoteLog> logs, RangePreset type) {
//     final grouped = groupByRange(logs, type);
//     final entries = grouped.entries.toList()
//       ..sort((a, b) => a.key.compareTo(b.key));
//     final result = <DateTime, double>{};

//     for (final e in entries) {
//       final sum = e.value.fold<double>(0, (p, n) => p + n.moodPoint!);
//       result[e.key] = sum / e.value.length;
//     }

//     return result;
//   }

//   // List<FlSpot> buildMoodLineSpots(
//   //   List<NoteLog> logs,
//   //   DateTimeRange range,
//   //   RangePreset type,
//   // ) {
//   //   if (logs.isEmpty) return [];

//   //   final data = calcAvgMood(logs, type);
//   //   final base = normalizeByPreset(data.keys.first, rangeToTimePreset(type));
//   //   //   final mapper = ChartXMapper(base, rangeToTimePreset(type));

//   //   //     return data.entries.map((log) {
//   //   //   final x = mapper.toX(log.date);
//   //   //   final y = log.moodPoint;

//   //   //   if (!x.isFinite || !y.isFinite) return null;
//   //   //   return FlSpot(x, y);
//   //   // }).whereType<FlSpot>().toList();

//   //   return List.generate(dates.length, (i) {
//   //     final date = dates[i];
//   //     return FlSpot(
//   //       (date.millisecondsSinceEpoch - base).toDouble(),
//   //       data[date]!,
//   //     );
//   //   });
//   // }

//   List<FlSpot> buildMoodLineSpots(
//     List<NoteLog> logs,
//     DateTimeRange range,
//     RangePreset type,
//   ) {
//     if (logs.isEmpty) return [];

//     final data = calcAvgMood(logs, type);
//     if (data.isEmpty) return [];

//     final dates = data.keys.toList()..sort();
//     final base = dates.first;
//     // _mapper = ChartXMapper(base, rangeToTimePreset(type));

//     return dates
//         .map((date) {
//           final x = dateToX(date, base, type);
//           final y = data[date]!;

//           if (!x.isFinite || !y.isFinite) return null;
//           return FlSpot(x, y);
//         })
//         .whereType<FlSpot>()
//         .toList();
//   }
// }

// class ChartXMapper {
//   final DateTime base;
//   final TimePreset preset;

//   ChartXMapper(this.base, this.preset);

//   double toX(DateTime dt) {
//     final d = normalizeByPreset(dt, preset);
//     switch (preset) {
//       case TimePreset.hour:
//         return d.difference(base).inHours.toDouble();
//       case TimePreset.day:
//       case TimePreset.week:
//         return d.difference(base).inDays.toDouble();
//       case TimePreset.month:
//         return (d.year - base.year) * 12 + (d.month - base.month).toDouble();
//     }
//   }

//   DateTime fromX(double x) {
//     switch (preset) {
//       case TimePreset.hour:
//         return base.add(Duration(hours: x.toInt()));
//       case TimePreset.day:
//       case TimePreset.week:
//         return base.add(Duration(days: x.toInt()));
//       case TimePreset.month:
//         return DateTime(base.year, base.month + x.toInt(), 1);
//     }
//   }
// }
