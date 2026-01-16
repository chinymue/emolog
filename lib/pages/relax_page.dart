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

enum TimerOption { countdown, timer, other }

class RelaxPage extends StatefulWidget {
  RelaxPage({super.key});

  @override
  State<RelaxPage> createState() => _RelaxPageState();
}

class _RelaxPageState extends State<RelaxPage> with RelaxPagePickers {
  TimerOption preset = TimerOption.timer;

  Future<Object?> showTimer(BuildContext c, TimerOption opt) async {
    return await showGeneralDialog(
      context: c,
      barrierDismissible: true,
      barrierLabel: 'Relax detail',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (c, _, __) {
        final relaxPvd = c.read<RelaxProvider>();
        final userUID = c.read<UserProvider>().user?.id.toString();
        switch (opt) {
          case TimerOption.countdown:
          case TimerOption.timer:
            return RelaxTimerSheet();
          case TimerOption.other:
            if (userUID == null) {
              return const SizedBox.shrink();
            }

            return FutureBuilder(
              future: relaxPvd.saveRelax(
                userUID,
                DateTime.now().subtract(const Duration(minutes: 5)),
                DateTime.now(),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                final newRelax = snapshot.data!;
                return RelaxDetailView(relax: newRelax);
              },
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    return MainScaffold(
      currentIndex: 2,
      actions: [
        ResetActions(),
        RelaxPageActions(onSelectDate: () => selectDate(c)),
      ],
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(kPaddingSmall),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Text("Debug Actions:"), // delete later
          //       ElevatedButton(
          //         child: Icon(Icons.add),
          //         onPressed: () async {
          //           final newRelax = await c.read<RelaxProvider>().saveRelax(
          //             userUid ?? "",
          //             DateTime.now().subtract(Duration(minutes: 5)),
          //             DateTime.now(),
          //           );
          //           print("Đã thêm relax ${newRelax.id} mới");
          //         },
          //       ),
          //       ElevatedButton(
          //         child: Icon(Icons.delete_forever),
          //         onPressed: () async {
          //           await c.read<RelaxProvider>().deleteAllRelax(userUid);
          //           print("Đã xóa toàn bộ relax của user $userUid");
          //         },
          //       ),
          //       ElevatedButton(
          //         child: Icon(Icons.delete_sweep),
          //         onPressed: () async {
          //           await c.read<RelaxProvider>().deleteAllRelaxs();
          //           print("Đã xóa toàn bộ relax trong database");
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          SegmentedButton<TimerOption>(
            segments: [
              // ButtonSegment(
              //   value: TimerOption.countdown,
              //   label: Row(
              //     children: [
              //       Icon(Icons.hourglass_empty, size: iconSizeLarge),
              //       Text(
              //         TimerOption.countdown.name,
              //         style: textTheme.labelMedium?.copyWith(
              //           color: colorScheme.primary,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              buildButtonSegment(
                colorScheme,
                textTheme,
                TimerOption.timer,
                Icons.timer,
              ),
              buildButtonSegment(
                colorScheme,
                textTheme,
                TimerOption.other,
                Icons.add,
              ),
            ],
            selected: {preset},
            onSelectionChanged: (set) => showTimer(c, set.first),
          ),
          Expanded(child: RelaxesList()),
        ],
      ),
    );
  }

  ButtonSegment<TimerOption> buildButtonSegment(
    ColorScheme colorScheme,
    TextTheme textTheme,
    TimerOption value,
    IconData icon,
  ) {
    return ButtonSegment(
      value: value,
      label: Padding(
        padding: const EdgeInsets.all(kPaddingSmall),
        child: Row(
          children: [
            Icon(icon, size: iconSize, color: colorScheme.primary),
            Text(
              value.name,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
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
