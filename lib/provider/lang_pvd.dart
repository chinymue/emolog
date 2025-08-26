import 'package:flutter/material.dart';
import '../enum/lang.dart';

class LanguageProvider extends ChangeNotifier {
  late LanguageAvailable _currentLang;

  LanguageProvider(this._currentLang);

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
