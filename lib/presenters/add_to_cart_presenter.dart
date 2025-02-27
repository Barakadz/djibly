import 'dart:convert';

import 'package:djibly/main.dart';
import 'package:djibly/models/available_color.dart';
import 'package:djibly/presenters/cart_presenter.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/repositories/cart_repository.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCartPresenter with ChangeNotifier {
  bool isFirstRequest = true;
  List<AvailableColor> _availableColors = [];
  PosProduct _product;

  PosProduct getProduct() {
    return _product;
  }

  void setProduct(PosProduct product){
    _product = product;
    setAvailableColors();
    notifyListeners();
  }

  void setAvailableColors(){
      _availableColors = [];
      _product.availableColors.forEach((item) {
        _availableColors.add(AvailableColor.fromJson(item));
      });

  }

  Future<bool> addProductToCart(data) async {

    final response = await CartRepository.addProductToCart(data);
    if(response != null ){
      Provider.of<CartPresenter>(MyApp.navigatorKey.currentContext, listen: false).fetchItems(true);
    }
    return true;
  }

  List<AvailableColor> getAvailableColors(){
    return _availableColors;
  }

}
