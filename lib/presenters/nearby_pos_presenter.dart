import 'dart:async';
import 'dart:convert';

import 'package:djibly/models/pos.dart';
import 'package:djibly/repositories/pos_repository.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NearbyPosPresenter with ChangeNotifier {
  List<Pos> _nearbyPosList = [];

  Future<List<Pos>> fetchNearbyPos({
    int pageNumber = 1,
    Position position,
    int dist = 10,
    int wilayaID = 0,
    int communeID = 0,
  }) async {
    _nearbyPosList = [];
    List<Pos> posList = [];

    final response = await PosRepository.getNearbyPosPagination(
      dist: dist,
      pageNumber: pageNumber,
      position: position,
      communeID: communeID,
      wilayaID: wilayaID,
    );
    if (response != null) {
      print("response != null");
      print("distance ${dist}");
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        result['data']['pos'].forEach((pos) {
          posList.add(new Pos.fromJson(pos));
          print("#########${pos}");
        });
      } catch (exception) {
        print(exception);
        return posList;
      }
    }
    _nearbyPosList = posList;
    notifyListeners();
    return posList;
  }

  List<Pos> getNearbyPos() {
    return [
      ..._nearbyPosList,
    ];
  }

  clearNearbyPosList() {
    _nearbyPosList = [];
  }
}
