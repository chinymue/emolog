import 'package:flutter/material.dart';
import 'dart:async';
import './isar/model/notelog.dart';
import './isar/isar_service.dart';
import './ultils.dart';

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
      initialRoute: '/',
      routes: {'/': (c) => MyHomePage(), '/logs': (c) => HistoryPage()},
      // navigatorObservers: [routeObserver],
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: buildAppBar(c, 'Logging'),
      body: Padding(padding: const EdgeInsets.all(20), child: EmologForm()),
      bottomNavigationBar: _buildBottomBar(c),
    );
  }

  Widget _buildBottomBar(BuildContext c) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 30,
        width: 100,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(c, '/logs'),
                child: Text('History Page'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(c, '/db'),
                child: Text('DB Page'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
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
            content: Text('log has been recorded'),
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
  MoodPicker({super.key, required this.onMoodSelected});
  final void Function(String selectedMood) onMoodSelected;

  @override
  State<MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<MoodPicker> {
  String _selectedMood = 'chill';

  @override
  Widget build(BuildContext c) {
    final colorBgPrimary = Theme.of(c).colorScheme.primaryContainer;
    final colorPrimary = Theme.of(c).colorScheme.primary;
    final textLabelSmall = Theme.of(c).textTheme.labelSmall;
    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: moods.entries.map((entry) {
            final selected = _selectedMood == entry.key;
            return Tooltip(
              message: entry.key,
              waitDuration: const Duration(
                milliseconds: 200,
              ), // thời gian chờ trước khi hiển thị
              showDuration: const Duration(
                seconds: 2,
              ), // thời gian tooltip còn hiển thị
              preferBelow: false, // tooltip hiện bên trên nút (nếu đủ chỗ)
              decoration: BoxDecoration(
                color: selected
                    ? adjustLightness(colorBgPrimary, -0.15)
                    : colorBgPrimary,
                borderRadius: BorderRadius.circular(4),
              ),
              textStyle: textLabelSmall?.copyWith(
                color: selected
                    ? adjustLightness(colorPrimary, -0.1)
                    : colorPrimary,
              ),
              child: RawMaterialButton(
                onPressed: () {
                  setState(() => _selectedMood = entry.key);
                  widget.onMoodSelected(entry.key);
                },
                fillColor: selected
                    ? adjustLightness(colorBgPrimary, -0.15)
                    : colorBgPrimary,
                elevation: selected ? 8 : 2,
                constraints: const BoxConstraints.tightFor(
                  width: 56,
                  height: 56,
                ),
                shape: const CircleBorder(),
                child: Icon(
                  entry.value,
                  size: 30,
                  color: selected
                      ? adjustLightness(colorPrimary, -0.1)
                      : colorPrimary,
                ),
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
  State<HistoryPage> createState() => _HistoryLogPageState();
}

class _HistoryLogPageState extends State<HistoryPage> {
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

  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: buildAppBar(c, 'History'),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : _buildBody(),
    bottomNavigationBar: _buildBottomBar(c),
  );

  Widget _buildBody() {
    if (logs.isEmpty) return const Center(child: Text('No logs yet'));
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: logs.length,
      itemBuilder: (c, i) => _buildLogTitle(c, logs[i]),
    );
  }

  Future<void> _toggleFavorite(NoteLog log) async {
    setState(() {
      log.isFavor = !log.isFavor;
      changedLogs.add(log);
    });
    print('Saved log no ${log.id} with favor is ${log.isFavor}');
  }

  String _shorten(String note) =>
      note.length > 16 ? '${note.substring(0, 16)}…' : note;

  Widget _buildLogTitle(BuildContext c, NoteLog log) {
    final theme = Theme.of(c);
    // final numMood = log.numericMood.toString();
    return ListTile(
      leading: IconButton(
        icon: Icon(
          Icons.monitor_heart,
          color: log.isFavor
              ? theme.colorScheme.primary
              : adjustLightness(theme.colorScheme.primary, 0.4),
        ),
        onPressed: () => _toggleFavorite(log),
        splashRadius: 20,
        tooltip: log.isFavor ? 'Unfavourite' : 'Favourite',
      ),
      title: Text(
        _shorten(log.note!),
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      subtitle: Text(
        formatShortDateTime(log.date),
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: kFontWeightRegular,
        ),
      ),
      trailing: Icon(
        moods[log.labelMood],
        size: 30,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext c) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 30,
        width: 100,
        child: Center(
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  for (NoteLog i in changedLogs) {
                    await isarService.saveNote(i);
                  }
                  // await isarService.syncFavoritesFromPrefs();
                  Navigator.pushNamed(c, '/');
                },
                child: Text('Main Page'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // await isarService.syncFavoritesFromPrefs();
                  Navigator.pushNamed(c, '/db');
                },
                child: Text('DB Page'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
