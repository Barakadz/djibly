import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/user.dart';
import 'package:djibly/pages/profile/header_widget.dart';
import 'package:djibly/pages/profile/user_informations_widget.dart';
import 'package:djibly/pages/profile/user_profile_widget.dart';
import 'package:djibly/pages/profile/wave_clipper.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presenters/profile_presenter.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = 'user_profile_page';

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isLoading = false;

  Future<void> initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonStyles.customAppBar(context, context.translate.profile_text,
          showCart: false),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: UserProfileWidget(),
        ),
      ),
    );
  }
}
