import 'package:flutter/material.dart';
import '../enum/lang.dart';

class LanguageProvider extends ChangeNotifier {
  LanguageAvailable currentLang;

  LanguageProvider(this.currentLang);

  Locale get locale => currentLang.locale;

  void setLang(LanguageAvailable newLang) {
    currentLang = newLang;
    notifyListeners();
  }
}
