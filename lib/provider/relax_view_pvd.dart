import 'package:flutter/material.dart';
import '../../isar/model/relax.dart';

enum SortDateOrder { newestFirst, oldestFirst }

class RelaxViewProvider extends ChangeNotifier {
  List<Relax> _allRelaxs = [];
  bool isFetchedRelaxs = false;

  void updateRelaxs(List<Relax> newRelaxs) {
    _allRelaxs = newRelaxs;
    isFetchedRelaxs = true;
    notifyListeners();
  }

  List<Relax> get allRelaxs => _sortedRelaxs;

  /// SORT
  SortDateOrder sortDateOrder = SortDateOrder.newestFirst;

  List<Relax> get _sortedRelaxs {
    var relaxs = [..._filteredRelaxs];
    relaxs.sort((a, b) {
      if (sortDateOrder == SortDateOrder.newestFirst) {
        return b.startTime.compareTo(a.startTime);
      } else {
        return a.startTime.compareTo(b.startTime);
      }
    });
    return relaxs;
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

  bool get hasActiveFilter {
    return _filterStartDate != null || _filterEndDate != null;
  }

  void clearFilters() {
    _filterStartDate = null;
    _filterEndDate = null;
    notifyListeners();
  }

  List<Relax> get _filteredRelaxs {
    var relaxs = [..._allRelaxs];

    if (_filterStartDate != null) {
      relaxs = relaxs
          .where(
            (relax) =>
                relax.startTime.isAfter(_filterStartDate!) ||
                relax.startTime.isAtSameMomentAs(_filterStartDate!),
          )
          .toList();
    }

    if (_filterEndDate != null) {
      relaxs = relaxs
          .where(
            (relax) =>
                relax.endTime.isBefore(_filterEndDate!) ||
                relax.endTime.isAtSameMomentAs(_filterEndDate!),
          )
          .toList();
    }

    return relaxs;
  }

  void setFilterDateRange(DateTime? start, DateTime? end) {
    _filterStartDate = start;
    _filterEndDate = end;
    notifyListeners();
  }
}
