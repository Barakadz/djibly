import 'package:djibly/models/color.dart';
import 'package:djibly/models/review.dart';
import 'package:djibly/providers/auth_provider.dart';

AuthProvider authProvider;

class OrderItem {
  int id;
  String productName;
  String productPicture;
  int productQuantity;
  double productPrice;
  double totalPrice;
  bool isAvailable;
  AssetColor color;
  Review review;

  OrderItem(
      {this.id,
      this.productName,
      this.productPicture,
      this.productQuantity,
      this.productPrice,
      this.totalPrice,
      this.color,
      this.isAvailable,
      this.review});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: int.parse(json['id'].toString()),
      productName: json['product_name']['fr'],
      productPicture: json['product_picture'],
      productQuantity: int.parse(json['product_quantity'].toString()),
      productPrice: double.parse(json['product_price'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      isAvailable:
          int.parse(json['is_available'].toString()) == 0 ? false : true,
      color: AssetColor.fromJson(json['color']),
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
    );
  }
}
