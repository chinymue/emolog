import '../export/data/notelog_isar.dart';
import 'package:flutter/material.dart';
// import '../export/basic_utils.dart';

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
  bool isFavoredLog = false;

  bool get hasActiveFilter {
    return _filterStartDate != null ||
        _filterEndDate != null ||
        isFavoredLog == true;
  }

  void clearFilters() {
    _filterStartDate = null;
    _filterEndDate = null;
    isFavoredLog = false;
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

    if (isFavoredLog) {
      logs = logs.where((log) => log.isFavor == true).toList();
    }

    return logs;
  }

  void setFilterDateRange(DateTime? start, DateTime? end) {
    _filterStartDate = start;
    _filterEndDate = end;
    notifyListeners();
  }

  void setFilterFavor() {
    isFavoredLog = !isFavoredLog;
    notifyListeners();
  }
}
