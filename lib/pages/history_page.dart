import 'package:emolog/provider/log_view_provider.dart';
import '../export/package/app_essential.dart';
import '../provider/log_provider.dart';
import '../widgets/default_scaffold.dart';
import '../widgets/listview/default_log_list.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});
  @override
  Widget build(BuildContext c) {
    final sortDateOrder = c.select<LogViewProvider, SortDateOrder>(
      (provider) => provider.sortDateOrder,
    );
    return MainScaffold(
      currentIndex: 1,
      actions: [
        IconButton(
          onPressed: () => c.read<LogViewProvider>().toggleSortDateOrder(),
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
