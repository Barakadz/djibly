import 'package:awesome_select/awesome_select.dart';
import 'package:djibly/app/core/extensions/list_extension.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/app/features/pos/presentation/controllers/pos_list_controller.dart';
import 'package:djibly/models/pos.dart';
import 'package:djibly/pages/home/tabs/home_tab/map_view/pos_item_widget.dart';
import 'package:djibly/pages/home/tabs/home_tab/map_view/pos_widget.dart';
import 'package:djibly/pages/home/tabs/home_tab/products_view/home_products_view.dart';
import 'package:djibly/presenters/nearby_pos_presenter.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../models/commune.dart';
import '../../../../../models/wilaya.dart';
import '../../../../pos/pos_page.dart';
import 'widgets/filter_widget.dart';
import 'widgets/selected_filter_widget.dart';

class HomeMapsView extends StatelessWidget {
  GoogleMapController _controller;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  double _googleCameraZoom = 4;
  static LatLng _initialCameraPosition = LatLng(36.4516736, 3.1153286);
  static LatLng _myPosition;
  Position userPosition;
  bool _gettingPosition = false;
  Pos _selectedPos;
  bool isLoading = false;

  BitmapDescriptor _customMarker;

  @override
  Widget build(BuildContext context) {
    print("HomeMapsView => Rebuild");
    Get.put(POSListController());
    final controller = Get.find<POSListController>();
    return Obx(() => Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            /*  leading: IconButton(
                  icon: Icon(
                    homePresenter.getSelectedTab() == 0
                        ? Icons.menu
                        : Icons.arrow_back,
                    color: Colors.grey.shade600,
                    size: 22,
                  ),
                  onPressed: () {
                    homePresenter.getSelectedTab() == 0
                        ? _drawerKey.currentState.openDrawer()
                        : Provider.of<HomePresenter>(context, listen: false)
                            .setSelectedTab(0);
                  },
                ), */
            centerTitle: false,
            title: Text(context.translate.store_text),
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet<dynamic>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext bc) {
                      return MultiProvider(
                        providers: [
                          ChangeNotifierProvider<Commune>(
                            create: (_) => Commune(),
                          ),
                          ChangeNotifierProvider<Wilaya>(
                            create: (_) => Wilaya(),
                          ),
                        ],
                        child: FilterWidget(),
                      );
                    },
                  ).whenComplete(() {
                    controller.currentPage(1);
                    controller.fetchWithFilter(
                      pageNumber: controller.currentPage.value,
                      dist: controller.selectedSegment.value,
                    );
                  });
                },
                icon: Icon(
                  FeatherIcons.sliders,
                  color: Colors.grey.shade600,
                  size: 22,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Iconsax.notification,
                  color: Colors.grey.shade600,
                  size: 22,
                ),
              )
              /*  homePresenter.getSelectedTab() == 0
                  ? Consumer<CartPresenter>(
                      builder: (_, cartProvider, ch) {
                        return CartBadge(
                          value: cartProvider.getNumberOfItems() > 0
                              ? cartProvider.getNumberOfItems().toString()
                              : null,
                          child: IconButton(
                            padding: EdgeInsets.all(4),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartPage(),
                                ),
                              );
                            },
                            icon: Icon(
                              Iconsax.notification,
                              color: Colors.grey.shade600,
                              size: 22.0,
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox() */
            ],
            bottom: PreferredSize(
              preferredSize: Size(
                MediaQuery.of(context).size.width,
                controller.selectedSegment.value == 0 &&
                        controller.wilayaID.value == 0 &&
                        controller.communeID.value == 0
                    ? 0
                    : 40,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Obx(
                      () => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            if (controller.selectedSegment > 0)
                              SelectedFIlterWidget(
                                filterName: context.translate.distance_text,
                                filterValue:
                                    '${controller.selectedSegment.value} ${context.translate.km_text}',
                                onClose: () {
                                  controller.currentPage(1);
                                  controller.selectedSegment(0);
                                  controller.fetchWithFilter(
                                    pageNumber: controller.currentPage.value,
                                    dist: controller.selectedSegment.value,
                                  );
                                },
                              ),
                            if (controller.wilayaID > 0)
                              SelectedFIlterWidget(
                                filterName: context.translate.wilaya_text,
                                filterValue: '${controller.wilayaText.value}',
                                onClose: () {
                                  controller.currentPage(1);
                                  controller.wilayaID.value = 0;
                                  controller.fetchWithFilter(
                                    pageNumber: controller.currentPage.value,
                                    dist: controller.selectedSegment.value,
                                  );
                                },
                              ),
                            if (controller.communeID.value > 0)
                              SelectedFIlterWidget(
                                filterName: context.translate.commune_text,
                                filterValue: '${controller.communeText.value}',
                                onClose: () {
                                  controller.currentPage(1);
                                  controller.communeID.value = 0;
                                  controller.fetchWithFilter(
                                    pageNumber: controller.currentPage.value,
                                    dist: controller.selectedSegment.value,
                                  );
                                },
                              )
                          ].addSeparators(
                            SizedBox(
                              width: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Obx(
                  () => controller.permissionStatus ==
                              PermissionStatus.deniedForever &&
                          controller.selectedSegment > 0
                      ? _buildBannerMessage()
                      : controller.permissionStatus.value ==
                                  PermissionStatus.granted ||
                              controller.selectedSegment == 0
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          controller.permissionStatus.value ==
                                                  PermissionStatus.isLoading
                                              ? Colors.black12
                                              : Colors.black,
                                    ),
                                    onPressed: () async {
                                      await controller
                                          .checkPermissionsAndGetData();
                                    },
                                    child: controller.permissionStatus.value ==
                                            PermissionStatus.isLoading
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(context.translate
                                                  .active_location_text),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 1,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            context
                                                .translate.active_location_text,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => // initialize MarkersFil
                      /*   posPresenter.getNearbyPos().forEach((pos) {
            setMarker(
                LatLng(double.parse(pos.lat),
                    double.parse(pos.lon)),
                pos.name,
                _customMarker,
                pos);
                }); */
                      controller.isLoading.isTrue &&
                              controller.permissionStatus.value ==
                                  PermissionStatus.granted
                          ? SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  ...[1, 2, 3].map((e) => Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SizedBox(
                                          width: double.maxFinite,
                                          height: 160,
                                          child: ShimmerWidget(),
                                        ),
                                      )),
                                ],
                              ),
                            )
                          : ListView.separated(
                              controller: controller.scrollController,
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.all(16),
                              itemBuilder: (BuildContext context, int index) {
                                final Pos item = controller.list[index];
                                return POSItemWidget(
                                  pos: item,
                                );
                              },
                              itemCount: controller.list.length,
                              separatorBuilder:
                                  (BuildContext context, int index) => SizedBox(
                                height: 16,
                              ),
                            ),
                ),
              ),
              Obx(() => controller.isLoadingMore.isTrue
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Colors.grey.shade300)),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(width: 0.0, height: 0.0))
            ],
          ),
        ));
  }

  void setMarker(LatLng latLng, String markerId, markerIcon, Pos pos) {
    final marker = Marker(
      icon: markerIcon,
      draggable: false,
      markerId: MarkerId(markerId),
      position: latLng,
      onTap: () {
        if (pos != null) {}
      },
      onDragEnd: (LatLng position) {
        //
      },
    );
    // setState(() {
    _markers[MarkerId(markerId)] = marker;
    // });
  }

  Widget _buildBannerMessage() {
    return MaterialBanner(
      content: Text(
        "Access to location is denied forever. Clear the distance filter to view the POS list.",
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.orange.shade50,
      actions: [
        TextButton(
          onPressed: () {
            final controller = Get.find<POSListController>();

            controller.currentPage(1);
            controller.selectedSegment(0);
            controller.fetchWithFilter(
              pageNumber: controller.currentPage.value,
              dist: controller.selectedSegment.value,
            );
          },
          child: Text("Clear Filter", style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }

  void _removeMarkers() {
    _markers = <MarkerId, Marker>{};
  }

  _getCurrentLocation() async {
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

    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {})
        .catchError((e) {});
  }

  _fetchNearbyPos({
    int pageNumber = 1,
    int dist = 10,
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

    /*  await Provider.of<NearbyPosPresenter>(context, listen: false)
        .fetchNearbyPos(
      position: userPosition,
      dist: dist,
      pageNumber: pageNumber,
    ); */
  }
}
