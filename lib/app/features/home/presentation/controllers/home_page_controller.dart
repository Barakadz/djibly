import 'dart:ffi';

import 'package:awesome_select/awesome_select.dart';
import 'package:awesome_select/src/model/chosen.dart';
import 'package:djibly/models/pos.dart';
import 'package:djibly/models/wilaya.dart';
import 'package:djibly/presenters/home/home_tab_presenter.dart';
import 'package:djibly/presenters/nearby_pos_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../models/commune.dart';

class HomePageController extends GetxController {
  final list = <Pos>[].obs;
  final willayList = <S2Choice<String>>[].obs;
  final communeList = <S2Choice<String>>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isLoadingWilaya = false.obs;
  RxBool isLoadingCommune = false.obs;
  RxInt selectedSegment = 10.obs;
  RxInt currentPage = 1.obs;
  RxInt wilayaID = 0.obs;
  RxInt communeID = 0.obs;
  RxString wilayaText = "".obs;
  RxString communeText = "".obs;
  final ScrollController scrollController = ScrollController();
  final wilayaIdController = TextEditingController();
  final communeIdController = TextEditingController();
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;

    final listData = await fetchNearbyPos(
      dist: selectedSegment.value,
      pageNumber: currentPage.value,
    );
    list.addAll(listData);
    isLoading.value = false;

    print("init controller");
    scrollController.addListener(_onScroll);
  }

  Future<void> _onScroll() async {
    final listData = await HomeTabPresenter().fetchIndexProductsList();
  }

  Future<List<Pos>> fetchNearbyPos({
    int pageNumber = 1,
    int dist = 10,
    int wilayaID = 0,
    int communeID = 0,
  }) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final posList = await NearbyPosPresenter().fetchNearbyPos(
      position: position,
      dist: dist,
      pageNumber: pageNumber,
      communeID: communeID,
      wilayaID: wilayaID,
    );

    return posList;
  }

  void ftchWithFilter({
    int pageNumber = 1,
    int dist = 10,
  }) async {
    isLoading(true);
    list.clear();
    final listData = await fetchNearbyPos(
      pageNumber: pageNumber,
      dist: dist,
      communeID: communeID.value,
      wilayaID: wilayaID.value,
    );
    list.addAll(listData);
    isLoading(false);
  }

  Future<void> openGoogleMaps(double latitude, double longitude) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void onsWillayaChange(S2SingleSelected<String> value) {
    print(
      "########## willaya text ${value.value}",
    );
    communeID.value = 0;
    if (value != wilayaID.value) {
      communeIdController..text = '';
      wilayaID.value = int.tryParse(value.value);
      print(
        "########## willaya text ${value.value}",
      );
      wilayaText.value = value.title;
      communeID.value = 0;
      getCommune();
    }
  }

  void onsCommuneChange(S2SingleSelected<String> value) {
    print(
      "########## Commune text ${value.value}",
    );
    if (value != communeID.value) {
      communeIdController..text = '';
      communeID.value = int.tryParse(value.value);
      print(
        "willaya text ${communeIdController.text}",
      );
      communeText.value = value.title;
    }
  }

  void getWilayas() async {
    isLoadingWilaya(true);
    willayList.value = await Wilaya().getWilayas();
    isLoadingWilaya(false);
    if (wilayaID.value != 0) getCommune();
  }

  void getCommune() async {
    print('##################  willaya ID ${wilayaID.value}');
    communeList.value = [];
    isLoadingCommune(true);

    if (wilayaID.value != 0) {
      final listC = await Commune.getCommunes(wilayaID.value);
      communeList.value = [...listC];
      communeList.refresh();
    }
    isLoadingCommune(false);
  }
}
