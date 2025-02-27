import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/user.dart';
import 'package:djibly/pages/profile/edit_profile_widget.dart';
import 'package:djibly/presenters/local_controller.dart';
import 'package:djibly/presenters/profile_presenter.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../presenters/local_presenter.dart';

class UserInformationWidget extends StatefulWidget {
  final User userData;

  UserInformationWidget({this.userData});

  @override
  _UserInformationWidgetState createState() => _UserInformationWidgetState();
}

class _UserInformationWidgetState extends State<UserInformationWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePresenter>(
      builder: (_, profilePresenter, ch) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: ListTile(
                            title: Text(
                              profilePresenter.user.firstName != null
                                  ? profilePresenter.user.firstName
                                  : '',
                            ),
                            leading: Icon(
                              FeatherIcons.user,
                              size: 18,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1.0,
                          color: Color(0xffa2adbc),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: ListTile(
                            title: Text(
                              profilePresenter.user.lastName != null
                                  ? profilePresenter.user.lastName
                                  : '',
                            ),
                            leading: Icon(
                              FeatherIcons.user,
                              size: 18,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1.0,
                          color: Color(0xffa2adbc),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: ListTile(
                            title: Text(
                              profilePresenter.user.email != null
                                  ? profilePresenter.user.email
                                  : '',
                            ),
                            leading: Icon(
                              FeatherIcons.mail,
                              size: 18,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1.0,
                          color: Color(0xffa2adbc),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: ListTile(
                            title: Text(
                              profilePresenter.user.phoneNumber != null
                                  ? profilePresenter.user.phoneNumber
                                  : '',
                            ),
                            leading: Icon(
                              FeatherIcons.phone,
                              size: 18,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1.0,
                          color: Color(0xffa2adbc),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 24.0,
                        bottom: 24,
                      ),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () async {
                              _editProfileModel(context, profilePresenter.user);
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FeatherIcons.edit,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    context.translate.edit_text,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            // padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(80.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  //delete account
                ],
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () => showDeleteAccountConfirmation(context),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 24,
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.shade500),
                      ),
                      child: Center(
                        child: Text(
                          context.translate.delete_account_text,
                          style: TextStyle(
                            color: Colors.red.shade500,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProfileModel(globalContext, User user) {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return EditProfileWidget(user: user);
        });
  }

  void showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.translate.delete_account_confirmation_text),
          content: Text(context.translate.delete_account_confirmation_body),
          actions: <Widget>[
            TextButton(
              child: Text(context.translate.cancel_text),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                context.translate.delete_text,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                print("-----------delete account function ");
                await Get.find<LocaleController>().deletePos();
                // Implement account deletion logic here
                // Navigator.of(context).pop();
                // After successful deletion, you might want to log out the user and navigate to the login screen
              },
            ),
          ],
        );
      },
    );
  }
}
