import 'package:flutter/material.dart';
import '../../isar/isar_service.dart';
import '../../isar/model/notelog.dart';
import '../utils/data_utils.dart';
import '../utils/constant.dart';

class LogProvider extends ChangeNotifier {
  final IsarService isarService;
  LogProvider(this.isarService);

  /// CRUD OPERATIONS ========================================
  /// CREATE A NEW LOG
  NoteLog newLog = NoteLog();

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
  List<NoteLog> logs = [];
  bool isFetchedLogs = false;

  Future<void> fetchLogs(String? userUid) async {
    if (!isFetchedLogs) {
      logs = userUid == null
          ? await isarService.getAll<NoteLog>()
          : await isarService.getAllLogs(userUid);
      isFetchedLogs = true;
      notifyListeners();
    }
  }

  void reset() {
    logs = [];
    isFetchedLogs = false;
    notifyListeners();
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
    _updateLogInList(updatedLog.id, (_) => updatedLog);
  }

  /// TOGGLE FAVORITE STATUS
  void updateLogFavor({required int id, bool isSaved = false}) async {
    _updateLogInList(id, (log) => log.copyWith(isFavor: !log.isFavor));
    if (isSaved) {
      final log = logs.firstWhere((log) => log.id == id);
      await isarService.updateLog(log);
    }
  }

  /// UPDATE IN DETAILS LOG ===================================
  late NoteLog editableLog;
  bool hasEditableLog = false;

  void setEditableLog({required NoteLog log, bool notify = true}) {
    editableLog = log.copyWith();
    hasEditableLog = true;
    if (notify) notifyListeners();
  }

  Future<void> saveEditableLog() async {
    await isarService.updateLog(editableLog);
    _updateLogInList(
      editableLog.id,
      (log) => isNoteLogChanged(log, editableLog) ? editableLog : log,
    );
    editableLog = NoteLog();
    hasEditableLog = false;
  }

  /// COMMON FIELD UPDATERS =================================
  void setLabelMood(String mood, {bool notify = false}) =>
      _updateLogField(newLog, (log) => log.labelMood = mood, notify);

  void setMoodPoint(double point, {bool notify = false}) =>
      _updateLogField(newLog, (log) => log.moodPoint = point, notify);

  void setNote(String? note, {bool notify = false}) =>
      _updateLogField(newLog, (log) => log.note = note, notify);

  void setFavor({bool notify = false}) =>
      _updateLogField(newLog, (log) => log.isFavor = !log.isFavor, notify);

  void updateLabelMood(String mood, {bool notify = false}) =>
      _updateLogField(editableLog, (log) => log.labelMood = mood, notify);

  void updateMoodPoint(double point, {bool notify = false}) =>
      _updateLogField(editableLog, (log) => log.moodPoint = point, notify);

  void updateNote(String? note, {bool notify = false}) =>
      _updateLogField(editableLog, (log) => log.note = note, notify);

  void updateFavor({bool notify = false}) =>
      _updateLogField(editableLog, (log) => log.isFavor = !log.isFavor, notify);

  /// HELPER METHODS ===================================

  void _updateLogField(
    NoteLog target,
    void Function(NoteLog) updater,
    bool notify,
  ) {
    updater(target);
    if (notify) notifyListeners();
  }

  void _updateLogInList(
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
