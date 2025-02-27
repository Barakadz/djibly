import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/main.dart';
import 'package:djibly/models/user.dart';
import 'package:djibly/pages/cart/badge.dart';
import 'package:djibly/pages/home/Drawer/custom_drawer.dart';
import 'package:djibly/pages/home/tabs/home_tab/home_tab.dart';
import 'package:djibly/pages/search/search_page.dart';
import 'package:djibly/services/device_info_service.dart';
import 'package:djibly/services/local_notification_service.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../presenters/profile_presenter.dart';
import '../../repositories/user_repository.dart';
import '../cart/cart_page.dart';
import 'tabs/home_tab/map_view/home_maps_view.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home_page';

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfilePresenter>(context, listen: true).getUser();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (homeController.selectedTab.value != 0) {
            homeController.setSelectedTab(0);
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          key: homeController.drawerKey,
          drawer: DrawerMenu(),
          bottomNavigationBar: _buildBottomNavigationBar(context),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Obx(
                () => _getSelectedTabView(homeController.selectedTab.value)),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1),
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Obx(() => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: context.colorScheme.primary,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedItemColor: Colors.grey.shade400,
            elevation: 0,
            key: homeController.bottomNavigationKey,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home, size: 21),
                activeIcon: Icon(Iconsax.home5, size: 22),
                label: context.translate.home_text,
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.shop, size: 20),
                activeIcon: Icon(Iconsax.shop5, size: 20),
                label: context.translate.store_text,
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.shopping_bag, size: 20),
                activeIcon: Icon(Iconsax.shopping_bag5),
                label: context.translate.my_cart,
              ),
              BottomNavigationBarItem(
                icon: Icon(FeatherIcons.user, size: 20),
                label: context.translate.account_text,
              ),
            ],
            currentIndex: homeController.selectedTab.value,
            onTap: (index) {
              homeController.setSelectedTab(index);
            },
          )),
    );
  }

  Widget _getSelectedTabView(int index) {
    switch (index) {
      case 0:
        return HomeTab();
      case 1:
        return HomeMapsView();
      case 2:
        CartPage.showReturn = false;
        return CartPage();
      case 3:
        return DrawerMenu();
      default:
        return HomeTab();
    }
  }
}

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  final GlobalKey bottomNavigationKey = GlobalKey();
  final RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();

    initNotification();
  }

  void setSelectedTab(int index) {
    selectedTab.value = index;
  }

  void initNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FirebaseMessaging.onMessage.listen ${message.messageId}");

      if (message.notification != null) {
        print(
            "FirebaseMessaging.onMessage.listen.notification ${message.notification}");

        LocalNotificationService.showLocalNotification(
            message.notification.title,
            message.notification.body,
            message.data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Handle opened app notification
      }
    });

    messaging.getToken().then((String token) async {
      if (token != null) {
        String device = await DeviceInfo.getDevice();
        String fingerprint = await DeviceInfo.getFingerprint();
        print(":::::::::::::: Device Name $device");
        print(":::::::::::::: Finger Print $fingerprint");

        final data = {
          'notification_token': token,
          'device_name': device,
          'fingerprint': fingerprint
        };
        UserRepository.refreshUserNotification(data);
      }
    });
  }
}
