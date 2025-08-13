import 'package:emolog/export/notelog_essential.dart';
import '../isar/isar_service.dart';
import 'package:flutter/material.dart';
import '../export/basic_utils.dart';

class LogProvider extends ChangeNotifier {
  final IsarService isarService = IsarService();

  /// CREATE A NEW LOG
  NoteLog newLog = NoteLog();

  void setLabelMood({required String mood, bool notify = false}) {
    if (moods.containsKey(mood)) {
      newLog.labelMood = mood;
      if (notify) notifyListeners();
    }
  }

  void setMoodPoint({required double moodPoint, bool notify = false}) {
    if (moodPoint >= 0 && moodPoint <= 1) {
      newLog.numericMood = moodPoint;
      if (notify) notifyListeners();
    }
  }

  void setNote({String? note, bool notify = false}) {
    if (note != null) {
      newLog.note = note;
      if (notify) notifyListeners();
    }
  }

  void setFavor({bool notify = false}) {
    newLog.isFavor = !newLog.isFavor;
    if (notify) notifyListeners();
  }

  Future<NoteLog> addLog() async {
    if (logs.any((l) => l.id == newLog.id)) return newLog;
    await isarService.saveLog(newLog);

    if (isFetchedLogs) {
      logs.add(newLog);
      notifyListeners();
    }

    final savedLog = newLog;
    newLog = NoteLog();
    return savedLog;
  }

  /// FETCH LOGS FROM ISAR
  List<NoteLog> logs = [];
  bool isFetchedLogs = false;

  Future<void> fetchLogs() async {
    if (!isFetchedLogs) {
      logs = await isarService.getAllLogs();
      isFetchedLogs = true;
      notifyListeners();
    }
  }

  Future<void> deleteLog({required int id}) async {
    await isarService.deleteLogById(id);
    if (isFetchedLogs) {
      logs.removeWhere((log) => log.id == id);
      notifyListeners();
    }
  }

  Future<void> updateLog({required NoteLog updatedLog}) async {
    if (updatedLog == NoteLog()) return;
    await isarService.updateLog(updatedLog);
    if (isFetchedLogs) {
      final index = logs.indexWhere((log) => log.id == updatedLog.id);
      if (index != -1) {
        logs[index] = updatedLog;
        notifyListeners();
      }
    }
  }

  // only if logs is fetched
  void updateLogFavor({required int id}) {
    if (isFetchedLogs) {
      final index = logs.indexWhere((l) => l.id == id);
      if (index != -1) {
        logs[index].isFavor = !logs[index].isFavor;
        notifyListeners();
      }
    }
  }

  /// UPDATE IN DETAILS LOG
  late NoteLog editableLog;

  void setEditableLog(NoteLog log) {
    editableLog = log.clone();
    notifyListeners();
  }

  void updateLabelMood({required String mood, bool notify = false}) {
    if (moods.containsKey(mood)) {
      editableLog.labelMood = mood;
      if (notify) notifyListeners();
    }
  }

  void updateMoodPoint({required double moodPoint, bool notify = false}) {
    if (moodPoint >= 0 && moodPoint <= 1) {
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

  void updateFavor({bool notify = false}) {
    editableLog.isFavor = !editableLog.isFavor;
    if (notify) notifyListeners();
  }

  Future<void> saveEditableLog() async {
    if (isFetchedLogs) {
      final index = logs.indexWhere((log) => log.id == editableLog.id);
      if (isNoteLogChanged(logs[index], editableLog)) {
        await isarService.updateLog(editableLog);
        if (index != -1) {
          logs[index] = editableLog;
          editableLog = NoteLog();
          notifyListeners();
        }
      }
    } else {
      await isarService.updateLog(editableLog);
    }
  }
}
