import 'dart:convert';

import 'package:djibly/main.dart';
import 'package:djibly/presenters/cart_presenter.dart';
import 'package:djibly/models/cart_item.dart';
import 'package:djibly/models/cart_pos.dart';
import 'package:djibly/models/delivery_price.dart';
import 'package:djibly/models/user_address.dart';
import 'package:djibly/repositories/cart_repository.dart';
import 'package:djibly/repositories/order_repository.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrderPresenter extends ChangeNotifier {
  UserAddress defaultAddress;

  UserAddress userAddress = new UserAddress();

  List<UserAddress> addresses = [];
  List<CartPos> _posList = [];
  List<int> _selectedItems = null;
  List<DeliveryPrice> prices = [];

  Map<String, dynamic> _orderData;

  Future<List<UserAddress>> getAddresses() async {
    addresses = await userAddress.getAddresses();
    return addresses;
  }

  selectDefaultAddress(UserAddress address) {
    defaultAddress = address;
    notifyListeners();
  }

  void clearData(){
    _selectedItems = null;
    defaultAddress = null;
    _orderData = null;
    _posList = [];
  }

  Future<void> getItems() async {
    if(_selectedItems.length == 0){
      return [];
    }
    List<CartItem> totalItems = [];
    Map<String, dynamic> mapPos;
    Map<String, dynamic> mapItem;

    final response = await CartRepository.getOrderedItems({'ids': _selectedItems});

    print("response from server");
    if(response != null){
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        result['data']['pos'].forEach((pos) {
          List<CartItem> posItems = [];
          pos['items'].forEach((item) {
            mapItem = item;
            posItems.add(CartItem.fromJson(mapItem));
          });
          mapPos = {
            'id': pos['id'].toString(),
            'name': pos['name'],
            'items': posItems,
            'delivery_price': pos['delivery_price'],
            'delivery_type': pos['delivery_type'],
          };
          _posList.add(CartPos.fromJson(mapPos));
          totalItems.addAll(posItems);
          if(result['data']['default_address'] != null)
            defaultAddress = UserAddress.fromJson(result['data']['default_address']);
          notifyListeners();
        });
      } catch (exception) {
        print(exception.toString());
      }
    }
  }

  List<int> getSelectedItems() {
    return _selectedItems;
  }

  setSelectedItems(ids) {
    _selectedItems = ids;
    notifyListeners();
  }

  List<CartPos> getPosList() {
    return _posList;
  }

  void setPosDeliveryPrice(posId, DeliveryPrice price){
    _posList.forEach((pos) {
        if (pos.id == posId) {
          pos.deliveryType = price.type;
          pos.deliveryPrice = double.parse(price.price.toString());
          pos.deliveryCompany = price.company;
          pos.companyId = price.companyId;
        }
    });
    notifyListeners();
  }

  double totalDeliveryPrice(){
    double total = 0;
    _posList.forEach((pos) {
          total = total + double.parse(pos.deliveryPrice != null ? pos.deliveryPrice.toString() : 0.toString());
    });

    return total;
  }

  double totalProductPrice(){
    double total = 0;
    _posList.forEach((pos) {
      pos.items.forEach((item) {
        total = total + item.quantity * item.productPrice;
      });
    });

    return total;
  }

  double totalPrice(){
    return totalDeliveryPrice() + totalProductPrice();
  }






//<------------------ ORDER METHODS ---------------------------------->
  void setOrderData(data) {
    _orderData = data;
  }

  Map<String, dynamic> getOrderData() {
    return _orderData;
  }

  Future<bool> makeOrder( Map<String,dynamic> initialData) async {
    List<Map<String,dynamic>> orderedPosItems = [];
    _posList.forEach((element) {

      Map<String, dynamic> data = {
        'id': element.id,
        'products': CartPos.getItemsIds(element.items)
      };

      orderedPosItems.add(data);
    });
    _orderData.addAll(initialData);
    _orderData.addAll({'pos': orderedPosItems, 'address_id': defaultAddress.id});

    final response = await OrderRepository.makeOrder(_orderData);

    if(response != null){
      final result = json.decode(utf8.decode(response.bodyBytes));
      _selectedItems = [];
      this.getItems();
      notifyListeners();
      await Provider.of<CartPresenter>(MyApp.navigatorKey.currentContext, listen: false).fetchItems(true);
      return true;
    }else {
      return false;
    }
  }
}
