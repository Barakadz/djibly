import 'dart:async';
import 'dart:convert';

import 'package:djibly/main.dart';
import 'package:djibly/models/ads.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/presenters/local_controller.dart';
import 'package:djibly/presenters/local_presenter.dart';
import 'package:djibly/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeTabPresenter with ChangeNotifier {
  static const AD_CAROUSEL_CODE = 'carousel';
  static const AD_BANNER_CODE = 'banner';

  List<PosProduct> _flashProducts = [];
  List<PosProduct> _mostSailedProducts = [];
  List<PosProduct> _bestRatedProducts = [];

  List<Map<String, List<PosProduct>>> homeProducts = [];
  List<Ads> _ads = [];

  int pageViewStyle = 0;

  bool _isFetching = false;
  bool _errorFetching = false;

  void changeViewStyle() {
    pageViewStyle = pageViewStyle == 0 ? 1 : 0;
    notifyListeners();
  }

  int getPageViewStyle() {
    return pageViewStyle;
  }

  Future<void> refresh() async {
    LocaleController controller = Get.find();
    _flashProducts = [];
    _mostSailedProducts = [];
    _bestRatedProducts = [];
    _ads = [];
    _isFetching = false;
    _errorFetching = false;

    homeProducts = [];
    String language = controller.locale.value.languageCode;

    final response = await HomeRepository.getProductsIndex();
    if (response != null) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        final products = result['data']['products'];

        products.forEach((key, item) {
          homeProducts.add({
            result['data']['keys'][key][language]:
                _generateNewProductsListFromJson(products[key])
          });
        });
        _generateAdsListFromJson(result['data']['ads']);
      } catch (exception) {
        print(exception);
      }
      _errorFetching = false;
    } else {
      _errorFetching = true;
    }
    notifyListeners();
  }

  Future<void> fetchIndexProductsList() async {
    if (_flashProducts.isEmpty) {
      _isFetching = true;
      _flashProducts = [];
      _flashProducts = [];
      _mostSailedProducts = [];
      _bestRatedProducts = [];
      _ads = [];
      homeProducts = [];

      LocaleController controller = Get.find();
      String language = controller.locale.value.languageCode;

      final response = await HomeRepository.getProductsIndex();
      if (response != null) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        try {
          final products = result['data']['products'];
          products.forEach((key, item) {
            homeProducts.add({
              result['data']['keys'][key][language]:
                  _generateNewProductsListFromJson(products[key])
            });
          });
          _generateAdsListFromJson(result['data']['ads']);
        } catch (exception) {
          print(exception);
        }
        _errorFetching = false;
      } else {
        _errorFetching = true;
      }
      _isFetching = false;
      notifyListeners();
    }
  }

  bool get errorFetching => _errorFetching;

  List<PosProduct> getFlashProductsList() {
    return _flashProducts;
  }

  List<PosProduct> getBestRatedProductsList() {
    return _bestRatedProducts;
  }

  List<PosProduct> getMostSailedProductsList() {
    return _mostSailedProducts;
  }

  bool isFetching() {
    return _isFetching;
  }

  List<PosProduct> _generateNewProductsListFromJson(data) {
    List<PosProduct> list = [];
    list.addAll(PosProduct.generateProductsList(data));
    return list;
  }

  void _generateAdsListFromJson(data) {
    data.forEach((ad) {
      _ads.add(Ads.fromJson(ad));
    });
  }

  List<Ads> getAdsListByType(type) {
    List<Ads> list = [];
    _ads.forEach((ad) {
      if (ad.type == type) {
        list.add(ad);
      }
    });
    return list;
  }
}
