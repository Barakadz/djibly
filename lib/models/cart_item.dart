import 'package:djibly/models/color.dart';
import 'package:djibly/models/review.dart';

class CartItem {
  int id;
  int productId;
  String productName;
  String productBrand;
  double productPrice;
  double deliveryPrice;
  String productImage;
  String posName;
  int posId;
  int quantity;
  int availableQuantity;
  AssetColor color;

  CartItem(
      {this.id, this.productId, this.productName, this.productBrand, this.productPrice,this.deliveryPrice,
        this.productImage, this.posId, this.posName, this.quantity, this.availableQuantity, this.color});
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id : int.parse(json['id'].toString()),
      productId: int.parse(json['product_id'].toString()),
      productName: json['product_name']['fr'],
      productBrand: json['product_brand']['fr'],
      productPrice: double.parse(json['product_price'].toString()),
      deliveryPrice: double.parse(json['delivery_price'].toString()),
      productImage: json['product_image'],
      posId: int.parse(json['pos_id'].toString()),
      posName: json['pos_name'],
      quantity: int.parse(json['quantity'].toString()),
      availableQuantity: int.parse(json['available_quantity'].toString()),
      color: AssetColor.fromJson(json['color'])
    );
  }

  // 16-230719-000001
}