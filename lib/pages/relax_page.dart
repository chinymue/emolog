import 'package:emolog/provider/user_pvd.dart';
import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/utils/constant.dart';
import 'package:emolog/widgets/listview/default_log_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/template/scaffold_template.dart';
import '../provider/relax_pvd.dart';
import '../provider/relax_view_pvd.dart';

class RelaxPage extends StatefulWidget {
  RelaxPage({super.key});

  @override
  State<RelaxPage> createState() => _RelaxPageState();
}

class _RelaxPageState extends State<RelaxPage> with RelaxPagePickers {
  bool isInit = false;
  DateTime? startTime;

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
                    setState(() {});
                    print("Đã thêm relax ${newRelax.id} mới");
                  },
                ),
                // ElevatedButton(
                //   child: Icon(Icons.update),
                //   onPressed: () async {
                //     final id = 36025389;
                //     await c.read<RelaxProvider>().updateRelax(
                //       id,
                //       start: DateTime.now().subtract(Duration(minutes: 15)),
                //       end: DateTime.now(),
                //     );
                //     // print("Đã sửa relax $id");
                //   },
                // ),
                // ElevatedButton(
                //   child: Icon(Icons.delete),
                //   onPressed: () async {
                //     final id = 36025389;
                //     await c.read<RelaxProvider>().deleteRelax(id: id);
                //     // print("Đã xóa relax $id");
                //   },
                // ),
                ElevatedButton(
                  child: Icon(Icons.delete_forever),
                  onPressed: () async {
                    await c.read<RelaxProvider>().deleteAllRelax(userUid);
                    setState(() {});
                    print("Đã xóa toàn bộ relax của user $userUid");
                  },
                ),
                ElevatedButton(
                  child: Icon(Icons.delete_sweep),
                  onPressed: () async {
                    await c.read<RelaxProvider>().deleteAllRelaxs();
                    setState(() {});
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
                  child: isInit ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                  onPressed: () async {
                    if (!isInit) {
                      final startTime = DateTime.now();
                      print("Start at $startTime");
                      setState(() {
                        this.startTime = startTime;
                        isInit = true;
                      });
                    } else {
                      final endTime = DateTime.now();
                      print("End at $endTime");
                      final newRelax = await c.read<RelaxProvider>().saveRelax(
                        userUid ?? "",
                        startTime!,
                        endTime,
                      );
                      print("Đã thêm relax ${newRelax.id} mới");
                      setState(() {
                        isInit = false;
                        startTime = null;
                      });
                      print("reset lai trang thai");
                    }
                  },
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
