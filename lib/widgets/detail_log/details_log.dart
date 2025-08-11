import '../../export/app_essential.dart';
import '../../export/detail_log_essential.dart';
import '../../export/common_utils.dart';

class DetailsLog extends StatelessWidget {
  const DetailsLog({super.key, required this.logId});
  final int logId;

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;

    final logProvider = c.watch<LogProvider>();
    final logList = logProvider.logs.where((l) => l.id == logId).toList();
    final log = logList.isEmpty ? null : logList.first;

    if (log == null) {
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
          child: Text(
            'Log does not exist',
            style: Theme.of(c).textTheme.displayMedium,
          ),
        ),
      );
    }

    // Set editableLog nếu chưa có hoặc khác với log hiện tại
    if (logProvider.editableLog == NoteLog() ||
        logProvider.editableLog.id != log.id) {
      // Đặt bản sao editable khi lần đầu build hoặc khi logId thay đổi
      Future.microtask(() => logProvider.setEditableLog(log));
    }

    final editableLog = logProvider.editableLog;

    void handleSave() async {
      if (editableLog == NoteLog()) return;
      if (isNoteLogChanged(editableLog, log)) {
        await logProvider.saveEditableLog();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Note detail',
          style: textTheme.headlineMedium?.copyWith(color: colorScheme.outline),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async => handleSave(),
          ),
        ],
      ),
      body: editableLog == NoteLog()
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                MoodPicker(
                  selectedMood: editableLog.labelMood,
                  onMoodSelected: (mood) =>
                      logProvider.updateLabelMood(mood: mood),
                ),
                Expanded(
                  child: DefaultQuillEditor(
                    initialContent: editableLog.note ?? '',
                    onContentChanged: (doc) =>
                        logProvider.updateNote(note: doc),
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
    final logProvider = c.watch<LogProvider>();
    final editableLog = logProvider.editableLog;

    return Column(
      children: [
        MoodPicker(
          selectedMood: editableLog.labelMood,
          onMoodSelected: (mood) => logProvider.updateLabelMood(mood: mood),
        ),
        Expanded(
          child: DefaultQuillEditor(
            initialContent: editableLog.note ?? '',
            onContentChanged: (doc) => logProvider.updateNote(note: doc),
          ),
        ),
      ],
    );
  }
}
