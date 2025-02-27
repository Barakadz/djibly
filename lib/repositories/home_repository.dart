import 'dart:convert';

import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  static Future<http.Response> getNearbyPos() async {
    final response = await Network.getWithToken('/pos/nearby');
    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> getProductsIndex() async {
    final response = await Network.getWithToken('/products/index');
    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }
}
