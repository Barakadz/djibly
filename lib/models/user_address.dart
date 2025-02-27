import 'dart:convert';

import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:flutter/cupertino.dart';

Network network;

class UserAddress with ChangeNotifier {
  int id;
  String firstName;
  String lastName;
  String phone;
  String address;
  String moreInfo;
  int communeId;
  String commune;
  String wilaya;
  int wilayaId;
  bool isDefault;
  String fullAddress;

  List<UserAddress> addresses = [];

  UserAddress(
      {this.id,
      this.firstName,
      this.lastName,
      this.phone,
      this.address,
      this.moreInfo,
      this.communeId,
      this.commune,
      this.wilaya,
      this.wilayaId,
      this.isDefault,
      this.fullAddress});

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
        id: int.parse(json['id'].toString()),
        firstName: json['first_name'],
        lastName: json['last_name'],
        phone: json['phone'],
        address: json['address'],
        moreInfo: json['more_info'],
        communeId: int.parse(json['commune_id'].toString()),
        commune: json['commune']['fr'],
        wilaya: json['wilaya']['fr'],
        wilayaId: int.parse(json['wilaya_id'].toString()),
        isDefault: int.parse(json['default'].toString()) == 0 ? false : true,
        fullAddress: json['address'] +
            ', ' +
            json['commune']['fr'] +
            ', ' +
            json['wilaya']['fr']);
  }

  Future<List<UserAddress>> getAddresses() async {
    var response = await Network.getWithToken("/addresses");

    print(response.body);
    try {
      if (response.statusCode == 200) {
        addresses = [];
        final result = json.decode(utf8.decode(response.bodyBytes));
        result['data']['addresses'].forEach((address) {
          addresses.add(UserAddress.fromJson(address));
        });
        notifyListeners();
        return addresses;
      } else {
        ServerResponse.serverResponseHandler(response: response);
        return [];
      }
    } catch (e) {
      print(e.toString());
      ServerResponse.serverResponseHandler(response: response);
      return [];
    }
  }

  Future<UserAddress> getAddress(id) async {
    var response = await Network.getWithToken("/addresses/$id");
    try {
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        return UserAddress.fromJson(result['data']['address']);
      } else {
        ServerResponse.serverResponseHandler(response: response);
        throw Future.error('');
      }
    } catch (e) {
      ServerResponse.serverResponseHandler(response: response);
      throw Future.error('');
    }
  }

  Future<bool> setAddressAsDefault(id) async {
    var response = await Network.postWithToken("/addresses/default/$id", {});

    try {
      if (response.statusCode == 200) {
        await getAddresses();
        return true;
      } else {
        ServerResponse.serverResponseHandler(response: response);
        return false;
      }
    } catch (e) {
      ServerResponse.serverResponseHandler(response: response);
      return false;
    }
  }

  Future<bool> addAddress(data) async {
    var response = await Network.postWithToken("/addresses/create", data);
    try {
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        await this.getAddresses();
        return true;
      } else {
        ServerResponse.serverResponseHandler(response: response);
        return false;
      }
    } catch (e) {
      ServerResponse.serverResponseHandler(response: response);
      return false;
    }
  }

  Future<bool> editAddress(data, id) async {
    var response = await Network.postWithToken("/addresses/update/$id", data);
    try {
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        await this.getAddresses();
        return true;
      } else {
        ServerResponse.serverResponseHandler(response: response);
        return false;
      }
    } catch (e) {
      ServerResponse.serverResponseHandler(response: response);
      return false;
    }
  }

  Future<bool> deleteAddress(id) async {
    var response = await Network.postWithToken("/addresses/delete/$id", {});
    try {
      if (response.statusCode == 200) {
        final result = json.decode(utf8.decode(response.bodyBytes));
        await this.getAddresses();
        return true;
      } else {
        ServerResponse.serverResponseHandler(response: response);
        return false;
      }
    } catch (e) {
      ServerResponse.serverResponseHandler(response: response);
      return false;
    }
  }
}
