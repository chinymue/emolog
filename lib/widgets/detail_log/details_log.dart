import 'package:flutter/material.dart';
import '../../export/detail_log_essential.dart';
import '../../export/common_utils.dart';

class DetailsLog extends StatefulWidget {
  const DetailsLog({
    super.key,
    required this.isarService,
    required this.content,
    required this.onLogUpdated,
  });
  final IsarService isarService;
  final NoteLog content;

  /// Callback để thông báo log đã được cập nhật
  final void Function(NoteLog updatedLog, String action) onLogUpdated;

  @override
  State<DetailsLog> createState() => _DetailsLogState();
}

class _DetailsLogState extends State<DetailsLog> {
  String? _currentNote;
  String? _currentMood;
  int? _currentMoodPoint;
  bool _isFavor = false;
  DateTime _date = DateTime.now();
  NoteLog newLog = NoteLog();
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _date = widget.content.date;
    _isFavor = widget.content.isFavor;
    _currentMood = widget.content.labelMood;
    _currentMoodPoint = widget.content.numericMood;
    _currentNote = widget.content.note;
  }

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Note detail',
          style: textTheme.headlineMedium?.copyWith(color: colorScheme.outline),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              newLog = NoteLog()
                ..id = widget.content.id
                ..isFavor = _isFavor
                ..note = _currentNote
                ..labelMood = _currentMood
                ..numericMood = _currentMoodPoint
                ..date = _date;
              setState(
                () => _hasChanged = isNoteLogChanged(newLog, widget.content),
              );
              if (_hasChanged) widget.onLogUpdated(newLog, 'saved');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          MoodPicker(
            selectedMood: _currentMood,
            onMoodSelected: (mood) => setState(() => _currentMood = mood),
          ),
          Expanded(
            child: DefaultQuillEditor(
              initialContent: _currentNote ?? '',
              onContentChanged: (doc) => _currentNote = doc,
            ),
          ),
        ],
      ),
    );
  }
}
