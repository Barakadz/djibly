import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/repositories/pos_product_repository.dart';

class SearchController extends GetxController {
  // Observable variables
  final products = <PosProduct>[].obs;
  final isSearching = false.obs;
  final isLoadingMore = false.obs;
  final page = 1.obs;
  final lastPage = 1.obs;
  final searchQuery = ''.obs;
  final searchController = TextEditingController().obs;
  final isFirstSearch = true.obs;
  final showCleanText = false.obs;
  final emptySearch = false.obs;
  @override
  void onInit() {
    searchController.value.addListener(() {
      if (searchController.value.text.length > 0) {
        searchQuery.value = searchController.value.text;
        showCleanText.value = true;
      } else {
        showCleanText.value = false;
      }
    });
  }

  void loadMore() async {
    if (page.value < lastPage.value) {
      page.value++;
      isLoadingMore.value = true;
      await fetchPosProduct(searchQuery.value);
      isLoadingMore.value = false;
    }
  }

  Future<bool> searchPosProduct() async {
    page.value = 1;
    products.value = [];
    isSearching.value = true;
    final response = await fetchPosProduct(searchQuery.value);
    isSearching.value = false;
    return response;
  }

  Future<bool> fetchPosProduct(String q) async {
    final response = await PosProductRepository.search(q, page.value);

    if (response != null && response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        products
            .addAll(PosProduct.generateProductsList(result['data']['items']));
        lastPage.value =
            int.parse(result['data']['pagination']['last_page'].toString());
        emptySearch.value = products.isEmpty;
        return true;
      } catch (exception) {
        print(exception);
        return false;
      }
    }
    return false;
  }

  void initData() {
    page.value = 1;
    lastPage.value = 1;
    products.value = [];
    isSearching.value = false;
    isLoadingMore.value = false;
  }
}
