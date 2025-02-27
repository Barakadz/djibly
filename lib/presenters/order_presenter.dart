import 'dart:convert';

import 'package:djibly/models/delivery_state.dart';
import 'package:djibly/models/order.dart';
import 'package:djibly/models/order_item.dart';
import 'package:djibly/repositories/order_repository.dart';
import 'package:djibly/repositories/review_repository.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:flutter/material.dart';

class OrderPresenter with ChangeNotifier {
  Order _selectedOrder;
  List<Order> _orders;

  Order get selectedOrder => _selectedOrder;

  setSelectedOrder(Order value) {
    _selectedOrder = value;
  }

  List<Order> getOrders() {
    return _orders;
  }

  void  setOrders(List<Order> orders) {
    _orders = orders;
  }

  Future<void> fetchOrders(status) async {
    List<Order> orders = [];

    final response = await OrderRepository.getOrders(status);

    if (response != null) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      if (result['status'] == 'success') {
        try {
          result['data']['orders'].forEach((order) {
            List<DeliveryState> states = [];
            order['states'].forEach((state) {
              states.add(DeliveryState.fromJson(state));
            });
            order['states'] = states;
            List<OrderItem> orderItems = [];
            order['items'].forEach((orderItem) {
              orderItems.add(OrderItem.fromJson(orderItem));
            });
            order['items'] = orderItems;
            orders.add(Order.fromJson(order));
          });
        } catch (exception) {
          print(exception.toString());
        }
      }
    }
    _orders = orders;
    notifyListeners();
  }

  DeliveryState getState(String stateText){
    DeliveryState state = null;
    selectedOrder.states.forEach((orderState) {
      if(orderState.state == stateText){
        print("state found");
        state = orderState;
      }
    });
    return state;
  }

  Future<bool> cancelSelectedOrder() async {
    final response = await OrderRepository.cancelOrder(selectedOrder.id);

    if (response != null && response.statusCode == 200)
      return true;
    return false;
  }

  bool isStateExist(String state){
    bool result = false;
    selectedOrder.states.forEach((deliveryState) {
      if(state.toString() == deliveryState.state.toString())
        result = true;
      return;
    });
    return result;
  }

  Future<bool> postReview(int orderItemID, Map<String, dynamic> data) async{
    final response = await ReviewRepository.addReview(orderItemID, data);

    if (response != null && response.statusCode == 200){
      fetchOrders(Order.FETCH_FINISHED);
      ToastService.showSuccessToast("Review Successfully posted");
      return true;
    }
    return false;
  }
}
