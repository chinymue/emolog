import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../widgets/default_scaffold.dart';
import '../export/log_essential.dart';
import '../export/common_utils.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final isarService = IsarService();
  late List<NoteLog> _logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final data = await isarService.getAllNotes();
    setState(() {
      _logs = data.reversed.toList();
      isLoading = false;
    });
  }

  Future<void> _loadALogs(NoteLog log, int index) async {
    final data = await isarService.getNoteById(log.id);
    setState(() {
      if (data != null) _logs[index] = data;
    });
  }

  Future<void> _removeLogs(NoteLog log, int index) async {
    setState(() => _logs.removeAt(index));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar() // nếu gọi nhiều snackbar trong thời gian gần nhau
      ..showSnackBar(
        SnackBar(
          content: Text('log ${log.id} has been dismissed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              setState(() => _logs.insert(index, log));
              await isarService.saveNote(log);
            },
          ),
        ),
      );
    if (!_logs.contains(log)) await isarService.deleteNoteById(log.id);
  }

  Future<void> _toggleFavorite(NoteLog log) async {
    setState(() {
      log.isFavor = !log.isFavor;
    });
    await isarService.saveNote(log);
    // print('Saved log no ${log.id} with favor is ${log.isFavor}');
  }

  @override
  Widget build(BuildContext c) => MainScaffold(
    currentIndex: 1,
    child: isLoading
        ? const Center(child: CircularProgressIndicator())
        : _buildBody(),
  );

  Widget _buildBody() {
    if (_logs.isEmpty) return const Center(child: Text('No logs yet'));
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: _logs.length,
      itemBuilder: (c, i) {
        final log = _logs[i];
        final colorScheme = Theme.of(c).colorScheme;
        return Dismissible(
          key: ValueKey(log.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => _removeLogs(log, i),
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: kPaddingLarge),
            color: colorScheme.errorContainer,
            child: Icon(Icons.delete, color: colorScheme.onErrorContainer),
          ),
          child: _buildLogTitle(c, log),
        );
      },
    );
  }

  Widget _buildLogTitle(BuildContext c, NoteLog log) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    // final numMood = log.numericMood.toString();
    return ListTile(
      onTap: () async {
        final updated = await Navigator.push(
          c,
          MaterialPageRoute(builder: (c) => DetailsLog(content: log)),
        );
        final index = _logs.indexOf(log);
        if (updated == true && index != -1) _loadALogs(log, index);
      },
      leading: IconButton(
        icon: Icon(
          Icons.monitor_heart,
          size: iconSize,
          color: log.isFavor
              ? colorScheme.primary
              : adjustLightness(colorScheme.primary, 0.4),
        ),
        onPressed: () => _toggleFavorite(log),
        splashRadius: kSplashRadius,
        tooltip: log.isFavor ? 'Unfavourite' : 'Favourite',
      ),
      title: Text(
        shortenText(deltaToPlainText(log.note!)),
        style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
      ),
      subtitle: Text(
        formatShortDateTime(log.date),
        style: textTheme.labelMedium?.copyWith(fontWeight: kFontWeightRegular),
      ),
      trailing: Icon(
        moods[log.labelMood],
        size: iconSizeLarge,
        color: colorScheme.primary,
      ),
    );
  }
}

class DetailsLog extends StatefulWidget {
  const DetailsLog({super.key, required this.content});
  final NoteLog content;

  @override
  State<DetailsLog> createState() => _DetailsLogState();
}

class _DetailsLogState extends State<DetailsLog> {
  final isarService = IsarService();
  late final quill.QuillController _controller;
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
    final doc = documentFromJsonOrEmpty(widget.content.note);
    _controller = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveChanged(NoteLog log) async {
    await isarService.saveNote(log);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar() // nếu gọi nhiều snackbar trong thời gian gần nhau
      ..showSnackBar(
        SnackBar(
          content: Text('log ${log.id} has been saved'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await isarService.saveNote(widget.content);
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext c) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasChanged);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Note detail',
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                newLog = NoteLog()
                  ..id = widget.content.id
                  ..isFavor = _isFavor
                  ..note = plainTextToDelta(_controller.document)
                  ..labelMood = _currentMood
                  ..numericMood = _currentMoodPoint
                  ..date = _date;
                setState(
                  () => _hasChanged = isNoteLogChanged(newLog, widget.content),
                );
                _saveChanged(newLog);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            MoodPicker(
              selectedMood: _currentMood ?? '',
              onMoodSelected: (mood) => setState(() => _currentMood = mood),
            ),
            Expanded(child: DefaultQuillEditor(controller: _controller)),
          ],
        ),
      ),
    );
  }
}
