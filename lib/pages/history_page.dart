import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/default_scaffold.dart';
import '../export/notelog_essential.dart';
import '../widgets/listview/default_log_list.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});
  final isarService = IsarService();
  @override
  Widget build(BuildContext c) =>
      MainScaffold(currentIndex: 1, child: LogsList(isarService: isarService));
}

class LogsList extends StatefulWidget {
  const LogsList({super.key, required this.isarService});
  final IsarService isarService;
  @override
  State<LogsList> createState() => _LogsListState();
}

class _LogsListState extends State<LogsList> {
  late List<NoteLog> _logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final data = await widget.isarService.getAllNotes();
    setState(() {
      _logs = data.reversed.toList();
      isLoading = false;
    });
  }

  Future<void> _loadALogs(NoteLog log, int index) async {
    final data = await widget.isarService.getNoteById(log.id);
    setState(() {
      if (data != null) _logs[index] = data;
    });
  }

  Future<void> _saveChanged(NoteLog log, int index) async {
    final previousLog = _logs[index];
    await widget.isarService.updateNote(log);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar() // nếu gọi nhiều snackbar trong thời gian gần nhau
      ..showSnackBar(
        SnackBar(
          content: Text('log ${log.id} has been saved'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async =>
                await widget.isarService.updateNote(previousLog),
          ),
        ),
      );
  }

  Future<void> _removeLogs(NoteLog log, int index) async {
    setState(() => _logs.removeAt(index));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('log ${log.id} has been dismissed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              setState(() => _logs.insert(index, log));
              await widget.isarService.saveNote(log);
            },
          ),
        ),
      );
    if (!_logs.contains(log)) {
      await widget.isarService.deleteNoteById(log.id);
    }
  }

  @override
  Widget build(BuildContext c) {
    return isLoading
        ? const CircularProgressIndicator()
        : DefaultList(
            isarService: widget.isarService,
            logs: _logs,
            onLogUpdated: (updatedLog, index, action) {
              if (action == 'removed') {
                _removeLogs(updatedLog, index);
              } else if (action == 'favourited') {
                _loadALogs(updatedLog, index);
              } else if (action == 'updated') {
                _saveChanged(updatedLog, index);
              }
            },
          );
  }
}
