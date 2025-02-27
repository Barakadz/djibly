import 'dart:io';
import 'package:djibly/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../providers/auth_provider.dart';

class LocaleController extends GetxController {
  Rx<Locale> locale = Locale(Platform.localeName.substring(0, 2)).obs;
  @override
  Future<void> onInit() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    final locale = storage.getString('locale');
    if (locale != null && locale != "") {
      this.locale.value = Locale(locale);
    } else {
      storage.setString('locale', this.locale.value.languageCode.toLowerCase());
    }
    super.onInit();
  }

  deletePos() async {
    final data = {
      'notification_token': "delete",
    };
    //inbox delete

    print("1------------ delete pos");

    final response = await UserRepository.refreshUserNotification(data);

    if (response != null) {
      if (response.statusCode == 200) {
        Provider.of<AuthProvider>(MyApp.navigatorKey.currentContext,
                listen: false)
            .redirectToLogin();
        return 0;
      } else if (response.statusCode == 401) {
        Provider.of<AuthProvider>(MyApp.navigatorKey.currentContext,
                listen: false)
            .redirectToLogin();
        return 0;
      } else {
        return response.statusCode;
      }
    } else {
      return response.statusCode;
    }
  }
  /*  oninit() async {
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
  } */

  Future<void> setLocale(Locale locale) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('locale', locale.toString());
    this.locale.value = locale;
  }

  static Locale getDeviceLanguage() {
    Locale locale = Locale(Platform.localeName.substring(0, 2));

    return locale;
  }
}
