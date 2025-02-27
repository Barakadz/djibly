import 'dart:convert';

import 'package:djibly/models/pos_product.dart';
import 'package:djibly/repositories/pos_product_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPresenter with ChangeNotifier {
  List<PosProduct> products = [];
  bool isSearching = false;
  bool isLoadingMore = false;
  int page = 1;
  int lastPage = 1;

  void loadMore(String q) async {
    if (page < lastPage) {
      page++;
      isLoadingMore = true;
      notifyListeners();
      await fetchPosProduct(q);
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<bool> searchPosProduct(String q) async {
    page = 1;
    products = [];
    isSearching = true;
    notifyListeners();
    final response = await fetchPosProduct(q);
    isSearching = false;
    notifyListeners();
    return response;
  }

  Future<bool> fetchPosProduct(String q) async {

    final response = await PosProductRepository.search(q, page);

    if (response != null && response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        products.addAll(PosProduct.generateProductsList(result['data']['items']));
        lastPage =
            int.parse(result['data']['pagination']['last_page'].toString());
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
    products = [];
    isSearching = false;
    isLoadingMore = false;
  }
}
