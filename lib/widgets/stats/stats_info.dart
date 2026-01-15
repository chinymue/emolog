import 'package:emolog/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/stats_pvd.dart';
import '../../utils/data_utils.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsInfo extends StatefulWidget {
  const StatsInfo({super.key});

  @override
  State<StatsInfo> createState() => _StatsInfoState();
}

class _StatsInfoState extends State<StatsInfo> with RangeMixin {
  RangePreset _preset = RangePreset.month;
  DateTime _anchor = DateTime.now();

  late DateTimeRange _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = buildRange(_preset, _anchor);
  }

  void _updateRange() {
    _currentRange = buildRange(_preset, _anchor);
    final stats = context.read<StatsProvider>();
    stats.updateRange(_currentRange);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RangeSelectorBar(
              preset: _preset,
              range: _currentRange,
              onPresetChanged: (p) {
                setState(() {
                  _preset = p;
                  _anchor = DateTime.now();
                });
                _updateRange();
              },
              onPrev: () {
                setState(() {
                  _anchor = shiftAnchor(_preset, _anchor, -1);
                });
                _updateRange();
              },
              onNext: () {
                setState(() {
                  _anchor = shiftAnchor(_preset, _anchor, 1);
                });
                _updateRange();
              },
            ),
            Container(
              constraints: BoxConstraints(
                minHeight: kChartHeightMax + kPaddingLarge,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: MoodCountChart(range: _currentRange),
            ),
            SizedBox(height: kPaddingLarge),
            Container(
              constraints: BoxConstraints(
                minHeight: kChartHeightMax + kPaddingLarge,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: MoodAvgChart(range: _currentRange),
            ),
          ],
        ),
      ),
    );
  }
}

class RangeSelectorBar extends StatelessWidget with RangeMixin {
  const RangeSelectorBar({
    super.key,
    required this.preset,
    required this.onPresetChanged,
    required this.onPrev,
    required this.onNext,
    required this.range,
  });

  final RangePreset preset;
  final ValueChanged<RangePreset> onPresetChanged;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final DateTimeRange range;

  @override
  Widget build(BuildContext c) {
    return SizedBox(
      height: kButtonHeight + kPaddingLarge * 2,
      child: Column(
        children: [
          // SegmentedButton<RangePreset>(
          //   segments: [
          //     ButtonSegment(value: RangePreset.day, label: Text('Day')),
          //     ButtonSegment(value: RangePreset.week, label: Text('Week')),
          //     ButtonSegment(value: RangePreset.month, label: Text('Month')),
          //     ButtonSegment(value: RangePreset.sixMonths, label: Text('6M')),
          //     ButtonSegment(value: RangePreset.year, label: Text('Year')),
          //   ],
          //   selected: {preset},
          //   onSelectionChanged: (set) {
          //     onPresetChanged(set.first);
          //   },
          // ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: iconSizeLarge,
                  icon: const Icon(Icons.chevron_left),
                  onPressed: onPrev,
                ),
                buildTitleRange(c, range, preset),
                IconButton(
                  iconSize: iconSizeLarge,
                  icon: const Icon(Icons.chevron_right),
                  onPressed: onNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

mixin RangeMixin {
  Widget buildTitleRange(
    BuildContext c,
    DateTimeRange dtRange,
    RangePreset preset,
  ) {
    if (preset == RangePreset.day) {
      return Text(
        formatFullDate(dtRange.start),
        style: Theme.of(c).textTheme.headlineMedium,
      );
    } else if (preset == RangePreset.month) {
      return Text(
        '${formatMonthDate(dtRange.start)}',
        style: Theme.of(c).textTheme.headlineMedium,
      );
    } else {
      return Text(
        '${formatDate(dtRange.start)} - ${formatDate(dtRange.end)}',
        style: Theme.of(c).textTheme.headlineMedium,
      );
    }
  }

  DateTimeRange buildRange(RangePreset preset, DateTime anchor) {
    final d = DateTime(anchor.year, anchor.month, anchor.day);

    switch (preset) {
      case RangePreset.day:
        return DateTimeRange(start: d, end: d.add(const Duration(days: 1)));

      case RangePreset.week:
        final start = d.subtract(Duration(days: d.weekday - 1));
        return DateTimeRange(
          start: start,
          end: start.add(const Duration(days: 7)),
        );

      case RangePreset.month:
        final start = DateTime(d.year, d.month, 1);
        final end = DateTime(d.year, d.month + 1, 1);
        return DateTimeRange(start: start, end: end);

      case RangePreset.sixMonths:
        final start = DateTime(d.year, d.month - 5, 1);
        final end = DateTime(d.year, d.month + 1, 1);
        return DateTimeRange(start: start, end: end);

      case RangePreset.year:
        final start = DateTime(d.year, 1, 1);
        final end = DateTime(d.year + 1, 1, 1);
        return DateTimeRange(start: start, end: end);
    }
  }

  DateTime shiftAnchor(RangePreset preset, DateTime anchor, int step) {
    switch (preset) {
      case RangePreset.day:
        return anchor.add(Duration(days: step));

      case RangePreset.week:
        return anchor.add(Duration(days: 7 * step));

      case RangePreset.month:
        return DateTime(anchor.year, anchor.month + step, anchor.day);

      case RangePreset.sixMonths:
        return DateTime(anchor.year, anchor.month + 6 * step, anchor.day);

      case RangePreset.year:
        return DateTime(anchor.year + step, anchor.month, anchor.day);
    }
  }
}

class MoodCountChart extends StatelessWidget {
  const MoodCountChart({super.key, required this.range});

  final DateTimeRange range;

  double ratio(int? num, int total) {
    if (total == 0) return 0;
    return (num ?? 0) / total;
  }

  List<PieChartSectionData> buildSection(Map<String, int> mapCount, int total) {
    return [
      PieChartSectionData(
        value: ratio(mapCount[MoodLevel.awesome.name], total) * 100,
        showTitle: mapCount[MoodLevel.awesome.name] == null ? false : true,
        title: mapCount[MoodLevel.awesome.name].toString(),
        color: colorMood(MoodLevel.awesome),
      ),
      PieChartSectionData(
        value: ratio(mapCount[MoodLevel.good.name], total) * 100,
        showTitle: mapCount[MoodLevel.good.name] == null ? false : true,
        title: mapCount[MoodLevel.good.name].toString(),
        color: colorMood(MoodLevel.good),
      ),
      PieChartSectionData(
        value: ratio(mapCount[MoodLevel.chill.name], total) * 100,
        showTitle: mapCount[MoodLevel.chill.name] == null ? false : true,
        title: mapCount[MoodLevel.chill.name].toString(),
        color: colorMood(MoodLevel.chill),
      ),
      PieChartSectionData(
        value: ratio(mapCount[MoodLevel.not_good.name], total) * 100,
        showTitle: mapCount[MoodLevel.not_good.name] == null ? false : true,
        title: mapCount[MoodLevel.not_good.name].toString(),
        color: colorMood(MoodLevel.not_good),
      ),
      PieChartSectionData(
        value: ratio(mapCount[MoodLevel.terrible.name], total) * 100,
        showTitle: mapCount[MoodLevel.terrible.name] == null ? false : true,
        title: mapCount[MoodLevel.terrible.name].toString(),
        color: colorMood(MoodLevel.terrible),
      ),
    ];
  }

  Widget buildMoodIcon(MoodLevel level, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(moods[level.name], size: iconMaxSize, color: colorMood(level)),
            Positioned(
              top: -kPaddingSmall,
              right: -kPaddingSmall,
              child: Container(
                padding: const EdgeInsets.all(kPaddingExtraSmall),
                constraints: const BoxConstraints(
                  minWidth: kPadding,
                  minHeight: kPadding,
                ),
                decoration: BoxDecoration(
                  color: colorMood(level),
                  shape: BoxShape.circle,
                ),
                child: Text(count.toString()),
              ),
            ),
          ],
        ),
        const SizedBox(width: kPaddingLarge),
        Text(moodLevelToString(level), style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget buildLegend(Map<String, int> moodCounts) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildMoodIcon(
            MoodLevel.awesome,
            moodCounts[MoodLevel.awesome.name] ?? 0,
          ),
          buildMoodIcon(MoodLevel.good, moodCounts[MoodLevel.good.name] ?? 0),
          buildMoodIcon(MoodLevel.chill, moodCounts[MoodLevel.chill.name] ?? 0),
          buildMoodIcon(
            MoodLevel.not_good,
            moodCounts[MoodLevel.not_good.name] ?? 0,
          ),
          buildMoodIcon(
            MoodLevel.terrible,
            moodCounts[MoodLevel.terrible.name] ?? 0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext c) {
    final moodCounts = c.read<StatsProvider>().getMoodCountsInRange(range);
    final total = moodCounts.values.fold<int>(0, (p, n) => p + n);
    if (moodCounts.isEmpty || total == 0) {
      return const Center(child: Text('No data'));
    }

    return Padding(
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Center(
        child: Column(
          children: [
            Text('Mood Counts', style: Theme.of(c).textTheme.headlineMedium),
            const SizedBox(height: kPaddingLarge),
            Wrap(
              children: [
                SizedBox(
                  width: kChartHeight,
                  height: kChartHeight,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          startDegreeOffset: -90,
                          centerSpaceRadius: kChartHeight / 3,
                          sectionsSpace: 10,
                          sections: buildSection(moodCounts, total),
                        ),
                      ),
                      Center(
                        child: Text(
                          total.toString(),
                          style: Theme.of(c).textTheme.headlineMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: kPaddingLarge),
                SizedBox(
                  width: kChartHeight,
                  height: kChartHeight,
                  child: buildLegend(moodCounts),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MoodAvgChart extends StatelessWidget {
  const MoodAvgChart({super.key, required this.range});

  final DateTimeRange range;

  @override
  Widget build(BuildContext c) {
    // return Center(child: Text('No data'));
    return Padding(
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Center(
        child: Column(
          children: [
            Text(
              'Mood Average Daily',
              style: Theme.of(c).textTheme.headlineMedium,
            ),
            const SizedBox(height: kPaddingLarge),
            Wrap(
              children: [
                SizedBox(
                  height: kChartHeight,
                  width: kChartWidth,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 1),
                            FlSpot(1, 2),
                            FlSpot(2, 3),
                            FlSpot(3, 4),
                            FlSpot(4, 5),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
