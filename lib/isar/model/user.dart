import 'package:isar/isar.dart';

part 'user.g.dart';

enum ThemeStyle { light, dark }

enum LanguageAvailable { en, vi, jp }

@collection
class User {
  Id id = Isar.autoIncrement;
  late String username; // TODO: loại bỏ late và tạo constructor
  late String password;
  String? fullName;
  String? email;
  late String avatarUrl;
  @enumerated
  LanguageAvailable language = LanguageAvailable.en;
  @enumerated
  ThemeStyle theme = ThemeStyle.light;
}

extension UserClone on User {
  User clone() {
    return User()
      ..id = id
      ..username = username
      ..password = password
      ..fullName = fullName
      ..email = email
      ..avatarUrl = avatarUrl
      ..language = language
      ..theme = theme;
  }
}

extension UserCopyWith on User {
  User copyWith({
    Id? id,
    String? username,
    String? password,
    String? fullName,
    String? email,
    String? avatarUrl,
    LanguageAvailable? language,
    ThemeStyle? theme,
  }) {
    return User()
      ..id = id ?? this.id
      ..username = username ?? this.username
      ..password = password ?? this.password
      ..fullName = fullName ?? this.fullName
      ..email = email ?? this.email
      ..avatarUrl = avatarUrl ?? this.avatarUrl
      ..language = language ?? this.language
      ..theme = theme ?? this.theme;
  }
}
