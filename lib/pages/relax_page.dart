import 'package:emolog/provider/user_pvd.dart';
import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/utils/constant.dart';
import 'package:emolog/utils/data_utils.dart';
import 'package:emolog/widgets/listview/default_log_list.dart';
import 'package:emolog/widgets/template/buttons_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/template/scaffold_template.dart';
import '../provider/relax_pvd.dart';
import '../provider/relax_view_pvd.dart';
import 'dart:async';
import '../isar/model/relax.dart';

enum TimerOption { countdown, timer, other }

class RelaxPage extends StatefulWidget {
  RelaxPage({super.key});

  @override
  State<RelaxPage> createState() => _RelaxPageState();
}

class _RelaxPageState extends State<RelaxPage> with RelaxPagePickers {
  TimerOption preset = TimerOption.timer;

  Future<void> showTimer(BuildContext c, TimerOption opt) async {
    final result = await showGeneralDialog(
      context: c,
      barrierDismissible: true,
      barrierLabel: 'Relax detail',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (c, _, __) {
        switch (opt) {
          case TimerOption.countdown:
            return const SizedBox.shrink();
          case TimerOption.timer:
            return RelaxTimerSheet();
          case TimerOption.other:
            return RelaxDetailView();
        }
      },
    );
    if (result == true && context.mounted) {
      context.read<RelaxViewProvider>().justNoti();
    }
  }

  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 2,
      actions: [
        ResetActions(),
        RelaxPageActions(onSelectDate: () => selectDate(c)),
      ],
      child: Column(
        children: [
          DefaultSegmentedButton(
            values: const [TimerOption.timer, TimerOption.other],
            selected: preset,
            icons: const [Icons.timer, Icons.add],
            labels: const ['timer', 'other'],
            onPressed: (opt) {
              setState(() {
                preset = opt;
              });
              showTimer(c, opt);
            },
          ),
          Expanded(child: RelaxesList()),
        ],
      ),
    );
  }

  ButtonSegment<TimerOption> buildButtonSegment(
    BuildContext c,
    ColorScheme colorScheme,
    TextTheme textTheme,
    TimerOption value,
    IconData icon,
  ) {
    return ButtonSegment(
      value: value,
      label: InkWell(
        onTap: () {
          showTimer(c, value);
        },
        child: Padding(
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

    // if (!mounted) return;
    // context.read<RelaxViewProvider>().justNoti();

    if (mounted) {
      Navigator.pop(context, true);
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
        // IconButton(
        //   onPressed: onSelectDate,
        //   icon: Icon(Icons.date_range),
        //   tooltip: l10n.filterDateRange,
        // ),
      ],
    );
  }
}

class RelaxesList extends StatefulWidget {
  const RelaxesList({super.key});

  @override
  State<RelaxesList> createState() => _RelaxesListState();
}

class _RelaxesListState extends State<RelaxesList> {
  @override
  void initState() {
    super.initState();
    _fetching();
  }

  Future<void> _fetching() async {
    final userPvd = context.read<UserProvider>();
    final relaxPvd = context.read<RelaxProvider>();
    final relaxViewPvd = context.read<RelaxViewProvider>();

    final uid = userPvd.user?.uid;
    if (uid == null) return;

    await relaxPvd.fetchRelaxs(userUid: uid, notify: true);

    if (!mounted) return;

    relaxViewPvd.updateRelaxesList(relaxPvd.relaxs, notify: true);
  }

  @override
  Widget build(BuildContext c) {
    final colorScheme = Theme.of(c).colorScheme;
    final textTheme = Theme.of(c).textTheme;
    return Selector<RelaxViewProvider, List<Relax>>(
      selector: (_, pvd) => pvd.allRelaxs,
      builder: (context, relaxs, _) {
        if (relaxs.isEmpty) {
          return Center(
            child: Text(
              'Không có dữ liệu',
              style: textTheme.displayMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: relaxs.length,
          itemBuilder: (c, i) {
            final item = relaxs[i];

            void handleDissmis() =>
                c.read<RelaxProvider>().deleteRelax(id: item.id);

            return Dismissible(
              key: ValueKey(item.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => handleDissmis(),
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: kPaddingLarge),
                color: colorScheme.errorContainer,
                child: Icon(Icons.delete, color: colorScheme.onErrorContainer),
              ),
              child: DefaultRelaxTile(relaxId: item.id),
            );
          },
        );
      },
    );
  }
}
