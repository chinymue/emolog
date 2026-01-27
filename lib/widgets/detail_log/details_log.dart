import 'package:emolog/l10n/app_localizations.dart';
// import 'package:emolog/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/log_pvd.dart';
import '../../widgets/detail_log/mood_picker.dart';
import '../../widgets/detail_log/quill_utils.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class DetailsLog extends StatefulWidget {
  const DetailsLog({super.key, required this.logId});
  final int logId;

  @override
  State<DetailsLog> createState() => _DetailsLogState();
}

class _DetailsLogState extends State<DetailsLog> {
  late final quill.QuillController _quillCtrl;
  String _changedDoc = "";

  @override
  void initState() {
    super.initState();
    _quillCtrl = quill.QuillController(
      document: docFromJson(""),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _changedDoc = "";
    _quillCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    final l10n = AppLocalizations.of(c)!;

    final logProvider = c.watch<LogProvider>();
    if (!logProvider.hasEditableLog ||
        logProvider.editableLog.id != widget.logId) {
      logProvider.setEditableLog(
        log: logProvider.logs.firstWhere((l) => l.id == widget.logId),
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
            onPressed: () {
              c.read<LogProvider>().updateNote(_changedDoc, target: editable);
              c.read<LogProvider>().saveEditableLog();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            MoodPicker(
              selectedMood: editable.labelMood,
              onMoodSelected: (mood) =>
                  c.read<LogProvider>().updateLabelMood(mood, target: editable),
            ),
            // MoodPointPicker(
            //   selectedMoodPoint: editable.moodPoint,
            //   onChangedMoodPoint: (moodPoint) => c
            //       .read<LogProvider>()
            //       .updateMoodPoint(moodPoint, target: editable),
            // ),
            Expanded(
              child: DefaultQuillEditor(
                controller: _quillCtrl,
                initialContent: editable.note ?? '',
                onContentChanged: (doc) => _changedDoc = doc,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
