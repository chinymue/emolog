import 'package:isar/isar.dart';
import './notelog.dart';

part 'note_image.g.dart';

@collection
class NoteImage {
  Id id = Isar.autoIncrement;

  // Link ngược về NoteLog
  final parent = IsarLink<NoteLog>();

  // Lưu path file cục bộ
  late String localPath;

  // Lưu thumbnail (dữ liệu nhỏ để load nhanh)
  List<int>? thumbnail;
}
