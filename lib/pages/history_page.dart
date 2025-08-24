import 'package:emolog/export/decor_utils.dart';
import 'package:emolog/provider/log_view_pvd.dart';
import 'package:emolog/widgets/detail_log/mood_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/log_pvd.dart';
import '../widgets/default_scaffold.dart';
import '../widgets/listview/default_log_list.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  Future<void> _selectDate(BuildContext c) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: c,
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 7)),
        end: DateTime.now(),
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (!c.mounted) return;
      c.read<LogViewProvider>().setFilterDateRange(picked.start, picked.end);
      // print("Ngày chọn: ${picked.start} - ${picked.end}");
    }
  }

  Future<void> _showMoodPicker(BuildContext c) async {
    return showModalBottomSheet(
      context: c,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(kPaddingSmall),
        child: MoodPicker(
          onMoodSelected: (mood) {
            c.read<LogViewProvider>().setMoodFilter(mood);
            Navigator.pop(c);
          },
        ),
      ),
    );
  }

  Future<void> _showMoodRangePicker(BuildContext c) async {
    return showModalBottomSheet(
      context: c,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(kPaddingSmall),
        child: MoodRangePicker(
          onChangedRange: (values) =>
              c.read<LogViewProvider>().setMoodRangeFilter(values),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext c) {
    final logViewProvider = c.read<LogViewProvider>();
    final sortDateOrder = c.select<LogViewProvider, SortDateOrder>(
      (provider) => provider.sortDateOrder,
    );
    final hasActiveFilter = c.select<LogViewProvider, bool>(
      (provider) => provider.hasActiveFilter,
    );
    final isFavorFilter = c.select<LogViewProvider, bool>(
      (provider) => provider.isFavoredLog,
    );
    // RangeValues currentRangeValues = c.select<LogViewProvider, RangeValues>(
    //   (provider) => provider.moodRangeFilter,
    // );
    return MainScaffold(
      currentIndex: 1,
      actions: [
        if (hasActiveFilter)
          IconButton(
            onPressed: () => logViewProvider.clearFilters(),
            icon: Icon(Icons.filter_alt_off),
            tooltip: "Xóa các filter đã chọn",
          ),
        IconButton(
          onPressed: () => _showMoodPicker(c),
          icon: Icon(Icons.emoji_emotions),
          tooltip: "Lọc theo mood",
        ),
        IconButton(
          onPressed: () => _showMoodRangePicker(c),
          icon: Icon(Icons.percent),
          tooltip: "Lọc theo % mood",
        ),
        IconButton(
          onPressed: () => logViewProvider.setFilterFavor(),
          icon: isFavorFilter
              ? Icon(Icons.favorite_border)
              : Icon(Icons.favorite),
          tooltip: isFavorFilter ? "Xóa lọc favorite" : "Lọc favorite",
        ),
        IconButton(
          onPressed: () => _selectDate(c),
          icon: Icon(Icons.date_range),
          tooltip: "Chọn khoảng thời gian hiển thị",
        ),
        IconButton(
          onPressed: () => logViewProvider.toggleSortDateOrder(),
          icon: Icon(
            sortDateOrder == SortDateOrder.newestFirst
                ? Icons.arrow_downward
                : Icons.arrow_upward,
          ),
          tooltip: sortDateOrder == SortDateOrder.newestFirst
              ? "Xếp theo cũ nhất"
              : "Xếp theo mới nhất",
        ),
      ],
      child: LogsList(),
    );
  }
}

class LogsList extends StatelessWidget {
  const LogsList({super.key});

  @override
  Widget build(BuildContext c) {
    return FutureBuilder(
      future: c.read<LogProvider>().fetchLogs(),
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snap.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final logs = c.read<LogProvider>().logs;
            c.read<LogViewProvider>().updateLogs(logs);
          });
        }
        return DefaultList();
      },
    );
  }
}
