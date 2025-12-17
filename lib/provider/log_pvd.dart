import 'package:emolog/isar/model/note_image.dart';
import 'package:flutter/material.dart';
import '../../isar/isar_service.dart';
import '../../isar/model/notelog.dart';
import '../utils/data_utils.dart';
import '../utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class LogProvider extends ChangeNotifier
    with
        ServiceAccess,
        LogStateMixin,
        LogCRUDMixin,
        LogSyncMixin,
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
      ..logId = const Uuid().v4()
      ..createdAt = DateTime.now()
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

  Future<List<int>> addImages(List<NoteImage>? imgs) async {
    if (imgs == null || imgs.isEmpty) return [];
    final savedImgs = await isarService.saveImages(imgs);
    return savedImgs.map((e) => e.id).toList();
  }

  Future<int> addLogWithImage(
    String userUid,
    NoteImage img, {
    DateTime? date,
  }) async {
    if (logs.any((l) => l.id == newLog.id)) return newLog.id;

    newLog
      ..logId = const Uuid().v4()
      ..createdAt = DateTime.now()
      ..userUid = userUid
      ..date = date ?? DateTime.now()
      ..labelMood ??= initialMood
      ..moodPoint ??= moodPointFromLabel(newLog.labelMood!);
    await isarService.saveLogWithImage(newLog, img);

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

  void deleteAllLogs() async {
    await isarService.clearCollection<NoteLog>();
    if (isFetchedLogs) {
      logs = [];
      isFetchedLogs = false;
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

mixin LogSyncMixin on ServiceAccess, LogStateMixin {
  final _firestore = FirebaseFirestore.instance;
  Future<void> syncLogs(String userUid) async {
    final isarLogs = await isarService.getAllLogs(userUid);
    final firestoreLogs = await _fetchLogsFromFirestore(userUid);

    // Map để dễ so sánh
    final isarMap = {for (var log in isarLogs) log.logId: log};
    final firestoreMap = {for (var log in firestoreLogs) log.logId: log};

    // Đồng bộ Isar -> Firestore
    for (var log in isarLogs) {
      final cloudLog = firestoreMap[log.logId];
      if (cloudLog == null) {
        await _uploadLogToFirestore(log);
      } else if (log.lastUpdated.isAfter(cloudLog.lastUpdated)) {
        await _uploadLogToFirestore(log); // overwrite cloud
      }
    }

    // Đồng bộ Firestore -> Isar
    for (var log in firestoreLogs) {
      final localLog = isarMap[log.logId];
      if (localLog == null) {
        await isarService.saveLog(log);
      } else if (log.lastUpdated.isAfter(localLog.lastUpdated)) {
        await isarService.updateLog(log);
      }
    }
  }

  Future<List<NoteLog>> _fetchLogsFromFirestore(String userUid) async {
    final snap = await _firestore
        .collection('notelogs')
        .where('userUid', isEqualTo: userUid)
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();
      return NoteLog()
        ..logId = doc.id
        ..note = data['note']
        ..labelMood = data['labelMood']
        ..moodPoint = (data['moodPoint'] as num?)?.toDouble()
        ..date = DateTime.parse(data['date'])
        ..createdAt = DateTime.parse(data['createdAt'])
        ..lastUpdated = DateTime.parse(data['lastUpdated'])
        ..isFavor = data['isFavor'] ?? false
        ..userUid = data['userUid'];
    }).toList();
  }

  Future<void> _uploadLogToFirestore(NoteLog log) async {
    await _firestore.collection('notelogs').doc(log.logId).set({
      'note': log.note,
      'labelMood': log.labelMood,
      'moodPoint': log.moodPoint,
      'date': log.date.toIso8601String(),
      'createdAt': log.createdAt.toIso8601String(),
      'lastUpdated': log.lastUpdated.toIso8601String(),
      'isFavor': log.isFavor,
      'userUid': log.userUid,
    });
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

mixin ToggleMixin on ServiceAccess, LogStateMixin, LogSyncMixin {
  /// TOGGLE FAVORITE STATUS
  Future<void> updateLogFavor({required int id, bool isSaved = false}) async {
    updateLogInList(id, (log) => log.copyWith(isFavor: !log.isFavor));
    if (isSaved) {
      final log = logs.firstWhere((log) => log.id == id);
      await isarService.updateLog(log);
    }
  }

  Future<void> toggleSync(String userUid) async {
    await syncLogs(userUid);
    if (isFetchedLogs) {
      logs = await isarService.getAllLogs(userUid);
      notifyListeners();
    }
  }
}
