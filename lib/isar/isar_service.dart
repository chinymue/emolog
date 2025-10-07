import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import './model/user.dart';
import './model/notelog.dart';
import './model/note_image.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = _openDB();
  }

  /// CREATE NEW ITEM

  Future<NoteLog> saveLog(NoteLog log) async {
    final isar = await db;
    log.lastUpdated = DateTime.now();
    await isar.writeTxn(() async {
      await isar.noteLogs.put(log);
      if (log.images.isNotEmpty) await log.images.save();
    });
    return log;
  }

  Future<User> saveUser(User user) async {
    final isar = await db;
    user.updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
    return user;
  }

  Future<NoteImage> saveImage(NoteImage img) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.noteImages.put(img);
    });
    return img;
  }

  Future<List<NoteImage>> saveImages(List<NoteImage> imgs) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.noteImages.putAll(imgs);
    });
    return imgs;
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
    user.updatedAt = DateTime.now();
    if (existedUser != null) {
      await isar.writeTxn(() async {
        await isar.users.put(user);
      });
    }
  }

  /// READ ALL ITEMS IN COLLECTION

  Future<List<T>> getAll<T>() async {
    final isar = await db;
    return await isar.collection<T>().where().findAll();
  }

  // read all logs of one user
  Future<List<NoteLog>> getAllLogs(String userUid) async {
    final isar = await db;
    return await isar.noteLogs.filter().userUidEqualTo(userUid).findAll();
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

  // delete all notelog items match user id-ref
  Future<void> deleteLogOfUser(String userUid) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final items = await isar.noteLogs
          .filter()
          .userUidEqualTo(userUid)
          .findAll();
      for (var item in items) {
        await isar.noteLogs.delete(item.id);
      }
    });
  }

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
        [NoteLogSchema, UserSchema, NoteImageSchema],
        directory: dir.path,
        name: "emolog_v3.2",
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
