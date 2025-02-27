import 'package:djibly/app/core/extensions/list_extension.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/styles.dart';
import 'package:djibly/models/user.dart';
import 'package:djibly/providers/auth_provider.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:djibly/ui/components/buttons/rounded_elevated_button.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:djibly/utilities/validate.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  static const String routeName = 'register_page';
  String phoneRegister;

  RegisterPage({this.phoneRegister});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String message = '';
  String firstName;
  String lastName;
  String phoneRegister;
  String countryCode = '213';
  String token;
  bool condition = true;
  Future<User> futureUser;
  bool isLoading;

  void redirectTo(String page) async {
    Navigator.of(context).pop();
    await Provider.of<AuthProvider>(context).redirectTo(page);
  }

  @override
  void initState() {
    super.initState();
    phoneRegister = widget.phoneRegister;
  }

  Future<void> register() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      await Provider.of<AuthProvider>(context, listen: false)
          .register(firstName, lastName, email, phoneRegister, context)
          .then((response) {
        if (response)
          Provider.of<AuthProvider>(context, listen: false)
              .redirectToHomePage();
        // Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isLoading = Provider.of<AuthProvider>(context).getLoader();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    //fit: BoxFit.fill,
                  ),
                  _buildSignIn(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(

          /* color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
          ) */
          ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    context.translate.first_name_text,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration:
                      inputDecorationStyle(prefixIcon: FeatherIcons.user),
                  validator: (value) {
                    firstName = value.trim();
                    if (value == null || value.isEmpty) {
                      return context.translate.first_name_empty_error;
                    }
                    if (!nameRegex.hasMatch(value)) {
                      return context.translate.first_name_not_valid_error;
                    }
                    return null;
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    context.translate.name_text,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration:
                      inputDecorationStyle(prefixIcon: FeatherIcons.user),
                  validator: (value) {
                    lastName = value.trim();
                    if (value == null || value.isEmpty) {
                      return context.translate.last_name_empty_error;
                    }
                    if (!nameRegex.hasMatch(value)) {
                      return context.translate.last_name_not_valid_error;
                    }
                    return null;
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    context.translate.email_text,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      inputDecorationStyle(prefixIcon: FeatherIcons.mail),
                  validator: (value) {
                    email = value.trim();

                    if (value == null || value.isEmpty) {
                      return context.translate.address_empty_error;
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return context.translate.address_empty_error;
                    }
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.maxFinite,
              height: 50,
              child: CustomRoundedElevatedButton(
                onPressed: () async {
                  register();
                },
                buttonColor: DjiblyColor,
                isDisabled: isLoading,
                child: !isLoading
                    ? Text(
                        context.translate.register_text,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      )
                    : SizedBox(
                        height: 15.0,
                        width: 15.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2.0,
                        ),
                      ),
              ),
            ),
          ].addSeparators(SizedBox(
            height: 16,
          )),
        ),
      ),
    );
  }
}
