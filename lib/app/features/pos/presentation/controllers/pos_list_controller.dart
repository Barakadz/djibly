import 'dart:ffi';

import 'package:awesome_select/awesome_select.dart';
import 'package:awesome_select/src/model/chosen.dart';
import 'package:djibly/models/pos.dart';
import 'package:djibly/models/wilaya.dart';
import 'package:djibly/presenters/nearby_pos_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../models/commune.dart';

enum PermissionStatus {
  denied,
  deniedForever,
  granted,
  isLoading,
}

class POSListController extends GetxController {
  final list = <Pos>[].obs;
  final willayList = <S2Choice<String>>[].obs;
  final communeList = <S2Choice<String>>[].obs;
  final permissionStatus = PermissionStatus.isLoading.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isLoadingWilaya = false.obs;
  RxBool isLoadingCommune = false.obs;
  RxBool needPermission = true.obs;
  RxInt selectedSegment = 5.obs;
  RxInt currentPage = 1.obs;
  RxInt wilayaID = 0.obs;
  RxInt communeID = 0.obs;
  RxString wilayaText = "".obs;
  RxString communeText = "".obs;
  final ScrollController scrollController = ScrollController();
  final wilayaIdController = TextEditingController();
  final communeIdController = TextEditingController();
  Position position;
  @override
  Future<void> onInit() async {
    super.onInit();
    scrollController.addListener(_onScroll);
    isLoading(true);
    await checkPermissionsAndGetData();
    printInfo(info: "######### onInit");
  }

  Future<void> checkPermissionsAndGetData() async {
    bool permissionIsAccess = await checkLocationPermissions();
    if (permissionIsAccess) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      printInfo(info: "Permissions access OK");

      final listData = await fetchNearbyPos(
        dist: selectedSegment.value,
        pageNumber: currentPage.value,
      );

      list.addAll(listData);
      print("init controller");
    }
    list.refresh();
    isLoading(false);
  }

  Future<bool> checkLocationPermissions() async {
    print("######### checkLocationPermissions");
    print(permissionStatus.value);
    permissionStatus.value = PermissionStatus.isLoading;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      final res = await Geolocator.openLocationSettings();
      if (res == false) {
        permissionStatus.value = PermissionStatus.denied;
      }

      //return Future.error('Location services are disabled.');
    }

    printInfo(info: "#########  Permissions access OK");

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      printInfo(info: "======>> Permissions access denied");

      if (permission == LocationPermission.denied) {
        permissionStatus.value = PermissionStatus.denied;
        printInfo(info: "======>> Permissions access denied");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      needPermission.value = false;
      permissionStatus.value = PermissionStatus.deniedForever;
      printInfo(info: "======>> Permissions access denied forever");
      return Future.error('Location permissions are permanently denied.');
    }

    permissionStatus.value = PermissionStatus.granted;
    printInfo(info: "======>> Permissions access granted");
    return true;
  }

  Future<void> _onScroll() async {
    printInfo(info: "######### _onScroll");
    print(
      "scrollController.position.pixels ${scrollController.position.pixels}",
    );
    print(
      "scrollController.position.maxScrollExtent ${scrollController.position.maxScrollExtent}",
    );
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      printInfo(info: "######### max scroll extent");
      isLoadingMore.value = true;
      currentPage.value = currentPage.value + 1;

      final listData = await fetchNearbyPos(
        dist: selectedSegment.value,
        pageNumber: currentPage.value,
        communeID: communeID.value,
        wilayaID: wilayaID.value,
      );
      if (listData.isNotEmpty) {
        printInfo(info: "######### listData.isNotEmpty");
        list.addAll(listData);
        list.refresh();
      }
      isLoadingMore.value = false;
    }
  }

  Future<List<Pos>> fetchNearbyPos({
    int pageNumber = 1,
    int dist = 10,
    int wilayaID = 0,
    int communeID = 0,
  }) async {
    final posList = await NearbyPosPresenter().fetchNearbyPos(
      position: position,
      dist: dist,
      pageNumber: pageNumber,
      communeID: communeID,
      wilayaID: wilayaID,
    );

    return posList;
  }

  void fetchWithFilter({
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
    list.refresh();
    printInfo(info: "############### POS List Length  ${list.length}");

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
    print("================ get willaya call ");
    isLoadingWilaya(true);
    willayList.value = await Wilaya().getWilayas();
    print("================ get willaya call End ");

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
