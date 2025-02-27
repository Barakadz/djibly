import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalePresenter with ChangeNotifier {
  Locale _locale = Locale(Platform.localeName.substring(0, 2));

  Locale get locale => _locale;

  initLocalePresenter() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final locale = storage.getString('locale');
    if (locale != null && locale != "") {
      _locale = Locale(locale);
    } else {
      print("############  local is null");
      print(
          "############ _locale.languageCode ${_locale.languageCode.toLowerCase()}");

      storage.setString('locale', _locale.languageCode.toLowerCase());
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    _locale = locale;
    await storage.setString('locale', _locale.toString());
    notifyListeners();
  }

  static Locale getDeviceLanguage() {
    Locale locale = Locale(Platform.localeName.substring(0, 2));

    return locale;
  }
}
