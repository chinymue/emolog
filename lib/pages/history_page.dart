import 'package:emolog/provider/log_view_provider.dart';
import '../export/package/app_essential.dart';
import '../provider/log_provider.dart';
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
      c.read<LogViewProvider>().setFilterDateRange(picked.start, picked.end);
      // print("Ngày chọn: ${picked.start} - ${picked.end}");
    }
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

    return MainScaffold(
      currentIndex: 1,
      actions: [
        if (hasActiveFilter)
          IconButton(
            onPressed: () => logViewProvider.clearFilters(),
            icon: Icon(Icons.filter_alt_off),
          ),
        IconButton(
          onPressed: () => logViewProvider.setFilterFavor(),
          icon: isFavorFilter
              ? Icon(Icons.favorite_border)
              : Icon(Icons.favorite),
        ),
        IconButton(
          onPressed: () => _selectDate(c),
          icon: Icon(Icons.date_range),
        ),
        IconButton(
          onPressed: () => logViewProvider.toggleSortDateOrder(),
          icon: Icon(
            sortDateOrder == SortDateOrder.newestFirst
                ? Icons.arrow_downward
                : Icons.arrow_upward,
          ),
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
