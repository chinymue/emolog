import 'package:flutter/material.dart';

enum ThemeStyle { light, dark }

extension ThemeStyleMapper on ThemeStyle {
  ThemeMode get toFlutterTheme {
    switch (this) {
      case ThemeStyle.light:
        return ThemeMode.light;
      case ThemeStyle.dark:
        return ThemeMode.dark;
    }
  }
}

extension ThemeModeMapper on ThemeMode {
  ThemeStyle get toThemeStyle {
    switch (this) {
      case ThemeMode.light:
        return ThemeStyle.light;
      case ThemeMode.dark:
        return ThemeStyle.dark;
      case ThemeMode.system:
        return ThemeStyle.light;
    }
  }
}
