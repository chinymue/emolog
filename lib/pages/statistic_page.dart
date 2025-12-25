import 'package:emolog/utils/constant.dart';
import 'package:flutter/material.dart';
import '../widgets/template/scaffold_template.dart';
import 'package:provider/provider.dart';
import '../provider/log_pvd.dart';
import '../provider/relax_pvd.dart';
import '../utils/data_utils.dart';

class StatisticPage extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: StatisticFields(),
      ),
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
}

class StatisticFields extends StatefulWidget {
  const StatisticFields({super.key});

  @override
  State<StatisticFields> createState() => _StatisticFieldsState();
}

class _StatisticFieldsState extends State<StatisticFields> with StatisticUtils {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext c) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () async {
            final picked = await selectDate(c, selectedDate ?? DateTime.now());
            if (picked != null) {
              setState(() {
                selectedDate = picked;
              });
            }
          },
          child: Text(formatFullDate(selectedDate ?? DateTime.now())),
        ),
        SizedBox(height: kPaddingLarge),
        LogStatisticFields(date: selectedDate),
        SizedBox(height: kPaddingLarge),
        RelaxStatisticFields(date: selectedDate),
      ],
    );
  }
}

class LogStatisticFields extends StatelessWidget {
  const LogStatisticFields({super.key, this.date});

  final DateTime? date;

  @override
  Widget build(BuildContext c) {
    final numberOfLogs = date != null
        ? c
              .read<LogProvider>()
              .logs
              .where((log) => isSameDate(log.date, date!))
              .length
        : c.read<LogProvider>().logs.length;

    final numberOfNoteLogs = date != null
        ? c
              .read<LogProvider>()
              .logs
              .where(
                (log) =>
                    log.note != null &&
                    log.note!.isNotEmpty &&
                    isSameDate(log.date, date!),
              )
              .length
        : c
              .read<LogProvider>()
              .logs
              .where((log) => log.note != null && log.note!.isNotEmpty)
              .length;

    final maxMood = date != null
        ? c
              .read<LogProvider>()
              .logs
              .where((log) => isSameDate(log.date, date!))
              .map((log) => log.moodPoint)
              .fold<double?>(null, (prev, mood) {
                if (prev == null) return mood;
                if (mood == null) return prev;
                return mood > prev ? mood : prev;
              })
        : c.read<LogProvider>().logs.map((log) => log.moodPoint).fold<double?>(
            null,
            (prev, mood) {
              if (prev == null) return mood;
              if (mood == null) return prev;
              return mood > prev ? mood : prev;
            },
          );

    final minMood = date != null
        ? c
              .read<LogProvider>()
              .logs
              .where((log) => isSameDate(log.date, date!))
              .map((log) => log.moodPoint)
              .fold<double?>(null, (prev, mood) {
                if (prev == null) return mood;
                if (mood == null) return prev;
                return mood < prev ? mood : prev;
              })
        : c.read<LogProvider>().logs.map((log) => log.moodPoint).fold<double?>(
            null,
            (prev, mood) {
              if (prev == null) return mood;
              if (mood == null) return prev;
              return mood < prev ? mood : prev;
            },
          );

    final avgMood = date != null
        ? c
                  .read<LogProvider>()
                  .logs
                  .where((log) => isSameDate(log.date, date!))
                  .map((log) => log.moodPoint)
                  .whereType<double>()
                  .fold<double>(0, (prev, mood) => prev + mood) /
              numberOfLogs
        : c
                  .read<LogProvider>()
                  .logs
                  .map((log) => log.moodPoint)
                  .whereType<double>()
                  .fold<double>(0, (prev, mood) => prev + mood) /
              numberOfLogs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total number of logs: $numberOfLogs',
          style: Theme.of(c).textTheme.bodyMedium,
        ),
        Text(
          'Total number of note logs: $numberOfNoteLogs',
          style: Theme.of(c).textTheme.bodyMedium,
        ),
        Text(
          'Highest mood point: ${maxMood?.toStringAsFixed(1) ?? "N/A"}',
          style: Theme.of(c).textTheme.bodyMedium,
        ),
        Text(
          'Lowest mood point: ${minMood?.toStringAsFixed(1) ?? "N/A"}',
          style: Theme.of(c).textTheme.bodyMedium,
        ),
        Text(
          'Average mood point: ${avgMood.isNaN ? "N/A" : avgMood.toStringAsFixed(2)}',
          style: Theme.of(c).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class RelaxStatisticFields extends StatelessWidget {
  const RelaxStatisticFields({super.key, this.date});

  final DateTime? date;

  @override
  Widget build(BuildContext c) {
    final numberOfRelaxSessions = date != null
        ? c
              .read<RelaxProvider>()
              .relaxs
              .where((relax) => isSameDate(relax.startTime, date!))
              .length
        : c.read<RelaxProvider>().relaxs.length;

    final numberOfNoteRelaxSessions = date != null
        ? c
              .read<RelaxProvider>()
              .relaxs
              .where(
                (relax) =>
                    relax.note != null &&
                    relax.note!.isNotEmpty &&
                    isSameDate(relax.startTime, date!),
              )
              .length
        : c
              .read<RelaxProvider>()
              .relaxs
              .where((relax) => relax.note != null && relax.note!.isNotEmpty)
              .length;

    final maxDuration = date != null
        ? c
              .read<RelaxProvider>()
              .relaxs
              .where((relax) => isSameDate(relax.startTime, date!))
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

    final minDuration = date != null
        ? c
              .read<RelaxProvider>()
              .relaxs
              .where((relax) => isSameDate(relax.startTime, date!))
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

    final avgDuration = date != null
        ? c
                  .read<RelaxProvider>()
                  .relaxs
                  .where((relax) => isSameDate(relax.startTime, date!))
                  .map((relax) => relax.durationMiliseconds)
                  .fold<int>(0, (prev, duration) => prev + duration) /
              numberOfRelaxSessions
        : c
                  .read<RelaxProvider>()
                  .relaxs
                  .map((relax) => relax.durationMiliseconds)
                  .fold<int>(0, (prev, duration) => prev + duration) /
              numberOfRelaxSessions;

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
