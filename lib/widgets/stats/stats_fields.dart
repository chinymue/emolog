// import 'package:emolog/utils/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../provider/stats_pvd.dart';
// import '../../utils/data_utils.dart';
// import 'package:fl_chart/fl_chart.dart';

// class StatisticFields extends StatefulWidget {
//   const StatisticFields({super.key});

//   @override
//   State<StatisticFields> createState() => _StatisticFieldsState();
// }

// class _StatisticFieldsState extends State<StatisticFields>
//     with StatisticUtils, RangeMixin {
//   RangePreset _preset = RangePreset.day;
//   DateTime _anchor = DateTime.now();

//   late DateTimeRange _currentRange;

//   @override
//   void initState() {
//     super.initState();
//     _currentRange = buildRange(_preset, _anchor);
//   }

//   void _updateRange() {
//     _currentRange = buildRange(_preset, _anchor);
//     final stats = context.read<StatsProvider>();
//     stats.updateRange(_currentRange);
//     stats.rebuildMood(_preset, _currentRange);
//   }

//   @override
//   Widget build(BuildContext c) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           RangeSelectorBar(
//             preset: _preset,
//             range: _currentRange,
//             onPresetChanged: (p) {
//               setState(() {
//                 _preset = p;
//                 _anchor = DateTime.now();
//               });
//               _updateRange();
//             },
//             onPrev: () {
//               setState(() {
//                 _anchor = shiftAnchor(_preset, _anchor, -1);
//               });
//               _updateRange();
//             },
//             onNext: () {
//               setState(() {
//                 _anchor = shiftAnchor(_preset, _anchor, 1);
//               });
//               _updateRange();
//             },
//           ),

//           const SizedBox(height: kPaddingLarge),

//           /// ---------- CONTENT ----------
//           // LogStatisticFields(),
//           const SizedBox(height: kPaddingLarge),
//           MoodChart(type: _preset, range: _currentRange),
//         ],
//       ),
//     );
//   }
// }

// mixin StatisticUtils {
//   Future<DateTime?> selectDate(BuildContext c, DateTime initialDate) async {
//     return await showDatePicker(
//       context: c,
//       initialDate: initialDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//   }

//   Future<DateTimeRange?> selectDateRange(
//     BuildContext c,
//     DateTimeRange initialDateRange,
//   ) async {
//     return await showDateRangePicker(
//       context: c,
//       initialDateRange: initialDateRange,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//   }
// }

// class RangeSelectorBar extends StatelessWidget with RangeMixin {
//   const RangeSelectorBar({
//     super.key,
//     required this.preset,
//     required this.onPresetChanged,
//     required this.onPrev,
//     required this.onNext,
//     required this.range,
//   });

//   final RangePreset preset;
//   final ValueChanged<RangePreset> onPresetChanged;
//   final VoidCallback onPrev;
//   final VoidCallback onNext;
//   final DateTimeRange range;

//   @override
//   Widget build(BuildContext c) {
//     return SizedBox(
//       height: 200,
//       child: Column(
//         children: [
//           SegmentedButton<RangePreset>(
//             segments: [
//               ButtonSegment(value: RangePreset.day, label: Text('Day')),
//               ButtonSegment(value: RangePreset.week, label: Text('Week')),
//               ButtonSegment(value: RangePreset.month, label: Text('Month')),
//               ButtonSegment(value: RangePreset.sixMonths, label: Text('6M')),
//               ButtonSegment(value: RangePreset.year, label: Text('Year')),
//             ],
//             selected: {preset},
//             onSelectionChanged: (set) {
//               onPresetChanged(set.first);
//             },
//           ),
//           Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                   iconSize: iconSizeLarge,
//                   icon: const Icon(Icons.chevron_left),
//                   onPressed: onPrev,
//                 ),
//                 buildTitleRange(c, range, preset),
//                 IconButton(
//                   iconSize: iconSizeLarge,
//                   icon: const Icon(Icons.chevron_right),
//                   onPressed: onNext,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// mixin RangeMixin {
//   Widget buildTitleRange(
//     BuildContext c,
//     DateTimeRange dtRange,
//     RangePreset preset,
//   ) {
//     if (preset == RangePreset.day) {
//       return Text(
//         formatFullDate(dtRange.start),
//         style: Theme.of(c).textTheme.headlineMedium,
//       );
//     } else {
//       return Text(
//         '${formatDate(dtRange.start)} - ${formatDate(dtRange.end)}',
//         style: Theme.of(c).textTheme.headlineMedium,
//       );
//     }
//   }

//   DateTimeRange buildRange(RangePreset preset, DateTime anchor) {
//     final d = DateTime(anchor.year, anchor.month, anchor.day);

//     switch (preset) {
//       case RangePreset.day:
//         return DateTimeRange(start: d, end: d.add(const Duration(days: 1)));

//       case RangePreset.week:
//         final start = d.subtract(Duration(days: d.weekday - 1));
//         return DateTimeRange(
//           start: start,
//           end: start.add(const Duration(days: 7)),
//         );

//       case RangePreset.month:
//         final start = DateTime(d.year, d.month, 1);
//         final end = DateTime(d.year, d.month + 1, 1);
//         return DateTimeRange(start: start, end: end);

//       case RangePreset.sixMonths:
//         final start = DateTime(d.year, d.month - 5, 1);
//         final end = DateTime(d.year, d.month + 1, 1);
//         return DateTimeRange(start: start, end: end);

//       case RangePreset.year:
//         final start = DateTime(d.year, 1, 1);
//         final end = DateTime(d.year + 1, 1, 1);
//         return DateTimeRange(start: start, end: end);
//     }
//   }

//   DateTime shiftAnchor(RangePreset preset, DateTime anchor, int step) {
//     switch (preset) {
//       case RangePreset.day:
//         return anchor.add(Duration(days: step));

//       case RangePreset.week:
//         return anchor.add(Duration(days: 7 * step));

//       case RangePreset.month:
//         return DateTime(anchor.year, anchor.month + step, anchor.day);

//       case RangePreset.sixMonths:
//         return DateTime(anchor.year, anchor.month + 6 * step, anchor.day);

//       case RangePreset.year:
//         return DateTime(anchor.year + step, anchor.month, anchor.day);
//     }
//   }
// }

// class MoodChart extends StatelessWidget {
//   const MoodChart({super.key, required this.type, required this.range});

//   final RangePreset type;

//   final DateTimeRange range;

//   double get minX => 0;
//   double get maxX => range.duration.inMilliseconds.toDouble();
//   int get baseX => range.start.millisecondsSinceEpoch;
//   int get maxXTitles => 8;

//   SideTitles buildMoodTitles() {
//     return SideTitles(
//       showTitles: true,
//       interval: 0.25,
//       getTitlesWidget: (value, meta) {
//         return SideTitleWidget(
//           meta: meta,
//           child: Text(value.toStringAsFixed(2)),
//         );
//       },
//     );
//   }

//   double intervalByPreset(RangePreset preset) {
//     switch (preset) {
//       case RangePreset.day:
//         return 2; // 2 giờ
//       case RangePreset.week:
//         return 1; // mỗi ngày
//       case RangePreset.month:
//         return 3; // 3 ngày
//       case RangePreset.sixMonths:
//         return 1; // 2 tuần
//       case RangePreset.year:
//         return 1; // mỗi tháng
//     }
//   }

//   Widget buildTextTime(DateTime date) {
//     switch (type) {
//       case RangePreset.day:
//         return Text(formatTimeHHmm(date));
//       case RangePreset.week:
//         return Text(formatDate(date));
//       case RangePreset.month:
//         return Text(formatDate(date));
//       case RangePreset.sixMonths:
//         return Text(formatDate(date));
//       case RangePreset.year:
//         return Text(formatMonthDate(date));
//     }
//   }

//   SideTitles buildTimeTitles(ChartXMapper? mapper) {
//     return SideTitles(
//       showTitles: true,
//       interval: intervalByPreset(type),
//       getTitlesWidget: (value, meta) {
//         if (!value.isFinite) {
//           return const SizedBox.shrink();
//         }

//         if (mapper == null) {
//           return SideTitleWidget(
//             angle: -0.5,
//             space: 6,
//             meta: meta,
//             child: Text(value.toString()),
//           );
//         }
//         final date = mapper.fromX(value);

//         return SideTitleWidget(
//           angle: -0.5,
//           space: 6,
//           meta: meta,
//           child: buildTextTime(date),
//         );
//       },
//       // getTitlesWidget: (value, meta) {
//       //   final date = DateTime.fromMillisecondsSinceEpoch(
//       //     (baseX + value).toInt(),
//       //   );
//       //   return SideTitleWidget(
//       //     angle: -0.5,
//       //     space: 5.0,
//       //     // fitInside: const SideTitleFitInsideData(
//       //     //   enabled: false,
//       //     //   axisPosition: 0,
//       //     //   parentAxisSize: 0,
//       //     //   distanceFromEdge: 1,
//       //     // ),
//       //     meta: meta,
//       //     child: buildTextTime(date),
//       //   );
//       // },
//     );
//   }

//   List<LineChartBarData> buildChartData(List<FlSpot> spots) {
//     if (spots.isEmpty) {
//       return [];
//     } else if (spots.length == 1) {
//       final s = spots.first;
//       return [
//         LineChartBarData(spots: [s, FlSpot(s.x + 0.0001, s.y)], barWidth: 0),
//       ];
//     } else {
//       return [LineChartBarData(spots: spots)];
//     }
//   }

//   @override
//   Widget build(BuildContext c) {
//     return Consumer<StatsProvider>(
//       builder: (c, statsPvd, _) {
//         final hasData = statsPvd.hasMoodData;

//         if (!hasData) {
//           return const SizedBox();
//         }

//         final spots = statsPvd.moodSpots;
//         final mapper = statsPvd.mapper;

//         return SizedBox(
//           height: MediaQuery.of(c).size.height * 0.4,
//           width: MediaQuery.of(c).size.width * 0.8,
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(kPaddingLarge),
//               child: Container(
//                 constraints: BoxConstraints.expand(height: 200, width: 700),
//                 // child: const Text('chart disabled'),
//                 child: LineChart(
//                   LineChartData(
//                     minX: hasData ? minX : 0,
//                     maxX: hasData ? maxX : 1,
//                     minY: 0.0,
//                     maxY: 1.0,
//                     lineBarsData: buildChartData(spots),
//                     titlesData: FlTitlesData(
//                       topTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       leftTitles: AxisTitles(sideTitles: buildMoodTitles()),
//                       rightTitles: AxisTitles(
//                         sideTitles: SideTitles(showTitles: false),
//                       ),
//                       bottomTitles: AxisTitles(
//                         sideTitles: buildTimeTitles(mapper),
//                       ),
//                     ),
//                     gridData: FlGridData(
//                       show: true,
//                       verticalInterval: maxX / maxXTitles,
//                     ),
//                     borderData: FlBorderData(show: true, border: Border.all()),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // class LogStatisticFields extends StatelessWidget {
// //   const LogStatisticFields({super.key});

// //   @override
// //   Widget build(BuildContext c) {
// //     return Consumer<StatsProvider>(
// //       builder: (c, statsPvd, _) {
// //         final numberOfLogs = statsPvd.totalLogs;
// //         final numberOfFavorLogs = statsPvd.totalFavorLogs;
// //         final numberOfNoteLogs = statsPvd.totalNoteLogs;
// //         final maxMood = statsPvd.maxMoodPoint;
// //         final minMood = statsPvd.minMoodPoint;
// //         final avgMood = statsPvd.avgMoodPoint;

// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Total number of logs: $numberOfLogs',
// //               style: Theme.of(c).textTheme.bodyMedium,
// //             ),
// //             Text(
// //               'Total number of favorite logs: $numberOfFavorLogs',
// //               style: Theme.of(c).textTheme.bodyMedium,
// //             ),
// //             Text(
// //               'Total number of note logs: $numberOfNoteLogs',
// //               style: Theme.of(c).textTheme.bodyMedium,
// //             ),
// //             Text(
// //               'Highest mood point: ${maxMood == 0.0 ? "N/A" : maxMood}',
// //               style: Theme.of(c).textTheme.bodyMedium,
// //             ),
// //             Text(
// //               'Lowest mood point: $minMood',
// //               style: Theme.of(c).textTheme.bodyMedium,
// //             ),
// //             Text(
// //               'Average mood point: ${avgMood == 0.0 ? "N/A" : avgMood.toStringAsFixed(2)}',
// //               style: Theme.of(c).textTheme.bodyMedium,
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }

// // class RelaxStatisticFields extends StatelessWidget {
// //   const RelaxStatisticFields({super.key, this.dateRange});

// //   final DateTimeRange? dateRange;

// //   @override
// //   Widget build(BuildContext c) {
// //     final numberOfRelaxSessions = dateRange != null
// //         ? c
// //               .read<RelaxProvider>()
// //               .relaxs
// //               .where(
// //                 (relax) => isInDateTimeRange(
// //                   dateRange!,
// //                   relax.startTime,
// //                   relax.endTime,
// //                 ),
// //               )
// //               .length
// //         : c.read<RelaxProvider>().relaxs.length;

// //     final numberOfNoteRelaxSessions = dateRange != null
// //         ? c
// //               .read<RelaxProvider>()
// //               .relaxs
// //               .where(
// //                 (relax) =>
// //                     relax.note != null &&
// //                     relax.note!.isNotEmpty &&
// //                     isInDateTimeRange(
// //                       dateRange!,
// //                       relax.startTime,
// //                       relax.endTime,
// //                     ),
// //               )
// //               .length
// //         : c
// //               .read<RelaxProvider>()
// //               .relaxs
// //               .where((relax) => relax.note != null && relax.note!.isNotEmpty)
// //               .length;

// //     final maxDuration = dateRange != null
// //         ? c
// //               .read<RelaxProvider>()
// //               .relaxs
// //               .where(
// //                 (relax) => isInDateTimeRange(
// //                   dateRange!,
// //                   relax.startTime,
// //                   relax.endTime,
// //                 ),
// //               )
// //               .map((relax) => relax.durationMiliseconds)
// //               .fold<int?>(null, (prev, duration) {
// //                 if (prev == null) return duration;
// //                 return duration > prev ? duration : prev;
// //               })
// //         : c
// //               .read<RelaxProvider>()
// //               .relaxs
// //               .map((relax) => relax.durationMiliseconds)
// //               .fold<int?>(null, (prev, duration) {
// //                 if (prev == null) return duration;
// //                 return duration > prev ? duration : prev;
// //               });

// //     final minDuration = dateRange != null
// //         ? c
// //               .read<RelaxProvider>()
// //               .relaxs
// //               .where(
// //                 (relax) => isInDateTimeRange(
// //                   dateRange!,
// //                   relax.startTime,
// //                   relax.endTime,
// //                 ),
// //               )
// //               .map((relax) => relax.durationMiliseconds)
// //               .fold<int?>(null, (prev, duration) {
// //                 if (prev == null) return duration;
// //                 return duration < prev ? duration : prev;
// //               })
// //         : c
// //               .read<RelaxProvider>()
// //               .relaxs
// //               .map((relax) => relax.durationMiliseconds)
// //               .fold<int?>(null, (prev, duration) {
// //                 if (prev == null) return duration;
// //                 return duration < prev ? duration : prev;
// //               });

// //     final avgDuration = dateRange != null
// //         ? c
// //                   .read<RelaxProvider>()
// //                   .relaxs
// //                   .where(
// //                     (relax) => isInDateTimeRange(
// //                       dateRange!,
// //                       relax.startTime,
// //                       relax.endTime,
// //                     ),
// //                   )
// //                   .map((relax) => relax.durationMiliseconds)
// //                   .fold<int>(0, (prev, duration) => prev + duration) /
// //               numberOfRelaxSessions
// //         : c
// //                   .read<RelaxProvider>()
// //                   .relaxs
// //                   .map((relax) => relax.durationMiliseconds)
// //                   .fold<int>(0, (prev, duration) => prev + duration) /
// //               numberOfRelaxSessions;

// //     final maxDurationPerDay = dateRange != null
// //         ? c
// //               .read<RelaxProvider>()
// //               .relaxs
// //               .where(
// //                 (relax) => isInDateTimeRange(
// //                   dateRange!,
// //                   relax.startTime,
// //                   relax.endTime,
// //                 ),
// //               )
// //               .map((relax) => relax.durationMiliseconds)
// //               .fold<int?>(null, (prev, duration) {
// //                 if (prev == null) return duration;
// //                 return duration > prev ? duration : prev;
// //               })
// //         : c
// //               .read<RelaxProvider>()
// //               .relaxs
// //               .map((relax) => relax.durationMiliseconds)
// //               .fold<int?>(null, (prev, duration) {
// //                 if (prev == null) return duration;
// //                 return duration > prev ? duration : prev;
// //               });

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           'Total number of relax sessions: $numberOfRelaxSessions',
// //           style: Theme.of(c).textTheme.bodyMedium,
// //         ),
// //         Text(
// //           'Total number of note relax sessions: $numberOfNoteRelaxSessions',
// //           style: Theme.of(c).textTheme.bodyMedium,
// //         ),
// //         Text(
// //           'Longest relax duration: ${maxDuration != null ? formatFullDuration(maxDuration) : "N/A"}',
// //           style: Theme.of(c).textTheme.bodyMedium,
// //         ),
// //         Text(
// //           'Shortest relax duration: ${minDuration != null ? formatFullDuration(minDuration) : "N/A"}',
// //           style: Theme.of(c).textTheme.bodyMedium,
// //         ),
// //         Text(
// //           'Average relax duration: ${numberOfRelaxSessions > 0 ? formatFullDuration(avgDuration.toInt()) : "N/A"}',
// //           style: Theme.of(c).textTheme.bodyMedium,
// //         ),
// //       ],
// //     );
// //   }
// // }
