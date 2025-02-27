import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:djibly/services/device_info_service.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class PosRepository {
  static Future<http.Response> getNearbyPos() async {
    final response = await Network.getWithToken('/pos/nearby');
    if (response == null) return null;

    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> getNearbyPosPagination({
    int pageNumber = 1,
    Position position,
    int dist,
    int wilayaID = 0,
    int communeID = 0,
  }) async {
    dynamic response;
    DateTime dateStart = DateTime.now();
    print("############## POS get Request start ");
    if (wilayaID == 0 && communeID == 0) {
      if (dist == 0) {
        response = await Network.getWithToken(
          '/pos/nearby?size=10&page=${pageNumber}',
        );
      } else {
        response = await Network.getWithToken(
          '/pos/nearby?lat=${position.latitude}&lon=${position.longitude}&dist=${dist}&size=10&page=${pageNumber}',
        );
      }
    } else {
      if (communeID > 0) {
        if (dist == 0) {
          response = await Network.getWithToken(
            '/pos/nearby?&commune=${communeID}&size=10&page=${pageNumber}',
          );
        } else {
          response = await Network.getWithToken(
            '/pos/nearby?lat=${position.latitude}&lon=${position.longitude}&dist=${dist}&commune=${communeID}&size=10&page=${pageNumber}',
          );
        }
      } else {
        if (dist == 0) {
          response = await Network.getWithToken(
            '/pos/nearby?wilaya=${wilayaID}&size=10&page=${pageNumber}',
          );
        } else {
          response = await Network.getWithToken(
            '/pos/nearby?lat=${position.latitude}&lon=${position.longitude}&dist=${dist}&wilaya=${wilayaID}&size=10&page=${pageNumber}',
          );
        }
      }
    }
    if (response == null) return null;
    DateTime dateEnd = DateTime.now();
    Duration difference = dateEnd.difference(dateStart);

    print("############## POS get Request end in :  ${difference}");
    print(response);
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }

  static Future<http.Response> getPos(id) async {
    final fingerprint = await DeviceInfo.getFingerprint();
    final response =
        await Network.getWithToken('/pos/details/$id?fingerprint=$fingerprint');
    if (response == null) return null;
    if (response.statusCode == 200) {
      return response;
    } else {
      ServerResponse.serverResponseHandler(response: response);
      return null;
    }
  }
}
