import 'package:flutter/material.dart';
import '../enum/lang.dart';

class LanguageProvider extends ChangeNotifier {
  LanguageAvailable _lang = LanguageAvailable.en;

  LanguageAvailable get currentLang => _lang;
  Locale get locale => _lang.locale;

  void setLang(LanguageAvailable newLang) {
    _lang = newLang;
    notifyListeners();
  }
}
