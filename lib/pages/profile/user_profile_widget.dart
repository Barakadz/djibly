import 'package:djibly/models/user.dart';
import 'package:djibly/pages/profile/header_widget.dart';
import 'package:djibly/pages/profile/user_informations_widget.dart';
import 'package:djibly/pages/profile/wave_clipper.dart';
import 'package:djibly/presenters/profile_presenter.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../presenters/profile_controller.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({Key key}) : super(key: key);

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    
    print("@@@@@@ Get User Profile ");
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (profileController) {
          if (profileController.user == null) {
            if (profileController.errorFetching) {
              return Center(
                child: IconButton(
                  icon: Icon(
                    Icons.refresh,
                    size: 50,
                    color: DjiblyColor,
                  ),
                  onPressed: () {
                    // profileController.errorFetching.value = false;
                    // cartPresenter.fetchItems(true);
                  },
                ),
              );
            } else {
              return Center(
                child: Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                    strokeWidth: 2.0,
                  ),
                ),
              );
            }
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  HeaderWidget(
                      headerHeight: MediaQuery.of(context).size.height * 0.25),
                  UserInformationWidget()
                ],
              ),
            );
          }
        });
  }
}
