import 'package:djibly/models/color.dart';

class AvailableColor {
  int id;
  int quantity;
  AssetColor color;



  AvailableColor({this.id, this.quantity, this.color});

  factory AvailableColor.fromJson(Map<String, dynamic> json) {
    return AvailableColor(
        id: json['id'],
        color: AssetColor.fromJson(json['color']),
        quantity: int.parse(json['quantity'].toString()));
  }
}
