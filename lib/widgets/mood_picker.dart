import 'package:flutter/material.dart';
import '../export/basic_utils.dart';

/// Moods default data ---------------------------------------------

const Map<String, IconData> moods = {
  'terrible': Icons.sentiment_very_dissatisfied,
  'not good': Icons.sentiment_dissatisfied,
  'chill': Icons.sentiment_neutral,
  'good': Icons.sentiment_satisfied,
  'awesome': Icons.sentiment_very_satisfied,
};

// Mood picker widget -----------------------------------------------
class MoodPicker extends StatefulWidget {
  MoodPicker({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });
  final void Function(String selectedMood) onMoodSelected;
  final String selectedMood;

  @override
  State<MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<MoodPicker> {
  late String _currentMood;
  @override
  void initState() {
    super.initState();
    _currentMood = widget.selectedMood;
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
              message: entry.key,
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
