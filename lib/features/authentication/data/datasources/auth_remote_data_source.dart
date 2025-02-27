import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../main.dart';
import '../../../../services/http_services/api_http.dart';
import '../../../../services/http_services/djezzy_auth.dart';
import '../../../../services/toast_service.dart';

abstract class AuthDataSource {
  Future<void> sendOtp(String phoneNumber);
  Future<void> verifyOtp(String phoneNumber, String otp);
  Future<void> createUser(String name, String phoneNumber);
  Future<Response> login(String phone);
  Future<bool> logout();
  Future<Response> register(Map<String, dynamic> body);
}

class AuthRemoteDataSourceImpl implements AuthDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  Future<bool> sendOtp(String phoneNumber) async {
    try {
      Map<String, dynamic> data = {
        'msisdn': phoneNumber,
        'client_id': DjezzyAuth.CLIENT_ID,
        'scope': 'smsotp'
      };

      var response = await http
          .post(Uri.parse(DjezzyAuth.SEND_OTP_URL), body: data, headers: {
        'Accept': 'application/json',
        'Content-type': 'application/x-www-form-urlencoded'
      });
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

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    await dio
        .post('/verify-otp', data: {'phone_number': phoneNumber, 'otp': otp});
  }

  Future<void> createUser(String name, String phoneNumber) async {
    await dio.post('/create-user',
        data: {'name': name, 'phone_number': phoneNumber});
  }

  Future<Response> login(String phone) async {
    final url = "${Network.host}/$phone/login";
    try {
      final response = await dio.post(
        url,
        data: {'phone': phone},
        options: Options(headers: await Network.headersWithToken()),
      );

      if (response.statusCode == 200 || response.statusCode == 404) {
        return response;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> register(Map<String, dynamic> body) async {
    final url = "${Network.host}${await Network.getMsisdn()}/register";
    try {
      final response = await dio.post(
        url,
        data: body,
        options: Options(headers: await Network.headersWithToken()),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logout() async {
    var fullUrl = DjezzyAuth().LOGOUT_URL;
    final storage = await SharedPreferences.getInstance();
    final token = storage.getString('access_token');

    Map<String, dynamic> data = {
      "token": "$token",
      "token_type_hint": "access_token",
      "client_id": DjezzyAuth.CLIENT_ID,
      "client_secret": DjezzyAuth().CLIENT_SECRET,
    };

    try {
      final response = await dio.post(
        fullUrl,
        data: data,
        options: Options(
          headers: {'Content-type': 'application/x-www-form-urlencoded'},
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
