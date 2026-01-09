import 'package:emolog/provider/user_pvd.dart';
import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/utils/constant.dart';
import 'package:emolog/utils/data_utils.dart';
import 'package:emolog/widgets/listview/default_log_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/template/scaffold_template.dart';
import '../provider/relax_pvd.dart';
import '../provider/relax_view_pvd.dart';
import 'dart:async';

class RelaxPage extends StatelessWidget with RelaxPagePickers {
  RelaxPage({super.key});

  Future<Object?> showTimer(BuildContext c) async {
    return await showGeneralDialog(
      context: c,
      barrierDismissible: true,
      barrierLabel: 'Relax detail',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (c, _, __) {
        return RelaxTimerSheet();
      },
    );
  }

  @override
  Widget build(BuildContext c) {
    final userUid = c.read<UserProvider>().user?.uid;
    return MainScaffold(
      currentIndex: 2,
      actions: [
        ResetActions(),
        RelaxPageActions(onSelectDate: () => selectDate(c)),
        RelexViewActions(),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(kPaddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Debug Actions:"), // delete later
                ElevatedButton(
                  child: Icon(Icons.add),
                  onPressed: () async {
                    final newRelax = await c.read<RelaxProvider>().saveRelax(
                      userUid ?? "",
                      DateTime.now().subtract(Duration(minutes: 5)),
                      DateTime.now(),
                    );
                    print("Đã thêm relax ${newRelax.id} mới");
                  },
                ),
                ElevatedButton(
                  child: Icon(Icons.delete_forever),
                  onPressed: () async {
                    await c.read<RelaxProvider>().deleteAllRelax(userUid);
                    print("Đã xóa toàn bộ relax của user $userUid");
                  },
                ),
                ElevatedButton(
                  child: Icon(Icons.delete_sweep),
                  onPressed: () async {
                    await c.read<RelaxProvider>().deleteAllRelaxs();
                    print("Đã xóa toàn bộ relax trong database");
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(kPaddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: () => showTimer(c),
                ),
              ],
            ),
          ),
          Expanded(child: RelaxesList()),
        ],
      ),
    );
  }
}

class RelaxTimerSheet extends StatefulWidget {
  const RelaxTimerSheet({super.key});

  @override
  State<RelaxTimerSheet> createState() => _RelaxTimerSheetState();
}

class _RelaxTimerSheetState extends State<RelaxTimerSheet> {
  Timer? _timer;
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      setState(() {
        _elapsed = DateTime.now().difference(_startTime!);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> stopAndSave() async {
    final userUid = context.read<UserProvider>().user?.uid;
    if (userUid == null) return;

    await context.read<RelaxProvider>().saveRelax(
      userUid,
      _startTime!,
      _startTime!.add(_elapsed),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  format(_elapsed),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: kPaddingLarge),
                ElevatedButton(
                  onPressed: stopAndSave,
                  child: const Text("Stop & Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

mixin RelaxPagePickers {
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
      // c.read<LogViewProvider>().setFilterDateRange(picked.start, picked.end);
      // print("Ngày chọn: ${picked.start} - ${picked.end}");
    }
  }
}

class ResetActions extends StatelessWidget {
  const ResetActions({super.key});

  @override
  Widget build(BuildContext c) {
    // final l10n = AppLocalizations.of(c)!;
    // final hasActiveFilter = c.select<LogViewProvider, bool>(
    //   (provider) => provider.hasActiveFilter,
    // );
    // return hasActiveFilter
    //     ? IconButton(
    //         onPressed: () => c.read<LogViewProvider>().clearFilters(),
    //         icon: Icon(Icons.filter_alt_off),
    //         tooltip: l10n.filtersClear,
    //       )
    //     : SizedBox.shrink();
    return SizedBox.shrink();
  }
}

class RelaxPageActions extends StatelessWidget {
  const RelaxPageActions({super.key, required this.onSelectDate});

  final VoidCallback onSelectDate;

  @override
  Widget build(BuildContext c) {
    final l10n = AppLocalizations.of(c)!;
    return Row(
      children: [
        IconButton(
          onPressed: onSelectDate,
          icon: Icon(Icons.date_range),
          tooltip: l10n.filterDateRange,
        ),
      ],
    );
  }
}

class RelexViewActions extends StatelessWidget {
  const RelexViewActions({super.key});

  @override
  Widget build(BuildContext c) {
    // final logViewProvider = c.read<LogViewProvider>();
    // final sortDateOrder = c.select<LogViewProvider, SortDateOrder>(
    //   (provider) => provider.sortDateOrder,
    // );
    // final isFavorFilter = c.select<LogViewProvider, bool>(
    //   (provider) => provider.isFavoredLog,
    // );
    // final l10n = AppLocalizations.of(c)!;
    // return Row(
    //   children: [
    //     IconButton(
    //       onPressed: () => logViewProvider.setFilterFavor(),
    //       icon: isFavorFilter
    //           ? Icon(Icons.favorite_border)
    //           : Icon(Icons.favorite),
    //       tooltip: isFavorFilter ? l10n.filterFavorClear : l10n.filterFavor,
    //     ),
    //     IconButton(
    //       onPressed: () => logViewProvider.toggleSortDateOrder(),
    //       icon: Icon(
    //         sortDateOrder == SortDateOrder.newestFirst
    //             ? Icons.arrow_downward
    //             : Icons.arrow_upward,
    //       ),
    //       tooltip: sortDateOrder == SortDateOrder.newestFirst
    //           ? l10n.sortOldest
    //           : l10n.sortNewest,
    //     ),
    //   ],
    // );
    return SizedBox.shrink();
  }
}

class RelaxesList extends StatelessWidget {
  const RelaxesList({super.key});

  @override
  Widget build(BuildContext c) {
    final userUid = c.read<UserProvider>().user?.uid;

    return FutureBuilder(
      future: c.read<RelaxProvider>().fetchRelaxs(userUid),
      builder: (c, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snap.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final relaxs = c.read<RelaxProvider>().relaxs;
            c.read<RelaxViewProvider>().updateRelaxs(relaxs);
            print("Số lượng relaxs: ${relaxs.length}");
          });
        }
        return DefaultList(type: "relax");
      },
    );
  }
}
