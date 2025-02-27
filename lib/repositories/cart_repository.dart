import 'dart:convert';

import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:http/http.dart' as http;

class CartRepository {

  static Future<http.Response> getCartItems() async {
    final response = await Network.getWithToken('/cart/items');
    if(response == null)
      return null;

    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> addProductToCart(data) async {
    final response = await Network.postWithToken('/cart/items/add/${data['available_color_id']}', {"quantity": data['quantity']});
    if(response == null)
      return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> deleteSelectedItems(data) async {
    final response = await Network.postWithToken('/cart/items/delete',data);
    if(response == null)
      return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> getOrderedItems(data) async {
    final response = await Network.postWithToken('/cart/ordered/items', data);
    if(response == null)
      return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }
}
