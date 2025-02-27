
import 'package:djibly/models/cart_item.dart';

class CartPos {
  int id;
  String name;
  List<CartItem> items;
  double deliveryPrice;
  String deliveryType;
  String deliveryCompany;
  String companyId;
  CartPos({this.name, this.id, this.items, this.deliveryPrice, this.deliveryType, this.deliveryCompany, this.companyId});

  factory CartPos.fromJson(Map<String, dynamic> json) {
    return CartPos(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        items: json['items'],
        deliveryPrice: double.parse(json['delivery_price'].toString()),
        deliveryType: json['delivery_type'],
    );
  }

  static List<int> getItemsIds(List<CartItem> items){
    List<int> ids = [];
    items.forEach((element) {
      ids.add(element.id);
    });
    return ids;
  }
}
