import 'package:flutter/material.dart';
import '../../utils/color_utils.dart';
import '../../utils/constant.dart';
import 'package:emolog/l10n/app_localizations.dart';

String localizedMood(AppLocalizations l10n, String moodKey) {
  switch (moodKey) {
    case 'terrible':
      return l10n.moodTerrible;
    case 'not_good':
      return l10n.moodNotGood;
    case 'chill':
      return l10n.moodChill;
    case 'good':
      return l10n.moodGood;
    case 'awesome':
      return l10n.moodAwesome;
    default:
      return moodKey; // fallback
  }
}

// Mood picker widget -----------------------------------------------
class MoodPicker extends StatefulWidget {
  const MoodPicker({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
  });
  final void Function(String selectedMood) onMoodSelected;
  final String? selectedMood;

  @override
  State<MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<MoodPicker> {
  late String _currentMood;
  @override
  void initState() {
    super.initState();
    _currentMood = widget.selectedMood ?? initialMood;
  }

  @override
  Widget build(BuildContext c) {
    final colorPrimary = Theme.of(c).colorScheme.primary;
    return SizedBox(
      height: 70,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: moods.entries.map((entry) {
            final selected = _currentMood == entry.key;
            return Tooltip(
              message: localizedMood(AppLocalizations.of(c)!, entry.key),
              preferBelow: false,
              child: IconButton(
                icon: Icon(
                  entry.value,
                  size: iconMaxSize,
                  color: selected
                      ? colorPrimary
                      : adjustLightness(colorPrimary, 0.2),
                ),
                onPressed: () {
                  setState(() => _currentMood = entry.key);
                  widget.onMoodSelected(entry.key);
                },
                splashRadius: kBorderRadiusSmall,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MoodPointPicker extends StatefulWidget {
  MoodPointPicker({
    super.key,
    this.selectedMoodPoint,
    required this.onChangedMoodPoint,
  });
  final void Function(double value) onChangedMoodPoint;
  final double? selectedMoodPoint;

  @override
  State<MoodPointPicker> createState() => _MoodPointPickerState();
}

class _MoodPointPickerState extends State<MoodPointPicker> {
  late double _value;
  @override
  void initState() {
    super.initState();
    _value = widget.selectedMoodPoint ?? 0.5;
  }

  @override
  Widget build(BuildContext c) {
    final colorScheme = Theme.of(c).colorScheme;
    return Slider(
      value: _value,
      min: minMoodPoint,
      max: maxMoodPoint,
      divisions: 100,
      label: "${(_value * 100).round().toString()}%",
      onChanged: (double value) {
        setState(() {
          _value = value;
        });
        widget.onChangedMoodPoint(value);
      },
      activeColor: colorScheme.primary,
      inactiveColor: colorScheme.secondary,
    );
  }
}

class MoodRangePicker extends StatefulWidget {
  const MoodRangePicker({super.key, required this.onChangedRange});
  final void Function(RangeValues values) onChangedRange;

  @override
  State<MoodRangePicker> createState() => _MoodRangePickerState();
}

class _MoodRangePickerState extends State<MoodRangePicker> {
  RangeValues _currentRange = const RangeValues(minMoodPoint, maxMoodPoint);

  @override
  Widget build(BuildContext c) {
    final colorScheme = Theme.of(c).colorScheme;
    return RangeSlider(
      values: _currentRange,
      min: minMoodPoint,
      max: maxMoodPoint,
      divisions: 100,
      labels: RangeLabels(
        "${(_currentRange.start * 100).round().toString()}%",
        "${(_currentRange.end * 100).round().toString()}%",
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRange = values;
        });
        widget.onChangedRange(values);
      },
      activeColor: colorScheme.primary,
      inactiveColor: colorScheme.secondary,
    );
  }
}
