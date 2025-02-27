// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  AuthLocalDataSource({
    this.sharedPreferences,
  });

  Future<void> cacheUser(dynamic user) async {
    await sharedPreferences.setString('user', jsonEncode(user));
  }

  dynamic getUser() {
    final user = sharedPreferences.getString('user');
    return user != null ? jsonDecode(user) : null;
  }
}
