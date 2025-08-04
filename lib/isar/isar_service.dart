import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import './model/notelog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  // READ - lấy tất cả ghi chú
  Future<List<NoteLog>> getAllNotes() async {
    final isar = await db;
    return await isar.noteLogs.where().findAll();
  }

  Stream<List<NoteLog>> watchAllNotes() {
    // Trả về một Stream emit ngay và khi có bất kỳ thay đổi trên collection noteLogs
    return Stream.fromFuture(db).asyncExpand((isar) {
      return isar.noteLogs
          .where() // query tất cả NoteLog
          .watch(fireImmediately: true);
    });
  }

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
