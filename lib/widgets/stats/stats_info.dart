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

  Widget buildChartArea(ColorScheme colorScheme, Widget childWidget) =>
      Container(
        constraints: BoxConstraints(
          minHeight: kChartHeightMax + kPaddingLarge,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: childWidget,
      );

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
            buildChartArea(colorScheme, MoodCountChart(range: _currentRange)),
            SizedBox(height: kPaddingLarge),
            buildChartArea(colorScheme, MoodAvgChart(range: _currentRange)),
            SizedBox(height: kPaddingLarge),
            buildChartArea(
              colorScheme,
              RelaxDurationChart(range: _currentRange),
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
        formatMonthDate(dtRange.start),
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
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    final moodCounts = c.read<StatsProvider>().getMoodCountsInRange(range);
    final total = moodCounts.values.fold<int>(0, (p, n) => p + n);
    if (moodCounts.isEmpty || total == 0) {
      return Center(
        child: Text(
          'No data',
          style: textTheme.displayLarge?.copyWith(color: colorScheme.primary),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Center(
        child: Column(
          children: [
            Text(
              'Mood Counts',
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
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
                          style: textTheme.headlineMedium,
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

  AxisTitles buildMoodTitle() => AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: 0.25,
      reservedSize: iconMaxSize + kPaddingLarge,
      getTitlesWidget: (value, meta) {
        const ticks = [0.0, 0.25, 0.5, 0.75, 1.0];
        final v = double.parse(value.toStringAsFixed(2));

        if (!ticks.contains(v)) {
          return const SizedBox.shrink();
        }

        final moodKey = labelFromMoodPoint(v);
        final moodLevel = stringToMoodLevel(moodKey);

        return Padding(
          padding: const EdgeInsets.all(kPaddingSmall),
          child: Tooltip(
            message: moodKey,
            child: Icon(
              moods[moodKey],
              size: iconMaxSize,
              color: colorMood(moodLevel),
            ),
          ),
        );
      },
    ),
  );

  AxisTitles buildDateTitle() => AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: 1,
      reservedSize: 32,
      getTitlesWidget: (value, meta) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    final moodAvg = c.read<StatsProvider>().getMoodAvgInRange(range);
    if (moodAvg.isEmpty) {
      return Center(
        child: Text(
          'No data',
          style: textTheme.displayLarge?.copyWith(color: colorScheme.primary),
        ),
      );
    } else if (moodAvg.length == 1) {
      return Center(
        child: Text(
          'Not enough data to draw chart',
          style: textTheme.displayLarge?.copyWith(color: colorScheme.primary),
        ),
      );
    }
    final avgMonthly = labelFromMoodPoint(
      moodAvg.map((e) => e.y).reduce((a, b) => a + b) / moodAvg.length,
    );
    return Padding(
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Center(
        child: Column(
          children: [
            Text(
              'Mood Average Daily',
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: kPaddingLarge),
            SizedBox(
              height: kChartHeight,
              width: kChartWidthMax,
              child: LineChart(
                LineChartData(
                  minY: 0.0,
                  maxY: 1.0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: moodAvg,
                      color: colorScheme.primary,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: buildMoodTitle(),
                    bottomTitles: buildDateTitle(),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 0.25,
                    drawVerticalLine: false,
                  ),
                  lineTouchData: buildTouchTooltip(colorScheme, textTheme),
                ),
              ),
            ),
            const SizedBox(height: kPaddingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mood in this month: $avgMonthly',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kPaddingSmall),
                  child: Icon(
                    moods[avgMonthly],
                    color: colorMood(stringToMoodLevel(avgMonthly)),
                    size: iconSize,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineTouchData buildTouchTooltip(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (_) => colorScheme.primary,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            return LineTooltipItem(
              'Mood: ${(spot.y * 100).round()}%',
              textTheme.labelLarge!.copyWith(color: colorScheme.onPrimary),
            );
          }).toList();
        },
      ),
    );
  }
}

class RelaxDurationChart extends StatelessWidget {
  const RelaxDurationChart({super.key, required this.range});

  final DateTimeRange range;

  AxisTitles buildDurationTitle() => AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 32,
      getTitlesWidget: (value, meta) {
        return SizedBox(
          width: 24,
          child: Text(
            value.round().toString(),
            textAlign: TextAlign.center,
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    ),
  );

  AxisTitles buildDateTitle() => AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      interval: 1,
      reservedSize: 32,
      getTitlesWidget: (value, meta) => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          value.toInt().toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    final duration = c.read<StatsProvider>().getRelaxDurationInRange(
      range,
      width: kChartWidthMax,
      color: colorScheme.primary,
    );
    if (duration.isEmpty) {
      return Center(
        child: Text(
          'No data',
          style: textTheme.displayLarge?.copyWith(color: colorScheme.primary),
        ),
      );
    }

    final totalDuration = duration
        .map((e) => e.barRods.first.toY)
        .reduce((a, b) => a + b)
        .round();
    final len = duration.fold<int>(
      0,
      (count, e) => e.barRods.first.toY > 0 ? count + 1 : count,
    );

    final avgDuration = (totalDuration / len).round();
    return Padding(
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Center(
        child: Column(
          children: [
            Text(
              'Relax Duration Daily',
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: kPaddingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(kPaddingExtraSmall),
                    child: Text(
                      "minutes",
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: kPadding),
                SizedBox(
                  height: kChartHeight,
                  width: kChartWidthMax - kPaddingLarge * 2,
                  child: BarChart(
                    BarChartData(
                      barGroups: duration,
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: buildDurationTitle(),
                        bottomTitles: buildDateTitle(),
                      ),
                      gridData: FlGridData(verticalInterval: 5),
                      barTouchData: buildTouchTooltip(colorScheme, textTheme),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kPaddingLarge),

            Text(
              'Average duration daily: $avgDuration minutes',
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary),
            ),
            Text(
              'Total time this month: $totalDuration minutes',
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  BarTouchData buildTouchTooltip(ColorScheme colorScheme, TextTheme textTheme) {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => colorScheme.primary,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final value = rod.toY;

          return BarTooltipItem(
            '${value.round()} minutes',
            textTheme.labelLarge!.copyWith(color: colorScheme.onPrimary),
          );
        },
      ),
    );
  }
}
