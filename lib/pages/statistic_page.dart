import 'package:emolog/utils/constant.dart';
import 'package:flutter/material.dart';
import '../widgets/template/scaffold_template.dart';
import 'package:provider/provider.dart';
import '../provider/log_pvd.dart';
import '../provider/user_pvd.dart';
import '../provider/log_view_pvd.dart';
import '../provider/relax_pvd.dart';
import '../utils/data_utils.dart';

class StatisticPage extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 3,
      child: Padding(padding: const EdgeInsets.all(20), child: StatsData()),
    );
  }
}

class StatsData extends StatelessWidget {
  const StatsData({super.key});

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
        return StatisticFields();
      },
    );
  }
}

mixin StatisticUtils {
  Future<DateTime?> selectDate(BuildContext c, DateTime initialDate) async {
    return await showDatePicker(
      context: c,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  Future<DateTimeRange?> selectDateRange(
    BuildContext c,
    DateTimeRange initialDateRange,
  ) async {
    return await showDateRangePicker(
      context: c,
      initialDateRange: initialDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }
}

class StatisticFields extends StatelessWidget with StatisticUtils {
  const StatisticFields({super.key});

  @override
  Widget build(BuildContext c) {
    final selectedDateRange = c.select<LogViewProvider, DateTimeRange?>(
      (p) => p.filterDateRange,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () async {
            final picked = await selectDate(
              c,
              getDateTimeFromDateRange(range: selectedDateRange),
            );
            if (picked != null) {
              if (!c.mounted) return;

              c.read<LogViewProvider>().updateRange(
                getDefaultDateRangeFromDateTime(date: picked),
              );
            }
          },
          child: Text(
            'Chọn ngày bất kỳ: ${formatFullDate(getDateTimeFromDateRange(range: selectedDateRange))}',
          ),
        ),
        SizedBox(height: kPaddingLarge),
        TextButton(
          onPressed: () async {
            final picked = await selectDateRange(
              c,
              selectedDateRange ?? getDefaultDateRangeFromDateTime(),
            );
            if (picked != null) {
              if (!c.mounted) return;
              c.read<LogViewProvider>().updateRange(picked);
            }
          },
          child: Text(
            'Chọn khoảng thời gian bất kỳ: ${formatFullDate(selectedDateRange?.start ?? DateTime.now())} - ${formatFullDate(selectedDateRange?.end ?? DateTime.now())}',
          ),
        ),
        SizedBox(height: kPaddingLarge),
        LogStatisticFields(dateRange: selectedDateRange),
        SizedBox(height: kPaddingLarge),
        RelaxStatisticFields(dateRange: selectedDateRange),
      ],
    );
  }
}

class LogStatisticFields extends StatelessWidget {
  const LogStatisticFields({super.key, this.dateRange});

  final DateTimeRange? dateRange;

  @override
  Widget build(BuildContext c) {
    return Consumer<LogViewProvider>(
      builder: (c, logViewPvd, _) {
        final numberOfLogs = logViewPvd.totalLogs;
        final numberOfFavorLogs = logViewPvd.totalFavorLogs;
        final numberOfNoteLogs = logViewPvd.totalNoteLogs;
        final maxMood = logViewPvd.maxMoodPoint;
        final minMood = logViewPvd.minMoodPoint;
        final avgMood = logViewPvd.avgMoodPoint;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total number of logs: $numberOfLogs',
              style: Theme.of(c).textTheme.bodyMedium,
            ),
            Text(
              'Total number of favorite logs: $numberOfFavorLogs',
              style: Theme.of(c).textTheme.bodyMedium,
            ),
            Text(
              'Total number of note logs: $numberOfNoteLogs',
              style: Theme.of(c).textTheme.bodyMedium,
            ),
            Text(
              'Highest mood point: ${maxMood == 0.0 ? "N/A" : maxMood}',
              style: Theme.of(c).textTheme.bodyMedium,
            ),
            Text(
              'Lowest mood point: $minMood',
              style: Theme.of(c).textTheme.bodyMedium,
            ),
            Text(
              'Average mood point: ${avgMood == 0.0 ? "N/A" : avgMood.toStringAsFixed(2)}',
              style: Theme.of(c).textTheme.bodyMedium,
            ),
          ],
        );
      },
    );
  }
}

class RelaxStatisticFields extends StatelessWidget {
  const RelaxStatisticFields({super.key, this.dateRange});

  final DateTimeRange? dateRange;

  @override
  Widget build(BuildContext c) {
    final numberOfRelaxSessions = dateRange != null
        ? c
              .read<RelaxProvider>()
              .relaxs
              .where(
                (relax) => isInDateTimeRange(
                  dateRange!,
                  relax.startTime,
                  relax.endTime,
                ),
              )
              .length
        : c.read<RelaxProvider>().relaxs.length;

    final numberOfNoteRelaxSessions = dateRange != null
        ? c
              .read<RelaxProvider>()
              .relaxs
              .where(
                (relax) =>
                    relax.note != null &&
                    relax.note!.isNotEmpty &&
                    isInDateTimeRange(
                      dateRange!,
                      relax.startTime,
                      relax.endTime,
                    ),
              )
              .length
        : c
              .read<RelaxProvider>()
              .relaxs
              .where((relax) => relax.note != null && relax.note!.isNotEmpty)
              .length;

    final maxDuration = dateRange != null
        ? c
              .read<RelaxProvider>()
              .relaxs
              .where(
                (relax) => isInDateTimeRange(
                  dateRange!,
                  relax.startTime,
                  relax.endTime,
                ),
              )
              .map((relax) => relax.durationMiliseconds)
              .fold<int?>(null, (prev, duration) {
                if (prev == null) return duration;
                return duration > prev ? duration : prev;
              })
        : c
              .read<RelaxProvider>()
              .relaxs
              .map((relax) => relax.durationMiliseconds)
              .fold<int?>(null, (prev, duration) {
                if (prev == null) return duration;
                return duration > prev ? duration : prev;
              });

    final minDuration = dateRange != null
        ? c
              .read<RelaxProvider>()
              .relaxs
              .where(
                (relax) => isInDateTimeRange(
                  dateRange!,
                  relax.startTime,
                  relax.endTime,
                ),
              )
              .map((relax) => relax.durationMiliseconds)
              .fold<int?>(null, (prev, duration) {
                if (prev == null) return duration;
                return duration < prev ? duration : prev;
              })
        : c
              .read<RelaxProvider>()
              .relaxs
              .map((relax) => relax.durationMiliseconds)
              .fold<int?>(null, (prev, duration) {
                if (prev == null) return duration;
                return duration < prev ? duration : prev;
              });

    final avgDuration = dateRange != null
        ? c
                  .read<RelaxProvider>()
                  .relaxs
                  .where(
                    (relax) => isInDateTimeRange(
                      dateRange!,
                      relax.startTime,
                      relax.endTime,
                    ),
                  )
                  .map((relax) => relax.durationMiliseconds)
                  .fold<int>(0, (prev, duration) => prev + duration) /
              numberOfRelaxSessions
        : c
                  .read<RelaxProvider>()
                  .relaxs
                  .map((relax) => relax.durationMiliseconds)
                  .fold<int>(0, (prev, duration) => prev + duration) /
              numberOfRelaxSessions;

    final maxDurationPerDay = dateRange != null
        ? c
              .read<RelaxProvider>()
              .relaxs
              .where(
                (relax) => isInDateTimeRange(
                  dateRange!,
                  relax.startTime,
                  relax.endTime,
                ),
              )
              .map((relax) => relax.durationMiliseconds)
              .fold<int?>(null, (prev, duration) {
                if (prev == null) return duration;
                return duration > prev ? duration : prev;
              })
        : c
              .read<RelaxProvider>()
              .relaxs
              .map((relax) => relax.durationMiliseconds)
              .fold<int?>(null, (prev, duration) {
                if (prev == null) return duration;
                return duration > prev ? duration : prev;
              });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total number of relax sessions: $numberOfRelaxSessions',
          style: Theme.of(c).textTheme.bodyMedium,
        ),
        Text(
          'Total number of note relax sessions: $numberOfNoteRelaxSessions',
          style: Theme.of(c).textTheme.bodyMedium,
        ),
        Text(
          'Longest relax duration: ${maxDuration != null ? formatFullDuration(maxDuration) : "N/A"}',
          style: Theme.of(c).textTheme.bodyMedium,
        ),
        Text(
          'Shortest relax duration: ${minDuration != null ? formatFullDuration(minDuration) : "N/A"}',
          style: Theme.of(c).textTheme.bodyMedium,
        ),
        Text(
          'Average relax duration: ${numberOfRelaxSessions > 0 ? formatFullDuration(avgDuration.toInt()) : "N/A"}',
          style: Theme.of(c).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
