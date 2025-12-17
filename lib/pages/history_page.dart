import 'package:emolog/provider/user_pvd.dart';
import '../utils/constant.dart';
import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/provider/log_view_pvd.dart';
import 'package:emolog/widgets/detail_log/mood_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/log_pvd.dart';
import '../widgets/template/scaffold_template.dart';
import '../widgets/listview/default_log_list.dart';

class HistoryPage extends StatelessWidget with HistoryPagePickers {
  HistoryPage({super.key});

  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 1,
      actions: [
        ResetActions(),
        HistoryPageActions(
          onShowMoodPicker: () => showMoodPicker(c),
          onShowMoodRangePicker: () => showMoodRangePicker(c),
          onSelectDate: () => selectDate(c),
        ),
        LogViewActions(),
      ],
      child: LogsList(),
    );
  }
}

mixin HistoryPagePickers {
  Future<void> selectDate(BuildContext c) async {
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

  Future<void> showMoodPicker(BuildContext c) async {
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

  Future<void> showMoodRangePicker(BuildContext c) async {
    return showModalBottomSheet(
      context: c,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(kPaddingSmall),
        child: SizedBox(
          height: kSingleRowScrollMaxHeight,
          child: MoodRangePicker(
            onChangedRange: (values) =>
                c.read<LogViewProvider>().setMoodRangeFilter(values),
          ),
        ),
      ),
    );
  }
}

class ResetActions extends StatelessWidget {
  const ResetActions({super.key});

  @override
  Widget build(BuildContext c) {
    final l10n = AppLocalizations.of(c)!;
    final hasActiveFilter = c.select<LogViewProvider, bool>(
      (provider) => provider.hasActiveFilter,
    );
    return hasActiveFilter
        ? IconButton(
            onPressed: () => c.read<LogViewProvider>().clearFilters(),
            icon: Icon(Icons.filter_alt_off),
            tooltip: l10n.filtersClear,
          )
        : SizedBox.shrink();
  }
}

class HistoryPageActions extends StatelessWidget {
  const HistoryPageActions({
    super.key,
    required this.onShowMoodPicker,
    required this.onShowMoodRangePicker,
    required this.onSelectDate,
  });

  final VoidCallback onShowMoodPicker;
  final VoidCallback onShowMoodRangePicker;
  final VoidCallback onSelectDate;

  @override
  Widget build(BuildContext c) {
    final l10n = AppLocalizations.of(c)!;
    return Row(
      children: [
        IconButton(
          onPressed: onShowMoodPicker,
          icon: Icon(Icons.emoji_emotions),
          tooltip: l10n.filterMood,
        ),
        IconButton(
          onPressed: onShowMoodRangePicker,
          icon: Icon(Icons.percent),
          tooltip: l10n.filterMoodPoint,
        ),
        IconButton(
          onPressed: onSelectDate,
          icon: Icon(Icons.date_range),
          tooltip: l10n.filterDateRange,
        ),
        IconButton(
          onPressed: () {
            c.read<LogProvider>().deleteAllLogs();
          },
          icon: Icon(Icons.dangerous),
          tooltip: "Xóa toàn bộ log trong cơ sở dữ liệu",
        ),
      ],
    );
  }
}

class LogViewActions extends StatelessWidget {
  const LogViewActions({super.key});

  @override
  Widget build(BuildContext c) {
    final logViewProvider = c.read<LogViewProvider>();
    final sortDateOrder = c.select<LogViewProvider, SortDateOrder>(
      (provider) => provider.sortDateOrder,
    );
    final isFavorFilter = c.select<LogViewProvider, bool>(
      (provider) => provider.isFavoredLog,
    );
    final l10n = AppLocalizations.of(c)!;
    return Row(
      children: [
        IconButton(
          onPressed: () => logViewProvider.setFilterFavor(),
          icon: isFavorFilter
              ? Icon(Icons.favorite_border)
              : Icon(Icons.favorite),
          tooltip: isFavorFilter ? l10n.filterFavorClear : l10n.filterFavor,
        ),
        IconButton(
          onPressed: () => logViewProvider.toggleSortDateOrder(),
          icon: Icon(
            sortDateOrder == SortDateOrder.newestFirst
                ? Icons.arrow_downward
                : Icons.arrow_upward,
          ),
          tooltip: sortDateOrder == SortDateOrder.newestFirst
              ? l10n.sortOldest
              : l10n.sortNewest,
        ),
      ],
    );
  }
}

class LogsList extends StatelessWidget {
  const LogsList({super.key});

  @override
  Widget build(BuildContext c) {
    final userUid = c.read<UserProvider>().user?.uid;
    return FutureBuilder(
      future: c.read<LogProvider>().fetchLogs(userUid),
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
