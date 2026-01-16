import 'package:isar/isar.dart';
import '../../enum/lang.dart';
import '../../enum/theme_style.dart';
part 'user.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uid; // Firebase UID
  @Index(unique: true)
  late String username;
  late String passwordHash;
  late String salt;
  bool isGuest = false;

  String? fullName;
  String? email;
  late String avatarUrl;
  DateTime createdAt = DateTime.now();
  DateTime? lastLogin;
  late DateTime updatedAt;

  @enumerated
  LanguageAvailable language = LanguageAvailable.en;
  @enumerated
  ThemeStyle theme = ThemeStyle.light;
}
