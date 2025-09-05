import 'package:flutter/material.dart';
import '../../isar/model/notelog.dart';
import '../utils/constant.dart';

enum SortDateOrder { newestFirst, oldestFirst }

class LogViewProvider extends ChangeNotifier {
  List<NoteLog> _allLogs = [];
  bool isFetchedLogs = false;

  void updateLogs(List<NoteLog> newLogs) {
    _allLogs = newLogs;
    isFetchedLogs = true;
    notifyListeners();
  }

  List<NoteLog> get allLogs => _sortedLogs;

  /// SORT
  SortDateOrder sortDateOrder = SortDateOrder.newestFirst;

  List<NoteLog> get _sortedLogs {
    var logs = [..._filteredLogs];
    logs.sort((a, b) {
      if (sortDateOrder == SortDateOrder.newestFirst) {
        return b.date.compareTo(a.date);
      } else {
        return a.date.compareTo(b.date);
      }
    });
    return logs;
  }

  void toggleSortDateOrder() {
    if (sortDateOrder == SortDateOrder.newestFirst) {
      sortDateOrder = SortDateOrder.oldestFirst;
    } else {
      sortDateOrder = SortDateOrder.newestFirst;
    }
    notifyListeners();
  }

  /// FILTERS
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  bool? _isFavoredLog;
  String? _moodFilter;
  RangeValues _moodRangeFilter = const RangeValues(minMoodPoint, maxMoodPoint);

  bool get isFavoredLog => _isFavoredLog ?? false;
  RangeValues get moodRangeFilter => _moodRangeFilter;

  bool get hasActiveFilter {
    return _filterStartDate != null ||
        _filterEndDate != null ||
        _isFavoredLog == true ||
        _moodFilter != null ||
        _moodRangeFilter != const RangeValues(minMoodPoint, maxMoodPoint);
  }

  void clearFilters() {
    _filterStartDate = null;
    _filterEndDate = null;
    _isFavoredLog = null;
    _moodFilter = null;
    _moodRangeFilter = const RangeValues(minMoodPoint, maxMoodPoint);
    notifyListeners();
  }

  List<NoteLog> get _filteredLogs {
    var logs = [..._allLogs];

    if (_filterStartDate != null) {
      logs = logs
          .where(
            (log) =>
                log.date.isAfter(_filterStartDate!) ||
                log.date.isAtSameMomentAs(_filterStartDate!),
          )
          .toList();
    }

    if (_filterEndDate != null) {
      logs = logs
          .where(
            (log) =>
                log.date.isBefore(_filterEndDate!) ||
                log.date.isAtSameMomentAs(_filterEndDate!),
          )
          .toList();
    }

    if (_isFavoredLog != null && _isFavoredLog == true) {
      logs = logs.where((log) => log.isFavor == true).toList();
    }

    if (_moodFilter != null && moods.containsKey(_moodFilter)) {
      logs = logs.where((log) => log.labelMood == _moodFilter).toList();
    }

    if (_moodRangeFilter != const RangeValues(minMoodPoint, maxMoodPoint) &&
        _moodRangeFilter.start >= minMoodPoint &&
        _moodRangeFilter.end <= maxMoodPoint) {
      logs = logs
          .where(
            (log) =>
                log.moodPoint! >= _moodRangeFilter.start &&
                log.moodPoint! <= _moodRangeFilter.end,
          )
          .toList();
    }

    return logs;
  }

  void setFilterDateRange(DateTime? start, DateTime? end) {
    _filterStartDate = start;
    _filterEndDate = end;
    notifyListeners();
  }

  void setFilterFavor() {
    if (_isFavoredLog == null) {
      _isFavoredLog = true;
    } else {
      _isFavoredLog = !_isFavoredLog!;
    }
    notifyListeners();
  }

  void setMoodFilter(String? mood) {
    _moodFilter = mood;
    notifyListeners();
  }

  void setMoodRangeFilter(RangeValues values) {
    _moodRangeFilter = values;
    notifyListeners();
  }
}
