import 'package:flutter/material.dart';

enum LanguageAvailable { en, vi }

extension LanguageExt on LanguageAvailable {
  String get code {
    switch (this) {
      case LanguageAvailable.en:
        return 'en';
      case LanguageAvailable.vi:
        return 'vi';
    }
  }

  Locale get locale => Locale(code);

  String get label {
    switch (this) {
      case LanguageAvailable.en:
        return "English";
      case LanguageAvailable.vi:
        return "Tiếng Việt";
    }
  }
}
