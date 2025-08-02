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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emolog',
      theme: buildAppTheme(follyRed),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/logs': (context) => HistoryLogPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textHdMedium = Theme.of(context).textTheme.headlineLarge;
    final colorPrimary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Logging',
          style: textHdMedium?.copyWith(color: colorPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [EmologForm()],
          ),
        ), //
      ),
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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
          SizedBox(height: kPaddingLarge),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/logs'),
            child: const Text('History'),
          ),
        ],
      ),
    );
  }
}

class HelloLog extends StatelessWidget {
  const HelloLog({super.key});

  @override
  Widget build(BuildContext context) {
    final textDisplaySmall = Theme.of(context).textTheme.displayMedium;
    final colorPrimary = Theme.of(context).colorScheme.primary;
    return Text(
      'Hi sweetie,\nhow is your day?',
      textAlign: TextAlign.center,
      style: textDisplaySmall?.copyWith(
        color: adjustLightness(colorPrimary, 0),
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

class NoteLogForm extends StatelessWidget {
  const NoteLogForm({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextFormField(
        maxLines: 5,
        decoration: const InputDecoration(hintText: 'Tell me your feelings'),
        // validator receives text that user entered
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Please enter some text';
        //   }
        //   return null;
        // },
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

  final Map<String, IconData> moods = {
    'terrible': Icons.sentiment_very_dissatisfied,
    'not good': Icons.sentiment_dissatisfied,
    'chill': Icons.sentiment_neutral,
    'good': Icons.sentiment_satisfied,
    'awesome': Icons.sentiment_very_satisfied,
  };

  @override
  Widget build(BuildContext context) {
    final colorBgPrimary = Theme.of(context).colorScheme.primaryContainer;
    final colorPrimary = Theme.of(context).colorScheme.primary;
    final textLabelSmall = Theme.of(context).textTheme.labelSmall;
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

class HistoryLogPage extends StatefulWidget {
  const HistoryLogPage({super.key});

  @override
  State<HistoryLogPage> createState() => _HistoryLogPageState();
}

class _HistoryLogPageState extends State<HistoryLogPage> {
  final isarService = IsarService();
  late Future<List<NoteLog>> _noteLogsFuture;

  @override
  void initState() {
    super.initState();
    _noteLogsFuture = isarService.getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;
    final textHdLarge = Theme.of(context).textTheme.headlineLarge;
    final textHdSmall = Theme.of(context).textTheme.headlineSmall;
    // final textLabelLarge = Theme.of(context).textTheme.labelLarge;
    final textLabelMedium = Theme.of(context).textTheme.labelMedium;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: textHdLarge?.copyWith(color: colorPrimary),
        ),
      ),
      body: FutureBuilder(
        future: _noteLogsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final logs = snapshot.data;
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 100),
              itemCount: logs?.length,
              itemBuilder: (context, index) {
                final log = logs?[index];
                final note = log?.note;
                final title = note!.length > 20
                    ? '${note.substring(0, 20)}...'
                    : note;
                final datetime = formatFullDateTime(log!.date);
                final mood = log.labelMood;
                final numMood = log.numericMood.toString();
                return ListTile(
                  leading: Icon(Icons.monitor_heart, color: colorPrimary),
                  title: Text(
                    title,
                    style: textHdSmall?.copyWith(color: colorPrimary),
                  ),
                  subtitle: Text(
                    datetime,
                    style: textLabelMedium?.copyWith(
                      fontWeight: kFontWeightRegular,
                    ),
                  ),
                  trailing: Text(
                    mood ?? numMood,
                    style: textLabelMedium?.copyWith(color: colorPrimary),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 30,
            width: 100,
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Go back'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
