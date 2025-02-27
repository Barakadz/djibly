import 'dart:convert';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/services/device_info_service.dart';
import 'package:djibly/services/http_interceptors/token_interceptor.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../main.dart';
import 'djezzy_auth.dart';

class Network {
  static Dio dio = Dio();

  String token;
  static String version = 'v1';
  static String storagePath = '';
  static int timeoutDuration = 15;

  static Map<String, String> headersWithBearer = {};

  // static String host = 'http://10.16.190.15:8000/api/$version/user';
  static String host =
      DjezzyAuth.BASE_URL + 'djezzy-api/external/djibli/$version';

  static setStoragePath() async {
    storagePath = "${host + await getMsisdn()}/storage/images?image=";
  }

  static Future<Map<String, String>> headersWithToken() {
    return SharedPreferences.getInstance().then((storage) {
      final token = storage.getString('access_token');
      headersWithBearer = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'CSRF-TOKEN': ''
      };
      return headersWithBearer;
    });
  }

  static Future<Options> dioOptionsWithToken() async {
    final storage = await SharedPreferences.getInstance();
    final token = storage.getString('access_token');

    final options = Options(
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      sendTimeout: Duration(seconds: timeoutDuration),
    );

    return options;
  }

  static Options dioOptions() {
    return Options(
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      sendTimeout: Duration(seconds: timeoutDuration),
      receiveTimeout: Duration(seconds: timeoutDuration),
    );
  }

  static Map<String, String> headers() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};

  static Future<String> getMsisdn() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String msisdn = "/${storage.getString('msisdn')}";
    return msisdn;
  }

  static Future<http.Response> postWithToken(apiUrl, data) async {
    dio.interceptors.clear();
    dio.interceptors.add(TokenInterceptor());
    String msisdn = await getMsisdn();
    var fullUrl = host + msisdn + apiUrl;
    try {
      final dioResponse = await dio.post(fullUrl,
          data: data, options: await dioOptionsWithToken());
      return dioResponseToHttpResponse(dioResponse);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.connectionError) {
        return http.Response('Connect Timeout', 408);
      } else {
        final errorResponse =
            e.response != null ? jsonEncode(e.response.data) : '';
        return http.Response('${errorResponse}', e.response.statusCode);
      }
    } catch (e) {
      return http.Response('something went wrong, Please try later', 500);
    }
  }

  static Future<http.Response> post(apiUrl, data) async {
    String msisdn = await getMsisdn();
    var fullUrl = host + msisdn + apiUrl;

    try {
      final dioResponse =
          await dio.post(fullUrl, data: data, options: dioOptions());
      return dioResponseToHttpResponse(dioResponse);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.connectionError) {
        return http.Response('Connect Timeout', 408);
      } else {
        final errorResponse =
            e.response != null ? jsonEncode(e.response.data) : '';
        return http.Response('${errorResponse}', e.response.statusCode);
      }
    } catch (e) {
      return http.Response('something went wrong, Please try later', 500);
    }
  }

  static Future<http.Response> getWithToken(apiUrl) async {
    dio.interceptors.clear();
    dio.interceptors.add(TokenInterceptor());
    final msisdn = await getMsisdn();
    final fullUrl = host + msisdn + apiUrl;
    try {
      final dioResponse =
          await dio.get(fullUrl, options: await dioOptionsWithToken());
      return dioResponseToHttpResponse(dioResponse);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.connectionError) {
        return http.Response('Connect Timeout', 408);
      } else {
        final errorResponse =
            e.response != null ? jsonEncode(e.response.data) : '';
        return http.Response('${errorResponse}', e.response.statusCode);
      }
    } catch (e) {
      return http.Response('something went wrong, Please try later', 502);
    }
  }

  static Future<http.Response> get(apiUrl) async {
    String msisdn = await getMsisdn();
    var fullUrl = host + msisdn + apiUrl;

    try {
      final dioResponse = await dio.get(fullUrl, options: dioOptions());
      return dioResponseToHttpResponse(dioResponse);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.connectionError) {
        return http.Response('Connect Timeout', 408);
      } else {
        final errorResponse =
            e.response != null ? jsonEncode(e.response.data) : '';
        return http.Response('${errorResponse}', e.response.statusCode);
      }
    } catch (e) {
      return http.Response('something went wrong, Please try later', 500);
    }
  }

  static Future<http.StreamedResponse> uploadFile(
      apiUrl, apiData, filePath) async {
    String msisdn = await getMsisdn();
    String token = '';
    await SharedPreferences.getInstance().then((storage) {
      token = storage.getString('access_token');
    });

    Map<String, String> headers = {
      'Content-type': 'application/octet-stream',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'User-Agent': await DeviceInfo.userAgent(),
      'CSRF-TOKEN': await DeviceInfo.getFingerprint()
    };

    var fullUrl = host + msisdn + apiUrl;
    var request = http.MultipartRequest('POST', Uri.parse(fullUrl))
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath(apiData, filePath));
    final response = await request.send().timeout(
      Duration(seconds: Network.timeoutDuration),
      onTimeout: () {
        ToastService.showErrorToast(MyApp
            .navigatorKey.currentContext.translate.connection_problem_body);
        return null;
      },
    );
    return response;
  }

  static http.Response dioResponseToHttpResponse(Response dioResponse) {
    final int statusCode = dioResponse.statusCode ?? 500;
    final Map<String, String> headers = {};
    dioResponse.headers?.map?.forEach((key, value) {
      final headerValue = value.length > 0 ? value[0] : '';
      headers.addAll({key: headerValue});
    });
    try {
      final String body =
          dioResponse.data != null ? jsonEncode(dioResponse.data) : '';

      return http.Response.bytes(utf8.encode(body), statusCode,
          headers: headers);
    } catch (e) {
      print(e.toString());
      return http.Response("error Parsing", 500, headers: headers);
    }
  }
}
