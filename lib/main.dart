import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'dart:convert'; // json
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:isar/isar.dart';
import './isar/model/notelog.dart';
import './isar/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// Một số màu tiện dùng
const Color follyRed = Color(0xFFFF0A54);
const Color tickleMePink = Color(0xFFFF85A1);
const Color brightPink = Color(0xFFFF5C8A);
const Color salmonPink = Color(0xFFFF99AC);
const Color cherryBlossom = Color(0xFFFBB1BD);
const Color mistyRose = Color(0xFFFAE0E4);
const Color lavenderBlush = Color(0xFFFFF0F3);
const Color chocolateCosmos = Color(0xFF590D22);
const Color claret = Color(0xFF800F2F);
const Color roseRed = Color(0xFFC9184A);
const Color amaranthPurple = Color(0xFFA4133C);

Color adjustLightness(Color color, double amount, {double maxLightness = 0.9}) {
  final hsl = HSLColor.fromColor(color);
  final newLightness = (hsl.lightness + amount).clamp(0.0, maxLightness);
  return hsl.withLightness(newLightness).toColor();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emolog',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: follyRed),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w600,
          ),
          displayMedium: const TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w600,
          ),
          displaySmall: const TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w600,
          ),
          headlineLarge: const TextStyle(fontWeight: FontWeight.w600),
          headlineSmall: const TextStyle(fontWeight: FontWeight.w600),
          labelLarge: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          labelMedium: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          labelSmall: const TextStyle(
            // fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
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
    final textHdSmall = Theme.of(context).textTheme.headlineSmall;
    final colorPrimary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Logging',
          style: textHdSmall?.copyWith(color: colorPrimary),
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
      isarService.saveNote(
        NoteLog()
          ..note = _controller.text
          ..labelMood = _selectedLabelMood
          ..date = DateTime.now(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar() // nếu gọi nhiều snackbar trong thời gian gần nhau
        ..showSnackBar(SnackBar(content: Text('log has been recorded')));
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
          const SizedBox(height: 10),
          NoteLogForm(controller: _controller),
          const SizedBox(height: 20),
          MoodPicker(
            onMoodSelected: (mood) => setState(() => _selectedLabelMood = mood),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submitForm, child: const Text('Submit')),
          SizedBox(height: 20),
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
    final textDisplaySmall = Theme.of(context).textTheme.displaySmall;
    final colorPrimary = Theme.of(context).colorScheme.primary;
    return Text(
      'Hi sweetie, how is your day?',
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
    final textLabelLarge = Theme.of(context).textTheme.labelLarge;
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 15,
          children: moods.entries.map((entry) {
            final selected = _selectedMood == entry.key;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedMood = entry.key);
                    widget.onMoodSelected(entry.key);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected
                        ? adjustLightness(colorBgPrimary, -0.15)
                        : colorBgPrimary,
                    foregroundColor: selected
                        ? adjustLightness(colorPrimary, -0.1)
                        : colorPrimary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(entry.value, size: 35),
                  ),
                ),
                Text(
                  entry.key,
                  style: textLabelLarge?.copyWith(color: colorPrimary),
                ),
              ],
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
    final textHdSmall = Theme.of(context).textTheme.headlineSmall;
    final textLabelLarge = Theme.of(context).textTheme.labelLarge;
    final textLabelMedium = Theme.of(context).textTheme.labelMedium;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: textHdSmall?.copyWith(color: colorPrimary),
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
                return ListTile(
                  leading: Icon(Icons.monitor_heart, color: colorPrimary),
                  title: Text(
                    log?.note ?? log?.date.toIso8601String() ?? 'Default note',
                    style: textLabelLarge?.copyWith(color: colorPrimary),
                  ),
                  subtitle: Text(
                    log?.date.toIso8601String() ?? 'Default datetime',
                  ),
                  trailing: Text(
                    log?.labelMood ??
                        log?.numericMood.toString() ??
                        'Default mood',
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
            width: 160,
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

  /** other way to try with each change
  
  // // some funct to react w/ addListener
  // void _printLastestValue() {
  //   final text = _controller.text;
  //   print('$text (${text.characters.length})');
  // }

  // // listener of TextEditingController
  // @override
  // void initState() {
  //   super.initState();
  //   _controller.addListener(_printLastestValue);
  // }
   */

  /** using shared_perferences
  List<String> _formLog = [];

  @override
  void initState() {
    super.initState();
    _loadFormLog();
  }

  // load initial value from persistent storage on start
  // or fallback to null if it doesn't exist.
  Future<void> _loadFormLog() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _formLog = prefs.getStringList('formlog') ?? [];
    });
  }

  // After click the button, save the new form log
  // and async save it to persistent storage;
  Future<void> _addFormLog(String newFormLog) async {
    final prefs = await SharedPreferences.getInstance();
    var formLog = (prefs.getStringList('formlog') ?? []);
    formLog.add(newFormLog);
    await prefs.setStringList('formlog', _formLog);
    setState(() {
      _formLog = formLog;
    });
  }
   */

  /** sqflite
  final NoteLogDB _db = NoteLogDB();
  Future<void> _saveNote(String note) async {
    final newNote = NoteLogForm(note: note, date: DateTime.now().toIso8601String());
    await _db.insertNote(newNote);
  }
   */

// sqflite
/**
class NoteLogForm {
  final int? id;
  final String note;
  final String date;

  NoteLogForm({this.id, required this.note, required this.date});

  // Convert data into a Map, each key must correspond to name of col in db
  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'note': note,
    'date': date,
  };

  // implement toString to make it look better w/ print
  @override
  String toString() => 'Note log {id: $id, note: $note, date: $date}';
}

class NoteLogDB {
  Future<Database> get database async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'notelog_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notelogs(id INTEGER PRIMARY KEY AUTOINCREMENT, note TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertNote(NoteLogForm newNote) async {
    final db = await database;
    await db.insert(
      'notelogs',
      newNote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NoteLogForm>> notelogs() async {
    final db = await database;
    final List<Map<String, Object?>> notelogMaps = await db.query('notelogs');
    return [
      for (final {
            'id': id as int,
            'note': note as String,
            'date': date as String,
          }
          in notelogMaps)
        NoteLogForm(id: id, note: note, date: date),
    ];
  }

  Future<void> updateNote(NoteLogForm NoteLogForm) async {
    final db = await database;
    await db.update(
      'notelogs',
      NoteLogForm.toMap(),
      // Ensure that the note has a matching id.
      where: 'id = ?',
      // Pass the note's id as a whereArg to prevent SQL injection.
      whereArgs: [NoteLogForm.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notelogs', where: 'id = ?', whereArgs: [id]);
  }
}
 */

/** Non cookbook version

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _noteController = TextEditingController();
//   double? tempMood;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final appState = context.read<MyAppState>();
//     tempMood ??= appState.moodPoint;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.read<MyAppState>();
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             HelloMessage(),
//             MoodPointSlider(
//               tempMood: tempMood!,
//               onMoodChanged: (value) => setState(() => tempMood = value),
//               onMoodSubmit: (value) => appState.updateMoodPoint(value),
//             ),
//             NotePlaceholder(
//               appState: appState,
//               noteController: _noteController,
//             ),
//             SizedBox(height: 15),
//             FeelingList(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HelloMessage extends StatelessWidget {
//   const HelloMessage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Chào, bạn cảm thấy thế nào?',
//       style: TextStyle(
//         fontFamily: 'Fuchsia',
//         fontFamilyFallback: ['Arial'],
//         fontSize: 30,
//       ),
//     );
//   }
// }

// class MoodPointSlider extends StatelessWidget {
//   final double tempMood;
//   final ValueChanged<double> onMoodChanged;
//   final ValueChanged<double> onMoodSubmit;

//   const MoodPointSlider({
//     super.key,
//     required this.tempMood,
//     required this.onMoodChanged,
//     required this.onMoodSubmit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 400,
//       child: Slider(
//         value: tempMood,
//         onChanged: onMoodChanged,
//         onChangeEnd: onMoodSubmit,
//         min: 1.0,
//         max: 5.0,
//         divisions: 4,
//         label: tempMood.toStringAsFixed(0),
//       ),
//     );
//   }
// }

// class NotePlaceholder extends StatelessWidget {
//   const NotePlaceholder({
//     super.key,
//     required this.appState,
//     required this.noteController,
//   });

//   final MyAppState appState;
//   final TextEditingController noteController;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           width: 500,
//           child: TextField(
//             textAlign: TextAlign.center,
//             controller: noteController,
//             decoration: InputDecoration(hintText: 'Nhập trạng thái của bạn'),
//           ),
//         ),
//         SizedBox(height: 15),
//         ElevatedButton(
//           onPressed: () {
//             final note = noteController.text;
//             appState.toggleTakeNote(note);
//             print('Submitted note: $note');
//             print(appState.note);
//           },
//           child: Text('Lưu ghi chú'),
//         ),
//       ],
//     );
//   }
// }

// class FeelingList extends StatelessWidget {
//   const FeelingList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final appState = context.watch<MyAppState>();
//     return Wrap(
//       spacing: 8,
//       children: appState.feeling.map((feeling) {
//         final selected = appState.currentFeeling == feeling;
//         return ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: selected ? Colors.pinkAccent : null,
//           ),
//           onPressed: () {
//             appState.toggleFeelingNow(feeling);
//           },
//           child: Text(
//             feeling,
//             style: TextStyle(color: selected ? Colors.white : null),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

// class FeelingListEmoji extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(itemBuilder: );
//   }

// }

// class MyAppState extends ChangeNotifier {
//   var feeling = ['Terrefic', 'Happy', 'Chill', 'Bored', 'Sad', 'Anger'];
//   var currentFeeling = 'Chill';
//   void toggleFeelingNow(String newFeeling) {
//     if (feeling.contains(newFeeling)) {
//       currentFeeling = newFeeling;
//       notifyListeners();
//     }
//   }

//   double moodPoint = 3.0;
//   void updateMoodPoint(double newMoodPoint) {
//     if (newMoodPoint >= 1.0 && newMoodPoint <= 5.0) {
//       moodPoint = newMoodPoint;
//       notifyListeners();
//     }
//   }

//   String? note;
//   void toggleTakeNote(String? newNote) {
//     if (newNote != null) {
//       note = newNote;
//       notifyListeners();
//     }
//   }
// }
 */