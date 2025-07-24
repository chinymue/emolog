import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert'; // json
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

void main() => runApp(const MyApp());

// Color Constants
const Color darkPink = Color(0xFF3A0519);
const Color midPink = Color(0xFF670D2F);
const Color hotWinePink = Color(0xFFA53860);
const Color emoWinePink = Color(0xFF8D4A5A);
const Color lightPink = Color(0xFFEf88AD);
const Color rosePink = Color(0xFFF6E3E5);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emolog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Logging',
          style: TextStyle(color: hotWinePink, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmologForm(storage: FormLogStorage()),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryLog()),
                ),
                child: const Text('History', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ), //
      ),
    );
  }
}

// read & write data in file as storage
class FormLogStorage {
  Future<String> get _localPath async =>
      (await getApplicationDocumentsDirectory()).path;

  Future<File> get _localFile async => File('${await _localPath}/formlog.txt');

  Future<File> writeFormLog(List<String> formLogList) async {
    final file = await _localFile;
    final jsonLines = formLogList.map((log) => json.encode(log)).join('\n');
    return file.writeAsString(jsonLines, flush: true);
  }

  Future<File> appendFormLog(String newFormLog) async {
    final file = await _localFile;
    return file.writeAsString(
      '${json.encode(newFormLog)}\n',
      mode: FileMode.append,
      flush: true,
    );
  }

  Future<List<String>> readFormLog() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => json.decode(line) as String)
          .toList();
    } catch (_) {
      return [];
    }
  }
}

class EmologForm extends StatefulWidget {
  const EmologForm({super.key, required this.storage});
  final FormLogStorage storage;

  @override
  State<EmologForm> createState() => _EmologFormState();
}

class _EmologFormState extends State<EmologForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  List<String> _formLogList = [];
  String _selectedMood = 'chill';

  // read & write into file
  @override
  void initState() {
    super.initState();
    widget.storage.readFormLog().then(
      (value) => setState(() => _formLogList = value),
    );
  }

  // used to discard resources used by obj when don't need obj anymore, avoid mmr leak
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final log =
          'Note: ${_controller.text}\nMood: $_selectedMood\nDate: ${DateTime.now().toIso8601String()}';
      await widget.storage.appendFormLog(log);
      if (!mounted) return;
      setState(() => _formLogList.add(log));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$log has been recorded')));
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
          NoteLog(controller: _controller),
          const SizedBox(height: 20),
          MoodPicker(
            onMoodSelected: (mood) => setState(() => _selectedMood = mood),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Submit', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class NoteLog extends StatelessWidget {
  const NoteLog({super.key, required this.controller});
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
  String _selectedMood = 'none';

  final Map<String, IconData> moods = {
    'awesome': Icons.sentiment_very_satisfied,
    'good': Icons.sentiment_satisfied,
    'chill': Icons.sentiment_neutral,
    'not good': Icons.sentiment_dissatisfied,
    'terrible': Icons.sentiment_very_dissatisfied,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
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
                    backgroundColor: selected ? emoWinePink : rosePink,
                  ),
                  child: Icon(
                    entry.value,
                    size: 25,
                    color: selected ? rosePink : emoWinePink,
                  ),
                ),
                Text(entry.key, style: TextStyle(fontSize: 16)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class HelloLog extends StatelessWidget {
  const HelloLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hi sweetie, how is your day?',
      style: TextStyle(
        color: hotWinePink,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

class HistoryLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tesst Route')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('That\'s work', style: TextStyle(fontSize: 50)),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Open route'),
            ),
          ],
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
    final newNote = NoteLog(note: note, date: DateTime.now().toIso8601String());
    await _db.insertNote(newNote);
  }
   */

// sqflite
/**
class NoteLog {
  final int? id;
  final String note;
  final String date;

  NoteLog({this.id, required this.note, required this.date});

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

  Future<void> insertNote(NoteLog newNote) async {
    final db = await database;
    await db.insert(
      'notelogs',
      newNote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NoteLog>> notelogs() async {
    final db = await database;
    final List<Map<String, Object?>> notelogMaps = await db.query('notelogs');
    return [
      for (final {
            'id': id as int,
            'note': note as String,
            'date': date as String,
          }
          in notelogMaps)
        NoteLog(id: id, note: note, date: date),
    ];
  }

  Future<void> updateNote(NoteLog notelog) async {
    final db = await database;
    await db.update(
      'notelogs',
      notelog.toMap(),
      // Ensure that the note has a matching id.
      where: 'id = ?',
      // Pass the note's id as a whereArg to prevent SQL injection.
      whereArgs: [notelog.id],
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