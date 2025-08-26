import 'package:flutter/material.dart';
import '../enum/theme_style.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeStyle _themeStyle;
  ThemeProvider(this._themeStyle);
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
