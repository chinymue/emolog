import 'package:isar/isar.dart';

part 'relax.g.dart';

@collection
class Relax {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  final String relaxId; // global ID (UUID), dùng để sync với Firestore

  String? note;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMiliseconds;

  @Index()
  final String userUid; // user uid from User collection for linking with Firestore user collection

  Relax({
    required this.relaxId,
    required this.startTime,
    required this.endTime,
    required this.durationMiliseconds,
    required this.userUid,
    this.note,
  });
}

extension RelaxCopyWith on Relax {
  Relax copyWith({
    String? relaxId,
    String? note,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMiliseconds,
    String? userUid,
  }) {
    final clone = Relax(
      relaxId: relaxId ?? this.relaxId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMiliseconds: durationMiliseconds ?? this.durationMiliseconds,
      userUid: userUid ?? this.userUid,
      note: note ?? this.note,
    );
    clone.id = this.id;
    return clone;
  }
}
