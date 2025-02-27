import 'dart:io';

import 'package:djibly/presenters/local_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presenters/local_presenter.dart';

class AuthController extends GetxController {
  final BuildContext context;

  AuthController(this.context);
  @override
  void onInit() async {
    LocaleController controller = Get.find();
    Locale locale = Locale(Platform.localeName.substring(0, 2));
    controller.setLocale(locale);

    super.onInit();
  }
}
