import 'package:emolog/export/notelog_essential.dart';
import '../isar/isar_service.dart';
import 'package:flutter/material.dart';
import '../export/basic_utils.dart';

class LogProvider extends ChangeNotifier {
  final IsarService isarService = IsarService();

  // làm việc với các log có sẵn
  List<NoteLog> logs = [];

  // read all log
  Future<void> fetchLogs() async {
    if (logs.isEmpty) {
      logs = await isarService.getAllNotes();
      notifyListeners();
    }
  }

  // // read log with id
  // Future<NoteLog?> readLogWithId({required int id}) async {
  //   return await isarService.getNoteById(id);
  // }

  // delete
  Future<void> deleteLog({required int id}) async {
    await isarService.deleteNoteById(id);
    logs.removeWhere((log) => log.id == id);
    notifyListeners();
  }

  NoteLog editableLog = NoteLog();

  // tạo mới log
  Future<NoteLog> addLog() async {
    if (logs.any((l) => l.id == editableLog.id)) return editableLog;
    await isarService.saveNote(editableLog);
    logs.add(editableLog);
    final savedLog = editableLog;
    editableLog = NoteLog();
    notifyListeners();
    return savedLog;
  }

  // update fields
  void setEditableLog(NoteLog? log) {
    editableLog = log != null ? log.clone() : NoteLog();
    notifyListeners();
  }

  void updateLabelMood({required String mood, bool notify = false}) {
    if (moods.containsKey(mood)) {
      editableLog.labelMood = mood;
      if (notify) notifyListeners();
    }
  }

  void updateMoodPoint({required double moodPoint, bool notify = false}) {
    if (moodPoint >= minMoodPoint && moodPoint <= maxMoodPoint) {
      editableLog.numericMood = moodPoint;
      if (notify) notifyListeners();
    }
  }

  void updateNote({String? note, bool notify = false}) {
    if (note != null) {
      editableLog.note = note;
      if (notify) notifyListeners();
    }
  }

  void updateFavor({NoteLog? log, bool notify = false}) {
    if (log == null) {
      editableLog.isFavor = !editableLog.isFavor;
    } else {
      log.isFavor = !log.isFavor;
    }
    if (notify) notifyListeners();
  }

  Future<void> saveEditableLog() async {
    if (editableLog == NoteLog()) return;
    final index = logs.indexWhere((log) => log.id == editableLog.id);
    if (isNoteLogChanged(logs[index], editableLog)) {
      await isarService.updateNote(editableLog);
      if (index != -1) {
        logs[index] = editableLog;
        editableLog = NoteLog();
        notifyListeners();
      }
    }
  }

  Future<void> updateLog({required NoteLog updatedLog}) async {
    if (updatedLog == NoteLog()) return;
    await isarService.updateNote(updatedLog);
    final index = logs.indexWhere((log) => log.id == updatedLog.id);
    if (index != -1) {
      logs[index] = updatedLog;
      editableLog = NoteLog();
      notifyListeners();
    }
  }
}
