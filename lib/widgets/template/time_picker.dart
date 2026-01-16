import 'package:emolog/utils/constant.dart';
import 'package:flutter/material.dart';
import '../../utils/data_utils.dart';

mixin TimePickerUtils {
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

enum NearbyDateOption { yesterday, today, other }

class TimePickerExampleWidget extends StatefulWidget with TimePickerUtils {
  const TimePickerExampleWidget({super.key, required this.onChanged});

  final ValueChanged<DateTime> onChanged;

  @override
  State<TimePickerExampleWidget> createState() =>
      _TimePickerExampleWidgetState();
}

class _TimePickerExampleWidgetState extends State<TimePickerExampleWidget>
    with TimePickerUtils {
  NearbyDateOption preset = NearbyDateOption.today;
  DateTime _currentDate = DateTime.now();

  void handleDateChange(NearbyDateOption? newPreset) async {
    if (newPreset == null) return;
    DateTime newDate;
    switch (newPreset) {
      case NearbyDateOption.yesterday:
        newDate = DateTime.now().subtract(const Duration(days: 1));
      case NearbyDateOption.today:
        newDate = DateTime.now();
      case NearbyDateOption.other:
        newDate = await selectDate(context, DateTime.now()) ?? DateTime.now();
    }

    setState(() {
      preset = newPreset;
      _currentDate = newDate;
    });

    widget.onChanged(_currentDate);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.primary),
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            children: [
              SegmentedButton(
                segments: [
                  ButtonSegment<NearbyDateOption>(
                    value: NearbyDateOption.yesterday,
                    label: Text(
                      'Yesterday',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  ButtonSegment<NearbyDateOption>(
                    value: NearbyDateOption.today,
                    label: Text(
                      'Today',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  ButtonSegment<NearbyDateOption>(
                    value: NearbyDateOption.other,
                    label: Text(
                      'Other',
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
                selected: {preset},
                onSelectionChanged: (set) => handleDateChange(set.first),
              ),
              SizedBox(height: kPadding),
              Text(
                formatFullDate(_currentDate),
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        // ElevatedButton(
        //   onPressed: () async {
        //     DateTime? selectedDate = await selectDate(context, DateTime.now());
        //     if (selectedDate != null) {
        //       print("Selected date: $selectedDate");
        //       setState(() {
        //         _currentDate = selectedDate;
        //       });
        //     }
        //     widget.onChanged(_currentDate);
        //   },
        //   child: Text('${formatFullDate(_currentDate)}'),
        // ),
      ),
    );
  }
}
