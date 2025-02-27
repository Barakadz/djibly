import 'dart:convert';

import 'package:djibly/app/features/pos/data/data_source/pos_data_source.dart';
import 'package:djibly/app/features/pos/domian/pos_entity.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

import '../../../../../repositories/pos_repository.dart';

class POSRemoteDataSource extends POSDataSource {
  @override
  Future<List<PosEntity>> fetchNearbyPos(
      {int pageNumber = 1, Position position, int dist = 10}) async {
    List<dynamic> _nearbyPosList = [];
    List<PosEntity> posList = [];

    final response = await PosRepository.getNearbyPosPagination(
      dist: dist,
      pageNumber: pageNumber,
      position: position,
    );
    if (response != null) {
      print("response != null");
      print("distance ${dist}");
      final result = json.decode(utf8.decode(response.bodyBytes));
      try {
        result['data']['pos'].forEach((pos) {
          posList.add(new PosEntity.fromJson(pos));
          print("#########${pos}");
        });
      } catch (exception) {
        print(exception);
        return posList;
      }
    }
    _nearbyPosList = posList;

    return posList;
  }
}
