import '../export/data/notelog_isar.dart';
import 'package:flutter/material.dart';
// import '../export/basic_utils.dart';

enum SortDateOrder { newestFirst, oldestFirst }

class LogViewProvider extends ChangeNotifier {
  List<NoteLog> _allLogs = [];
  bool isFetchedLogs = false;
  SortDateOrder sortDateOrder = SortDateOrder.newestFirst;

  void updateLogs(List<NoteLog> newLogs) {
    _allLogs = newLogs;
    isFetchedLogs = true;
    notifyListeners();
  }

  List<NoteLog> get allLogs {
    final logs = [..._allLogs];
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
}
