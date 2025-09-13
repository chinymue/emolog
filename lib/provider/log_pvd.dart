import 'package:flutter/material.dart';
import '../../isar/isar_service.dart';
import '../../isar/model/notelog.dart';
import '../utils/data_utils.dart';
import '../utils/constant.dart';

class LogProvider extends ChangeNotifier
    with
        ServiceAccess,
        LogStateMixin,
        LogCRUDMixin,
        EditableLogMixin,
        FieldUpdaterMixin,
        ToggleMixin {
  LogProvider(IsarService service) {
    isarService = service;
  }
}

mixin ServiceAccess on ChangeNotifier {
  late final IsarService isarService;
}

mixin LogStateMixin on ChangeNotifier {
  NoteLog newLog = NoteLog();

  List<NoteLog> logs = [];
  bool isFetchedLogs = false;

  late NoteLog editableLog;
  bool hasEditableLog = false;

  void reset() {
    logs = [];
    isFetchedLogs = false;
    notifyListeners();
  }

  void updateLogField(
    NoteLog target,
    void Function(NoteLog) updater, {
    bool notify = false,
  }) {
    updater(target);
    if (notify) notifyListeners();
  }

  void updateLogInList(
    int id,
    NoteLog Function(NoteLog) transform, {
    bool notify = true,
  }) {
    if (!isFetchedLogs) return;

    final index = logs.indexWhere((l) => l.id == id);
    if (index == -1) return;

    logs[index] = transform(logs[index]);
    if (notify) notifyListeners();
  }
}

mixin LogCRUDMixin on ServiceAccess, LogStateMixin {
  /// CREATE A NEW LOG

  Future<int> addLog(String userUid, {DateTime? date}) async {
    if (logs.any((l) => l.id == newLog.id)) return newLog.id;

    newLog
      ..userUid = userUid
      ..date = date ?? DateTime.now()
      ..labelMood ??= initialMood
      ..moodPoint ??= moodPointFromLabel(newLog.labelMood!);
    await isarService.saveLog(newLog);

    if (isFetchedLogs) {
      logs.add(newLog);
      notifyListeners();
    }

    final savedLog = newLog;
    newLog = NoteLog();
    return savedLog.id;
  }

  /// FETCH LOGS FROM ISAR

  Future<void> fetchLogs(String? userUid) async {
    if (!isFetchedLogs) {
      logs = userUid == null
          ? await isarService.getAll<NoteLog>()
          : await isarService.getAllLogs(userUid);
      isFetchedLogs = true;
      notifyListeners();
    }
  }

  Future<void> deleteAllLog({
    required String userUid,
    bool notify = false,
  }) async {
    await isarService.deleteLogOfUser(userUid);
    if (isFetchedLogs) {
      logs = [];
      if (notify) notifyListeners();
    }
  }

  Future<void> deleteLog({required int id}) async {
    await isarService.deleteById<NoteLog>(id);
    if (isFetchedLogs) {
      logs.removeWhere((log) => log.id == id);
      notifyListeners();
    }
  }

  Future<void> updateLog({required NoteLog updatedLog}) async {
    await isarService.updateLog(updatedLog);
    updateLogInList(updatedLog.id, (_) => updatedLog);
  }
}

mixin EditableLogMixin on ServiceAccess, LogStateMixin {
  void setEditableLog({required NoteLog log, bool notify = true}) {
    editableLog = log.copyWith();
    hasEditableLog = true;
    if (notify) notifyListeners();
  }

  Future<void> saveEditableLog() async {
    await isarService.updateLog(editableLog);
    updateLogInList(
      editableLog.id,
      (log) => isNoteLogChanged(log, editableLog) ? editableLog : log,
    );
    editableLog = NoteLog();
    hasEditableLog = false;
  }
}

mixin FieldUpdaterMixin on LogStateMixin {
  void updateLabelMood(String mood, {NoteLog? target}) =>
      updateLogField(target ?? newLog, (log) => log.labelMood = mood);

  void updateMoodPoint(double point, {NoteLog? target}) =>
      updateLogField(target ?? newLog, (log) => log.moodPoint = point);

  void updateNote(String? note, {NoteLog? target}) =>
      updateLogField(target ?? newLog, (log) => log.note = note);

  void updateFavor({NoteLog? target}) =>
      updateLogField(target ?? newLog, (log) => log.isFavor = !log.isFavor);
}

mixin ToggleMixin on ServiceAccess, LogStateMixin {
  /// TOGGLE FAVORITE STATUS
  Future<void> updateLogFavor({required int id, bool isSaved = false}) async {
    updateLogInList(id, (log) => log.copyWith(isFavor: !log.isFavor));
    if (isSaved) {
      final log = logs.firstWhere((log) => log.id == id);
      await isarService.updateLog(log);
    }
  }
}
