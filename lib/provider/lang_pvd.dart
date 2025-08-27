import 'package:flutter/material.dart';
import '../enum/lang.dart';

class LanguageProvider extends ChangeNotifier {
  LanguageAvailable _currentLang = LanguageAvailable.en;

  Locale get locale => _currentLang.locale;

  void setLang(LanguageAvailable newLang) {
    _currentLang = newLang;
    notifyListeners();
  }

  void resetLang() {
    _currentLang = LanguageAvailable.vi;
    notifyListeners();
  }
}
