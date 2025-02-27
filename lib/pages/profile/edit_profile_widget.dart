import 'package:djibly/app/core/extensions/list_extension.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/user.dart';
import 'package:djibly/presenters/profile_presenter.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../helpers/styles.dart';

class EditProfileWidget extends StatefulWidget {
  User user;
  EditProfileWidget({this.user});

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _firstName..text = widget.user.firstName;
    _lastName..text = widget.user.lastName;
    _email..text = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(20.0)),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
                            child: Text(context.translate.edit_text,
                                style: context.text.titleLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Divider(color: Colors.grey),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.translate.first_name_empty_error;
                              }
                              if (!nameRegex.hasMatch(value)) {
                                return context
                                    .translate.first_name_not_valid_error;
                              }
                              return null;
                            },
                            controller: _firstName,
                            textCapitalization: TextCapitalization.words,
                            decoration: inputDecorationStyle(
                              prefixIcon: Icons.person_2_outlined,
                            ),
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
                            onChanged: (String value) {
                              _validateForm();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.translate.last_name_empty_error;
                              }
                              if (!nameRegex.hasMatch(value)) {
                                return context
                                    .translate.last_name_not_valid_error;
                              }
                              return null;
                            },
                            controller: _lastName,
                            decoration: inputDecorationStyle(
                              prefixIcon: Icons.person_2_outlined,
                            ),
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
                            controller: _email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.translate.mail_empty_error;
                              }
                              if (!emailRegex.hasMatch(value)) {
                                return context.translate.email_not_valid_error;
                              }
                              return null;
                            },
                            decoration: inputDecorationStyle(
                              prefixIcon: FeatherIcons.mail,
                            ),
                          ),
                        ],
                      ),
                    ].addSeparators(Column(
                      children: [
                        SizedBox(
                          height: 12,
                        )
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (form.validate()) _updateProfileInfos();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          context.colorScheme.primary,
                        ),
                      ),
                      child: Text(
                        context.translate.edit_text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      // padding:
                      // EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(80.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _updateProfileInfos() async {
    Loader.show(
      context,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.black),
        strokeWidth: 2.0,
      ),
    );

    bool response = await Provider.of<ProfilePresenter>(context, listen: false)
        .updateUserInformation(_firstName.text, _lastName.text, _email.text);

    if (response) {
      ToastService.showSuccessToast(
        context.translate.edit_profile_successfully_text,
      );
      Navigator.pop(context);
    }

    Loader.hide();
  }

  bool _validateForm() {
    if (_email.text.length < 3 ||
        _firstName.text.length < 3 ||
        _lastName.text.length < 3) {
      setState(() {
        _isFormValid = false;
      });
      return false;
    }
    if (_email.text == widget.user.email &&
        _firstName.text == widget.user.firstName &&
        _lastName.text == widget.user.lastName) {
      setState(() {
        _isFormValid = false;
      });
      return false;
    }
    setState(() {
      _isFormValid = true;
    });
    return true;
  }
}
