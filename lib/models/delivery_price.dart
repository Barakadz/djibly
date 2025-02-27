import 'package:djibly/models/cart_item.dart';

class DeliveryPrice {
  String company;
  String price;
  String companyId;
  String type;

  DeliveryPrice({this.company, this.price, this.companyId, this.type});

  factory DeliveryPrice.fromJson(Map<String, dynamic> json) {
    return DeliveryPrice(
      company: json['company'],
      price: json['price'],
      companyId: json['company_id'].toString(),
      type: json['type'],
    );
  }
}
