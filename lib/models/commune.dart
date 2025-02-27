import 'dart:convert';

import 'package:awesome_select/awesome_select.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:flutter/material.dart';
import 'package:djibly/presenters/local_controller.dart';
import 'package:get/get.dart';

Network network;

class Commune with ChangeNotifier {
  int id;
  String nameAr;
  String nameFr;
  String nameEn;
  int wilayaId;

  String _selectedCommune;

  Commune({this.id, this.nameAr, this.nameFr, this.nameEn, this.wilayaId});

  factory Commune.fromJson(Map<String, dynamic> json) {
    return Commune(
        id: json['id'],
        nameAr: json['name_ar'],
        nameFr: json['name_fr'],
        nameEn: json['name_en'],
        wilayaId: json['wiliaya_id']);
  }

  static Future<List<S2Choice<String>>> getCommunes(wilaya) async {
    LocaleController localController = Get.find();

    try {
      var response = await Network.getWithToken("/communes/$wilaya");
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        return S2Choice.listFrom<String, dynamic>(
          source: result['data']['communes'],
          value: (index, item) => item['id'].toString(),
          title: (index, item) =>
              item['name_' + localController.locale.value.languageCode],
          //disabled: (index, item) => item['disabled']
        );
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  String getGelectedCommune() {
    return this._selectedCommune;
  }

  void setSelectedCommune(String wilayaId) {
    this._selectedCommune = wilayaId;
    notifyListeners();
  }
}
