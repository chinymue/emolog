import 'package:emolog/export/notelog_essential.dart';
import 'package:flutter/material.dart';

class LogProvider extends ChangeNotifier {
  final IsarService isarService = IsarService();
  List<NoteLog> logs = [];

  Future<void> fetchLogs() async {
    logs = await isarService.getAllNotes();
    notifyListeners();
  }

  Future<void> addLog({required NoteLog newLog}) async {
    await isarService.saveNote(newLog);
    logs.add(newLog);
    notifyListeners();
  }

  Future<void> deleteLog({required int id}) async {
    await isarService.deleteNoteById(id);
    logs.removeWhere((log) => log.id == id);
    notifyListeners();
  }

  Future<void> updateLog({required NoteLog updatedLog}) async {
    await isarService.updateNote(updatedLog);
    final index = logs.indexWhere((log) => log.id == updatedLog.id);
    if (index != -1) {
      logs[index] = updatedLog;
      notifyListeners();
    }
  }
}
