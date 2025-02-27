import 'dart:async';

import 'package:djibly/helpers/styles.dart';
import 'package:djibly/main.dart';
import 'package:djibly/providers/auth_provider.dart';
import 'package:djibly/services/http_services/djezzy_auth.dart';
import 'package:djibly/ui/components/buttons/rounded_elevated_button.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class VerifyOtpPage extends StatefulWidget {
  static const String routeName = 'verify_otp';

  VerifyOtpPage();

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  OTPInteractor _otpInteractor = OTPInteractor();

  OTPTextEditController otpTextEditController;
  final _codeController = TextEditingController();
  final GlobalKey<FormState> _formVerifyKey = GlobalKey<FormState>();
  Timer timer;
  int start = 59;
  bool isSent = true;
  String phone;
  bool isVerified = false;
  bool isLoading = false;

  Future<void> getPhone() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    setState(() {
      phone = storage.getString('msisdn');
    });
  }

  verifyOtp() async {
    if (_formVerifyKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      final otp = _codeController.text.trim();

      DjezzyAuth djezzyAuth = new DjezzyAuth();
      bool response = await djezzyAuth.verifyOTP(phone, otp);
      if (response) {
        await login();
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> login() async {
    bool response =
        await Provider.of<AuthProvider>(context, listen: false).login(phone);
    if (response != null) {
      if (response) {
        Provider.of<AuthProvider>(MyApp.navigatorKey.currentContext,
                listen: false)
            .redirectToHomePage();
      } else {
        Provider.of<AuthProvider>(context, listen: false)
            .redirectToRegisterPage(this.phone);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    getPhone();
    retrieveOTPDynamically();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (start <= 0) {
            timer.cancel();
            start = 0;
            isSent = false;
          } else {
            start = start - 1;
            isSent = true;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _otpInteractor.stopListenForCode();
    if (otpTextEditController != null) otpTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  child: Form(
                key: _formVerifyKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 32,
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      //fit: BoxFit.fill,
                    ),
                    Text(
                      AppLocalizations.of(context).verify_phone_title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFe31D1A)),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .verify_phone_body(phone),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _codeController,
                      textAlign: TextAlign.center,
                      onFieldSubmitted: (String value) {
                        verifyOtp();
                      },
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        height: 0.7,
                        letterSpacing: 0,
                      ),
                      // decoration: inputDecorationStyle(),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Column(
                      children: <Widget>[
                        isSent
                            ? Text(
                                AppLocalizations.of(context)
                                    .otp_not_received_text,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  DjezzyAuth djezzyAuth = new DjezzyAuth();
                                  final response =
                                      await djezzyAuth.sendOTP(phone);
                                  if (response) {
                                    startTimer();
                                    setState(() {
                                      start = 59;
                                      isSent = true;
                                    });
                                  }

                                  retrieveOTPDynamically();
                                },
                                child: Text(
                                  AppLocalizations.of(context)
                                      .request_new_code_text,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFe31D1A),
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '0:' + start.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      height: 55,
                      child: CustomRoundedElevatedButton(
                        isDisabled: isLoading,
                        onPressed: !isLoading
                            ? () async {
                                verifyOtp();
                              }
                            : null,
                        buttonColor: DjiblyColor,
                        child: Text(
                          AppLocalizations.of(context)
                              .verify_text
                              .toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    )
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  retrieveOTPDynamically() {
    try {
      if (otpTextEditController != null) otpTextEditController.dispose();
    } catch (exception) {
      print(exception.toString());
    }
    _otpInteractor.getAppSignature().then((value) => print('signature'));
    otpTextEditController = OTPTextEditController(
      codeLength: 6,
      onCodeReceive: (code) {
        _codeController..text = code;
      },
    )..startListenRetriever(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      );
  }
}
