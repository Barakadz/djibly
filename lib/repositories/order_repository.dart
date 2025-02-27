import 'dart:convert';

import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:http/http.dart' as http;

class OrderRepository {
  static Future<http.Response> makeOrder(data) async {
    final response = await Network.postWithToken('/orders/create', data);
    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> getOrders(status) async {
    final response = await Network.getWithToken('/orders/$status');
    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> cancelOrder(id) async {
    final response = await Network.postWithToken('/orders/cancel/$id', {});
    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }
}
