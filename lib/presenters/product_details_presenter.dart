import 'dart:convert';

import 'package:djibly/app/core/theme/theme.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/repositories/wishlist_repository.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';

class ProductDetailsPresenter with ChangeNotifier {
  PosProduct selectedProduct;

  static int SPECIFICATION_VIEW = 0;
  static int REVIEWS_VIEW = 1;
  int _selectedView = 0;
  bool isLoading = false;

  Widget getWishlistIcon() {
    if (isLoading) {
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
    } else {
      return Icon(
        selectedProduct.inWishlist
            ? Icons.favorite
            : Icons.favorite_border_outlined,
        color: selectedProduct.inWishlist
            ? lightTheme.colorScheme.primary
            : Colors.grey,
        size: 20.0,
      );
    }
  }

  void setSelectedProduct(PosProduct product) {
    selectedProduct = product;
  }

  int getSelectedView() {
    return _selectedView;
  }

  void setSelectedView(int view) {
    this._selectedView = view;
    notifyListeners();
  }

  Future<bool> addToWishlist() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      final response =
          await WishlistRepository.addToWishlist(selectedProduct.id);
      isLoading = false;
      notifyListeners();
      if (response != null && response.statusCode == 200) {
        selectedProduct.inWishlist = true;
        return true;
      } else {
        return false;
      }
    } else
      return false;
  }

  Future<bool> removeFromWishlist() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      final response =
          await WishlistRepository.removeFromWishlist(selectedProduct.id);
      isLoading = false;
      notifyListeners();
      if (response != null && response.statusCode == 200) {
        selectedProduct.inWishlist = false;
        return true;
      } else {
        return false;
      }
    } else
      return false;
  }
}
