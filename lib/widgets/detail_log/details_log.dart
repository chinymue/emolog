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
  bool _hasChanged = false;
  late NoteLog _currentLog;

  @override
  void initState() {
    super.initState();
    _currentLog = widget.content.clone();
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
              setState(
                () =>
                    _hasChanged = isNoteLogChanged(_currentLog, widget.content),
              );
              if (_hasChanged) {
                widget.onLogUpdated(_currentLog, 'updated');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          MoodPicker(
            selectedMood: _currentLog.labelMood,
            onMoodSelected: (mood) {
              _currentLog.labelMood = mood;
              // widget.onLogUpdated(_currentLog, 'updated');
            },
          ),
          Expanded(
            child: DefaultQuillEditor(
              initialContent: _currentLog.note ?? '',
              onContentChanged: (doc) {
                _currentLog.note = doc;
                // widget.onLogUpdated(_currentLog, 'updated');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsLogContent extends StatefulWidget {
  const DetailsLogContent({
    super.key,
    required this.isarService,
    required this.onLogUpdated,
  });
  final IsarService isarService;
  final void Function(NoteLog updatedLog) onLogUpdated;

  @override
  State<DetailsLogContent> createState() => _DetailsLogContentState();
}

class _DetailsLogContentState extends State<DetailsLogContent> {
  NoteLog _currentLog = NoteLog()..labelMood = initialMood;
  @override
  Widget build(BuildContext c) {
    return Column(
      children: [
        MoodPicker(
          selectedMood: _currentLog.labelMood,
          onMoodSelected: (mood) {
            _currentLog.labelMood = mood;
            widget.onLogUpdated(_currentLog);
          },
        ),
        Expanded(
          child: DefaultQuillEditor(
            onContentChanged: (doc) {
              _currentLog.note = doc;
              widget.onLogUpdated(_currentLog);
            },
          ),
        ),
      ],
    );
  }
}
