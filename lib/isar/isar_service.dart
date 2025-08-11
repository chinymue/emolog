import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import './model/notelog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import '../ultils.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = _openDB();
  }

  // CREATE or UPDATE
  // tự động tạo mới hoặc cập nhật nếu có id
  Future<NoteLog> saveNote(NoteLog note) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.noteLogs.put(note);
    });
    return note;
  }

  Future<void> updateNote(NoteLog note) async {
    final isar = await db;
    if (isar.noteLogs.get(note.id) != NoteLog()) {
      await isar.writeTxn(() async {
        await isar.noteLogs.put(note);
      });
    }
  }

  // READ - lấy tất cả ghi chú
  Future<List<NoteLog>> getAllNotes() async {
    final isar = await db;
    return await isar.noteLogs.where().findAll();
  }

  // // chưa áp dụng được thành công
  // Stream<List<NoteLog>> watchAllNotes() {
  //   // Trả về một Stream emit ngay và khi có bất kỳ thay đổi trên collection noteLogs
  //   return Stream.fromFuture(db).asyncExpand((isar) {
  //     return isar.noteLogs
  //         .where() // query tất cả NoteLog
  //         .watch(fireImmediately: true);
  //   });
  // }

  // READ - theo id
  Future<NoteLog?> getNoteById(int id) async {
    final isar = await db;
    return await isar.noteLogs.get(id);
  }

  // DELETE - theo id
  Future<void> deleteNoteById(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.noteLogs.delete(id);
    });
  }

  Future<void> clearDB() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  // // chưa áp dụng được thành công
  // // Đồng bộ lại trường isFavor của NoteLog từ SharedPreferences
  // Future<void> syncFavoritesFromPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final favList = prefs.getStringList(kPrefsKey) ?? [];

  //   final isar = await db; // hoặc instance của Isar
  //   // Lấy tất cả notes
  //   final allNotes = await isar.noteLogs.where().findAll();

  //   await isar.writeTxn(() async {
  //     for (final note in allNotes) {
  //       // Cập nhật isFavor dựa trên prefs
  //       note.isFavor = favList.contains(note.id.toString());
  //       await isar.noteLogs.put(note);
  //     }
  //   });

  //   // Xóa cache tạm trong prefs
  //   await prefs.remove(kPrefsKey);
  // }

  Future<Isar> _openDB() async {
    if (Isar.instanceNames.isEmpty) {
      if (kIsWeb) {
        return await Isar.open(
          [NoteLogSchema],
          directory: '',
          name: 'default',
          inspector: true,
        );
      } else {
        final dir = await getApplicationDocumentsDirectory();
        return await Isar.open(
          [NoteLogSchema],
          directory: dir.path,
          inspector: true,
        );
      }
    }
    return Future.value(Isar.getInstance());
  }
}
