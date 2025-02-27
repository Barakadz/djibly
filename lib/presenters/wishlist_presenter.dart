import 'dart:convert';

import 'package:djibly/models/pos_product.dart';
import 'package:djibly/repositories/wishlist_repository.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';

class WishlistPresenter with ChangeNotifier {
  PosProduct selectedProduct;

  List<PosProduct> products;

  bool isFetching = false;
  bool isLoadingMore = false;
  bool errorFetching = false;
  bool isRemoving = false;
  int page = 1;
  int lastPage = 1;

  void setSelectedProduct(PosProduct product) {
    selectedProduct = product;
  }

  List<PosProduct> getWishlist() {
    if (products == null) {
      fetchWishlist();
    }
    return products;
  }

  void loadMore() async {
    print("load more");
    if (page < lastPage) {
      page++;
      isLoadingMore = true;
      notifyListeners();
      await fetchWishlist();
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<bool> fetchWishlist() async {
    if (page == 1) isFetching = true;
    final response = await WishlistRepository.getWishlist(page);
    if (page == 1) isFetching = false;
    if (response != null && response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        if (page == 1) products = [];
        products
            .addAll(PosProduct.generateProductsList(result['data']['items']));
        lastPage =
            int.parse(result['data']['pagination']['last_page'].toString());
        errorFetching = false;
        notifyListeners();
        return true;
      } catch (exception) {
        errorFetching = true;
        print(exception);
        notifyListeners();
        return false;
      }
    } else {
      errorFetching = true;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFromWishlist() async {
    if (!isRemoving) {
      isRemoving = true;
      notifyListeners();
      final response =
          await WishlistRepository.removeFromWishlist(selectedProduct.id);
      isRemoving = false;
      if (response != null && response.statusCode == 200) {
        products.removeWhere((product) => product.id == selectedProduct.id);
        selectedProduct = null;
        notifyListeners();
        return true;
      } else {
        notifyListeners();
        return false;
      }
    } else {
      notifyListeners();
      return false;
    }
  }

  void initData() {
    page = 1;
    lastPage = 1;
    products = null;
    isLoadingMore = false;
    errorFetching = false;
    isFetching = false;
    selectedProduct = null;
  }

  Widget getWishlistIcon(id) {
    if (isRemoving && selectedProduct != null && id == selectedProduct.id) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.black),
            strokeWidth: 2.0,
          ),
        ),
      );
    }
    return Icon(
      Icons.favorite,
      color: DjiblyColor,
      size: 30.0,
    );
  }
}
