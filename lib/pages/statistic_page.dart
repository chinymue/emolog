import 'package:flutter/material.dart';
import '../widgets/template/scaffold_template.dart';
import 'package:provider/provider.dart';
import '../provider/stats_pvd.dart';
import 'package:emolog/provider/log_pvd.dart';
import '../provider/user_pvd.dart';
import '../provider/relax_pvd.dart';
import '../widgets/stats/stats_data.dart';

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
    final userUid = context.read<UserProvider>().user?.uid;
    context.read<LogProvider>().fetchLogs(userUid);
    final logs = context.read<LogProvider>().logs;
    context.read<RelaxProvider>().fetchRelaxs(userUid);
    final relaxs = context.read<RelaxProvider>().relaxs;

    _future = context.read<StatsProvider>().fetchData(logs, relaxs);
  }

  @override
  Widget build(BuildContext c) {
    return FutureBuilder(
      future: _future,
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return StatisticFields();
      },
    );
  }
}
