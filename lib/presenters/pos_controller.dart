import 'dart:async';
import 'dart:convert';

import 'package:djibly/models/pos.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/repositories/pos_product_repository.dart';
import 'package:djibly/repositories/pos_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PosController extends GetxController {
  Pos _selectedPos;

  int selectedTab = 0;

  final isTabChanging = false.obs;

  final isFetching = false.obs;
  final errorFetching = false.obs;

  final scrollController = ScrollController();

  final products = <PosProduct>[].obs;
  final isLoadingMore = false.obs;
  final page = 1.obs;
  final lastPage = 1.obs;

  final currentPage = 1.obs;
  final totalItems = 0.obs;
  final hasMoreItems = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    scrollController.addListener(_onScroll);

    initData();
    ever(page, (value) {
      print("page changed: $value");
    });
  }

  setSelectedTab(int index) {
    if (selectedTab != index) {
      selectedTab = index;
      getPosProduct();
    }
  }

  Future<void> _onScroll() async {
    if (_isAtBottom) {
      await loadMore();
    }
  }

  bool get _isAtBottom =>
      scrollController.position.pixels ==
      scrollController.position.maxScrollExtent;

  Pos getSelectedPos(id) {
    if (_selectedPos != null && _selectedPos.id == id) {
      return _selectedPos;
    } else {
      fetchPos(id);
      return _selectedPos;
    }
  }

  Future<bool> fetchPos(id) async {
    try {
      isFetching.value = true;
      final response = await PosRepository.getPos(id);

      if (response == null) {
        errorFetching.value = true;
        return false;
      }

      final result = json.decode(utf8.decode(response.bodyBytes));
      return _processPositiveResponse(result);
    } catch (e) {
      errorFetching.value = true;
      return false;
    } finally {
      isFetching.value = false;
    }
  }

  Future<bool> _processPositiveResponse(Map<String, dynamic> result) async {
    try {
      _updatePaginationInfo(result['data']['products']['pagination']);
      _updateProducts(result['data']['products']['items']);
      _updateSelectedPos(result['data']['pos']);
      return true;
    } catch (e) {
      errorFetching.value = true;
      return false;
    }
  }

  Future<void> loadMore() async {
    if (page.value < lastPage.value) {
      page.value++;
      isLoadingMore.value = true;
      await fetchPosProduct(_selectedPos.id,
          selectedTab == 0 ? null : (selectedTab + 1), page.value, true);
      isLoadingMore.value = false;
    }
  }

  Future<bool> getPosProduct() async {
    print("tab changed");
    isTabChanging.value = true;
    page.value = 1;
    products.value = [];
    final response = await fetchPosProduct(_selectedPos.id,
        selectedTab == 0 ? null : (selectedTab + 1), page.value, false);
    isTabChanging.value = false;
    return response;
  }

  Future<bool> fetchPosProduct(
      pos, int category, int page, bool fromPagination) async {
    fromPagination ? isLoadingMore : isFetching.value = true;

    final response =
        await PosProductRepository.getPosProducts(pos, category, page);
    isFetching.value = false;

    if (response != null && response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        products
            .addAll(PosProduct.generateProductsList(result['data']['items']));
        lastPage.value =
            int.parse(result['data']['pagination']['last_page'].toString());
        currentPage.value =
            int.parse(result['data']['pagination']['current_page'].toString());
        totalItems.value =
            int.parse(result['data']['pagination']['total'].toString());
        hasMoreItems.value = currentPage.value < lastPage.value;
        products.refresh();
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
    page.value = 1;
    lastPage.value = 1;
    selectedTab = 0;
    products.value = [];
    isTabChanging.value = false;
    isLoadingMore.value = false;
    _selectedPos = null;
    errorFetching.value = false;
    currentPage.value = 1;
    totalItems.value = 0;
    hasMoreItems.value = true;
  }

  void _updatePaginationInfo(Map<String, dynamic> pagination) {
    currentPage.value = int.parse(pagination['current_page'].toString());
    lastPage.value = int.parse(pagination['last_page'].toString());
    totalItems.value = int.parse(pagination['total'].toString());
    hasMoreItems.value = currentPage.value < lastPage.value;
  }

  void _updateProducts(List<dynamic> items) {
    if (page.value == 1) {
      products.value = [];
    }
    products.addAll(PosProduct.generateProductsList(items));
    products.refresh();
  }

  void _updateSelectedPos(Map<String, dynamic> posData) {
    _selectedPos = Pos.fromJson(posData);
  }

  Future<bool> searchPosProduct(String q) async {
    page.value = 1;
    products.value = [];
    final response = await _searchPosProduct(q);
    return response;
  }

  Future<bool> _searchPosProduct(String q) async {
    final response = await PosProductRepository.search(q, page.value);

    if (response != null && response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        products
            .addAll(PosProduct.generateProductsList(result['data']['items']));
        lastPage.value =
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

  Future<void> loadMoreSearch(String q) async {
    if (page.value < lastPage.value) {
      page.value++;
      isLoadingMore.value = true;
      await _searchPosProduct(q);
      isLoadingMore.value = false;
    }
  }
}
