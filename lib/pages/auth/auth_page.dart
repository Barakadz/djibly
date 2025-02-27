import 'package:djibly/app/core/extensions/list_extension.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/styles.dart';
import 'package:djibly/main.dart';
import 'package:djibly/pages/auth/auth_controller.dart';
import 'package:djibly/presenters/local_presenter.dart';
import 'package:djibly/providers/auth_provider.dart';
import 'package:djibly/services/http_services/djezzy_auth.dart';
import 'package:djibly/ui/components/buttons/rounded_elevated_button.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:djibly/utilities/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class AuthPage extends StatefulWidget {
  static const String routeName = 'auth_page';
  // bool isForgetPassword;

  AuthPage();

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  final _phoneController = TextEditingController();
  final GlobalKey<FormState> _formRegisterKey = GlobalKey<FormState>();
  String countryCode = '213';
  String token;
  bool isLoading = false;

  bool checkboxValue = false;

  @override
  Future<void> initState() {
    super.initState();

    _phoneController..text = "";
  }

  storePhone(msisdn) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('msisdn', msisdn);
  }

  storeVerificationId(verificationId) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('verificationId', verificationId);
  }

  Future<void> sendOTP() async {
    if (_formRegisterKey.currentState.validate()) {
      while (_phoneController.text.trim()[0] == '0') {
        _phoneController.text = _phoneController.text.trim().substring(1);
      }
      final msisdn = countryCode + _phoneController.text.trim();

      setState(() {
        isLoading = true;
      });

      await Future.delayed(Duration(seconds: 5));
      DjezzyAuth djezzyAuth = new DjezzyAuth();
      bool response = await djezzyAuth.sendOTP(msisdn);
      if (response) {
        storePhone(msisdn);
        Provider.of<AuthProvider>(MyApp.navigatorKey.currentContext,
                listen: false)
            .redirectToVerifyPage();
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController(context));

    AuthController controller = Get.find();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                   SizedBox(
                    height: 32,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    //fit: BoxFit.fill,
                  ),
                  _buildAuthIn(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthIn(BuildContext context) {
    return Form(
      key: _formRegisterKey,
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context).phone_number_text,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  maxLength: 10,
                  onFieldSubmitted: (String value) {
                    sendOTP();
                  },
                  decoration: inputDecorationStyle(
                    prefixIcon: Icons.phone_android_sharp,
                  ),
                  validator: (value) {
                    _phoneController.text = value.trim();
                    return Validate.validatePhone(_phoneController.text);
                  }),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: double.maxFinite,
            height: 50,
            child: CustomRoundedElevatedButton(
              onPressed: () async {
                sendOTP();
              },
              buttonColor: DjiblyColor,
              isDisabled: isLoading,
              child: Text(
                AppLocalizations.of(context).send_text.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          FormField<bool>(
            builder: (state) {
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: checkboxValue,
                          fillColor: MaterialStateProperty.all(DjiblyColor),
                          onChanged: (value) {
                            setState(() {
                              checkboxValue = value;
                              state.didChange(value);
                            });
                          }),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            launchUrl(
                              Uri.parse(Localizations.localeOf(context)
                                          .languageCode ==
                                      "ar"
                                  ? ArabicPrivacyURL
                                  : PrivacyURL),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context).accept_privacy_text,
                            style: context.text.labelLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    state.errorText ?? '',
                    style: context.text.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade600,
                    ),
                  )
                ],
              );
            },
            validator: (value) {
              if (!checkboxValue) {
                return AppLocalizations.of(context).accept_privacy_error_text;
              } else {
                return null;
              }
            },
          ),
        ].addSeparators(SizedBox(
          height: 16,
        )),
      ),
    );
  }
}
