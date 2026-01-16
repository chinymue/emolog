import 'package:emolog/l10n/app_localizations.dart';
import 'package:emolog/widgets/detail_log/mood_picker.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../isar/model/notelog.dart';
import '../../isar/model/relax.dart';
import '../../provider/log_pvd.dart';
import '../../provider/log_view_pvd.dart';
import '../../utils/constant.dart';
import '../../utils/data_utils.dart';
import '../../widgets/detail_log/details_log.dart';
import '../../provider/relax_view_pvd.dart';
import '../../provider/relax_pvd.dart';

class DefaultList extends StatelessWidget {
  const DefaultList({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext c) {
    final colorScheme = Theme.of(c).colorScheme;
    final textTheme = Theme.of(c).textTheme;
    late List<dynamic> data;
    if (type == "log") {
      final logViewPvd = c.watch<LogViewProvider>();
      final logs = logViewPvd.allLogs;

      if (logs.isEmpty && logViewPvd.isFetchedLogs) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Text(
              AppLocalizations.of(c)!.logNotFound,
              style: textTheme.displayMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        );
      } else {
        data = logs;
      }
    } else if (type == "relax") {
      final relaxViewPvd = c.watch<RelaxViewProvider>();
      final relaxs = relaxViewPvd.allRelaxs;
      if (relaxs.isEmpty && relaxViewPvd.isFetchedRelaxs) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Text(
              "Chưa có phiên tập trung nào được ghi lại",
              style: textTheme.displayMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        );
      } else {
        data = relaxs;
      }
    } else {
      data = [];
    }

    if (data.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: data.length,
        itemBuilder: (c, i) {
          final item = data[i];

          void handleDissmis() {
            if (type == "log") {
              c.read<LogProvider>().deleteLog(id: item.id);
            } else if (type == "relax") {
              c.read<RelaxProvider>().deleteRelax(id: item.id);
            }
          }

          Widget showListTile() {
            if (type == "log") {
              return DefaultLogTile(logId: item.id);
            } else if (type == "relax") {
              return DefaultRelaxTile(relaxId: item.id);
            } else {
              return ListTile(title: Text("Unknown type"));
            }
          }

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
            child: showListTile(),
          );
        },
      );
    }
  }
}

class DefaultLogTile extends StatelessWidget {
  final int logId;

  const DefaultLogTile({super.key, required this.logId});

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    final log = c.select<LogProvider, NoteLog>(
      (provider) => provider.logs.firstWhere((l) => l.id == logId),
    );

    void handleFavor() async =>
        await c.read<LogProvider>().updateLogFavor(id: logId, isSaved: true);

    Future<void> handleTap() async => await Navigator.push(
      c,
      MaterialPageRoute(builder: (c) => DetailsLog(logId: logId)),
    );

    final l10n = AppLocalizations.of(c)!;

    return ListTile(
      onTap: () => handleTap(),
      leading: IconButton(
        icon: Icon(
          log.isFavor ? Icons.favorite : Icons.favorite_border,
          size: iconSize,
          color: colorScheme.primary,
        ),
        onPressed: () => handleFavor(),
        splashRadius: kSplashRadius,
        tooltip: log.isFavor ? l10n.logUnfavor : l10n.logFavor,
      ),
      title: Text(
        shortenText(plainTextFromDeltaJson(log.note)),
        style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
      ),
      subtitle: Text(
        formatShortDateTime(log.date),
        style: textTheme.labelMedium?.copyWith(fontWeight: kFontWeightRegular),
      ),
      trailing: Tooltip(
        message: localizedMood(l10n, log.labelMood),
        child: Icon(
          moods[log.labelMood],
          size: iconSizeLarge,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

class DefaultRelaxTile extends StatelessWidget {
  final int relaxId;

  const DefaultRelaxTile({super.key, required this.relaxId});

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    final relax = c.select<RelaxProvider, Relax>(
      (provider) => provider.relaxs.firstWhere((l) => l.id == relaxId),
    );

    Future<Object?> handleTap(BuildContext c, Relax relax) async {
      return await showGeneralDialog(
        context: c,
        barrierDismissible: true,
        barrierLabel: 'Relax detail',
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (c, _, __) {
          return RelaxDetailView(relax: relax);
        },
      );
    }

    // final l10n = AppLocalizations.of(c)!;

    return ListTile(
      onTap: () => handleTap(c, relax),
      leading: Icon(Icons.spa, size: iconSize, color: colorScheme.primary),
      title: Text(
        formatFullDuration(relax.durationMiliseconds),
        style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
      ),
      trailing: Text(
        formatShortDateTime(relax.startTime),
        style: textTheme.labelMedium?.copyWith(fontWeight: kFontWeightRegular),
      ),
    );
  }
}

mixin RelaxDetailPickers {
  Future<TimeOfDay?> selectTime(BuildContext c, TimeOfDay initialTime) async {
    return await showTimePicker(context: c, initialTime: initialTime);
  }

  Future<DateTime?> selectDate(BuildContext c, DateTime initialDate) async {
    return await showDatePicker(
      context: c,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }
}

mixin RelaxDetailBuilders {
  Widget buildContainer(BuildContext c, Widget childWidget) {
    final colorScheme = Theme.of(c).colorScheme;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(c).size.width * 0.8,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(kPaddingLarge),
              child: childWidget,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    return Center(
      child: Text(
        "Chi tiết phiên tập trung",
        style: textTheme.headlineMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RelaxDetailView extends StatefulWidget {
  const RelaxDetailView({super.key, required this.relax});

  final Relax relax;

  @override
  State<RelaxDetailView> createState() => _RelaxDetailViewState();
}

class _RelaxDetailViewState extends State<RelaxDetailView>
    with RelaxDetailPickers, RelaxDetailBuilders {
  DateTime? newStart;
  DateTime? newEnd;
  bool isWarningShown = false;
  String warningText = "";
  bool isSaved = false;

  Widget buildTimeButton(BuildContext c, bool isStart) {
    final textTheme = Theme.of(c).textTheme;
    final time = isStart
        ? TimeOfDay.fromDateTime(newStart ?? widget.relax.startTime)
        : TimeOfDay.fromDateTime(newEnd ?? widget.relax.endTime);
    return TextButton(
      onPressed: () async {
        final picked = await selectTime(c, time);
        if (picked != null) {
          if (!c.mounted) return;
          if (isStart) {
            final tmp = DateTime(
              widget.relax.startTime.year,
              widget.relax.startTime.month,
              widget.relax.startTime.day,
              picked.hour,
              picked.minute,
            );
            if (tmp.isAfter(newEnd ?? widget.relax.endTime)) {
              setState(() {
                isWarningShown = true;
                warningText = "Thời gian bắt đầu phải trước thời gian kết thúc";
              });
            } else {
              setState(() {
                newStart = tmp;
                isWarningShown = false;
              });
            }
          } else {
            final tmp = DateTime(
              widget.relax.endTime.year,
              widget.relax.endTime.month,
              widget.relax.endTime.day,
              picked.hour,
              picked.minute,
            );
            if (tmp.isBefore(newStart ?? widget.relax.startTime)) {
              setState(() {
                isWarningShown = true;
                warningText = "Thời gian kết thúc phải sau thời gian bắt đầu";
              });
            } else {
              setState(() {
                newEnd = tmp;
                isWarningShown = false;
              });
            }
          }
        }
      },
      child: Text(
        formatShortTime(time),
        style: textTheme.bodyLarge?.copyWith(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget buildDateButton(BuildContext c, bool isStart) {
    final textTheme = Theme.of(c).textTheme;
    final date = isStart
        ? (newStart ?? widget.relax.startTime)
        : (newEnd ?? widget.relax.endTime);
    return TextButton(
      onPressed: () async {
        final picked = await selectDate(c, date);
        if (picked != null) {
          if (!c.mounted) return;
          if (isStart) {
            final tmp = DateTime(
              picked.year,
              picked.month,
              picked.day,
              widget.relax.startTime.hour,
              widget.relax.startTime.minute,
            );
            if (tmp.isAfter(newEnd ?? widget.relax.endTime)) {
              setState(() {
                isWarningShown = true;
                warningText = "Thời gian bắt đầu phải trước thời gian kết thúc";
              });
            } else {
              setState(() {
                newStart = tmp;
                isWarningShown = false;
              });
            }
          } else {
            final tmp = DateTime(
              picked.year,
              picked.month,
              picked.day,
              widget.relax.endTime.hour,
              widget.relax.endTime.minute,
            );
            if (tmp.isBefore(newStart ?? widget.relax.startTime)) {
              setState(() {
                isWarningShown = true;
                warningText = "Thời gian kết thúc phải sau thời gian bắt đầu";
              });
            } else {
              setState(() {
                newEnd = tmp;
                isWarningShown = false;
              });
            }
          }
        }
      },
      child: Text(
        formatDate(date),
        style: textTheme.bodyLarge?.copyWith(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget buildDateTimeRow(BuildContext c, bool isStart) {
    final textTheme = Theme.of(c).textTheme;
    return Row(
      children: [
        Text(isStart ? "Bắt đầu: " : "Kết thúc: ", style: textTheme.bodyLarge),
        buildTimeButton(c, isStart),
        buildDateButton(c, isStart),
      ],
    );
  }

  Widget buildDurationField(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    return Row(
      children: [
        Text(
          "Thời lượng: ${formatFullDuration(widget.relax.durationMiliseconds)}",
          style: textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget buildNoteField() {
    return TextField(
      controller: TextEditingController(text: widget.relax.note ?? ''),
      maxLines: 3,
      decoration: InputDecoration(
        labelText: "Ghi chú",
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        widget.relax.note = value;
      },
    );
  }

  Widget handleUpdateButton(BuildContext c) {
    return ElevatedButton(
      onPressed: () {
        c.read<RelaxProvider>().updateRelax(
          id: widget.relax.id,
          start: newStart,
          end: newEnd,
          newNote: widget.relax.note,
        );
        setState(() => isSaved = true);
      },
      child: Text("Cập nhật"),
    );
  }

  Widget buildWarningText(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    return Text(
      warningText,
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.error,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext c) {
    return buildContainer(
      c,
      Column(
        children: [
          buildTitle(c),
          SizedBox(height: kPaddingLarge),
          isWarningShown ? buildWarningText(c) : SizedBox.shrink(),
          buildDateTimeRow(c, true),
          SizedBox(height: kPaddingSmall),
          buildDateTimeRow(c, false),
          SizedBox(height: kPaddingSmall),
          buildDurationField(c),
          SizedBox(height: kPadding),
          buildNoteField(),
          SizedBox(height: kPaddingLarge),
          handleUpdateButton(c),
          SizedBox(height: kPaddingLarge),
          isSaved ? Text("Saved successfully") : const SizedBox.shrink(),
          SizedBox(height: kPaddingLarge),
        ],
      ),
    );
  }
}
