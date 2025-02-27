import 'dart:async';
import 'dart:convert';

import 'package:djibly/models/pos.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/repositories/pos_product_repository.dart';
import 'package:djibly/repositories/pos_repository.dart';
import 'package:flutter/material.dart';

class PosPresenter with ChangeNotifier {
  Pos _selectedPos;

  int selectedTab = 0;

  bool isTabChanging = false;

  bool isFetching = false;
  bool errorFetching = false;

  List<PosProduct> products = [];
  bool isLoadingMore = false;
  int page = 1;
  int lastPage = 1;

  int currentPage = 1;
  int totalItems = 0;
  bool hasMoreItems = true;

  setSelectedTab(int index) {
    if (selectedTab != index) {
      selectedTab = index;
      getPosProduct();
    }
  }

  Pos getSelectedPos(id) {
    if (_selectedPos != null && _selectedPos.id == id) {
      return _selectedPos;
    } else {
      fetchPos(id);
      return _selectedPos;
    }
  }

  Future<bool> fetchPos(id) async {
    isFetching = true;
    Map<String, dynamic> mapPos;

    final response = await PosRepository.getPos(id);
    isFetching = false;
    if (response != null) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      mapPos = result['data']['pos'];
      products.addAll(
          PosProduct.generateProductsList(result['data']['products']['items']));
      lastPage = int.parse(
          result['data']['products']['pagination']['last_page'].toString());
      currentPage = int.parse(
          result['data']['products']['pagination']['current_page'].toString());
      totalItems = int.parse(
          result['data']['products']['pagination']['total'].toString());
      hasMoreItems = currentPage < lastPage;
      try {
        _selectedPos = new Pos.fromJson(mapPos);
        errorFetching = false;
      } catch (exception) {
        _selectedPos = null;
        errorFetching = true;
      }
      notifyListeners();
      return true;
    } else {
      errorFetching = true;
      notifyListeners();
      return false;
    }
  }

  void loadMore() async {
    if (page < lastPage) {
      page++;
      isLoadingMore = true;
      notifyListeners();
      await fetchPosProduct(
          _selectedPos.id, selectedTab == 0 ? null : (selectedTab + 1), page);
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<bool> getPosProduct() async {
    print("tab changed");
    isTabChanging = true;
    page = 1;
    products = [];
    notifyListeners();
    final response = await fetchPosProduct(
        _selectedPos.id, selectedTab == 0 ? null : (selectedTab + 1), page);
    isTabChanging = false;
    notifyListeners();
    return response;
  }

  Future<bool> fetchPosProduct(pos, int category, int page) async {
    final response =
        await PosProductRepository.getPosProducts(pos, category, page);

    if (response != null && response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        products
            .addAll(PosProduct.generateProductsList(result['data']['items']));
        lastPage =
            int.parse(result['data']['pagination']['last_page'].toString());
        currentPage =
            int.parse(result['data']['pagination']['current_page'].toString());
        totalItems =
            int.parse(result['data']['pagination']['total'].toString());
        hasMoreItems = currentPage < lastPage;
        return true;
      } catch (exception) {
        print(exception);
        return false;
      }
    } else {
      return false;
    }
  }

  void initData() {
    page = 1;
    lastPage = 1;
    selectedTab = 0;
    products = [];
    isTabChanging = false;
    isLoadingMore = false;
    _selectedPos = null;
    errorFetching = false;
    currentPage = 1;
    totalItems = 0;
    hasMoreItems = true;
  }
}
