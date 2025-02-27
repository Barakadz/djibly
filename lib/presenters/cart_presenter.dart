import 'dart:convert';

import 'package:djibly/models/cart_item.dart';
import 'package:djibly/models/cart_pos.dart';
import 'package:djibly/repositories/cart_repository.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:flutter/material.dart';

class CartPresenter with ChangeNotifier {
  bool _checkAllItems = false;
  List<CartItem> _cartItems = [];
  List<int> _selectedItems = [];
  List<String> _selectedPos = [];
  Map<String, dynamic> _orderData;
  List<CartPos> _posList = [];

  bool isFetching = false;
  bool itemsFetchedSuccessfully = false;

  bool errorFetching = false;

  List<CartPos> getItems() {
    if (itemsFetchedSuccessfully == true)
      return _posList;
    else {
      fetchItems(true);
      return [];
    }
  }

  Future<void> fetchItems(bool notify) async {
    List<CartPos> posList = [];
    List<CartItem> totalItems = [];
    Map<String, dynamic> mapPos;
    Map<String, dynamic> mapItem;
    initData();
    /*  isFetching = true;
    await Future.delayed(Duration.zero, () {
      if (notify) notifyListeners();
    }); */
    final response = await CartRepository.getCartItems();
    isFetching = false;
    if (response != null) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        if (result["data"]['pos'] != null) {
          result['data']['pos'].forEach((pos) {
            List<CartItem> posItems = [];
            pos['items'].forEach((item) {
              mapItem = item;
              posItems.add(CartItem.fromJson(mapItem));
            });
            mapPos = {
              'name': pos['name'],
              'id': pos['id'],
              'items': posItems,
              'delivery_price': pos['delivery_price'].toString()
            };
            posList.add(CartPos.fromJson(mapPos));
            totalItems.addAll(posItems);
          });
          _cartItems = totalItems;
          _posList = posList;
        }
        itemsFetchedSuccessfully = true;
      } catch (exception) {
        print(exception.toString());
        errorFetching = true;
      }
    } else {
      errorFetching = true;
    }
    await Future.delayed(Duration.zero, () {
      if (notify) notifyListeners();
    });
  }

  getPosList() {
    return _posList;
  }

  CartItem getItemFromId(id) {
    return _cartItems.firstWhere((item) => item.id == id, orElse: () {
      return null;
    });
  }

  Future<bool> increaseQuantity(id) async {
    bool response = await Network.postWithToken('/cart/items/$id/increase', {})
        .then((response) {
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        if (result['status'] == 'success') {
          _cartItems.firstWhere((item) => item.id == id, orElse: () {
            return null;
          }).quantity++;
          notifyListeners();
          return true;
        } else {
          ToastService.showErrorToast(result['message']);
          return false;
        }
      } else {
        ServerResponse.serverResponseHandler(response: response);
        throw Future.error('');
      }
    });
    return response;
  }

  Future<bool> decreaseQuantity(id) async {
    bool response = await Network.postWithToken('/cart/items/$id/decrease', {})
        .then((response) {
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        if (result['status'] == 'success') {
          _cartItems.firstWhere((item) => item.id == id, orElse: () {
            return null;
          }).quantity--;
          notifyListeners();
          return true;
        } else {
          ToastService.showErrorToast(result['message']);
          return false;
        }
      } else {
        ServerResponse.serverResponseHandler(response: response);
        throw Future.error('');
      }
    });
    return response;
  }

  Future<bool> deleteSelectedItems() async {
    final response =
        await CartRepository.deleteSelectedItems({'ids': _selectedItems});

    if (response != null) {
      _selectedItems = [];
      itemsFetchedSuccessfully = false;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void selectItem(int id) {
    _selectedItems.add(id);
    _posList.forEach((pos) {
      pos.items.forEach((item) {
        if (item.id == id && !_selectedPos.contains(pos.id)) {
          print("selectItem  =>  selected POS   ${pos.id}");
          print("selectItem  =>  selected POS price  ${pos.deliveryPrice}");
          _selectedPos.add(pos.id.toString());
        }
      });
    });
    notifyListeners();
  }

  void deselectItem(int id) {
    CartItem item = getItemFromId(id);
    _selectedItems.remove(id);
    bool otherItemExist = false;
    _selectedItems.forEach((itemId) {
      if (getItemFromId(itemId).posId == item.posId) {
        print("deselectItem  =>  otherItemExist  ${otherItemExist}");
        otherItemExist = true;
      }
    });

    if (!otherItemExist) {
      print("deselectItem  =>  remove pos  ${item.posId}");

      for (int i = 0; i < _selectedPos.length; i++) {
        if (_selectedPos[i] == item.posId.toString()) {
          print("🟢🟢🟢🟢🟢 deselectItem  =>  remove pos at index  ${i}");
          print(
              "🟢🟢🟢🟢🟢 deselectItem  =>  item total price  ${item.deliveryPrice}");

          _selectedPos.removeAt(i);
          break;
        }
      }
    }
    print(
        "🟢🟢🟢🟢🟢 deselectItem  =>   total delivery price  ${totalDeliveryPrice()}");

    notifyListeners();
  }

  bool isItemSelected(int itemId) {
    int selectedItem =
        _selectedItems.firstWhere((id) => id == itemId, orElse: () {
      return null;
    });
    if (selectedItem == null) {
      return false;
    } else {
      return true;
    }
  }

  bool isAllItemsSelected() {
    if (_selectedItems.length == _cartItems.length) {
      return true;
    } else {
      return false;
    }
  }

  double totalPrice() {
    double totalPrice = 0;
    _selectedItems.forEach((itemId) {
      CartItem item =
          _cartItems.firstWhere((item) => item.id == itemId, orElse: () {
        return null;
      });
      totalPrice += (item.productPrice * item.quantity);
    });

    print(" ######### pos Seleceted Lenght ${_selectedPos.length} ");
    print(" ######### pos Seleceted delevery total ${totalDeliveryPrice()} ");

    return totalPrice;
  }

  double totalDeliveryPrice() {
    double totalDeliveryPrice = 0;
    List<String> posIdAdded = [];
    _selectedPos.forEach((selectedPOSId) {
      print(" ######### totalDeliveryPrice   selectedPos ID ${selectedPOSId} ");

      _posList.forEach((pos) {
        print(" ######### totalDeliveryPrice   posList ID ${pos.id} ");

        if (pos.id == int.tryParse(selectedPOSId) &&
            !posIdAdded.contains(selectedPOSId)) {
          totalDeliveryPrice += pos.deliveryPrice;
          posIdAdded.add(selectedPOSId);
        }
      });
    });
    return totalDeliveryPrice;
  }

  List<CartItem> getAllItems() {
    return _cartItems;
  }

  void selectAllItems() {
    _cartItems.forEach((cartItem) {
      int selectedItem =
          _selectedItems.firstWhere((item) => item == cartItem.id, orElse: () {
        return null;
      });
      if (selectedItem == null) {
        _selectedItems.add(cartItem.id);
      }
    });
    _selectedPos = [];
    _posList.forEach((pos) {
      _selectedPos.add(pos.id.toString());
    });

    notifyListeners();
  }

  void deselectAllItems() {
    _selectedItems = [];
    _selectedPos = [];
    notifyListeners();
  }

  bool getCheckAllItems() {
    return _checkAllItems;
  }

  int getNumberOfItems() {
    return _cartItems.length;
  }

  List<int> getSelectedItems() {
    return _selectedItems;
  }

  void initData() {
    itemsFetchedSuccessfully = false;
    _checkAllItems = false;
    _cartItems = [];
    _selectedItems = [];
    _selectedPos = [];
    _posList = [];
  }
}
