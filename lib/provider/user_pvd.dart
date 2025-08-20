import 'package:flutter/material.dart';

class UserTemp {
  int userId;
  String username;
  String password;
  String? fullName;
  String? email;
  String avatarUrl;
  String language;
  String theme;

  UserTemp({
    required this.userId,
    required this.username,
    required this.password,
    this.fullName,
    this.email,
    this.avatarUrl = "",
    this.language = "en",
    this.theme = "light",
  });
}

class UserProvider extends ChangeNotifier {
  UserTemp _user = UserTemp(
    userId: 0,
    username: "guest",
    password: "default_pw",
  );
  UserTemp get user => _user;

  void resetGuest() {
    _user.username = "guest";
    _user.password = "default_pw";
    _user.fullName = _user.username;
    _user.email = "${_user.username}@emolog.com";
    _user.avatarUrl = "default_url";
    _user.language = "en";
    _user.theme = "light";
    notifyListeners();
  }

  void resetSetting() {
    _user.language = "en";
    _user.theme = "light";
    notifyListeners();
  }

  void updateUser({
    String? newUsername,
    String? newPass,
    String? newFullname,
    String? newEmail,
    String? newURL,
    String? newLanguage,
    String? newTheme,
  }) {
    if (newUsername != null) {
      _user.username = newUsername;
    }
    if (newPass != null) {
      _user.password = newPass;
    }
    if (newFullname != null) {
      _user.fullName = newFullname;
    }
    if (newEmail != null) {
      _user.email = newEmail;
    }
    if (newURL != null) {
      _user.avatarUrl = newURL;
    }
    if (newLanguage != null) {
      _user.language = newLanguage;
    }
    if (newTheme != null) {
      _user.theme = newTheme;
    }
    notifyListeners();
  }

  void updateUsername(String newUsername) {
    _user.username = newUsername;
    notifyListeners();
  }

  void updatePassword(String newPass) {
    _user.password = newPass;
    notifyListeners();
  }

  void updateFullname(String newFullname) {
    _user.fullName = newFullname;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _user.email = newEmail;
    notifyListeners();
  }

  void updateAvatar(String newURL) {
    _user.avatarUrl = newURL;
    notifyListeners();
  }

  void updateLanguage(String newLanguage) {
    _user.language = newLanguage;
    notifyListeners();
  }

  void updateTheme(String newTheme) {
    _user.theme = newTheme;
    notifyListeners();
  }
}
