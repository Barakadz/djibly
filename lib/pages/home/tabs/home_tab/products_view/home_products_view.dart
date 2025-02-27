import 'dart:math';

import 'package:djibly/app/core/extensions/list_extension.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/pages/home/tabs/home_tab/products_view/group_products_widget.dart';
import 'package:djibly/pages/home/tabs/home_tab/products_view/home_carousel_widget.dart';
import 'package:djibly/presenters/home/home_tab_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeProductsView extends StatefulWidget {
  @override
  _HomeProductsViewState createState() => _HomeProductsViewState();
}

class _HomeProductsViewState extends State<HomeProductsView> {
  var randomizer = new Random();

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<HomeTabPresenter>(context, listen: false)
        .fetchIndexProductsList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabPresenter>(builder: (_, homePresenter, ch) {
      if (homePresenter.isFetching()) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 160,
                  child: ShimmerWidget(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(width: 120, height: 40, child: ShimmerWidget()),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: <Widget>[
                      ...[1, 2, 3].map((e) => SizedBox(
                          width: 140, height: 200, child: ShimmerWidget())),
                    ].addSeparators(SizedBox(
                      width: 12,
                    )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                    width: double.maxFinite,
                    height: 160,
                    child: ShimmerWidget()),
              )
            ].addSeparators(
              SizedBox(
                height: 8,
              ),
            ),
          ),
        );
      } else {
        if (homePresenter.errorFetching) {
          return Center(
            child:
                Text(AppLocalizations.of(context).something_went_wrong_title),
          );
        } else {
          print("hhhhhhhhhhhhhhhhhhhhhh");
          print(homePresenter.homeProducts.length);
          return RefreshIndicator(
            color: context.colorScheme.primary,
            onRefresh: () async {
              await Provider.of<HomeTabPresenter>(context, listen: false)
                  .refresh();
              return;
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  homePresenter
                              .getAdsListByType(
                                  HomeTabPresenter.AD_CAROUSEL_CODE)
                              .length >
                          0
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                          ),
                          child: HomeCarouselWidget(
                              ads: homePresenter.getAdsListByType(
                                  HomeTabPresenter.AD_CAROUSEL_CODE)),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: homePresenter.homeProducts
                          .asMap()
                          .entries
                          .map((item) => GroupProductsWidget(
                                products: item.value,
                                ad: homePresenter
                                            .getAdsListByType(
                                              HomeTabPresenter.AD_BANNER_CODE,
                                            )
                                            .length >
                                        item.key
                                    ? homePresenter.getAdsListByType(
                                        HomeTabPresenter
                                            .AD_BANNER_CODE)[item.key]
                                    : null,
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          );
        }
      }
    });
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Color.fromARGB(255, 205, 203, 203),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
