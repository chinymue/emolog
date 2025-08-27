import 'package:emolog/export/basic_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import './model/user.dart';
import './model/notelog.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = _openDB();
  }

  /// CREATE NEW ITEM

  Future<NoteLog> saveLog(NoteLog log) async {
    final isar = await db;
    log.date = DateTime.now();
    log.lastUpdated = DateTime.now();
    log.labelMood ??= initialMood;
    if (log.moodPoint == null) {
      if (log.labelMood == 'terrible') {
        log.moodPoint = 0;
      } else if (log.labelMood == 'not good') {
        log.moodPoint = 0.25;
      } else if (log.labelMood == 'chill') {
        log.moodPoint = 0.5;
      } else if (log.labelMood == 'good') {
        log.moodPoint = 0.75;
      } else if (log.labelMood == 'awesome') {
        log.moodPoint = 1.0;
      }
    }
    await isar.writeTxn(() async {
      await isar.noteLogs.put(log);
    });
    return log;
  }

  Future<User> saveUser(User user) async {
    final isar = await db;
    user.avatarUrl = "";
    user.fullName = user.fullName ?? user.username;
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
    return user;
  }

  /// UPDATE ITEM

  Future<void> updateLog(NoteLog log) async {
    final isar = await db;
    log.lastUpdated = DateTime.now();
    final existedLog = await isar.noteLogs.get(log.id);
    if (existedLog != null) {
      await isar.writeTxn(() async {
        await isar.noteLogs.put(log);
      });
    }
  }

  Future<void> updateUser(User user) async {
    final isar = await db;
    final existedUser = await isar.users.get(user.id);
    if (existedUser != null) {
      await isar.writeTxn(() async {
        await isar.users.put(user);
      });
    }
  }

  // READ ALL ITEMS IN COLLECTION

  Future<List<T>> getAll<T>() async {
    final isar = await db;
    return await isar.collection<T>().where().findAll();
  }

  /// READ SPECIFIC ITEMS

  // read one item by id
  Future<dynamic> getById(Type type, int id) async {
    final isar = await db;
    if (type == User) {
      return await isar.users.get(id);
    } else if (type == NoteLog) {
      return await isar.noteLogs.get(id);
    }
    throw UnsupportedError("Type $type not supported");
  }

  // read one user by username
  Future<User?> getByUsername(String username) async {
    final isar = await db;
    return isar.users.filter().usernameEqualTo(username).findFirst();
  }

  /// DELETE SPECIFIC ITEMS

  // delete one item by id on collection T
  Future<void> deleteById<T>(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().delete(id);
    });
  }

  // TODO: delete all items match id-ref

  /// DELETE COLLECTIONS

  // delete all colections
  Future<void> clearDB() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  // delete one collection specific: T
  Future<void> clearCollection<T>() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().clear();
    });
  }

  /// OPEN DATABASES

  Future<Isar> _openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [NoteLogSchema, UserSchema],
        directory: dir.path,
        name: "emolog_v2",
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
