import 'dart:convert';

import 'package:awesome_select/awesome_select.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/presenters/local_controller.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:flutter/cupertino.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:get/get.dart';

import '../main.dart';

Network network;

class Wilaya with ChangeNotifier {
  int id;
  String nameAr;
  String nameFr;
  String nameEn;
  List<S2Choice> _wilayas = [];
  String _selectedWilaya;

  Wilaya({this.id, this.nameAr, this.nameFr, this.nameEn});

  factory Wilaya.fromJson(Map<String, dynamic> json) {
    return Wilaya(
        id: json['id'],
        nameAr: json['name_ar'],
        nameFr: json['name_fr'],
        nameEn: json['name_en']);
  }

  Future<List<S2Choice<String>>> getWilayas() async {
    LocaleController localController = Get.find();

    try {
      var response = await Network.getWithToken("/wilayas");
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        _wilayas = S2Choice.listFrom<String, dynamic>(
          source: result['data']['wilayas'],
          value: (index, item) => item['id'].toString(),
          title: (index, item) =>
              item['name_' + localController.locale.value.languageCode],
          //disabled: (index, item) => item['disabled']
        );
        return _wilayas;
      } else {
        ToastService.showErrorToast(MyApp
            .navigatorKey.currentContext.translate.connection_problem_body);
        return [];
      }
    } catch (e) {
      ToastService.showErrorToast(
          MyApp.navigatorKey.currentContext.translate.connection_problem_body);
      return [];
    }
  }

  String getGelectedWilaya() {
    return this._selectedWilaya;
  }

  String getGelectedWilayaName() {
    return this.nameFr;
  }

  void setSelectedWilaya(String wilayaId) {
    this._selectedWilaya = wilayaId;
    if (this._selectedWilaya != null) notifyListeners();
  }
}
