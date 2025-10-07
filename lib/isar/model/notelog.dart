import 'package:isar/isar.dart';
import './note_image.dart';

part 'notelog.g.dart';

@collection
class NoteLog {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String logId; // global ID (UUID), dùng để sync với Firestore

  String? note;
  String? labelMood;
  double? moodPoint;
  late DateTime date;
  bool isFavor = false;

  DateTime createdAt = DateTime.now();
  late DateTime lastUpdated;

  @Index()
  late String userUid; // user uid from User collection for linking with Firestore user collection

  final image = IsarLink<NoteImage>();
}

extension NoteLogCopyWith on NoteLog {
  NoteLog copyWith({
    Id? id,
    String? logId,
    String? note,
    String? labelMood,
    double? moodPoint,
    DateTime? date,
    bool? isFavor,
    DateTime? lastUpdated,
    String? userUid,
  }) {
    return NoteLog()
      ..id = id ?? this.id
      ..logId = logId ?? this.logId
      ..note = note ?? this.note
      ..labelMood = labelMood ?? this.labelMood
      ..moodPoint = moodPoint ?? this.moodPoint
      ..date = date ?? this.date
      ..isFavor = isFavor ?? this.isFavor
      ..lastUpdated = lastUpdated ?? this.lastUpdated
      ..userUid = userUid ?? this.userUid;
  }
}
