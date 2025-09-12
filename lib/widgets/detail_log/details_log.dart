import 'package:emolog/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/log_pvd.dart';
import '../../widgets/detail_log/mood_picker.dart';
import '../../widgets/detail_log/quill_utils.dart';

class DetailsLog extends StatelessWidget {
  const DetailsLog({super.key, required this.logId});
  final int logId;

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    final l10n = AppLocalizations.of(c)!;

    final logProvider = c.watch<LogProvider>();
    if (!logProvider.hasEditableLog || logProvider.editableLog.id != logId) {
      logProvider.setEditableLog(
        log: logProvider.logs.firstWhere((l) => l.id == logId),
        notify: false,
      );
    }

    if (!logProvider.hasEditableLog || logProvider.editableLog.id == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.pageDetail,
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ),
        body: Center(
          child: Text(l10n.logNotExist, style: textTheme.displayMedium),
        ),
      );
    }

    final editable = logProvider.editableLog;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.pageDetail,
          style: textTheme.headlineMedium?.copyWith(color: colorScheme.outline),
        ),
        actions: [
          IconButton(
            tooltip: l10n.saveChanges,
            icon: Icon(Icons.save),
            onPressed: () => c.read<LogProvider>().saveEditableLog(),
          ),
        ],
      ),
      body: Column(
        children: [
          MoodPicker(
            selectedMood: editable.labelMood,
            onMoodSelected: (mood) =>
                c.read<LogProvider>().updateLabelMood(mood),
          ),
          MoodPointPicker(
            selectedMoodPoint: editable.moodPoint,
            onChangedMoodPoint: (moodPoint) =>
                c.read<LogProvider>().updateMoodPoint(moodPoint),
          ),
          Expanded(
            child: DefaultQuillEditor(
              initialContent: editable.note ?? '',
              onContentChanged: (doc) => c.read<LogProvider>().updateNote(doc),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsLogContent extends StatelessWidget {
  const DetailsLogContent({super.key});

  @override
  Widget build(BuildContext c) {
    final logProvider = c.read<LogProvider>();
    return Column(
      children: [
        MoodPicker(onMoodSelected: (mood) => logProvider.setLabelMood(mood)),
        MoodPointPicker(
          onChangedMoodPoint: (moodPoint) {
            logProvider.setMoodPoint(moodPoint);
          },
        ),
        Expanded(
          child: DefaultQuillEditor(
            onContentChanged: (doc) => logProvider.setNote(doc),
          ),
        ),
      ],
    );
  }
}
