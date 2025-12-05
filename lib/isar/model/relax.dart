import 'package:isar/isar.dart';

part 'relax.g.dart';

@collection
class Relax {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String relaxId; // global ID (UUID), dùng để sync với Firestore

  String? note;
  late DateTime startTime;
  late DateTime endTime;
  late int durationMiliseconds;

  @Index()
  late String userUid; // user uid from User collection for linking with Firestore user collection
}
