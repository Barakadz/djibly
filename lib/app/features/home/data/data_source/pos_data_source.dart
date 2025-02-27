import 'package:djibly/app/features/pos/data/data_source/remote_data_source.dart';
import 'package:geolocator/geolocator.dart';

import '../../domian/pos_entity.dart';

abstract class POSDataSource {
  Future<List<PosEntity>> fetchNearbyPos({
    int pageNumber = 1,
    Position position,
    int dist = 10,
  });
}
