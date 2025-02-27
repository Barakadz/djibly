import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../utilities/constants.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/verify_otp.dart';

class AuthController extends GetxController {
  final SendOtp sendOtpUsecase;
  final VerifyOtp verifyOtpUsecase;
  final SignIn signInUsecase;
  final SignOut signOutUsecase;
  final GetCurrentUser getCurrentUserUsecase;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool checkboxValue = false.obs;

  AuthController({
    this.sendOtpUsecase,
    this.verifyOtpUsecase,
    this.signInUsecase,
    this.signOutUsecase,
    this.getCurrentUserUsecase,
  });

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> sendOtp(String phoneNumber) async {
    print("------------------- sendOtp ------------------- ");
    isLoading.value = true;
    final result = await sendOtpUsecase.call(phoneNumber);
    result.fold((l) => print(l.message), (r) {
      if (r == true) {
        
        storePhone(phoneNumber);
        Provider.of<AuthProvider>(MyApp.navigatorKey.currentContext,
                listen: false)
            .redirectToVerifyPage();
      }
    });
    isLoading.value = false;
    return result;
  }

  storePhone(msisdn) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('msisdn', msisdn);
  }

  Future<void> verifyOtp(String otp) async {
    return await verifyOtpUsecase.call(otp);
  }

  Future<void> signIn(String phoneNumber) async {
    return await signInUsecase.call(phoneNumber);
  }

  Future<void> signOut() async {
    return await signOutUsecase.call(null);
  }

  Future<void> launchPrivacyPolicy(BuildContext context) async {
    return await launchUrl(
      Uri.parse(Localizations.localeOf(context).languageCode == "ar"
          ? ArabicPrivacyURL
          : PrivacyURL),
    );
  }
}
