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
  Future<String> register(String username, String password) async {
    final user = await isarService.getByUsername(username);
    if (user != null) return "username";
    if (username == "" || password == "") return "length";
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
    // if (_currentUser != null && !(_currentUser!.isGuest)) {
    //   await _syncUserToFirestore(_currentUser!);
    // }
    notifyListeners();
    return "registered";
  }

  Future<bool> login(
    BuildContext c, {
    required String username,
    required String password,
  }) async {
    final user = await isarService.getByUsername(username);
    // User? firestoreUser;
    if (user == null) {
      //   firestoreUser = await _fetchLatestUserFromFirestore(username);
      //   if (firestoreUser == null) return false;

      //   final hash = hashPassword(password, firestoreUser.salt);
      //   if (hash != firestoreUser.passwordHash) return false;
      //   _currentUser = firestoreUser;
      return false;
    } else {
      final hash = hashPassword(password, user.salt);
      if (hash != user.passwordHash) return false;
      _currentUser = user;
    }

    isFetchedUser = true;
    _currentUser!.lastLogin = DateTime.now();

    // if (!_currentUser!.isGuest) await _fetchAndSyncUser(_currentUser!);

    if (c.mounted) {
      c.read<LanguageProvider>().setLang(_currentUser!.language);
      c.read<ThemeProvider>().setTheme(_currentUser!.theme);
    }

    notifyListeners();
    return true;
  }

  Future<void> logout(BuildContext c) async {
    if (_currentUser!.isGuest) {
      await resetGuest(c, isLogout: true);
    }
    _currentUser = null;
    isFetchedUser = false;
    notifyListeners();
    if (c.mounted) c.read<LogProvider>().reset();
  }

  Future<bool> loginAsGuest(BuildContext c) async {
    final newUser = User()
      ..uid = const Uuid().v4()
      ..username = "guest${DateTime.now().millisecondsSinceEpoch}"
      ..passwordHash = "default_pw"
      ..salt = "default_salt"
      ..isGuest = true
      ..fullName = "guest"
      ..avatarUrl = "default_url"
      ..createdAt = DateTime.now()
      ..lastLogin = DateTime.now();
    await isarService.saveUser(newUser);
    _currentUser = newUser;
    isFetchedUser = true;
    notifyListeners();
    if (!c.mounted) return false;
    c.read<LanguageProvider>().setLang(_currentUser!.language);
    c.read<ThemeProvider>().setTheme(_currentUser!.theme);
    return true;
  }

  /// CLOUD FIRESTORE SYNC

  Future<void> _fetchAndSyncUser(User user) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      final doc = await docRef.get();

      if (doc.exists) {
        final cloudData = doc.data()!;
        final cloudUpdatedAt = DateTime.parse(cloudData['updatedAt']);

        if (user.updatedAt.isAfter(cloudUpdatedAt)) {
          await isarService.updateUser(user);
          await _syncUserToFirestore(user);
        } else if (cloudUpdatedAt.isAfter(user.updatedAt)) {
          await _checkAndSyncUserFromFirestore(user);
        }
      } else {
        await isarService.updateUser(user);
        await _syncUserToFirestore(user);
      }
    } catch (e) {
      print("Error during user sync: $e");
    }
  }

  Future<User?> _fetchLatestUserFromFirestore(String username) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get(); // lấy tất cả phiên bản cùng username

      if (querySnapshot.docs.isEmpty) return null;

      // Chọn doc có updatedAt mới nhất
      querySnapshot.docs.sort((a, b) {
        final aUpdated = a.data()['updatedAt'] != null
            ? DateTime.parse(a.data()['updatedAt'])
            : DateTime.fromMillisecondsSinceEpoch(0);
        final bUpdated = b.data()['updatedAt'] != null
            ? DateTime.parse(b.data()['updatedAt'])
            : DateTime.fromMillisecondsSinceEpoch(0);
        return bUpdated.compareTo(aUpdated); // giảm dần
      });

      final doc = querySnapshot.docs.first;
      final data = doc.data();

      return User()
        ..uid = doc.id
        ..username = data['username'] ?? ''
        ..passwordHash = data['passwordHash'] ?? ''
        ..salt = data['salt'] ?? ''
        ..fullName = data['fullName']
        ..email = data['email']
        ..avatarUrl = data['avatarUrl'] ?? ''
        ..createdAt = DateTime.parse(data['createdAt'])
        ..lastLogin = data['lastLogin'] != null
            ? DateTime.parse(data['lastLogin'])
            : null
        ..language = LanguageAvailable.values.firstWhere(
          (e) => e.name == data['language'],
          orElse: () => LanguageAvailable.en,
        )
        ..theme = ThemeStyle.values.firstWhere(
          (e) => e.name == data['theme'],
          orElse: () => ThemeStyle.light,
        )
        ..updatedAt = data['updatedAt'] != null
            ? DateTime.parse(data['updatedAt'])
            : DateTime.now();
    } catch (e) {
      debugPrint('Error fetching user from Firestore: $e');
      return null;
    }
  }

  Future<void> syncAllUsersToFirestore() async {
    final users = await isarService.getAll<User>();

    for (var user in users) {
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
        'updatedAt': user.updatedAt.toIso8601String(),
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
      'updatedAt': user.updatedAt.toIso8601String(),
    }, SetOptions(merge: true)); // merge để không overwrite dữ liệu cũ
  }

  Future<void> _checkAndSyncUserFromFirestore(User localUser) async {
    if (localUser.uid.isEmpty) return; // chưa có Firestore docId → không sync

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(localUser.uid);
    final doc = await docRef.get();

    if (!doc.exists) return; // user chưa có trên Firestore

    final data = doc.data()!;
    bool updated = false;

    // Kiểm tra từng field, nếu khác thì cập nhật
    final userToUpdate = localUser;

    if ((data['fullName'] ?? '') != (localUser.fullName ?? '')) {
      userToUpdate.fullName = data['fullName'];
      updated = true;
    }
    if ((data['email'] ?? '') != (localUser.email ?? '')) {
      userToUpdate.email = data['email'];
      updated = true;
    }
    if ((data['avatarUrl'] ?? '') != localUser.avatarUrl) {
      userToUpdate.avatarUrl = data['avatarUrl'];
      updated = true;
    }
    if (data['lastLogin'] != null) {
      final firestoreLastLogin = DateTime.parse(data['lastLogin']);
      if (localUser.lastLogin == null ||
          firestoreLastLogin.isAfter(localUser.lastLogin!)) {
        userToUpdate.lastLogin = firestoreLastLogin;
        updated = true;
      }
    }
    if (data['language'] != null &&
        data['language'] != localUser.language.name) {
      userToUpdate.language = LanguageAvailable.values.firstWhere(
        (e) => e.name == data['language'],
      );
      updated = true;
    }
    if (data['theme'] != null && data['theme'] != localUser.theme.name) {
      userToUpdate.theme = ThemeStyle.values.firstWhere(
        (e) => e.name == data['theme'],
      );
      updated = true;
    }

    if (updated) {
      await isarService.updateUser(userToUpdate);
    }
  }

  /// RESET USER INFO INTO DEFAULT

  Future<void> resetGuest(
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
    if (isChange && c.mounted) {
      c.read<LanguageProvider>().resetLang();
      c.read<ThemeProvider>().resetTheme();
      c.read<LogProvider>().deleteAllLog(userUid: _currentUser!.uid);
    }
    if (isLogout) {
      await isarService.deleteById<User>(_currentUser!.id);
    }
  }

  void resetSetting(BuildContext c) {
    _currentUser!.language = LanguageAvailable.en;
    _currentUser!.theme = ThemeStyle.light;
    notifyListeners();
    c.read<LanguageProvider>().resetLang();
    c.read<ThemeProvider>().resetTheme();
  }

  void deleteAllUsers() async {
    await isarService.clearCollection<User>();
    _currentUser = null;
    isFetchedUser = false;
    notifyListeners();
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
