> Stuff in {{}} indicate that you can name that part whatever you want.
> Data type related stuff in [[]] indicate that you can change into what you need.
Data type related stuff in [[]] indicate that you can change into what you need.

### Persistance

- Refer to how you save / store data in local.
- Have different ways according to what kind of data you want to store:
  - **shared_preferences** plugin/package: small collection (KB), format often is key-value.
  - **path_provider** plugin w/ **dart:io**: bigger (MB), store in file(s), and all logic have to do manually.
  - SQLite (**sqflite** plugin/package): sql data and query, often use when data is big. (made a try but not good & can't work it out, maybe that's too old)
  - noSQL with **objectbox**, **Hive** (will try in future)

#### shared_perferences

- add package as a dependency: `flutter pub add shared_preferences`
- import when use: `import 'package:shared_preferences/shared_preferences.dart';`
- only work with these data type: `int`, `double`, `bool`, `String`, and `List<String>`.
- no guarantee that data will be persisted across app restarts.
- testing support: `setMockInitialValues`.
  `SharedPreferences.setMockInitialValues(<String, Object>{'{{counter}}': 2});`
- `{{prefs}}.clear()`: để xoá tất cả.

> load perference: inside the widget you need

```
  @override
  void initState() {
    super.initState();
    _{{loadFormLog}}();
  }

  // load initial value from persistent storage on start
  // or fallback to null if it doesn't exist.
  Future<void> _{{loadFormLog}}() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _{{formLog}} = prefs.[[getStringList]]('{{formlog}}') ?? [];
    });
  }
```

> read data: should wrap by a `Future<void>` function
> load perference: inside the widget you need

```
  @override
  void initState() {
    super.initState();
    _{{loadFormLog}}();
  }

  // load initial value from persistent storage on start
  // or fallback to null if it doesn't exist.
  Future<void> _{{loadFormLog}}() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _{{formLog}} = prefs.[[getStringList]]('{{formlog}}') ?? [];
    });
  }
```

> read data: should wrap by a `Future<void>` function

```
final {{prefs}} = await SharedPreferences.getInstance();

// Try reading the counter value from persistent storage.
// If not present, null is returned, so default to 0.
final {{counter}} = {{prefs}}.[[getInt]]('{{counter}}') ?? 0;
final {{counter}} = {{prefs}}.[[getInt]]('{{counter}}') ?? 0;
```

> save data: should wrap by a `Future<void>` function
> save data: should wrap by a `Future<void>` function

```
  // After click the button, save the new form log
  // and async save it to persistent storage;
  Future<void> _{{addFormLog}}([[String]] {{newFormLog}}) async {
    final {{prefs}} = await SharedPreferences.getInstance();
    var {{formLog}} = ({{prefs}}.[[getStringList]]('{{formlog}}') ?? []);
    {{formLog}}.add({{newFormLog}});
    await {{prefs}}.[[setStringList]]('{{formlog}}', _formLog);
    setState(() {
      _{{formLog}} = {{formLog}};
    });
  }
  // After click the button, save the new form log
  // and async save it to persistent storage;
  Future<void> _{{addFormLog}}([[String]] {{newFormLog}}) async {
    final {{prefs}} = await SharedPreferences.getInstance();
    var {{formLog}} = ({{prefs}}.[[getStringList]]('{{formlog}}') ?? []);
    {{formLog}}.add({{newFormLog}});
    await {{prefs}}.[[setStringList]]('{{formlog}}', _formLog);
    setState(() {
      _{{formLog}} = {{formLog}};
    });
  }
```

> remove data: should wrap by a `Future<void>` function
> remove data: should wrap by a `Future<void>` function

```
final {{prefs}} = await SharedPreferences.getInstance();

// Remove the counter key-value pair from persistent storage.
await {{prefs}}.remove('{{counter}}');
```

#### path_provider & dart:io

- _DO NOT_ work on web apps (because there're no file to access), only mobile / desktop apps.
- add package: `flutter pub add path_provider`
- import package: `import 'package:path_provider/path_provider.dart';`
- import `dart:io`: `import 'dart:io';`
- import `dart:convert` for json case.
- workflow in this case: find path -> create file -> read data -> write data. Should be write in a class and set that as storage of a **stateful widget**.

> Find path:

```
Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
```

> create file:

```
  Future<File> get _localFile async {
    final path = await _localPath;
    print("📁 Saving to path: $path/{{formlog.txt}}"); // DEBUG: print to console
    return File('$path/{{formlog.txt}}');
  }
```

> read file:

```
  Future<List<String>> readFormLog() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      final decode = contents
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => json.decode(line) as String);

      return decode.toList();
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }
```

> write file: two way, 1 is write all file, 2 is append new data in file (as a line split by '\n')

```
  Future<File> {{writeFormLog}}([[List<String>]] {{formLogList}}) async {
    final file = await _localFile;

    // convert List<String> to each json line
    final jsonLines = formLogList.map((log) => json.encode(log)).join('\n');

    // Write the file
    return file.writeAsString(jsonString);
  }
```

`file.writeAsString({{newFormLog}} + '\n', mode: FileMode.append);`

`await file.writeAsString('\n${{newLog}}', mode: FileMode.append, flush: true);`

> should write in json type for convinience: `json.encode()`, `json.decode()`

#### SQLite with sqflite

- **sqflite** only work with macOS, iOS, Android
- add dependency: `flutter pub add sqflite path`
- import: `import 'package:sqflite/sqflite.dart';`, `import 'package:path/path.dart';`
- workflow: define a data model -> open db -> create that table -> retrieve data -> insert data in db -> update data in db -> delete data in db

> model:

```
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
```

> connect w/ db:

```
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
```
