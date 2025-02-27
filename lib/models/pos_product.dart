import 'dart:convert';

import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';

class PosProduct {
  String id;
  String name;
  String picture;
  String released;
  String category;
  int categoryId;
  String brand;
  String pos;
  String posId;
  int brandId;
  bool status;
  double price;
  double deliveryPrice;
  int quantity;
  int productId;
  List<Map<String, dynamic>> specifications = [];
  List<dynamic> availableColors;
  bool inWishlist;
  double avgReviews;

  PosProduct(
      {this.id,
      this.name,
      this.picture,
      this.price,
      this.deliveryPrice,
      this.quantity,
      this.brand,
      this.pos,
      this.posId,
      this.status,
      this.brandId,
      this.category,
      this.categoryId,
      this.productId,
      this.specifications,
      this.availableColors,
      this.inWishlist,
      this.avgReviews,
      this.released});

  factory PosProduct.fromJson(Map<String, dynamic> json) {
    return PosProduct(
      id: json['id'].toString(),
      name: json['name'],
      picture: json['picture'],
      released: json['released'],
      brand: json['brand'],
      pos: json['pos'],
      posId: json['pos_id'].toString(),
      status: int.parse(json['is_active'].toString()) == 0 ? false : true,
      brandId: int.parse(json['brand_id'].toString()),
      categoryId: int.parse(json['category_id'].toString()),
      category: json['category'],
      price: double.parse(json['price'].toString()),
      deliveryPrice: double.parse(json['delivery_price'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      productId: int.parse(json['product_id'].toString()),
      specifications: json['specifications'],
      availableColors: json['available_colors'],
      inWishlist: json['in_wishlist'],
      avgReviews: double.parse(json['avg_reviews'].toString()),
    );
  }

  static Future<List<PosProduct>> getPosProductsFromUuid(
      String category, String uuid) async {
    List<PosProduct> products = [];
    Map<String, dynamic> mapPosProduct;
    Map<String, dynamic> mapSpecification;
    List<Map<String, dynamic>> specifications = [];
    await Network.getWithToken('/pos/products/$uuid?category=' + category)
        .then((response) {
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        if (result['status'] == 'success') {
          try {
            result['data']['products'].forEach((product) {
              mapPosProduct = product;
              product['specifications'].forEach((item) {
                try {
                  mapSpecification = item;
                  specifications.add(mapSpecification);
                } catch (exception) {
                  print("Spec :" + exception.toString());
                }
              });
              mapPosProduct.addAll({'specifications': specifications});
              products.add(PosProduct.fromJson(mapPosProduct));
            });
          } catch (exception) {
            print(exception.toString());
          }
        } else {
          return null;
        }
      } else {
        ServerResponse.serverResponseHandler(response: response);
        throw Future.error('');
      }
    });
    return products;
  }

  static List<PosProduct> generateProductsList(items) {
    List<PosProduct> products = [];
    Map<String, dynamic> mapPosProduct;
    Map<String, dynamic> mapSpecification;
    List<Map<String, dynamic>> specifications = [];
    items.forEach((product) {
      mapPosProduct = product;
      product['specifications'].forEach((item) {
        try {
          mapSpecification = item;
          specifications.add(mapSpecification);
        } catch (exception) {}
      });
      mapPosProduct.addAll({'specifications': specifications});
      products.add(PosProduct.fromJson(mapPosProduct));
      specifications = [];
    });

    return products;
  }
}
