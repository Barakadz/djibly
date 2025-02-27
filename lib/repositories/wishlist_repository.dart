import 'dart:convert';

import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:http/http.dart' as http;

class WishlistRepository {
  static Future<http.Response> getWishlist(int page) async {
    final response = await Network.getWithToken('/wishlist/index?page=${page}');
    if(response == null)
      return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> addToWishlist(id) async {
    final response = await Network.postWithToken('/wishlist/add/$id',{});
    if(response == null)
      return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }
  static Future<http.Response> removeFromWishlist(id) async {
    final response = await Network.postWithToken('/wishlist/remove/$id',{});
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
