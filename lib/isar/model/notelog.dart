import 'package:isar/isar.dart';

part 'notelog.g.dart';

@collection
class NoteLog {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  String? note;

  String? labelMood;

  int? numericMood;

  late DateTime date;

  bool isFavor = false;
}
