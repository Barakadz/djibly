import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:http/http.dart' as http;

class PosProductRepository {
  static Future<http.Response> search(String q, int page) async {
    final response =
        await Network.getWithToken('/products/search?q=$q&page=$page');
    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> getPosProducts(
      pos, int category, int page) async {
    String fullUrl = '';
    if (category != null) {
      fullUrl = '/pos/products/$pos?category=$category&page=$page';
    } else {
      fullUrl = '/pos/products/$pos?page=$page';
    }
    final response = await Network.getWithToken(fullUrl);
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
