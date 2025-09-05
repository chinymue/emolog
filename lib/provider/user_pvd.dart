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
      notifyListeners();
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
      ..username = username
      ..passwordHash = hash
      ..salt = salt;
    await isarService.saveUser(newUser);
    _currentUser = newUser;
    isFetchedUser = true;
    notifyListeners();
    return true;
  }

  Future<bool> loginAsGuest(BuildContext c) async {
    final user = await isarService.getByUsername('guest');
    if (user == null) {
      return false;
    } else {
      _currentUser = user;
      isFetchedUser = true;
      notifyListeners();
      c.read<LanguageProvider>().setLang(_currentUser!.language);
      c.read<ThemeProvider>().setTheme(_currentUser!.theme);
      return true;
    }
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
    LanguageAvailable? newLanguage,
    ThemeStyle? newTheme,
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
    if (newLanguage != null) {
      _currentUser!.language = newLanguage;
    }
    if (newTheme != null) {
      _currentUser!.theme = newTheme;
    }
    await isarService.updateUser(_currentUser!);
    notifyListeners();
  }

  // update each field

  void updatePassword(String newPass) {
    final salt = generateSalt();
    final hash = hashPassword(newPass, salt);
    _currentUser!.passwordHash = hash;
    _currentUser!.salt = salt;
    notifyListeners();
  }

  void updateFullname(String newFullname) {
    _currentUser!.fullName = newFullname;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _currentUser!.email = newEmail;
    notifyListeners();
  }

  void updateAvatar(String newURL) {
    _currentUser!.avatarUrl = newURL;
    notifyListeners();
  }

  void updateLanguage(LanguageAvailable newLanguage) {
    _currentUser!.language = newLanguage;
    notifyListeners();
  }

  void updateTheme(ThemeStyle newTheme) {
    _currentUser!.theme = newTheme;
    notifyListeners();
  }
}
