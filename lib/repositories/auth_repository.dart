import 'dart:convert';

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/http_services/djezzy_auth.dart';
import 'package:djibly/services/server_response.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class AuthRepository {
  static Future<http.Response> login(String phone) async {
    final url = "${Network.host}/" + phone + "/login";
    print(url);
    var data = {'phone': phone};
    try {
      final response = await http
          .post(Uri.parse(url),
              body: jsonEncode(data), headers: await Network.headersWithToken())
          .timeout(
        Duration(seconds: Network.timeoutDuration),
        onTimeout: () {
          ToastService.showErrorToast(MyApp
              .navigatorKey.currentContext.translate.connection_problem_body);
          return null;
        },
      );

      if (response != null) {
        if (response.statusCode == 200 || response.statusCode == 404) {
          return response;
        } else {
          ServerResponse.serverResponseHandler(response: response);
          return null;
        }
      } else {
        ToastService.showErrorToast(MyApp
            .navigatorKey.currentContext.translate.something_went_wrong_body);
        return null;
      }
    } catch (e) {
      print(e.toString());
      ToastService.showErrorToast(MyApp
          .navigatorKey.currentContext.translate.something_went_wrong_body);
      return null;
    }
  }

  static Future<http.Response> register(
      Map<String, dynamic> body, context) async {
    final url = "${Network.host}" + await Network.getMsisdn() + "/register";
    print(url);

    final response = await http
        .post(Uri.parse(url),
            body: jsonEncode(body), headers: await Network.headersWithToken())
        .timeout(
      Duration(seconds: Network.timeoutDuration),
      onTimeout: () {
        ToastService.showErrorToast(MyApp
            .navigatorKey.currentContext.translate.connection_problem_body);
        return null;
      },
    );

    if (response != null) {
      if (response.statusCode == 200) {
        return response;
      } else {
        ServerResponse.serverResponseHandler(response: response);
        return null;
      }
    } else {
      ToastService.showErrorToast(MyApp
          .navigatorKey.currentContext.translate.something_went_wrong_body);
      return null;
    }
  }

  static Future<bool> logout() async {
    var fullUrl = DjezzyAuth().LOGOUT_URL;
    final storage = await SharedPreferences.getInstance();
    final token = storage.getString('access_token');

    Map<String, dynamic> data = {
      "token": "$token",
      "token_type_hint": "access_token",
      "client_id": DjezzyAuth.CLIENT_ID,
      "client_secret": DjezzyAuth().CLIENT_SECRET,
    };

    final response = await http.post(Uri.parse(fullUrl),
        body: data,
        headers: {'Content-type': 'application/x-www-form-urlencoded'}).timeout(
      Duration(seconds: Network.timeoutDuration),
      onTimeout: () {
        ToastService.showErrorToast(MyApp
            .navigatorKey.currentContext.translate.connection_problem_body);
        return null;
      },
    );
    if (response != null) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
