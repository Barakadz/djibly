import 'dart:convert';

import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:http/http.dart' as http;

class ReviewRepository {

  static Future<http.Response> addReview(id, Map<String,dynamic> data) async {
    final response = await Network.postWithToken('/review/add/$id',data);
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
