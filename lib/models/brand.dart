import 'dart:convert';
import 'dart:js';

import 'package:awesome_select/awesome_select.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/main.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/toast_service.dart';

Network network;

class Brand {
  int id;
  String name;

  Brand({this.id, this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(id: json['id'], name: json['name']);
  }

  static Future<List<S2Choice<String>>> getBrands() async {
    network = Network();
    try {
      var response = await Network.getWithToken("/brands");
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        return S2Choice.listFrom<String, dynamic>(
            source: result['data'],
            value: (index, item) => item['id'].toString(),
            title: (index, item) => item['name']);
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
}
