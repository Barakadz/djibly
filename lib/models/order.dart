import 'dart:convert';
import 'package:djibly/main.dart';
import 'package:djibly/models/delivery_state.dart';
import 'package:djibly/models/order_item.dart';
import 'package:djibly/services/server_response.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//AuthProvider authProvider;

class Order with ChangeNotifier {

  static const STATUS_CANCELED_BY_SELLER = 'CP';
  static const STATUS_CANCELED_BY_CLIENT = 'CC';
  static const STATUS_FINISHED = 'F';
  static const STATUS_DELIVERING = 'D';
  static const STATUS_VALIDATED = 'V';
  static const STATUS_PENDING = 'P';

  static const FETCH_PENDING = "pending";
  static const FETCH_FINISHED = "finished";
  static const FETCH_CANCELED = "canceled";

  Order selectedOrder;
  List<Order> orders;


  int id;
  String lastState;
  String paymentType;
  String deliveryType;
  String deliveryPrice;
  double productsPrice;
  double totalPrice;
  String firstName;
  String lastName;
  String phone;
  String deliveryAddress;
  String deliverywilaya;
  String deliveryCommune;
  String lat;
  String lon;
  int posId;
  String pos;
  String posAddress;
  String posLat;
  String posLon;
  String orderDate;
  List<OrderItem> items;
  List<DeliveryState> states;

  Order(
      {this.id,
        this.lastState,
        this.paymentType,
        this.deliveryType,
        this.deliveryPrice,
        this.productsPrice,
        this.totalPrice,
        this.firstName,
        this.lastName,
        this.phone,
        this.deliveryAddress,
        this.lat,
        this.lon,
        this.posId,
        this.pos,
        this.posAddress,
        this.posLat,
        this.posLon,
        this.orderDate,
        this.items,
        this.states
      });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: int.parse(json['id'].toString()),
      lastState: json['last_state'],
      paymentType: json['payment_type'],
      deliveryType: json['delivery_type'],
      deliveryPrice: json['delivery_price'],
      productsPrice: double.parse(json['products_price'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      firstName: json['client_first_name'],
      lastName: json['client_last_name'],
      phone: json['client_phone'],
      deliveryAddress: json['delivery_address'] +", " +json['delivery_commune']['fr']+ ", "+ json['delivery_wilaya']['fr'],
      lat: json['lat'],
      lon: json['lon'],
      posId: int.parse(json['pos_id'].toString()),
      pos: json['pos'],
      posAddress: json['pos_address'],
      posLat: json['pos_lat'],
      posLon: json['pos_lon'],
      orderDate: json['order_date'],
      items: json['items'],
      states: json['states']
    );
  }

  static String orderStatusMessage(String status){
    switch(status){
      case Order.STATUS_FINISHED:
        return AppLocalizations.of(MyApp.navigatorKey.currentContext).finished_text;
      case Order.STATUS_DELIVERING:
        return AppLocalizations.of(MyApp.navigatorKey.currentContext).on_delivery_text;
      case Order.STATUS_CANCELED_BY_CLIENT:
      case Order.STATUS_CANCELED_BY_SELLER:
        return AppLocalizations.of(MyApp.navigatorKey.currentContext).canceled_text;
      case Order.STATUS_VALIDATED:
        return AppLocalizations.of(MyApp.navigatorKey.currentContext).confirmation_text;
      default :
        return AppLocalizations.of(MyApp.navigatorKey.currentContext).pending_text;
    }
  }

  static Color orderStatusColor(String status){
    switch(status){
      case Order.STATUS_FINISHED:
        return Color(0xFF007D32);
      case Order.STATUS_DELIVERING:
      case Order.STATUS_VALIDATED:
        return Color(0xFFFF7A00);
      case Order.STATUS_CANCELED_BY_CLIENT:
      case Order.STATUS_CANCELED_BY_SELLER:
        return Color(0xFFE71722);
      default :
        return Color(0xFFFF7A00);
    }
  }

   Future<bool> rejectOrder(id) async {
    final response = await Network.postWithToken('/orders/reject/$id',{});
    print('/pos/orders/reject/$id');
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        if (result['status'] == 'success') {
          ToastService.showSuccessToast(result['data']['message']);
          selectedOrder.lastState=Order.STATUS_CANCELED_BY_SELLER;
          notifyListeners();
          return true;
        } else {
          ToastService.showErrorToast(result['message']);
          return false;
        }
      } else {
        ServerResponse.serverResponseHandler(response: response);
        return false;
      }
  }

}
