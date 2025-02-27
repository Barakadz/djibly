import 'package:djibly/pages/home/tabs/home_tab/map_view/home_maps_view.dart';
import 'package:djibly/pages/home/tabs/home_tab/products_view/home_products_view.dart';
import 'package:djibly/presenters/home/home_tab_presenter.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../main.dart';
import '../../../search/search_page.dart';

class HomeTab extends StatefulWidget {
  static const String Tag = 'home_tab';

  @override
  HomeTabState createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabPresenter>(
        builder: (context, homeTabPresenter, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          /*  leading: IconButton(
              icon: Icon(
                homePresenter.getSelectedTab() == 0
                    ? Icons.menu
                    : Icons.arrow_back,
                color: Colors.grey.shade600,
                size: 22,
              ),
              onPressed: () {
                homePresenter.getSelectedTab() == 0
                    ? _drawerKey.currentState.openDrawer()
                    : Provider.of<HomePresenter>(context, listen: false)
                        .setSelectedTab(0);
              },
            ), */
          centerTitle: false,
          titleSpacing: 0,
          title: Padding(
            padding: Localizations.localeOf(context).languageCode == "ar"
                ? EdgeInsets.only(right: 16)
                : EdgeInsets.only(left: 16),
            child: SizedBox(
              width: double.maxFinite,
              height: 35.0,
              child: TextField(
                textAlign: TextAlign.start,
                readOnly: true,
                onTap: () {
                  print("🟢🟢🟢🟢  tap search field");
                  Navigator.of(context).pushNamed(SearchPage.routeName);
                },
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  hintText:
                      AppLocalizations.of(MyApp.navigatorKey.currentContext)
                          .search_product,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  prefixIcon: Icon(
                    FeatherIcons.search,
                    size: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                style: TextStyle(fontSize: 13.0, height: 2.0),
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: 16,
            ),
          ],
        ),
        body: HomeProductsView(),
      );
    });
  }
}
