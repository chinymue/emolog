import 'package:emolog/provider/lang_pvd.dart';
import 'package:emolog/provider/theme_pvd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../isar/isar_service.dart';
import '../isar/model/user.dart';
import '../enum/lang.dart';
import '../enum/theme_style.dart';

class UserProvider extends ChangeNotifier {
  final IsarService isarService;
  UserProvider(this.isarService);

  late User _currentUser;
  bool isFetchedUser = false;
  User? get user => _currentUser;
  LanguageAvailable get languagePref => _currentUser.language;
  ThemeStyle get themePref => _currentUser.theme;

  /// FETCH USER

  Future<void> loadUser({required int userId}) async {
    _currentUser = await isarService.getById(User, userId);
    isFetchedUser = true;
    notifyListeners();
  }

  List<User> userList = [];
  Future<void> fetchAllUsers() async {
    userList = await isarService.getAll<User>();
    notifyListeners();
  }

  /// LOGIN AND REGISTATION
  Future<bool> login(String username, String password) async {
    final user = await isarService.getByUsername(username);
    if (user == null) return false;
    if (user.password == password) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// RESET USER INFO INTO DEFAULT

  void resetGuest(BuildContext c) {
    _currentUser.username = "guest";
    _currentUser.password = "default_pw";
    _currentUser.fullName = _currentUser.username;
    _currentUser.email = "${_currentUser.username}@emolog.com";
    _currentUser.avatarUrl = "default_url";
    _currentUser.language = LanguageAvailable.en;
    _currentUser.theme = ThemeStyle.light;
    notifyListeners();
    c.read<LanguageProvider>().resetLang();
    c.read<ThemeProvider>().resetTheme();
  }

  void resetSetting(BuildContext c) {
    _currentUser.language = LanguageAvailable.en;
    _currentUser.theme = ThemeStyle.light;
    notifyListeners();
    c.read<LanguageProvider>().resetLang();
    c.read<ThemeProvider>().resetTheme();
  }

  /// CREATE NEW USER

  // TODO: Tạo DraftUser riêng cho form sau đó convert về kiểu User
  User newUser = User();

  Future<int> addUser() async {
    _currentUser = await isarService.saveUser(newUser);
    isFetchedUser = true;
    userList.add(_currentUser);
    newUser = User();
    notifyListeners();
    return _currentUser.id;
  }

  // default guest
  void setGuestAccount({bool notify = false}) {
    newUser.username = "guest";
    newUser.password = "default_pw";
    newUser.fullName = newUser.username;
    newUser.email = "${newUser.username}@emolog.com";
    newUser.avatarUrl = "default_url";
    newUser.language = LanguageAvailable.en;
    newUser.theme = ThemeStyle.light;
    if (notify) notifyListeners();
  }

  // set account info
  void setAccount(
    String newUsername,
    String newPass,
    String? newFullname,
    String? newEmail,
    String? newURL,
    LanguageAvailable? newLanguage,
    ThemeStyle? newTheme,
  ) {
    newUser.username = newUsername;
    newUser.password = newPass;
    newUser.fullName = newFullname ?? newUsername;
    newUser.email = newEmail;
    newUser.avatarUrl = newURL ?? "";
    newUser.language = newLanguage ?? LanguageAvailable.en;
    newUser.theme = newTheme ?? ThemeStyle.light;
    notifyListeners();
  }

  // set each field

  void setUsername(String newUsername) {
    newUser.username = newUsername;
    notifyListeners();
  }

  void setPassword(String newPass) {
    newUser.password = newPass;
    notifyListeners();
  }

  void setFullname(String newFullname) {
    newUser.fullName = newFullname;
    notifyListeners();
  }

  void setEmail(String newEmail) {
    newUser.email = newEmail;
    notifyListeners();
  }

  void setAvatar(String newURL) {
    newUser.avatarUrl = newURL;
    notifyListeners();
  }

  void setLanguage(LanguageAvailable newLanguage) {
    newUser.language = newLanguage;
    notifyListeners();
  }

  void setTheme(ThemeStyle newTheme) {
    newUser.theme = newTheme;
    notifyListeners();
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
      _currentUser.username = newUsername;
    }
    if (newPass != null) {
      _currentUser.password = newPass;
    }
    if (newFullname != null) {
      _currentUser.fullName = newFullname;
    }
    if (newEmail != null) {
      _currentUser.email = newEmail;
    }
    if (newURL != null) {
      _currentUser.avatarUrl = newURL;
    }
    if (newLanguage != null) {
      _currentUser.language = newLanguage;
    }
    if (newTheme != null) {
      _currentUser.theme = newTheme;
    }
    await isarService.updateUser(_currentUser);
    notifyListeners();
  }

  // update each field

  void updateUsername(String newUsername) {
    _currentUser.username = newUsername;
    notifyListeners();
  }

  void updatePassword(String newPass) {
    _currentUser.password = newPass;
    notifyListeners();
  }

  void updateFullname(String newFullname) {
    _currentUser.fullName = newFullname;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _currentUser.email = newEmail;
    notifyListeners();
  }

  void updateAvatar(String newURL) {
    _currentUser.avatarUrl = newURL;
    notifyListeners();
  }

  void updateLanguage(LanguageAvailable newLanguage) {
    _currentUser.language = newLanguage;
    notifyListeners();
  }

  void updateTheme(ThemeStyle newTheme) {
    _currentUser.theme = newTheme;
    notifyListeners();
  }
}
