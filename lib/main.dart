import 'package:flutter/material.dart';
import 'dart:async';
import './isar/model/notelog.dart';
import './isar/isar_service.dart';
import './ultils.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext c) {
    return MaterialApp(
      title: 'Emolog',
      theme: buildAppTheme(follyRed),
      initialRoute: pages[0]['route'],
      routes: {
        pages[0]['route']: (c) => HomePage(),
        pages[1]['route']: (c) => HistoryPage(),
        pages[2]['route']: (c) => SettingsPage(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        quill.FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return MainScaffold(
      currentIndex: 0,
      child: Padding(padding: const EdgeInsets.all(20), child: EmologForm()),
    );
  }
}

class EmologForm extends StatefulWidget {
  const EmologForm({super.key});
  @override
  State<EmologForm> createState() => _EmologFormState();
}

class _EmologFormState extends State<EmologForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String _selectedLabelMood = 'chill';
  // int _selectedNumericMood = 0;

  // used to discard resources used by obj when don't need obj anymore, avoid mmr leak
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final isarService = IsarService();
      final savedNote = await isarService.saveNote(
        NoteLog()
          ..note = _controller.text
          ..labelMood = _selectedLabelMood
          ..date = DateTime.now(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar() // nếu gọi nhiều snackbar trong thời gian gần nhau
        ..showSnackBar(
          SnackBar(
            content: Text('log ${savedNote.id} has been recorded'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                await isarService.deleteNoteById(savedNote.id);
              },
            ),
          ),
        );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext c) => Form(
    key: _formKey,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          HelloLog(),
          const SizedBox(height: kPadding),
          MoodPicker(
            selectedMood: _selectedLabelMood,
            onMoodSelected: (mood) => setState(() => _selectedLabelMood = mood),
          ),
          const SizedBox(height: kPaddingLarge),
          NoteLogForm(controller: _controller),
          const SizedBox(height: kPaddingLarge),
          ElevatedButton(onPressed: _submitForm, child: const Text('Submit')),
        ],
      ),
    ),
  );
}

class HelloLog extends StatelessWidget {
  const HelloLog({super.key});

  @override
  Widget build(BuildContext c) => Text(
    'Hi sweetie,\nhow is your day?',
    textAlign: TextAlign.center,
    style: Theme.of(c).textTheme.displayMedium?.copyWith(
      color: Theme.of(c).colorScheme.primary,
      fontStyle: FontStyle.italic,
    ),
  );
}

class NoteLogForm extends StatelessWidget {
  const NoteLogForm({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext c) {
    return SizedBox(
      width: 500,
      child: TextFormField(
        maxLines: 5,
        decoration: const InputDecoration(hintText: 'Tell me your feelings'),
        style: TextStyle(letterSpacing: 0.75),
        controller: controller,
      ),
    );
  }
}

class MoodPicker extends StatefulWidget {
  MoodPicker({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });
  final void Function(String selectedMood) onMoodSelected;
  final String selectedMood;

  @override
  State<MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<MoodPicker> {
  late String _currentMood;
  @override
  void initState() {
    super.initState();
    _currentMood = widget.selectedMood;
  }

  @override
  Widget build(BuildContext c) {
    final colorPrimary = Theme.of(c).colorScheme.primary;
    return SizedBox(
      height: 70,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: moods.entries.map((entry) {
            final selected = _currentMood == entry.key;
            return Tooltip(
              message: entry.key,
              preferBelow: false,
              child: IconButton(
                icon: Icon(
                  entry.value,
                  size: iconMaxSize,
                  color: selected
                      ? colorPrimary
                      : adjustLightness(colorPrimary, 0.2),
                ),
                onPressed: () {
                  setState(() => _currentMood = entry.key);
                  widget.onMoodSelected(entry.key);
                },
                splashRadius: kBorderRadiusSmall,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final isarService = IsarService();
  late List<NoteLog> changedLogs = [];
  late List<NoteLog> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final data = await isarService.getAllNotes();
    setState(() {
      logs = data.reversed.toList();
      isLoading = false;
    });
  }

  Future<void> _removeLogs(NoteLog log, int index) async {
    setState(() => logs.removeAt(index));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar() // nếu gọi nhiều snackbar trong thời gian gần nhau
      ..showSnackBar(
        SnackBar(
          content: Text('log ${log.id} has been dismissed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              setState(() => logs.insert(index, log));
              await isarService.saveNote(log);
            },
          ),
        ),
      );
    if (!logs.contains(log)) await isarService.deleteNoteById(log.id);
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
    if (logs.isEmpty) return const Center(child: Text('No logs yet'));
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: logs.length,
      itemBuilder: (c, i) {
        final log = logs[i];
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

  String _shorten(String note) =>
      note.length > 16 ? '${note.substring(0, 16)}…' : note;

  Widget _buildLogTitle(BuildContext c, NoteLog log) {
    final textTheme = Theme.of(c).textTheme;
    final colorScheme = Theme.of(c).colorScheme;
    // final numMood = log.numericMood.toString();
    return ListTile(
      onTap: () => Navigator.push(
        c,
        MaterialPageRoute(
          builder: (c) => DetailsLog(isarService: isarService, content: log),
        ),
      ),
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
        _shorten(log.note!),
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
  const DetailsLog({
    super.key,
    required this.isarService,
    required this.content,
  });
  final NoteLog content;
  final IsarService isarService;

  @override
  State<DetailsLog> createState() => _DetailsLogState();
}

class _DetailsLogState extends State<DetailsLog> {
  late final quill.QuillController _controller;
  late final String rawNote;
  late final String? _currentMood;
  // late final int? _currentMoodPoint;

  @override
  void initState() {
    super.initState();
    _currentMood = widget.content.labelMood;
    rawNote = (widget.content.note ?? '').split('\n').first.trim();
    final doc = quill.Document()..insert(0, rawNote);
    _controller = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  Future<void> _saveChanged(NoteLog log) async {
    await widget.isarService.saveNote(log);
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
          IconButton(icon: Icon(Icons.save), onPressed: () => _saveChanged),
        ],
      ),
      body: Column(
        children: [
          MoodPicker(
            selectedMood: _currentMood ?? '',
            onMoodSelected: (mood) => setState(() => _currentMood = mood),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kPadding),
              child: quill.QuillEditor.basic(controller: _controller),
            ),
          ),
          quill.QuillSimpleToolbar(
            controller: _controller,
            config: quill.QuillSimpleToolbarConfig(),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(currentIndex: 2, child: Placeholder());
  }
}
