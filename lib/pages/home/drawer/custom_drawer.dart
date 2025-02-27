import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/user.dart';
import 'package:djibly/pages/addresses/user_addresses_page.dart';
import 'package:djibly/pages/home/Drawer/language_button.dart';
import 'package:djibly/pages/orders_list/orders_list_page.dart';
import 'package:djibly/pages/profile/user_profile_page.dart';
import 'package:djibly/pages/wishlist/wishlist_page.dart';
import 'package:djibly/providers/auth_provider.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../presenters/profile_presenter.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool isLoading = false;
  var _data;
  String firstName, lastName, email, profilePicture;
  User user;
  String appVersion = '';

  logOut(context) async {
    // SharedPreferences.getInstance().then((storage) {
    //   storage.clear();
    // });
    // Navigator.of(context).pushReplacementNamed(AuthPage.routeName);
    Provider.of<AuthProvider>(context, listen: false).logout();
  }

  void _getUser() async {
    var storage = await SharedPreferences.getInstance();
    // final data = await ProfilePresenter().getUser();
    setState(() {
      // user = data;
      firstName = storage.get('first_name');
      lastName = storage.get('last_name');
      email = storage.get('email');
      profilePicture = storage.get('profile_picture');
    });
  }

  void initState() {
    _getUser();
    _getAppVersion();
    super.initState();
  }

  void _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: context.colorScheme.background),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    12,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                        child: profilePicture == null
                            ? SizedBox(width: 0.0, height: 0.0)
                            : CachedNetworkImage(
                                placeholderFadeInDuration: Duration(seconds: 0),
                                fadeInDuration: Duration(seconds: 0),
                                fadeOutDuration: Duration(seconds: 0),
                                imageUrl: Network.storagePath + profilePicture,
                                httpHeaders: Network.headersWithBearer,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                      "assets/images/user-avatar.png");
                                },
                                placeholder: (context, url) {
                                  return Image.asset(
                                      "assets/images/user-avatar.png");
                                },
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Column(
                      children: [
                        Text(
                          email != null ? email : "",
                          style: context.text.labelLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          firstName != null ? firstName + ' ' + lastName : "",
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        /*  InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(UpdatePosPage.routeName);
                          },
                          child: Text(
                            context.translate.manage_account_settings,
                            style: context.text.labelLarge.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ), */
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                          contentPadding: EdgeInsets.symmetric(),
                          tileColor: Colors.white,
                          title:
                              Text(AppLocalizations.of(context).profile_text),
                          trailing: Icon(
                            Icons.chevron_right,
                          ),
                          leading: Icon(
                            Icons.person_pin_sharp,
                            color: Colors.black54,
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(UserProfilePage.routeName);
                          }),
                      ListTile(
                          contentPadding: EdgeInsets.symmetric(),
                          tileColor: Colors.white,
                          title: Text(
                              AppLocalizations.of(context).my_addresses_text),
                          trailing: Icon(
                            Icons.chevron_right,
                          ),
                          leading: Icon(
                            Icons.map,
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(UserAddressesPage.routeName);
                          }),
                      Divider(
                        height: 8,
                      ),
                      ListTile(
                          contentPadding: EdgeInsets.symmetric(),
                          tileColor: Colors.white,
                          title:
                              Text(AppLocalizations.of(context).my_orders_text),
                          trailing: Icon(
                            Icons.chevron_right,
                          ),
                          leading: Icon(
                            Icons.receipt,
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(OrdersListPage.routeName);
                          }),
                      Divider(
                        height: 8,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(),
                        tileColor: Colors.white,
                        title: Text(AppLocalizations.of(context).favorite_text),
                        trailing: Icon(
                          Icons.chevron_right,
                        ),
                        leading: Icon(
                          Icons.favorite,
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(WishlistPage.routeName);
                        },
                      ),
                      Divider(
                        height: 8,
                      ),

                      ListTile(
                          contentPadding: EdgeInsets.symmetric(),
                          tileColor: Colors.white,
                          title: Text(
                              AppLocalizations.of(context).privacy_menu_text),
                          trailing: Icon(
                            Icons.chevron_right,
                          ),
                          leading: Icon(
                            Icons.assignment,
                          ),
                          onTap: () {
                            launchUrl(
                              Uri.parse(Localizations.localeOf(context)
                                          .languageCode ==
                                      "ar"
                                  ? ArabicPrivacyURL
                                  : PrivacyURL),
                              mode: LaunchMode.externalApplication,
                            );
                            //                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => AboutPage()));
                          }),
                      Divider(
                        height: 8,
                      ),
                      //           ListTile(
                      //               title: Text("A propos"),
                      //               trailing: Icon(Icons.arrow_right),
                      //               leading: Icon(Icons.auto_stories, color: Color(0xFFFF4646)),
                      //               onTap: () {
                      //
                      // //                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => AboutPage()));
                      //               }),
                      //           ListTile(
                      //               title: Text("FAQ"),
                      //               trailing: Icon(Icons.arrow_right),
                      //               leading: Icon(Icons.announcement, color: Color(0xFFFF4646)),
                      //               onTap: () {
                      //
                      // //                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => AboutPage()));
                      //               }),
                      ListTile(
                          contentPadding: EdgeInsets.symmetric(),
                          tileColor: Colors.white,
                          title: Text(
                              AppLocalizations.of(context).contact_menu_text),
                          trailing: Icon(Icons.chevron_right),
                          leading: Icon(
                            Icons.phone,
                          ),
                          onTap: () async {
                            launchUrlString("tel://777");
                            //                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => AboutPage()));
                          }),
                      Divider(
                        height: 8,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(),
                        tileColor: Colors.white,
                        title: Text(context.translate.app_version),
                        trailing: Text(appVersion),
                        leading: Icon(
                          Icons.info_outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: LanguageButton())),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await new Future.delayed(const Duration(seconds: 2));
                    logOut(context);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  /*  buttonColor: Colors.red.shade50,
                isDisabled: isLoading, */
                  child: DecoratedBox(
                    //height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12)),

                    child: Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: !isLoading
                            ? Text(
                                AppLocalizations.of(context).disconnect_text,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                            : Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.red),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
