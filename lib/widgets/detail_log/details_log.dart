import '../../export/package/app_essential.dart';
import '../../export/detail_log_essential.dart';

class DetailsLog extends StatelessWidget {
  const DetailsLog({super.key, required this.logId});
  final int logId;

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;

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
            'Note detail',
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
        ),
        body: Center(
          child: Text('Log does not exist', style: textTheme.displayMedium),
        ),
      );
    }

    final editable = logProvider.editableLog;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Note detail',
          style: textTheme.headlineMedium?.copyWith(color: colorScheme.outline),
        ),
        actions: [
          IconButton(
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
                c.read<LogProvider>().updateLabelMood(mood: mood),
          ),
          MoodPointPicker(
            selectedMoodPoint: editable.moodPoint,
            onChangedMoodPoint: (moodPoint) =>
                c.read<LogProvider>().updateMoodPoint(moodPoint: moodPoint),
          ),
          Expanded(
            child: DefaultQuillEditor(
              initialContent: editable.note ?? '',
              onContentChanged: (doc) =>
                  c.read<LogProvider>().updateNote(note: doc),
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
        MoodPicker(
          onMoodSelected: (mood) => logProvider.setLabelMood(mood: mood),
        ),
        MoodPointPicker(
          onChangedMoodPoint: (moodPoint) {
            logProvider.setMoodPoint(moodPoint: moodPoint);
          },
        ),
        Expanded(
          child: DefaultQuillEditor(
            onContentChanged: (doc) => logProvider.setNote(note: doc),
          ),
        ),
      ],
    );
  }
}
