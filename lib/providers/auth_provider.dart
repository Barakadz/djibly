import 'dart:convert';

import 'package:djibly/main.dart';
import 'package:djibly/models/user.dart';
import 'package:djibly/pages/auth/auth_page.dart';
import 'package:djibly/repositories/auth_repository.dart';
import 'package:djibly/repositories/user_repository.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Unverified,
  Unauthenticated,
  Unregistered
}

class AuthProvider with ChangeNotifier {
  bool _loader = false;
  Status _status = Status.Uninitialized;
  String _token;
  User user;

  bool isRefreshing = false;

  String registerPhone;

  Status get status => _status;

  String get token => _token;

  static String version = 'api/v1';
  static String host = Network.host;

  Future<int> initAuthProvider() async {
    printInfo(info: "######### initAuthProvider");
    await Future.delayed(Duration(seconds: 1));

    if (isRefreshing) return 0;
    String user = await getUser();

    if (user != null) {
      isRefreshing = true;
      await Network.setStoragePath();
      await Network.headersWithToken();
      print(" 🟢🟢 ############  initAuthProvider --->>> call profile api");

      final response = await Network.getWithToken('/profile');
      print(
          " 🟢🟢 ############  initAuthProvider END CALL profile api --->>> response ${response}");

      if (response != null) {
        if (response.statusCode == 200) {
          printInfo(
              info: "######### initAuthProvider => response.statusCode == 200");
          _status = Status.Authenticated;
          notifyListeners();
          return 0;
        } else if (response.statusCode == 401) {
          _status = Status.Unauthenticated;
          notifyListeners();
          return 0;
        } else {
          return response.statusCode;
        }
      } else {
        return 408;
      }
    } else {
      _status = Status.Unauthenticated;
      notifyListeners();
      return 0;
    }
  }

  void redirectToVerifyPage() {
    _status = Status.Unverified;
    notifyListeners();
  }

  void redirectToHomePage() {
    _status = Status.Authenticated;
    notifyListeners();
  }

  void redirectToRegisterPage(String phone) {
    _status = Status.Unregistered;
    registerPhone = phone;
    notifyListeners();
  }

  Future<bool> login(String phone) async {
    setLoader(true);
    final response = await AuthRepository.login(phone);
    setLoader(false);
    if (response != null) {
      if (response.statusCode == 200) {
        await storeUserData(response.body);
        await Network.setStoragePath();
        return true;
      } else if (response.statusCode == 404) {
        return false;
      }
    }
    return null;
  }

  Future<bool> register(String firstName, String lastName, String email,
      String phone, context) async {
    var body = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone
    };
    setLoader(true);
    final response = await AuthRepository.register(body, context);
    if (response != null && response.statusCode == 200) {
      await storeUserData(response.body);
      setLoader(false);
      await Network.setStoragePath();
      return true;
    } else {
      setLoader(false);
      return false;
    }
  }

  logout() async {
    await AuthRepository.logout();
    redirectToLogin();
  }

  redirectToLogin() {
    _status = Status.Unauthenticated;
    SharedPreferences.getInstance().then((storage) {
      storage.clear();
    });
    notifyListeners();

    Navigator.of(MyApp.navigatorKey.currentContext).pushNamedAndRemoveUntil(
      '/', // Replace with the name of your login route
      (route) => false,
    );
  }

  redirectTo(String redirect) {
    switch (redirect) {
      case 'Authenticated':
        {
          _status = Status.Authenticated;
          notifyListeners();
        }
        break;
      case 'Uninitialized':
        {
          _status = Status.Uninitialized;
          notifyListeners();
        }
        break;
      default:
        {
          _status = Status.Unauthenticated;
          notifyListeners();
        }
        break;
    }
  }

  storeUserData(String data) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap =
        json.decode(utf8.decode(data.codeUnits))['data']['user'];
    user = User.fromJson(userMap);
    await storage.setString('first_name', user.firstName);
    await storage.setString('last_name', user.lastName);
    await storage.setString('email', user.email);
    await storage.setString('profile_picture', user.profilePicture);
    await storage.setString(
        'msisdn', json.decode(data)['data']['user']['phone']);
  }

  Future<String> getUser() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String user = storage.getString('email');
    return user;
  }

  void setLoader(bool value) {
    _loader = value;
    notifyListeners();
  }

  bool getLoader() {
    return _loader;
  }
}
