import 'package:emolog/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/stats_pvd.dart';
import '../../utils/data_utils.dart';
import 'package:fl_chart/fl_chart.dart';

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
    final selectedDateRange = c.select<StatsProvider, DateTimeRange?>(
      (p) => p.filterDateRange,
    );

    return SingleChildScrollView(
      child: Column(
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

                c.read<StatsProvider>().updateRange(
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
                c.read<StatsProvider>().updateRange(picked);
              }
            },
            child: Text(
              'Chọn khoảng thời gian bất kỳ: ${formatFullDate(selectedDateRange?.start ?? DateTime.now())} - ${formatFullDate(selectedDateRange?.end ?? DateTime.now())}',
            ),
          ),
          SizedBox(height: kPaddingLarge),
          LogStatisticFields(dateRange: selectedDateRange),
          SizedBox(height: kPaddingLarge),
          MoodChart(dateRange: selectedDateRange),
          // RelaxStatisticFields(dateRange: selectedDateRange),
        ],
      ),
    );
  }
}

class LogStatisticFields extends StatelessWidget {
  const LogStatisticFields({super.key, this.dateRange});

  final DateTimeRange? dateRange;

  @override
  Widget build(BuildContext c) {
    return Consumer<StatsProvider>(
      builder: (c, statsPvd, _) {
        final numberOfLogs = statsPvd.totalLogs;
        final numberOfFavorLogs = statsPvd.totalFavorLogs;
        final numberOfNoteLogs = statsPvd.totalNoteLogs;
        final maxMood = statsPvd.maxMoodPoint;
        final minMood = statsPvd.minMoodPoint;
        final avgMood = statsPvd.avgMoodPoint;

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

class MoodChart extends StatelessWidget {
  const MoodChart({super.key, this.dateRange});

  final DateTimeRange? dateRange;

  @override
  Widget build(BuildContext c) {
    return Consumer<StatsProvider>(
      builder: (c, statsPvd, _) {
        // final spots = statsPvd.moodDaily;
        final rawSpots = statsPvd.moodRaw;
        // final safeSpots = spots
        //     .where((e) => e.x.isFinite && e.y.isFinite)
        //     .toList();

        // if (safeSpots.isEmpty) {
        //   return const SizedBox(
        //     height: 200,
        //     child: Center(child: Text('No data')),
        //   );
        // } else if (spots.length < 2) {
        //   return const SizedBox(
        //     height: 200,
        //     child: Center(child: Text('Không đủ dữ liệu để vẽ biểu đồ')),
        //   );
        if (rawSpots.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('No data')),
          );
        } else {
          final firstX = DateTime.fromMillisecondsSinceEpoch(
            rawSpots.first.x.toInt(),
          );
          final lastX = DateTime.fromMillisecondsSinceEpoch(
            rawSpots.last.x.toInt(),
          );
          final intervalX = lastX.difference(firstX).inMilliseconds / 8;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(kPaddingLarge),
              child: Container(
                constraints: BoxConstraints.expand(width: 500, height: 500),
                child: LineChart(
                  LineChartData(
                    lineBarsData: [LineChartBarData(spots: rawSpots)],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: Duration(
                            milliseconds: intervalX.toInt(),
                          ).inMilliseconds.toDouble(),
                          getTitlesWidget: (value, meta) {
                            final date = DateTime.fromMillisecondsSinceEpoch(
                              value.toInt(),
                            );
                            return SideTitleWidget(
                              angle: -0.5,
                              space: 1.0,
                              meta: meta,
                              child: Text(formatTime(date)),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

// class RelaxStatisticFields extends StatelessWidget {
//   const RelaxStatisticFields({super.key, this.dateRange});

//   final DateTimeRange? dateRange;

//   @override
//   Widget build(BuildContext c) {
//     final numberOfRelaxSessions = dateRange != null
//         ? c
//               .read<RelaxProvider>()
//               .relaxs
//               .where(
//                 (relax) => isInDateTimeRange(
//                   dateRange!,
//                   relax.startTime,
//                   relax.endTime,
//                 ),
//               )
//               .length
//         : c.read<RelaxProvider>().relaxs.length;

//     final numberOfNoteRelaxSessions = dateRange != null
//         ? c
//               .read<RelaxProvider>()
//               .relaxs
//               .where(
//                 (relax) =>
//                     relax.note != null &&
//                     relax.note!.isNotEmpty &&
//                     isInDateTimeRange(
//                       dateRange!,
//                       relax.startTime,
//                       relax.endTime,
//                     ),
//               )
//               .length
//         : c
//               .read<RelaxProvider>()
//               .relaxs
//               .where((relax) => relax.note != null && relax.note!.isNotEmpty)
//               .length;

//     final maxDuration = dateRange != null
//         ? c
//               .read<RelaxProvider>()
//               .relaxs
//               .where(
//                 (relax) => isInDateTimeRange(
//                   dateRange!,
//                   relax.startTime,
//                   relax.endTime,
//                 ),
//               )
//               .map((relax) => relax.durationMiliseconds)
//               .fold<int?>(null, (prev, duration) {
//                 if (prev == null) return duration;
//                 return duration > prev ? duration : prev;
//               })
//         : c
//               .read<RelaxProvider>()
//               .relaxs
//               .map((relax) => relax.durationMiliseconds)
//               .fold<int?>(null, (prev, duration) {
//                 if (prev == null) return duration;
//                 return duration > prev ? duration : prev;
//               });

//     final minDuration = dateRange != null
//         ? c
//               .read<RelaxProvider>()
//               .relaxs
//               .where(
//                 (relax) => isInDateTimeRange(
//                   dateRange!,
//                   relax.startTime,
//                   relax.endTime,
//                 ),
//               )
//               .map((relax) => relax.durationMiliseconds)
//               .fold<int?>(null, (prev, duration) {
//                 if (prev == null) return duration;
//                 return duration < prev ? duration : prev;
//               })
//         : c
//               .read<RelaxProvider>()
//               .relaxs
//               .map((relax) => relax.durationMiliseconds)
//               .fold<int?>(null, (prev, duration) {
//                 if (prev == null) return duration;
//                 return duration < prev ? duration : prev;
//               });

//     final avgDuration = dateRange != null
//         ? c
//                   .read<RelaxProvider>()
//                   .relaxs
//                   .where(
//                     (relax) => isInDateTimeRange(
//                       dateRange!,
//                       relax.startTime,
//                       relax.endTime,
//                     ),
//                   )
//                   .map((relax) => relax.durationMiliseconds)
//                   .fold<int>(0, (prev, duration) => prev + duration) /
//               numberOfRelaxSessions
//         : c
//                   .read<RelaxProvider>()
//                   .relaxs
//                   .map((relax) => relax.durationMiliseconds)
//                   .fold<int>(0, (prev, duration) => prev + duration) /
//               numberOfRelaxSessions;

//     final maxDurationPerDay = dateRange != null
//         ? c
//               .read<RelaxProvider>()
//               .relaxs
//               .where(
//                 (relax) => isInDateTimeRange(
//                   dateRange!,
//                   relax.startTime,
//                   relax.endTime,
//                 ),
//               )
//               .map((relax) => relax.durationMiliseconds)
//               .fold<int?>(null, (prev, duration) {
//                 if (prev == null) return duration;
//                 return duration > prev ? duration : prev;
//               })
//         : c
//               .read<RelaxProvider>()
//               .relaxs
//               .map((relax) => relax.durationMiliseconds)
//               .fold<int?>(null, (prev, duration) {
//                 if (prev == null) return duration;
//                 return duration > prev ? duration : prev;
//               });

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Total number of relax sessions: $numberOfRelaxSessions',
//           style: Theme.of(c).textTheme.bodyMedium,
//         ),
//         Text(
//           'Total number of note relax sessions: $numberOfNoteRelaxSessions',
//           style: Theme.of(c).textTheme.bodyMedium,
//         ),
//         Text(
//           'Longest relax duration: ${maxDuration != null ? formatFullDuration(maxDuration) : "N/A"}',
//           style: Theme.of(c).textTheme.bodyMedium,
//         ),
//         Text(
//           'Shortest relax duration: ${minDuration != null ? formatFullDuration(minDuration) : "N/A"}',
//           style: Theme.of(c).textTheme.bodyMedium,
//         ),
//         Text(
//           'Average relax duration: ${numberOfRelaxSessions > 0 ? formatFullDuration(avgDuration.toInt()) : "N/A"}',
//           style: Theme.of(c).textTheme.bodyMedium,
//         ),
//       ],
//     );
//   }
// }
