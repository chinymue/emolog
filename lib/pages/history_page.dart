import '../export/app_essential.dart';
import '../provider/log_provider.dart';
import '../widgets/default_scaffold.dart';
import '../widgets/listview/default_log_list.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});
  @override
  Widget build(BuildContext c) =>
      MainScaffold(currentIndex: 1, child: LogsList());
}

class LogsList extends StatelessWidget {
  const LogsList({super.key});

  @override
  Widget build(BuildContext c) {
    final logProvider = c.watch<LogProvider>();
    return FutureBuilder(
      future: logProvider.fetchLogs(),
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return DefaultList();
      },
    );
  }
}
