import 'package:emolog/export/basic_utils.dart';
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
  Future<NoteLog> saveNote(NoteLog log) async {
    final isar = await db;
    log.date = DateTime.now();
    log.lastUpdated = DateTime.now();
    log.labelMood ??= initialMood;
    await isar.writeTxn(() async {
      await isar.noteLogs.put(log);
    });
    return log;
  }

  Future<void> updateNote(NoteLog log) async {
    final isar = await db;
    log.lastUpdated = DateTime.now();
    final existedLog = await isar.noteLogs.get(log.id);
    if (existedLog != null) {
      await isar.writeTxn(() async {
        await isar.noteLogs.put(log);
      });
    }
  }

  // READ - lấy tất cả ghi chú
  Future<List<NoteLog>> getAllNotes() async {
    final isar = await db;
    return await isar.noteLogs.where().findAll();
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
