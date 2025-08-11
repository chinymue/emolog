import 'package:isar/isar.dart';

part 'notelog.g.dart';

@collection
class NoteLog {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? note;

  String? labelMood;

  double? numericMood;

  late DateTime date;

  late DateTime lastUpdated;

  bool isFavor = false;
}

extension NoteLogClone on NoteLog {
  NoteLog clone() {
    return NoteLog()
      ..id = id
      ..date = date
      ..isFavor = isFavor
      ..note = note
      ..labelMood = labelMood
      ..numericMood = numericMood
      ..lastUpdated = lastUpdated;
  }
}
