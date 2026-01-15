import 'package:isar/isar.dart';

part 'note_image.g.dart';

@collection
class NoteImage {
  Id id = Isar.autoIncrement;

  int usedCount = 0;

  late String localPath;

  List<int>? thumbnail;

  late DateTime createdAt;
}
