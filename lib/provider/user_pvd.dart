import 'package:emolog/provider/lang_pvd.dart';
import 'package:emolog/provider/log_pvd.dart';
import 'package:emolog/provider/theme_pvd.dart';
import 'package:emolog/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../isar/isar_service.dart';
import '../isar/model/user.dart';
import '../enum/lang.dart';
import '../enum/theme_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserProvider extends ChangeNotifier {
  final IsarService isarService;
  UserProvider(this.isarService);

  User? _currentUser;
  bool isFetchedUser = false;
  User? get user => _currentUser;

  /// LOGIN, LOGOUT AND REGISTATION
  Future<bool> login(
    BuildContext c, {
    required String username,
    required String password,
  }) async {
    final user = await isarService.getByUsername(username);
    if (user == null) return false;
    final hash = hashPassword(password, user.salt);
    if (hash == user.passwordHash) {
      _currentUser = user;
      isFetchedUser = true;
      updateUser(newLastLogin: DateTime.now(), isNotify: false);
      _syncUserToFirestore(user);
      notifyListeners();
      if (!c.mounted) return false;
      c.read<LanguageProvider>().setLang(_currentUser!.language);
      c.read<ThemeProvider>().setTheme(_currentUser!.theme);
      return true;
    }
    return false;
  }

  void logout(BuildContext c) {
    _currentUser = null;
    isFetchedUser = false;
    notifyListeners();
    c.read<LogProvider>().reset();
  }

  Future<bool> register(String username, String password) async {
    final user = await isarService.getByUsername(username);
    if (user != null) return false;
    final salt = generateSalt();
    final hash = hashPassword(password, salt);
    final newUser = User()
      ..uid = const Uuid().v4()
      ..username = username
      ..passwordHash = hash
      ..salt = salt
      ..avatarUrl = ""
      ..createdAt = DateTime.now()
      ..fullName = username;
    await isarService.saveUser(newUser);
    _currentUser = newUser;
    isFetchedUser = true;
    if (_currentUser != null) {
      await _syncUserToFirestore(_currentUser!);
    }
    notifyListeners();
    return true;
  }

  Future<bool> loginAsGuest(BuildContext c) async {
    // create guest account if not exist
    final user = await isarService.getByUsername('guest');
    if (user == null) {
      final newUser = User()
        ..uid = const Uuid().v4()
        ..username = "guest"
        ..passwordHash = "default_pw"
        ..salt = "default_salt"
        ..avatarUrl = "default_url"
        ..fullName = "guest"
        ..createdAt = DateTime.now();
      await isarService.saveUser(newUser);
      _currentUser = newUser;
    } else {
      _currentUser = user;
    }
    _currentUser!.lastLogin = DateTime.now();
    await isarService.updateUser(_currentUser!);
    isFetchedUser = true;
    notifyListeners();
    if (!c.mounted) return false;
    c.read<LanguageProvider>().setLang(_currentUser!.language);
    c.read<ThemeProvider>().setTheme(_currentUser!.theme);
    return true;
  }

  /// CLOUD FIRESTORE SYNC

  Future<void> syncAllUsersToFirestore() async {
    final users = await isarService.getAll<User>();

    for (var user in users) {
      // TODO: change into FirebaseAuth UID after implemented auth
      if (user.uid.isEmpty) {
        user.uid = const Uuid().v4();
        await isarService.updateUser(user);
      }

      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      await docRef.set({
        'username': user.username,
        'passwordHash': user.passwordHash,
        'salt': user.salt,
        'fullName': user.fullName,
        'email': user.email,
        'avatarUrl': user.avatarUrl,
        'createdAt': user.createdAt.toIso8601String(),
        'lastLogin': user.lastLogin?.toIso8601String(),
        'language': user.language.name,
        'theme': user.theme.name,
      }, SetOptions(merge: true)); // merge để không overwrite dữ liệu cũ
    }
  }

  Future<void> _syncUserToFirestore(User user) async {
    if (user.uid.isEmpty) {
      user.uid = const Uuid().v4();
      await isarService.updateUser(user);
    }
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    await docRef.set({
      'username': user.username,
      'passwordHash': user.passwordHash,
      'salt': user.salt,
      'fullName': user.fullName,
      'email': user.email,
      'avatarUrl': user.avatarUrl,
      'createdAt': user.createdAt.toIso8601String(),
      'lastLogin': user.lastLogin?.toIso8601String(),
      'language': user.language.name,
      'theme': user.theme.name,
    }, SetOptions(merge: true)); // merge để không overwrite dữ liệu cũ
  }

  /// RESET USER INFO INTO DEFAULT

  void resetGuest(
    BuildContext c, {
    bool isNotify = true,
    bool isChange = true,
    bool isLogout = false,
  }) async {
    _currentUser!.username = "guest";
    _currentUser!.passwordHash = "default_pw";
    _currentUser!.fullName = _currentUser!.username;
    _currentUser!.email = "${_currentUser!.username}@emolog.com";
    _currentUser!.avatarUrl = "default_url";
    _currentUser!.language = LanguageAvailable.en;
    _currentUser!.theme = ThemeStyle.light;
    if (isNotify) notifyListeners();
    if (isChange) {
      c.read<LanguageProvider>().resetLang();
      c.read<ThemeProvider>().resetTheme();
    }
    if (isLogout) {
      await isarService.updateUser(_currentUser!);
    }
  }

  void resetSetting(BuildContext c) {
    _currentUser!.language = LanguageAvailable.en;
    _currentUser!.theme = ThemeStyle.light;
    notifyListeners();
    c.read<LanguageProvider>().resetLang();
    c.read<ThemeProvider>().resetTheme();
  }

  /// UPDATE USER INFO

  Future<void> updateUser({
    String? newUsername,
    String? newPass,
    String? newFullname,
    String? newEmail,
    String? newURL,
    DateTime? newLastLogin,
    LanguageAvailable? newLanguage,
    ThemeStyle? newTheme,
    bool isNotify = true,
  }) async {
    if (newUsername != null) {
      _currentUser!.username = newUsername;
    }
    if (newPass != null) {
      final salt = generateSalt();
      final hash = hashPassword(newPass, salt);
      _currentUser!.passwordHash = hash;
      _currentUser!.salt = salt;
    }
    if (newFullname != null) {
      _currentUser!.fullName = newFullname;
    }
    if (newEmail != null) {
      _currentUser!.email = newEmail;
    }
    if (newURL != null) {
      _currentUser!.avatarUrl = newURL;
    }
    if (newLastLogin != null) {
      _currentUser!.lastLogin = newLastLogin;
    }
    if (newLanguage != null) {
      _currentUser!.language = newLanguage;
    }
    if (newTheme != null) {
      _currentUser!.theme = newTheme;
    }
    await isarService.updateUser(_currentUser!);
    if (isNotify) notifyListeners();
  }
}
