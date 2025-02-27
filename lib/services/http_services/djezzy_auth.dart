import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:http/http.dart' as http;
import 'package:djibly/services/toast_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class DjezzyAuth {
  static final bool isProd = true;
  final AUTHORIZATION_CODE =
      'Basic OXJrQ1FiM1B4TTlEd2ZxM3RMbnJVdUY0Ym1vYTpnYUpEMnRYbW5ITVJhR3ZmVFdrOWVmSHp2dTBh';

  // static String BASE_URL = "http://10.16.190.15:8000/api/v1/";
/*   static String BASE_URL = "https://apim.djezzy.dz/uat/";
  final SEND_OTP_URL = DjezzyAuth.BASE_URL + 'oauth2/registration';
  final VERIFY_OTP_URL = DjezzyAuth.BASE_URL + 'oauth2/token';
  final LOGOUT_URL = DjezzyAuth.BASE_URL + 'oauth2/logout'; */
  static String BASE_URL =
      isProd ? "https://apim.djezzy.dz/" : "https://apim.djezzy.dz/uat/";
  static String SEND_OTP_URL =
      DjezzyAuth.BASE_URL + 'djezzy-api/external/djibli/oauth2/registration';
  static String VERIFY_OTP_URL =
      DjezzyAuth.BASE_URL + 'djezzy-api/external/djibli/oauth2/token';
  final LOGOUT_URL =
      DjezzyAuth.BASE_URL + 'djezzy-api/external/djibli/oauth2/logout';
/* 
  final CLIENT_ID = "9rkCQb3PxM9Dwfq3tLnrUuF4bmoa";
  final CLIENT_SECRET = "gaJD2tXmnHMRaGvfTWk9efHzvu0a5"; */
  static String CLIENT_ID =
      isProd ? "8Bq5hbbsNKJILc5daZ0j0g4MYIEa" : "9rkCQb3PxM9Dwfq3tLnrUuF4bmoa";
  final String CLIENT_SECRET =
      isProd ? "C4Yseq0BrfThn7_76o0qsh4HzDca" : "gaJD2tXmnHMRaGvfTWk9efHzvu0a";

  // final CLIENT_ID = "WOlEQEQyIrWsGBc8qL3G35xvjMga";
  // final CLIENT_SECRET = "wqVzGeM1zL3rjBDvJlhYVlfbL0oa";

  Future<bool> sendOTP(String msisdn) async {
    try {
      Map<String, dynamic> data = {
        'msisdn': msisdn,
        'client_id': CLIENT_ID,
        'scope': 'smsotp'
      };

      var response = await http.post(Uri.parse(SEND_OTP_URL),
          body: data, headers: _setHeaders());
      print(response.body);
      final result = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        return true;
      } else {
        ToastService.showErrorToast(
          MyApp.navigatorKey.currentContext.translate.otp_access_data_not_found,
        );
        return false;
      }
    } catch (e) {
      ToastService.showErrorToast(MyApp
          .navigatorKey.currentContext.translate.something_went_wrong_body);
      return false;
    }
  }

  Future<bool> verifyOTP(String phone, String otp) async {
    try {
      Map<String, dynamic> data = {
        'grant_type': 'mobile',
        'mobileNumber': phone,
        'otp': otp,
        'scope': 'openid',
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
      };

      var response = await http.post(Uri.parse(VERIFY_OTP_URL),
          body: data, headers: _setHeaders());
      final result = json.decode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        storeUserTokens(result['access_token'], result['refresh_token']);
        return true;
      } else {
        ToastService.showErrorToast(result['error_description']);
        return false;
      }
    } catch (e) {
      ToastService.showErrorToast(
          MyApp.navigatorKey.currentContext.translate.connection_problem_body);
      return false;
    }
  }

  storeUserTokens(String access_token, String refresh_token) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('access_token', access_token);
    await storage.setString('refresh_token', refresh_token);
  }

  getPhoneNumber() {
    return SharedPreferences.getInstance().then((storage) {
      return storage.getString('phone');
    });
  }

  _setHeaders() => {
        'Accept': 'application/json',
        'Content-type': 'application/x-www-form-urlencoded'
      };

  _setHeadersWithToken() {
    return {
      'Accept': 'application/json',
      'Content-type': 'application/x-www-form-urlencoded',
      'Authorization':
          'Basic OXJrQ1FiM1B4TTlEd2ZxM3RMbnJVdUY0Ym1vYTpnYUpEMnRYbW5ITVJhR3ZmVFdrOWVmSHp2dTBh'
    };
  }

  Future<bool> refreshToken() async {
    Map<String, String> headers = await _setHeaders();
    final storage = await SharedPreferences.getInstance();
    final token = storage.getString('access_token');
    final refreshToken = storage.getString('refresh_token');

    headers.addAll({'Authorization': 'Bearer $token'});

    Map<String, dynamic> data = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
      'scope': 'openid',
      'client_secret': CLIENT_SECRET,
      'client_id': CLIENT_ID
    };

    try {
      var response = await http.post(
        Uri.parse(VERIFY_OTP_URL),
        body: data,
        headers: headers,
      );
      final result = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        storeUserTokens(result['access_token'], result['refresh_token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
