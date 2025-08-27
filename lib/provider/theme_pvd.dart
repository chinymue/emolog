import 'package:flutter/material.dart';
import '../enum/theme_style.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeStyle _themeStyle = ThemeStyle.light;
  ThemeMode get themeMode => _themeStyle.toFlutterTheme;

  void setTheme(ThemeStyle themePref) {
    _themeStyle = themePref == ThemeStyle.light
        ? ThemeStyle.light
        : ThemeStyle.dark;
    notifyListeners();
  }

  void resetTheme() {
    _themeStyle = ThemeStyle.light;
    notifyListeners();
  }
}
