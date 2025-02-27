import 'dart:convert';

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/toast_service.dart';

import '../main.dart';

Network network;

class Product {
  int id;
  String model;
  String picture;
  int brandId;

  Product({this.id, this.model, this.picture, this.brandId});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        model: json['model'],
        picture: json['picture'],
        brandId: json['brand_id']
    );
  }

  static Future<List<Map<String, dynamic>>> getProducts(String category, String brand) async {
    try{
      var response = await Network.getWithToken("/products/$category/$brand");
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        List<Map<String, dynamic>> data = [];
        result['data'].forEach((product) {
          data.add({
            'model': product['model'],
            'picture': product['picture'],
            'id': product['id']
          });
        });
        return data;
      } else {
        return [];
      }
    }catch (e){
      ToastService.showErrorToast(MyApp
            .navigatorKey.currentContext.translate.connection_problem_body);
      return [];
    }

  }
}
