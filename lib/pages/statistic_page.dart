import 'package:emolog/widgets/stats/stats_info.dart';
import 'package:flutter/material.dart';
import '../widgets/template/scaffold_template.dart';
import 'package:provider/provider.dart';
import '../provider/stats_pvd.dart';
import 'package:emolog/provider/log_pvd.dart';
import '../provider/user_pvd.dart';
import '../provider/relax_pvd.dart';
// import '../widgets/stats/stats_fields.dart';

class StatisticPage extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 3,
      child: Padding(padding: const EdgeInsets.all(20), child: StatsData()),
    );
  }
}

class StatsData extends StatefulWidget {
  const StatsData({super.key});

  @override
  State<StatsData> createState() => _StatsDataState();
}

class _StatsDataState extends State<StatsData> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadStats();
    // _future = Future.value();
  }

  Future<void> _loadStats() async {
    final userUid = context.read<UserProvider>().user?.uid;

    final logPvd = context.read<LogProvider>();
    final relaxPvd = context.read<RelaxProvider>();

    await logPvd.fetchLogs(userUid);
    if (userUid != null) await relaxPvd.fetchRelaxs(userUid: userUid);

    final logs = logPvd.logs;
    final relaxs = relaxPvd.relaxs;

    if (!mounted) return;
    await context.read<StatsProvider>().fetchData(logs, relaxs);
    if (!mounted) return;
    context.read<StatsProvider>().groupLogsByDate();
    context.read<StatsProvider>().groupRelaxByDate();
  }

  @override
  Widget build(BuildContext c) {
    return FutureBuilder(
      future: _future,
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return StatsInfo();
      },
    );
  }
}
