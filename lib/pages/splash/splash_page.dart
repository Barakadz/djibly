import 'package:djibly/providers/auth_provider.dart';
import 'package:djibly/ui/components/buttons/rounded_elevated_button.dart';
import 'package:djibly/ui/components/pop_ups/single_action_popup.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  const SplashScreen({Key key}) : super(key: key);

  initAuthProvider(context) async {}

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: controller.obx(
          (state) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                )
                /*  Image.asset(
                  "assets/images/logo_djibly.png",
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(DjiblyColor),
                    strokeWidth: 2.0,
                    color: DjiblyColor,
                  ),
                ) */
              ],
            ),
          ),
          onError: (error) => Center(
            child: SingleActionPopup(
              action: () => SystemNavigator.pop(),
              title: error == 408
                  ? "Probléme de Connexion"
                  : "Quelque chose s'est mal passé",
              body: error == 408
                  ? "Il y a une erreur de connexion, veuillez vérifier votre connexion Internet et réessayer"
                  : "Quelque chose s'est mal passé, veuillez réessayer plus tard",
              iconData: Icons.error_outline_outlined,
            ),
          ),
          onLoading: Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  showErrorPopup(int errorCode, BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) => SingleActionPopup(
              action: () => SystemNavigator.pop(),
              title: errorCode == 408
                  ? "Probléme de Connexion"
                  : "Quelque chose s'est mal passé",
              body: errorCode == 408
                  ? "Il y a une erreur de connexion, veuillez vérifier votre connexion Internet et réessayer"
                  : "Quelque chose s'est mal passé, veuillez réessayer plus tard",
              iconData: Icons.error_outline_outlined,
            ));
  }
}

//create controller for splash screen with state mixin
class SplashController extends GetxController with StateMixin<int> {
  int errorCode;

  @override
  void onInit() async {
    super.onInit();
    await initAuthProvider();
  }

  initAuthProvider() async {
    printInfo(info: " SplashController ######### initAuthProvider");
    change(null, status: RxStatus.loading());
    final responseCode = await Provider.of<AuthProvider>(
            MyApp.navigatorKey.currentContext,
            listen: false)
        .initAuthProvider();
    if (responseCode != 0) {
      printInfo(info: " SplashController ######### initAuthProvider => error");
      errorCode = responseCode;
      change(null, status: RxStatus.error(errorCode.toString()));
    }
  }
}
