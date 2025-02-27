import 'dart:convert';

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../services/toast_service.dart';

class UserRepository {
  static Future<http.Response> getUser() async {
    print(" 🟢🟢 ############  user info request --->>> call profile api");
    final response = await Network.getWithToken('/profile');
    if (response == null) return null;
    if (response.statusCode == 200) {
      print(
          " 🟢🟢 ############  user info request END CALL profile api --->>> response ${response}");
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> updateProfile(Map<String, dynamic> data) async {
    final response = await Network.postWithToken('/profile/update', data);
    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.StreamedResponse> updateProfilePicture(
      String name, String path) async {
    final response =
        await Network.uploadFile('/profile/picture/update', name, path);
    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverStreamedResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> refreshUserNotification(data) async {
    final response = await Network.postWithToken("/notification/token", data);
    if (response != null) {
      return response;
    } else {
      ToastService.showErrorToast(MyApp.navigatorKey.currentContext.translate
          .something_went_wrong_please_try_again_later);
      return null;
    }
  }
}
