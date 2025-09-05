import 'package:emolog/isar/model/user.dart';
import 'package:isar/isar.dart';

part 'notelog.g.dart';

@collection
class NoteLog {
  Id id = Isar.autoIncrement;

  String? note;

  String? labelMood;

  double? moodPoint;

  late DateTime date;

  late DateTime lastUpdated;

  bool isFavor = false;

  final user = IsarLink<User>(); // use userId
}

extension NoteLogClone on NoteLog {
  NoteLog clone() {
    final newLog = NoteLog()
      ..id = id
      ..date = date
      ..isFavor = isFavor
      ..note = note
      ..labelMood = labelMood
      ..moodPoint = moodPoint
      ..lastUpdated = lastUpdated;

    // clone quan hệ user (chỉ copy link, không copy cả object)
    newLog.user.value = user.value;

    return newLog;
  }
}

extension NoteLogCopyWith on NoteLog {
  NoteLog copyWith({
    Id? id,
    String? note,
    String? labelMood,
    double? moodPoint,
    DateTime? date,
    bool? isFavor,
  }) {
    final newLog = NoteLog()
      ..id = id ?? this.id
      ..note = note ?? this.note
      ..labelMood = labelMood ?? this.labelMood
      ..moodPoint = moodPoint ?? this.moodPoint
      ..date = date ?? this.date
      ..isFavor = isFavor ?? this.isFavor;

    // clone quan hệ user (chỉ copy link, không copy cả object)
    newLog.user.value = user.value;

    return newLog;
  }
}
