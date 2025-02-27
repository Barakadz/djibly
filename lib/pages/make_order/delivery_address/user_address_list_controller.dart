import 'dart:ffi';

import 'package:awesome_select/awesome_select.dart';
import 'package:awesome_select/src/model/chosen.dart';
import 'package:djibly/models/pos.dart';
import 'package:djibly/models/wilaya.dart';
import 'package:djibly/presenters/create_order_presenter.dart';
import 'package:djibly/presenters/nearby_pos_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../models/commune.dart';
import '../../../models/user_address.dart';

class UserAddressesListController extends GetxController {
  final list = <UserAddress>[].obs;

  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();

    print("init controller");
  }

  Future<void> initPage() async {
    isLoading.value = true;
    list.clear();

    final listData = await CreateOrderPresenter().getAddresses();
    list.addAll(listData);
    isLoading.value = false;
  }
}
